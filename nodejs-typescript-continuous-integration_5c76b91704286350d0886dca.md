This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for a Node.js app. The guide applies to both TypeScript and
JavaScript.

- [Demo project](#demo-project)
- [Overview of the CI pipeline](#overview-of-the-ci-pipeline)
- [Sample configuration](#sample-configuration)
- [Run the demo project yourself](#run-the-demo-project-yourself)

## Demo project

Semaphore maintains an example JavaScript project with a CI pipeline for both
client and server side code:

- [Demo JavaScript project on GitHub][demo-project]

The Node.js server is based on the Nest.js framework, while the client is
implemented in React. Code is written in TypeScript and compiled to JavaScript.

In the repository you will find an annotated Semaphore configuration file
`.semaphore/semaphore.yml`.

## Overview of the CI pipeline

The example pipeline contains 4 blocks. Blocks run parallel jobs for server and
client code:

- Install dependencies
  - Installs and caches all NPM dependencies
- Code linting
  - Runs tslint to check code style in project files
- Run unit tests
  - Runs unit tests, written with Jest framework
- Run end-to-end (E2E) tests
  - On server, E2E tests run through Jest.
  - On client, E2E tests run through Cypress.

![Node.js CI pipeline](https://github.com/semaphoreci-demos/semaphore-demo-javascript/raw/master/images/ci-pipeline-client.png)

## Sample configuration

``` yaml
# .semaphore/semaphore.yml

# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name your pipeline. In case you connect multiple pipelines with promotions,
# the name will help you differentiate between, for example, a CI build phase
# and delivery phases.
name: Semaphore JavaScript Example Pipeline

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
      # Set environment variables that your project requires.
      # See https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
      env_vars:
        - name: NODE_ENV
          value: test
        - name: CI
          value: 'true'

      # This block runs two jobs in parallel and they both share common
      # setup steps. We can group them in a prologue.
      # See https://docs.semaphoreci.com/article/50-pipeline-yaml#prologue
      prologue:
        commands:
          # Get the latest version of our source code from GitHub:
          - checkout

          # Use the version of Node.js specified in .nvmrc.
          # Semaphore provides nvm preinstalled.
          - nvm use
          - node --version
          - npm --version
      jobs:
        # First parallel job:
        - name: client npm install and cache
          commands:
            - cd src/client

            # Restore dependencies from cache. This command will not fail in
            # case of a cache miss. In case of a cache hit, npm install will
            # run very fast.
            # For more info on caching, see https://docs.semaphoreci.com/article/68-caching-dependencies
            - cache restore client-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),client-node-modules-$SEMAPHORE_GIT_BRANCH,client-node-modules-master
            - npm install

            # Store the latest version of node modules in cache to reuse in
            # further blocks:
            - cache store client-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json) node_modules

        # Second parallel job:
        - name: server npm install and cache
          commands:
            - cd src/server
            - cache restore server-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),server-node-modules-$SEMAPHORE_GIT_BRANCH,server-node-modules-master
            - npm install
            - cache store server-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json) node_modules

  - name: Lint
    task:
      env_vars:
        - name: NODE_ENV
          value: test
        - name: CI
          value: 'true'
      prologue:
        commands:
          - checkout
          - nvm use
          - node --version
          - npm --version
      jobs:
        - name: Client Lint
          commands:
            - cd src/client
            # At this point we can assume 100% cache hit rate of node modules:
            - cache restore client-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),client-node-modules-$SEMAPHORE_GIT_BRANCH,client-node-modules-master

            # Run task as defined in package.json:
            - npm run lint
        - name: Server Lint
          commands:
            - cd src/server
            - cache restore server-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),server-node-modules-$SEMAPHORE_GIT_BRANCH,server-node-modules-master
            - npm run lint

  - name: Tests
    task:
      env_vars:
        - name: NODE_ENV
          value: test
        - name: CI
          value: 'true'
      prologue:
        commands:
          - checkout
          - nvm use
          - node --version
          - npm --version
      jobs:
        - name: Client Tests
          commands:
            - cd src/client
            - cache restore client-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),client-node-modules-$SEMAPHORE_GIT_BRANCH,client-node-modules-master
            - npm test
        - name: Server Tests
          commands:
            - cd src/server
            - cache restore server-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),server-node-modules-$SEMAPHORE_GIT_BRANCH,server-node-modules-master
            - npm test

  - name: E2e Tests
    task:
      env_vars:
        - name: NODE_ENV
          value: test
        - name: CI
          value: 'true'
      prologue:
        commands:
          - checkout
          - nvm use
          - node --version
          - npm --version
          # Start a Postgres database. On Semaphore, databases run in the same
          # environment as your code.
          # See https://docs.semaphoreci.com/article/32-ubuntu-1804-image#databases-and-services
          - sem-service start postgres
          # With unrestricted sudo access, you can install any additional
          # system package:
          - sudo apt-get install -y libgtk2.0-0
      jobs:
        - name: Client Tests
          commands:
            - cd src/client
            - cache restore client-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),client-node-modules-$SEMAPHORE_GIT_BRANCH,client-node-modules-master
            - npx cypress install
            - npm run test:e2e
        - name: Server Tests
          commands:
            - cd src/server
            - cache restore server-node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),server-node-modules-$SEMAPHORE_GIT_BRANCH,server-node-modules-master
            - cp ci.env .env
            - cp ormconfig.ci.json ormconfig.json
            - npm run migrate:up
            - npm run test:e2e
```

## Run the demo project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][demo-project] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Edit any file and push GitHub, and Semaphore will run the CI pipeline.

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-javascript
