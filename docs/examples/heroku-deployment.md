---
Description: This guide shows you how to use Semaphore 2.0 to set up deployment to Heroku for an application or microservice written in any language.
---


# Heroku Deployment

This guide shows you how to use Semaphore to set up deployment to Heroku
for an application or microservice written in any language.

For this guide you will need:

- [A working Semaphore project][create-project] with a basic CI pipeline.
You can use one of the documented [use cases][use-cases] or
[language guides][language-guides] as a starting point.
- A pre-existing app on Heroku.
- Basic familiarity with Git and SSH.

## Connecting CI and deployment pipelines with a promotion

Start by defining a [promotion][promotions-intro] at the end of your
`semaphore.yml` file:

``` yaml
# .semaphore/semaphore.yml
promotions:
  - name: Deploy to Heroku
    pipeline_file: heroku.yml
```

This defines a simple deployment pipeline that can be triggered manually
for every revision on every branch. You can define as many pipelines
as you need for any project, using a variety of options and conditions.
For designing custom delivery pipelines, consult the
[promotions reference documentation][promotions-ref].

At this point, one of the following authentication methods can be chosen:
- [HTTP authentication][http-method]

or
- [SSH authentication][ssh-method]

**Note**: Heroku announced that SSH authentication method will be deprecated on November 30, 2021.

## Heroku deployment via HTTP authentication
[http-method]: #Heroku-deployment-via-HTTP-authentication
In this example, we're going to configure Heroku deployment using HTTP Git transport.

### Creating and Storing an API token

The Heroku HTTP Git endpoint only accepts API-key based HTTP Basic authentication. For that, Heroku stores API tokens in the standard Unix file `~/.netrc` (`$HOME\_netrc` on Windows), so that other tools such as Git can access the Heroku API with little or no extra work.

Therefore, the first step is to locally create the API token which Semaphore will use to access Heroku.

Running `heroku login` (or any other heroku command that requires authentication) creates or updates your `~/.netrc` file:

``` bash
$ heroku login
 heroku: Press any key to open up the browser to login or q to exit
 ›   Warning: If browser does not open, visit
 ›   https://cli-auth.heroku.com/auth/browser/***
 heroku: Waiting for login...
 Logging in... done
 Logged in as me@example.com

$ cat ~/.netrc
 machine api.heroku.com
   login me@example.com
   password c4cd94da15ea0544802c2cfd5ec4ead324327430
 machine git.heroku.com
   login me@example.com
   password c4cd94da15ea0544802c2cfd5ec4ead324327430
```

### Injecting an API token
Next, we need to make the `.netrc` file available to Semaphore. Use the [sem create secret command][sem-create-ref] to inject the file.

`sem create secret heroku-http -f ~/.netrc:~/.netrc`

You can verify the existence of your new secret with the command shown below:

``` bash
$ sem get secrets
NAME             AGE
heroku-http      30s
```

### Defining the Deployment pipelines

Finally, let's define what happens in our `heroku.yml` pipeline:

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
        - name: heroku-http
      env_vars:
        - name: HEROKU_APP_NAME
          value: heroku-app-name
      jobs:
      - name: Push code
        commands:
          - checkout --use-cache
          - heroku git:remote -a $HEROKU_APP_NAME
          - git push heroku -f $SEMAPHORE_GIT_BRANCH:master
