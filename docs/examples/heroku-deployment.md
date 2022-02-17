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

## Troubleshooting

### Authentication method Expired

The `.netrc` file is not a permanent token. It must be updated from time to time.

If you encounter a job hanging at the authentication step, it could be due to an expired `.netrc` file. In this case, recreating the file and the secret should solve the issue.

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
