* [Supported Versions](#supported-versions)
* [Dependency Caching](#dependency-caching)
* [Environment Variables](#environment-variables)

## Supported Versions

Semaphore uses [nvm](https://github.com/creationix/nvm) to manage
Ruby versions. Any version installable with `nvm` is supported on
Semaphore. Version 8.11 is pre-installed. The default
version is set from `.nvmrc` file in your repo. You can change this
by calling `sem-version ruby`. Here's an example:

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

## Dependency Caching

You can use Semaphores `cache` command to store and load
`node_modules`. You'll need one block to warm the cache, then use the
cache in subsequent blocks.

<pre><code class="language-yaml">version: "v1.0"
name: First pipeline example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Warm cache
    task:
      jobs:
        - name: cache node_modules
          commands:
            - checkout
            - cache restore v1-node-modules-$(checksum package-lock.json)
            - npm install
            - cache store v1-node-modules-$(checksum package-lock.json) node_modules

  - name: Tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore v1-node-modules-$(checksum package-lock.json)
      jobs:
        - name: Everything
          commands:
            - npm test
</code></pre>

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