```
**Note**: change the value of `HEROKU_APP_NAME` to match your application's
details as registered on Heroku.

**Note**: For deploying to Heroku, you must use `checkout` with
the `--use-cache` option in order to avoid a shallow clone of your GitHub
repository.


### Verifying that it works

Push a new commit on any branch and open Semaphore to watch the new workflow run.
If all goes well, you'll see the "Promote" button next to your initial pipeline.
Click on it to launch deployment, and open the "Push code" job to observe its'
output.

## Heroku deployment via SSH authentication
[ssh-method]: #heroku-deployment-via-ssh-authentication

In this example, we're going to configure Heroku deployment using SSH Git transport.

### Creating a deploy key

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

Next, we need to make the private key `id_rsa_semaphore_heroku` available to
Semaphore, and add the corresponding public key `id_rsa_semaphore_heroku.pub`
to Heroku.

### Storing a private SSH key in a Semaphore secret

[Create a new Semaphore secret][secrets-guide] using [sem CLI][sem-create-ref]:

``` bash
$ sem create secret demoapp-heroku \
  --file /Users/joe/.ssh/id_rsa_semaphore_heroku:/home/semaphore/.ssh/id_rsa_semaphore_heroku
Secret 'demoapp-heroku' created.
```

You can verify the existence of your new secret with the command shown below:

``` bash
$ sem get secrets
NAME             AGE
demoapp-heroku   26s
```

You can also verify the content of your secret with the command shown below:

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

The content of secrets is base64-encoded, and we can see that our file will be
mounted in Semaphore jobs on the desired path. All is as it should be.

### Adding your public key to Heroku

Add the public SSH key to Heroku using `heroku keys:add`:

``` bash
$ heroku keys:add
? Which SSH key would you like to upload?
  /Users/joe/.ssh/id_rsa.pub
❯ /Users/joe/.ssh/id_rsa_semaphore_heroku.pub
```

You can do the same via the Heroku user interface, in the "SSH Keys"
section of your Account Settings. For more information, consult the
[Heroku documentation][heroku-keys].

### Defining the deployment pipeline

Finally, let's define what happens in our `heroku.yml` pipeline:

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
        - name: HEROKU_APP_NAME
          value: heroku-app-name
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
          - heroku run --app $HEROKU_APP_NAME rake db:migrate
          - heroku ps:restart
```

**Note**: change the value of `HEROKU_APP_NAME` to match your application's
name as it is registered on Heroku.

**Note**: For deploying to Heroku, you must use `checkout` with
the `--use-cache` option in order to avoid a shallow clone of your GitHub
repository.

**Note**: In order to invoke commands on a remote Heroku application, the `HEROKU_API_KEY` environment variable should be set on Semaphore. The API key can be found by logging in to the Heroku website and navigating to your `Account Settings`. Clicking on the `Reveal` button next to the API Key textbox will reveal your API key.

#### Comments

- Mounting the `demoapp-heroku` secret makes the private SSH key available
inside the pipeline block.
- Using `ssh-keyscan` specifies that heroku.com is a trusted domain and bypasses
an interactive confirmation step that would block our job.
- We need to manually add our private SSH key to the local SSH agent.
- Using force-push ensures that we can deploy any amended Git branch without issues.

### Verifying that it works

Push a new commit on any branch and open Semaphore to watch the new workflow run.
If all goes well, you'll see the "Promote" button next to your initial pipeline.
Click on it to launch deployment, and open the "Push code" job to observe its'
output.

## Next steps

Congratulations! You have automated deployment of your application to Heroku.
Here’s some recommended reading:

- [Explore the promotions reference][promotions-ref] to learn more about what
options you have available when designing delivery pipelines on Semaphore.
- [Set up a deployment dashboard][deployment-dashboards] to keep track of
your team's activities.

[create-project]: ../guided-tour/getting-started.md
[use-cases]: https://docs.semaphoreci.com/examples/tutorials-and-example-projects/
[language-guides]: https://docs.semaphoreci.com/programming-languages/android/
[promotions-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
[promotions-intro]: ../essentials/deploying-with-promotions.md
[secrets-guide]: ../essentials/environment-variables.md
[sem-create-ref]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-create
[heroku-keys]: https://devcenter.heroku.com/articles/keys
[heroku-ssh-git]: https://devcenter.heroku.com/articles/git#ssh-git-transport
[deployment-dashboards]: https://docs.semaphoreci.com/essentials/deployment-dashboards/
