# Heroku Deployment

This guide shows you how to use Semaphore to set up deployment to Heroku
for an application or microservice written in any language.

For this guide you will need:

- [A working Semaphore project][create-project] with a basic CI pipeline.
You can use one of the documented [use cases][use-cases] or
[language guides][language-guides] as a starting point.
- A created app on Heroku.
- Basic familiarity with Git and SSH.

## Connect CI and deployment pipelines with a promotion

Start by defining a [promotion][promotions-intro] at the end of your
`semaphore.yml` file:

``` yaml
# .semaphore/semaphore.yml
promotions:
  - name: Deploy to Heroku
    pipeline_file: heroku.yml
```

This defines a simple deployment pipeline which can be triggered manually
on every revision on every branch. You can generally define as many pipelines
for a project as you need using a variety of options and conditions.
For designing custom delivery pipelines, consult the
[promotions reference documentation][promotions-ref].

## Define Heroku deployment

In this example we're going to configure Heroku deployment using SSH Git
transport.

### Create a deploy key

Create a new SSH key with no passphrase which Semaphore will use to
authenticate with Heroku:

``` bash
$ ssh-keygen -t rsa -b 4096 -C "semaphore@heroku.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/marko/.ssh/id_rsa): /Users/marko/.ssh/id_rsa_semaphore_heroku
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/joe/.ssh/id_rsa_semaphore_heroku.
Your public key has been saved in /Users/joe/.ssh/id_rsa_semaphore_heroku.pub.
The key fingerprint is:
SHA256:8ujVmyIhyAAMaaDpyE+xty5mVDyzK2YrX4OrJxgkj80 semaphore@heroku.com
The key's randomart image is:
+---[RSA 4096]----+
|*.               |
|++               |
|=  ..            |
|*.  o=           |
|+X +..= S        |
|o E.+.o+ .       |
|...o =o.o .      |
|.o O+oo..  o     |
| .@++... .o      |
+----[SHA256]-----+
```

Next we need to make the private key `id_rsa_semaphore_heroku` available on
Semaphore, and add the corresponding public key `id_rsa_semaphore_heroku.pub`
to Heroku.

### Store private SSH key in a Semaphore secret

[Create a new Semaphore secret][secrets-guide] using the [sem CLI][sem-create-ref]:

``` bash
$ sem create secret demoapp-heroku \
  --file /Users/joe/.ssh/id_rsa_semaphore_heroku:/home/semaphore/.ssh/id_rsa_semaphore_heroku
Secret 'demoapp-heroku' created.
```

You can verify the existence of your new secret:

``` bash
$ sem get secrets
NAME             AGE
demoapp-heroku   26s
```

You can also verify the content of your secret:

``` bash
$ sem get secret demoapp-heroku
apiVersion: v1beta
kind: Secret
metadata:
  name: demoapp-heroku
  id: a4f08e2c-166f-4a01-97e2-1b961719454f
  create_time: "1543748243"
  update_time: "1543748243"
data:
  env_vars: []
  files:
  - path: /home/semaphore/.ssh/id_rsa_semaphore_heroku
    content: LS0tLS1CRUdJTiBPUEV...
```

The content of secrets is base64-encoded, and we see that our file will be
mounted in Semaphore jobs on desired path. All good.

### Add your public key to Heroku

Add the public SSH key to Heroku using `heroku keys:add`:

``` bash
$ heroku keys:add
? Which SSH key would you like to upload?
  /Users/joe/.ssh/id_rsa.pub
❯ /Users/joe/.ssh/id_rsa_semaphore_heroku.pub
```

You can do the same through the Heroku user interface, in the "SSH Keys"
section of your Account Settings. For more information consult
[Heroku documentation][heroku-keys].

### Define the deployment pipeline

Finally let's define what happens in our `heroku.yml` pipeline:

``` yaml
# .semaphore/heroku.yml
version: v1.0
name: Heroku deployment
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Deploy
    task:
      secrets:
        - name: demoapp-heroku
      env_vars:
        - name: HEROKU_REMOTE
          value: https://git.heroku.com/semaphore-demoapp.git
      jobs:
      - name: Push code
        commands:
          - checkout --use-cache
          - ssh-keyscan -H heroku.com >> ~/.ssh/known_hosts
          - chmod 600 ~/.ssh/id_rsa_semaphore_heroku
          - ssh-add ~/.ssh/id_rsa_semaphore_heroku
          - git config --global url.ssh://git@heroku.com/.insteadOf https://git.heroku.com/
          - git remote add heroku $HEROKU_REMOTE
          - git push heroku -f $SEMAPHORE_GIT_BRANCH:master
```

**Note**: change the value of `HEROKU_REMOTE` to match your application's
name as it is registered on Heroku.

**Note**: For deploying to Heroku, it is required that you use `checkout` with
the `--use-cache` option in order to avoid the shallow clone of your GitHub
repository.

#### Comments

- By mounting the `demoapp-heroku` secret we make the private SSH key available
inside the pipeline block.
- Using `ssh-keyscan` we specify that heroku.com is a trusted domain and bypass
an interactive confirmation step which would block our job.
- We need to manually add our private SSH key to local SSH agent.
- We want to [always use SSH Git transport][heroku-ssh-git].
- Using force-push ensures we can deploy any amended Git branch without issues.

### Verify it works

Push a new commit on any branch and open Semaphore to watch a new workflow run.
If all goes well you'll see the "Promote" button next to your initial pipeline.
Click on it to launch deployment, and open the "Push code" job to observe its'
output.

## Next steps

Congratulations! You have automated deployment of your application to Heroku.
Here’s some recommended reading:

- [Explore the promotions reference][promotions-ref] to learn more about what
options you have available when designing delivery pipelines on Semaphore.
- [Set up a deployment dashboard][deployment-dashboards] to keep track of
your team's activities.

[create-project]: https://docs.semaphoreci.com/article/63-your-first-project
[use-cases]: https://docs.semaphoreci.com/category/59-use-cases
[language-guides]: https://docs.semaphoreci.com/category/58-programming-languages
[promotions-ref]: https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions
[promotions-intro]: https://docs.semaphoreci.com/article/67-deploying-with-promotions
[secrets-guide]: https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
[sem-create-ref]: https://docs.semaphoreci.com/article/53-sem-reference#sem-create
[heroku-keys]: https://devcenter.heroku.com/articles/keys
[heroku-ssh-git]: https://devcenter.heroku.com/articles/git#ssh-git-transport
[deployment-dashboards]: https://docs.semaphoreci.com/article/101-deployment-dashboards
