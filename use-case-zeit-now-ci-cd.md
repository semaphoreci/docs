# Zeit Now Continuous Deployment

## Demo project

Semaphore provides a demo project:

- [Demo Zeit Now project on GitHub](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now)

The demo consists of an API server that replies with a simple JSON
payload. The project runs on [Node.js](https://nodejs.org). It uses
[Express](http://expressjs.com/) for the web framework and
[Jest](https://jestjs.io/) for testing.

## Overview of the pipelines

The pipeline performs the following tasks:

- Install dependencies.
- Run unit tests.
- Continuously deploy master branch to production site.

On manual approval:

- Deploy to staging site.

The `.semaphore` directory in the repository contains annotated pipeline configuration files.

![CI+CD
Pipelines](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now/raw/master/images/semaphore-zeit-now-ci-cd.png)


## Continuous integration pipeline

``` yaml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name your pipeline. In case you connect multiple pipelines with promotions,
# the name will help you differentiate between, for example, a CI build phase
# and delivery phases.
name: Build and test Express.js app

# An agent defines the environment in which your code runs.
# It is a combination of one of available machine types and operating
# system images.
# See https://docs.semaphoreci.com/article/20-machine-types
# and https://docs.semaphoreci.com/article/32-ubuntu-1804-image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

# Blocks are the heart of a pipeline and are executed sequentially.
# Each block has a task that defines one or more jobs. Jobs define the
# commands to execute.
# See https://docs.semaphoreci.com/article/62-concepts
blocks:
  - name: Install dependencies
    task:
      jobs:
        - name: npm install and cache
          commands:
            # Get the latest version of our source code from GitHub:
            - checkout

            # Use the version of Node.js specified in .nvmrc.
            # Semaphore provides nvm preinstalled.
            - nvm use
            - node --version
            - npm --version

            # Restore dependencies from cache. This command will not fail in
            # case of a cache miss. In case of a cache hit, npm install will
            # run very fast.
            # For more info on caching, see https://docs.semaphoreci.com/article/68-caching-dependencies
            - cache restore client-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),client-node-modules-$SEMAPHORE_GIT_BRANCH,client-node-modules-master
            - npm install

            # Store the latest version of node modules in cache to reuse in
            # further blocks:
            - cache store client-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json) node_modules

  - name: Run tests
    task:
      jobs:
        - name: npm test
          commands:
            - checkout
            - nvm use
            - cache restore client-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),client-node-modules-$SEMAPHORE_GIT_BRANCH,client-node-modules-master
            - npm test

promotions:
  # Deployment to staging can be triggered manually:
  - name: Deploy to staging
    pipeline_file: deploy-staging.yml

  # Automatically deploy to production on successful builds on master branch:
  - name: Deploy to production
    pipeline_file: deploy-production.yml
    auto_promote_on:
      - result: passed
        branch:
          - master
```

Just 2 blocks make the CI pipeline:

![CI Pipeline](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now/raw/master/images/semaphore-zeit-now-ci.png)

-   npm install and cache:
    -   Downloads and installs the Node.js packages.
    -   Builds the app and saves it to the cache.
-   npm test:
    -   Runs unit and coverage tests.

Two
[promotions](https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions)
branch out of the CI pipeline:

-   Deploy to production: automatically started once all tests are green
    for the master branch.
-   Deploy to staging: can be manually initiated from a Semaphore workflow on any branch.

## Continuous deployment pipeline

``` yaml
version: v1.0
name: Deploy to production
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Deploy to production
    task:
      secrets:
        - name: now
      jobs:
      - name: Deploy to Zeit Now
        commands:
          - checkout
          - nvm use
          - npm install now -g
          - now --token $ZEIT_TOKEN --local-config production.json
```

The deployment pipeline consists of one block:

![CD Pipeline](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now/raw/master/images/semaphore-zeit-now-cd-production.png)

### Node.js

Both
[nvm](https://docs.semaphoreci.com/article/32-ubuntu-1804-image#javascript-via-node-js)
and [npm](https://www.npmjs.com) are pre-installed on Semaphore's Ubuntu
image. We can use the them to switch Node.js versions and install
packages.

### Deployment

[Zeit Now](https://zeit.co/) is a cloud service for serverless websites
and web applications. Deployment is performed with the
[Now CLI](https://zeit.co/docs/v2/getting-started/installation/#now-cli)
and a config file:

``` javascript
{
  "version": 2,
  "name": "semaphore-demo",
  "builds": [
      { "src": "**/*.js", "use": "@now/node" }
  ]
}
```

Both staging and production pipelines are practically identical. They
only differ on the app `name`, which maps to the final URL:

-   Production: `semaphore-demo.USERNAME.now.sh`
-   Staging: `semaphore-demo-staging.USERNAME.now.sh`

## Run the demo yourself

You can get started right away with Semaphore. Running and deploying the
demo by yourself takes only a few minutes:

### Get a Zeit token

1.  Create a [Zeit](https://zeit.co) account.
2.  Open your account **Settings**
3.  Go to the **Tokens** tab.
4.  Click on the **Create** button.
5.  Enter a name for the token, something descriptive like:
    semaphore-zeit-now

![Create Token](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now/raw/master/images/zeit-create-token.png)

6. Copy the generated token and keep it safe.

### Create the pipeline on Semaphore

Now add the token to Semaphore:

1.  Create an account for [Semaphore](https://semaphoreci.com).
2.  On the left navigation bar, under **Configuration** click on
    **Secrets**.
3.  Hit the **Create New Secret** button.
4.  Create the secret as shown below. Copy the token obtained earlier.

![Create Secret](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now/raw/master/images/semaphore-create-secret.png)

To run the project on Semaphore:

1.  Fork the [Demo
    project](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now)
    on GitHub.
2.  Clone the repository on your local machine.
3.  In Semaphore, follow the link on the sidebar to create a new
    project.
4.  Edit any file and do a push to GitHub, Semaphore starts
    automatically.


Once deployment is completed, the API service should be online. Browse the production URL:

![API
Service](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now/raw/master/images/semaphore-demo-zeit-now-json.png)

## See also

-   [Semaphore guided
    tour](https://docs.semaphoreci.com/category/56-guided-tour)
-   [Pipelines
    reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
-   [Environment variables and
    secrets](https://docs.semaphoreci.com/article/66-environment-variables-and-secrets)
-   [JavaScript and
    Node.js](https://docs.semaphoreci.com/article/82-language-javascript-and-nodejs)
