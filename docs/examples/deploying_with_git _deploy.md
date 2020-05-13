# Deploying with Git Deploy

This guide shows you how to deploy with [git-deploy](https://github.com/mislav/git-deploy). 

For this guide you will need:

- [A working Semaphore project][create-project] with a basic CI pipeline. 
You can use one of the documented [use cases][use-cases] or [language guides][language-guides] as a starting point.
- Basic familiarity with Git and SSH.

## Generate a deploy key

Generate a new SSH key with no passphrase that Semaphore will use to authenticate:

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

## Store the private SSH key in a Semaphore secret

[Create a new Semaphore secret][secrets-guide] using the [sem CLI][sem-create-ref]:

```bash
sem create secret demo-git-deploy \
 --file /Users/admin/.ssh/id_rsa_git_deploy:/home/semaphore/.ssh/id_rsa_git_deploy
Secret 'demo-git-deploy' created.
```

You can verify the existence of your new secret:
```bash
sem get secrets
NAME             AGE
demo-git-deploy   1m
```

You can also verify the content of your secret:

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
The content of secrets is base64-encoded. You can see the file will be
mounted in Semaphore jobs on the specified path.

## Add the public key to your server

Copy the content of the public key `id_rsa_git_deploy.pub` to your server's user `~/.authorized_keys` file.

## Define the deployment pipeline

The last step will be to define our `git-deploy.yml` pipeline:
```yaml
# .semaphore/git-deploy.yml
version: v1.0
name: Git deploy
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Deploy
    task:
      secrets:
        - name: demo-git-deploy
      env_vars:
        - name: SERVER_NAME
          value: your-server.com
        - name: GIT_REMOTE
          value: user@$SERVER_NAME.com:/apps/myapp/current
      jobs:
      - name: Push code
        commands:
          - checkout
          - ssh-keyscan -H $SERVER_NAME >> ~/.ssh/known_hosts
          - chmod 600 ~/.ssh/id_rsa_git_deploy
          - ssh-add ~/.ssh/id_rsa_git_deploy
          - git remote add production $GIT_REMOTE
          - git push -f production $SEMAPHORE_GIT_BRANCH:master
```

#### Comments

- By mounting the `demo-git-deploy` secret the private SSH key is available inside the pipeline block.
- Using `ssh-keyscan` you specify that your-server.com is a trusted domain and bypass an 
interactive confirmation step which would block our job.
- You need to manually add the private SSH key to local SSH agent.
- Using force-push ensures you can deploy any amended Git branch without issues.

### Does it work?

Push a new commit on any branch and open Semaphore to watch a new workflow run. 
You should see the `Promote` button next to your initial pipeline. 
Click on the button to launch the deployment, and open the `Push code` job to observe its' output.
