* [Supported PHP versions](#supported-php-versions)
* [Dependency caching](#dependency-caching)
* [Environment variables](#environment-variables)
* [System dependencies](#system-dependendices)

This guide covers configuring PHP projects on Semaphore.
If you’re new to Semaphore please read our
[Guided tour](https://docs.semaphoreci.com/article/77-getting-started) first.

## Supported PHP versions

Semaphore provides major PHP versions and tools preinstalled.
You can find information about them in the
[Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image#php).

Semaphore uses [phpbrew](https://github.com/phpbrew/phpbrew) to manage
PHP versions. Any version installable with phpbrew is supported on
Semaphore. Version 7.1 is pre-installed. You can install and switch
versions using `phpbrew` and `sem-version`.  Here's an example:

<pre><code class="language-yaml">
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - phpbrew install 5.6
          - sem-version php 5.6
      jobs:
        - name: Tests
          commands:
            - php --version
</code></pre>

## Dependency caching

Composer is preinstalled, so you can use the `cache` command to
store and restore the `vendor` directory.
In the following configuration example, we install dependencies
and warm the cache in the first block, then use the cache in subsequent blocks.

<pre><code class="language-yaml">
version: "v1.0"
name: PHP Example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Install dependencies
    task:
      jobs:
        - name: Composer install
          commands:
            - checkout
            - cache restore composer-$SEMAPHORE_GIT_BRANCH-$(checksum composer.lock),composer-$SEMAPHORE_GIT_BRANCH,composer-master
            - composer install
            - cache store composer-$(checksum composer.lock) vendor

  - name: Tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore composer-$SEMAPHORE_GIT_BRANCH-$(checksum package-lock.json),composer-$SEMAPHORE_GIT_BRANCH,composer-master
          # Prepend vendor/bin to the path so you can use dependency executables
          - export "PATH=./vendor/bin:${PATH}"
      jobs:
        - name: Everything
          commands:
            - codecept test
</code></pre>

## Environment variables

Semaphore doesn't set specific environment variables like `APP_ENV`.
You can set these at the task level.

<pre><code class="language-yaml">blocks:
  - name: Tests
    task:
      env_vars:
        - name: APP_ENV
          value: test
      jobs:
        - name: Everything
          commands:
            - codecept run
</code></pre>

## System dependencies

Projects may need system packages to install libraries for things like
database drivers. Semaphore provides full `sudo` access so you can install
all required packages. Here's an example:

<pre><code class="language-yaml">
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sudo apt-get update && sudo apt-get install -y libpq-dev
          - composer install
      jobs:
        - name: Everything
          commands:
            - codecept run
</code></pre>
