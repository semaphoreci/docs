# Netlify Continuous Deployment

This guide shows you how to configure Semaphore to continuously deploy a
static website to Netlify.

Before getting started, you'll need:

  - A [Netlify](https://netlify.com) account.
  - A working
    [Semaphore project](https://docs.semaphoreci.com/article/63-your-first-project)
    with a CI pipeline that builds the website.

For the initial CI pipeline, you may refer to Semaphore's [open source demo
static website project][demo-project], which uses a Node.js framework to generate site
pages, and the [companion guide][static-website-guide].

## Write a deployment pipeline

Create a deployment pipeline as a new file in your `.semaphore` directory:

``` yaml
# .semaphore/production-deploy-netlify.yml

version: v1.0
name: Deploy website
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: 🏁 Deploy
    task:
      # Mount a secret which defines /home/semaphore/.netlify/config.json and
      # /home/semaphore/.netlify/state.json.
      # For info on creating secrets, see:
      # https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
      secrets:
        - name: netlify-authentication
      jobs:
        - name: Copy to netlify
          commands:
            - npm install netlify-cli -g
            # restore the website cached as website-build
            - cache restore website-build
            # deploy the contents of the public directory
            - netlify deploy --dir=public --prod
```

The pipeline shown above assumes that the website files are generated in
the `public` directory and
[cached](https://docs.semaphoreci.com/article/54-toolbox-reference#cache)
with the key: `website-build`. You may need to adjust the last two
commands of the job to suit your needs.

## Add a promotion to deployment

Add a
[promotion](https://docs.semaphoreci.com/article/67-deploying-with-promotions)
to your existing `semaphore.yml` file:

``` yaml
- name: Netlify Production deploy
  pipeline_file: production-deploy-netlify.yml
  auto_promote_on:
    - result: passed
      branch:
        - master
```

This will start the deployment on every successful revision on the
master branch. For more details regarding promotions, consult the
[reference
documentation](https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions).

## Manage Netlify credentials

To obtain your Netlify credentials:

1.  Install the [netlify command line
    interface](https://www.netlify.com/docs/cli/):
    
    ``` bash
    $ npm install netlify-cli -g
    ```

2.  Log in to your Netlify account:
    
    ``` bash
    $ netlify login
    ```
    
    This opens a browser window, follow the instructions to get
    authorized.

3.  Link your project's directory with the Netlify site. The actual
    command depends on whether you are updating an existing site or
    creating a new one. If you are:
    
- Creating a new site:
    
    ``` bash
    $ cd /your/project/path
    $ netlify init
    ```

- Updating a previously existing site:
    
    ``` bash
    $ cd /your/project/path
    $ netlify link
    ```

### Store credentials on Semaphore

You need to upload two files to Semaphore in order to allow access to
your Netlify account and site.
[Secrets](https://docs.semaphoreci.com/article/66-environment-variables-and-secrets)
are the best way to store private data such as authentication tokens and
passwords. You can securely send the files to Semaphore using [sem
CLI](https://docs.semaphoreci.com/article/53-sem-reference):

``` bash
$ cd /your/project/path
$ sem create secret netlify-authentication \
    --file .netlify/state.json:/home/semaphore/.netlify/state.json \
    --file ~/.netlify/config.json:/home/semaphore/.netlify/config.json
```

To see the secrets stored on Semaphore:

``` bash
$ sem get secrets
```

## Launch your first deployment

The workflow will start as soon as the changes are pushed to your
repository:

``` bash
$ git add .semaphore/production-deploy-netlify.yml
$ git add .semaphore/semaphore.yml
$ git commit -m "add deployment"
$ git push
```

That’s all. Your website will be automatically deployed on every
successful update of the master branch. With a setup such as this, you can
ship updates quickly while preventing any errors from reaching your site.

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-static-website
[static-website-guide]: https://docs.semaphoreci.com/article/97-continuous-deployment-static-website
