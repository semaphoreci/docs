---
Description: This guide demonstrates how to deploy with git-deploy and covers the necessary steps to set up git-deploy on Semaphore 2.0.
---

# Deploying with Git Deploy

This guide demonstrates how to deploy with [git-deploy][git-deploy] and Semaphore 2.0. 

We will cover the following steps to set up git-deploy on Semaphore:

1. Create a Git Deploy key that allows pushing to your production Git server. 
2. Store the Git Deploy key in a [secret](https://docs.semaphoreci.com/essentials/using-secrets/) on Semaphore.
3. Create a deployment pipeline and attach the Git Deploy key secret.
4. Run a deployment from Semaphore and ship your code to production.

For this guide you will need:

- [A working Semaphore project][create-project] with a basic CI pipeline. 
You can use one of the documented [use cases][use-cases] or [language guides][language-guides] as a starting point.
- Basic familiarity with Git and SSH.

## Generating a deploy key

Generate a new SSH key with no passphrase that Semaphore will use to authenticate, as shown below:

``` bash
$ ssh-keygen -t rsa -b 4096 -C "semaphore@example.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/admin/.ssh/id_rsa): /Users/admin/.ssh/id_rsa_git_deploy
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/admin/.ssh/id_rsa_git_deploy.
Your public key has been saved in /Users/admin/.ssh/id_rsa_git_deploy.pub.
The key fingerprint is:
SHA256:JlwvP69Nyee12w6ON0hI8w6mB+1sqWHKK4A2nua9Dng semaphore@example.com
The key's randomart image is:
+---[RSA 4096]----+
|                 |
|                 |
|        .        |
|     . . .o      |
| .    o So.+     |
|oo.    o.o=.o.   |
|+.E.    o*o=+.o .|
| =o .. o..*=o=ooo|
|o..+..+..+..+.o=+|
+----[SHA256]-----+
```
Next, make the private key `id_rsa_git_deploy` available on Semaphore. 
Also, add the corresponding public key `id_rsa_git_deploy.pub` to your server.

## Storing the private SSH key in a Semaphore secret

[Create a new Semaphore secret][secrets-guide] using [sem CLI][sem-create-ref], as shown below:

```bash
sem create secret demo-git-deploy \
 --file /Users/admin/.ssh/id_rsa_git_deploy:/home/semaphore/.ssh/id_rsa_git_deploy
Secret 'demo-git-deploy' created.
```

You can verify the existence of your new secret, as shown below:
```bash
sem get secrets
NAME             AGE
demo-git-deploy   1m
```

You can also verify the content of your secret, as shown below:

```bash
admin $ sem get secret demo-git-deploy
apiVersion: v1beta
kind: Secret
metadata:
  name: demo-git-deploy
  id: 2cd33f3f-4cb2-4457-bd33-7f05f5b134ca
  create_time: "1589370175"
  update_time: "1589370175"
data:
  env_vars: []
  files:
  - path: /home/semaphore/.ssh/id_rsa_git_deploy
    content: LS0tLS1CRUdJTiBPUEVOU1N...
```
The content of secrets is base64-encoded. The file will be
mounted in Semaphore jobs in the specified path.

## Adding the public key to your server

Copy the content of the public key `id_rsa_git_deploy.pub` to your server's user `~/.authorized_keys` file.

## Defining the deployment pipeline

The last step is to define our `git-deploy.yml` pipeline, as shown below:
```yaml
# .semaphore/git-deploy.yml
version: v1.0
name: Git deploy
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Deploy
    task:
      # Mounting the secret with the private SSH key ~/.ssh/id_rsa_git_deploy.
      secrets:
        - name: demo-git-deploy
      env_vars:
        - name: GIT_REMOTE
          value: user@your-server.com:/apps/myapp/current
      jobs:
      - name: Push code
        commands:
          - checkout
          # Using `ssh-keyscan` you specify that your-server.com is a trusted domain
          # and bypass an interactive confirmation step that would block the job.
          - ssh-keyscan -H your-server.com >> ~/.ssh/known_hosts
          - chmod 600 ~/.ssh/id_rsa_git_deploy
          # Adding the private SSH key to the local SSH agent so it will be available while executing Git push.
          - ssh-add ~/.ssh/id_rsa_git_deploy
          - git remote add production $GIT_REMOTE
          # Using force-push ensures you can deploy any amended Git branch without issues.
          - git push -f production $SEMAPHORE_GIT_BRANCH:master
```

### Running your first git-deploy production deployment

Push a new commit on any branch and open Semaphore to watch the new workflow run. 
You should see the `Promote` button next to your initial pipeline. 
Click on the button to launch the deployment and open the `Push code` job to observe the output.

## Next steps

Congratulations! You have automated the deployment of your application using Git Deploy. 

Here’s some more recommended reading:
- [Explore the promotions reference][promotions-ref] to learn more about which options you have available when designing delivery pipelines on Semaphore.
- [Set up a deployment dashboard][deployment-dashboards] to keep track of your team's activities.

[git-deploy]: https://github.com/mislav/git-deploy
[create-project]: ../guided-tour/getting-started.md
[use-cases]: https://docs.semaphoreci.com/examples/tutorials-and-example-projects/
[language-guides]: https://docs.semaphoreci.com/programming-languages/android/
[promotions-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
[promotions-intro]: ../essentials/deploying-with-promotions.md
[secrets-guide]: ../essentials/using-secrets.md
[sem-create-ref]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-create
[deployment-dashboards]: https://docs.semaphoreci.com/essentials/deployment-dashboards/
