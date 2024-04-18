---
Description: This guide shows you how to use Semaphore 2.0 to set up continuous deployment for a static website.
---

# Continuous Deployment of a Static Website

This guide shows you how to use Semaphore to set up continuous deployment for
a static website.

## Example project

Semaphore provides an example open source project based on Gatsby.js, which you
can use as an example for building a CI/CD pipeline for a static website:

- [Demo static website project on GitHub][demo-project]

The project includes a build pipeline and two deployment pipelines, for AWS S3
and Netlify:

![static website ci/cd pipeline](https://github.com/semaphoreci-demos/semaphore-demo-static-website/raw/master/images/ci-pipeline-gatsby.png)

## Defining the build pipeline

There are many static site generators, but the essential deployment steps are
the same for all:

1. Install the tools to generate the site and their dependencies
2. Build the website from source files
3. Upload the website files to cloud storage or host

We'll start by setting up a Semaphore pipeline that maps the first two steps
to blocks. If all blocks run successfully on master branch, we'll automatically
[promote][promotions-guide] the code to the deployment pipeline.

This configuration also uses [caching][caching-guide] to store the project's
dependencies and pass website files to the deployment pipeline.

The example is based on a static website built with a [Node.js][nodejs]
toolchain. You can change the dependency installation and site building steps to match
your tools.

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: "Deploy website"
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: "Install dependencies"
    task:
      jobs:
      - name: npm install
        commands:
          - checkout
          # Reuse dependencies from the cache and avoid installing them from scratch:
          - cache restore
          - npm install
          - cache store

  - name: "Build site"
    task:
      jobs:
      - name: Build
        commands:
          - checkout
          - cache restore
          # Replace this with the command(s) that build your website:
          - npm run build:all
          # The script puts website files in directory `public`,
          # store it in the cache to propagate to deployment:
          - cache store website-build-$SEMAPHORE_GIT_SHA public

promotions:
  - name: Production deploy
    pipeline_file: production-deploy.yml
    auto_promote:
      when: "result = 'passed' and branch = 'master'"
```

## Deployment to AWS S3

In this example, we'll deploy our static website to AWS S3.

### Configuring deployment credentials

To perform deployment in a CI/CD job, we need to use valid AWS credentials.
A secure way to pass our credentials to Semaphore
is by defining a [secret][secrets-guide].

Create a new secret based on local `~/.aws` configuration files:

``` bash
sem create secret aws-website \
  --file ~/.aws/config:/home/semaphore/.aws/config \
  --file ~/.aws/credentials:/home/semaphore/.aws/credentials
```

This ensures that the files sourced from our local machine will be placed
in the home directory of the user executing our code on Semaphore.

### Deploying the website by uploading files to S3

Finally, create a file `.semaphore/production-deploy.yml` to execute
deployment and import the secret for authentication:

``` yaml
# .semaphore/production-deploy.yml
version: v1.0
name: Deploy website
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: Deploy
    task:
      secrets:
        - name: aws-website
      jobs:
        - name: Copy to S3
          commands:
            - checkout
            - cache restore website-build-$SEMAPHORE_GIT_SHA
            - aws s3 sync "public" "s3://bucket-name" --acl "public-read"
```

That’s it. Your website will now be continuously deployed every time there is
a valid change on master branch. Deployment won't run for other branches and
pull requests. However, Semaphore will report a build failure in the event that there's
an error that prevents the website from being generated, so that you can fix it
before merging to master.

## Deploying to Netlify

See the [Netlify Continuous Deployment][netlify-guide] guide.

## See also

- [Semaphore guided tour][guided-tour]
- [Pipelines reference][pipelines-ref]
- [Cache reference][cache-ref]

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-static-website
[promotions-guide]: https://docs.semaphoreci.com/essentials/deploying-with-promotions/
[caching-guide]: https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/
[nodejs]: https://docs.semaphoreci.com/programming-languages/javascript-and-node-js/
[secrets-guide]: https://docs.semaphoreci.com/essentials/using-secrets/
[guided-tour]: https://docs.semaphoreci.com/guided-tour/getting-started/
[pipelines-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
[cache-ref]: https://docs.semaphoreci.com/reference/toolbox-reference/#cache
[netlify-guide]: https://docs.semaphoreci.com/examples/netlify-continuous-deployment/
