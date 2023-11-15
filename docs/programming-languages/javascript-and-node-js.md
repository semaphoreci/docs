---
Description: This guide gives an example Semaphore project using Node.js, TypeScript, and React, so you can learn about dependency caching and environment variables.
---

# JavaScript and Node.js

This guide will help you get started with a JavaScript project on Semaphore.
If you’re new to Semaphore please read our
[Guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) first.

## Hello world

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: JavaScript example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Hello world
    task:
      jobs:
        - name: Run some code
          commands:
            - node -p '"evol".split("").reverse().join("")'
```

## Example project with Node.js, TypeScript, and React

Semaphore provides a tutorial and demo application with a working
CI pipeline that you can use to get started quickly:

- [Node.js server and React client tutorial][tutorial]
- [Demo project on GitHub][demo-project]

## Supported Node.js versions

Semaphore supports all versions of Node.js. You have the following options:

- Linux: Node.js is available out-of-the-box in the [Ubuntu 18.04 VM image][ubuntu-javascript].
- macOS: Node.js is available out-of-the-box in the [macOS VM image][macos-javascript].
- Docker: use [semaphoreci/node](/ci-cd-environment/semaphore-registry-images/#node) or
  [your own Docker image][docker-env] with the version of Node.js and related
  packages that you want.

Follow the links above for details on currently-available language versions and
additional tools.

#### Selecting a Node.js version on Linux

On Linux, Semaphore uses [nvm](https://github.com/creationix/nvm) to manage Node.js
versions. Any version that can be installed with `nvm` is supported by Semaphore.

The version of Node.js that will be used can be set from a `.nvmrc` file, if
such a file exists in your repository. If you want to make use of the `.nvmrc`
file, you will need to run `nvm use` so you can tell nvm to set the
node version specified within the `.nvmrc` file.

Alternatively, you can change the Node.js version by calling `sem-version node`.
Here's an example:

``` yaml
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sem-version node 10.13.0
      jobs:
        - name: Tests
          commands:
            - node --version
```

If you want a version other than the preinstalled versions, you
can install it with `nvm`. Here's an example:

``` yaml
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - nvm install --lts carbon
          - sem-version node --lts carbon
      jobs:
        - name: Tests
          commands:
            - node --version
```

If the version of Node.js that you want is not currently available in the Linux VM,
we recommend running your jobs in [a custom Docker image][docker-env].

## Dependency caching

You can use Semaphore's `cache` command to store and load
`node_modules`. In the following configuration example, we install dependencies
and warm the cache in the first block, then use the cache in subsequent blocks.

``` yaml
version: v1.0
name: First pipeline example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Install dependencies
    task:
      jobs:
        - name: npm install and cache
          commands:
            - checkout
            - cache restore
            - npm install
            - cache store

  - name: Tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore
      jobs:
        - name: Everything
          commands:
            - npm test
```

If you need to clear the cache for your project, launch a
[debug session](https://docs.semaphoreci.com/essentials/debugging-with-ssh-access/)
and execute `cache clear` or `cache delete <key>`.

### Yarn is supported

Besides NPM, Semaphore also supports Yarn for managing Node.js dependencies.

To get started, use the previous configuration example and replace
`package-lock.json` with `yarn.lock`.

## Environment Variables

Semaphore doesn't set language-specific environment variables like
`NODE_ENV`. You should set these at the task level.

``` yaml
blocks:
  - name: Tests
    task:
      env_vars:
        - name: NODE_ENV
          value: test
      jobs:
        - name: Everything
          commands:
            - npm test
```

## Browser testing

Install the
[selenium-webdriver](https://www.npmjs.com/package/selenium-webdriver)
library and it should work out of the box. The same goes for higher-level
libraries that leverage Selenium. See the official [Node examples](https://github.com/SeleniumHQ/selenium/tree/master/javascript/node/selenium-webdriver/example) documentation for more information.  
Refer to the [Ubuntu image reference](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/)
for details on pre-installed browsers and testing tools on Semaphore.

[browser-ref]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/#browsers-and-headless-browser-testing
[tutorial]: https://docs.semaphoreci.com/examples/node-js-and-typescript-continuous-integration/
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-javascript
[ubuntu-javascript]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/#javascript-via-node-js
[macos-javascript]: https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-14-image/#javascript-via-node-js
[docker-env]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/

## Connecting your Node.js application to the test Database

Set up a `config/config.js` file in your repository with the following content:
``` javascript
// config/config.js

module.exports = {
  postgres: {
    database: process.env.DATABASE_NAME,
    username: process.env.DATABASE_USERNAME,
    password: process.env.DATABASE_PASSWORD
  },
}
```

Start a Postgres database in your job with [sem-service](/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/#sem-service-managing-databases-and-services-on-linux), as shown below:

``` bash
export DATABASE_USERNAME="test-user"
export DATABASE_PASSWORD="keyboard-cat"
export DATABASE_NAME="test-db"

sem-service start postgres --username="$DATABASE_USERNAME" --password="$DATABASE_PASSWORD" --db="$DATABASE_NAME"
```

Then, use the credentials in `config.js` to instantiate [Sequelize](https://github.com/sequelize/sequelize), as shown below:
``` javascript
var Sequelize = require('sequelize')
  , config = require(__dirname + "/../config/config")

var sequelize = new Sequelize(config.postgres.database,
config.postgres.username, config.postgres.password, {
  dialect:  'postgres',
  protocol: 'postgres'
})
```

