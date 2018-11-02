* [Supported Versions](#supported-versions)
* [Dependency Caching](#dependency-caching)
* [Environment Variables](#environment-variables)
* [System Dependencies](#system-dependendices)

## Supported Versions

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

## Dependency Caching

`composer` is preinstalled, so you can use the `cache` command to
store and restore the `vendor` directory. You'll need one block to
warm the cache, then use the cache in subsequent blocks.

<pre><code class="language-yaml">
version: "v1.0"
name: PHP Example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Warm cache
    task:
      jobs:
        - name: Dependencies
          commands:
            - checkout
            - cache restore v1-composer-$(checksum composer.lock)
            - composer install
            - cache store v1-composer-$(checksum composer.lock) vendor

  - name: Tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore v1-composer-$(checksum composer.lock)
          # Prepend vendor/bin to the path so you can use dependency executables
          - export "PATH=./vendor/bin:${PATH}"
      jobs:
        - name: Everything
          commands:
            - codecept test
</code></pre>

## Environment Variables

Semaphore doesn't set specific environment variables like `APP_ENV`.
You should set these at the task level.

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

## System Dependencies

Projects may need system packages to install libraries for things like
database drivers. You have full `sudo` access to install required
packages. Here's an example:

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
