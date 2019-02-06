* [Supported Node.js versions](#supported-node-js-versions)
* [Dependency caching](#dependency-caching)
* [Environment variables](#environment-variables)
* [Browser testing](#browser-testing)

## Supported Node.js versions

Semaphore uses [nvm](https://github.com/creationix/nvm) to manage Node.js
versions. Any version installable with `nvm` is supported by Semaphore. By
default, version 8.11 of Node.js is pre-installed on the Semaphore VM.

The version of Node.js that will be used can be set from a `.nvmrc` file if
such a file exists on your repo. If you want to make use of the `.nvmrc` file
you will need to run `nvm use` so you can actually tell nvm to set the node
version specified within the `.nvmrc` file.

Alternatively, you can change the Node.js version by calling `sem-version node`.
Here's an example:

<pre><code class="language-yaml">blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sem-version node 10.13.0
      jobs:
        - name: Tests
          commands:
            - node --version
</code></pre>

If you need a version other than the preinstalled versions, then you
can install it with `nvm`. Here's an example:

<pre><code class="language-yaml">blocks:
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
</code></pre>

## Dependency caching

You can use Semaphores `cache` command to store and load
`node_modules`. In the following configuration example, we install dependencies
and warm the cache in the first block, then use the cache in subsequent blocks.

<pre><code class="language-yaml">version: v1.0
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
            - cache restore node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),node-modules-$SEMAPHORE_GIT_BRANCH,node-modules-master
            - npm install
            - cache store node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json) node_modules

  - name: Tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore node-modules-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),node-modules-$SEMAPHORE_GIT_BRANCH,node-modules-master
      jobs:
        - name: Everything
          commands:
            - npm test
</code></pre>

If you need to clear cache for your project, launch a
[debug session](https://docs.semaphoreci.com/article/75-debugging-with-ssh-access)
and execute `cache clear` or `cache delete <key>`.

### Yarn is supported

Besides NPM, Semaphore also supports Yarn for managing Node.js dependencies.

To get started, use the configuration example above and replace
`package-lock.json` with `yarn.lock`.

## Environment Variables

Semaphore doesn't set language specific environment variables like
`NODE_ENV` You should set these at the task level.

<pre><code class="language-yaml">blocks:
  - name: Tests
    task:
      env_vars:
        - name: NODE_ENV
          value: test
      jobs:
        - name: Everything
          commands:
            - npm test
</code></pre>

## Browser testing

Install the
[selenium-webdriver](https://www.npmjs.com/package/selenium-webdriver)
library and it should work out of the box, same goes for higher level
libraries that leverage Selenium. See the official [Node
examples](https://github.com/SeleniumHQ/selenium/tree/master/javascript/node/selenium-webdriver/example).

Refer to the [Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image) for details on preinstalled
browsers and testing tools on Semaphore.

[browser-ref]: https://docs.semaphoreci.com/article/32-ubuntu-1804-image#browsers-and-headless-browser-testing
