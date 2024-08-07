---
Description: This guide explains how to configure PHP projects on Semaphore 2.0. 
---

# PHP

This guide covers configuring PHP projects on Semaphore. If you are new to
Semaphore we recommend taking our
[Guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) first.

## Hello world

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: PHP example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: Hello world
    task:
      jobs:
        - name: Run some code
          commands:
            - echo '<?php print "Hello World!\n"; ?>' > hello.php && php hello.php
```

## Laravel example

Semaphore provides a tutorial and a demo Laravel application with a working
CI pipeline that you can use to get started quickly:

- [Laravel Continuous Integration tutorial][laravel-tutorial]
- [Demo project on GitHub][laravel-demo-project]

## Supported PHP versions

Semaphore supports all versions of PHP. You have the following options:

- Linux: PHP and related tools are available out-of-the-box in the
  [Ubuntu 20.04 VM image][ubuntu2004-php] and [Ubuntu 22.04 VM image][ubuntu2204-php].
- Docker: Use [your own Docker image][docker-env] with the version of PHP and other
  packages that you want.

Follow the links above for details on available language versions and
additional tools.

#### Selecting a PHP version on Linux

Semaphore uses [phpbrew](https://github.com/phpbrew/phpbrew) to manage
PHP versions. Any version installable with `phpbrew` is supported on
Semaphore. Version 7.2 comes pre-installed. You can install and switch
versions using `sem-version`, as shown below:

``` yaml
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sem-version php 8.2.20
      jobs:
        - name: Tests
          commands:
            - php --version
```
We recommend this approach as `sem-version` will use a precompiled
version if available and fall back on `phpbrew` otherwise. This usually
leads to shorter job setup.

You can still use `phpbrew` directly but it will always compile the
target version, which is a slow process:

``` yaml
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - phpbrew --no-progress install 8.2.20
      jobs:
        - name: Tests
          commands:
            - php --version
```

If the version of PHP that you want is not available in the Linux VM,
we recommend running your jobs in [a custom Docker image][docker-env].

## Dependency caching

Composer is preinstalled, so you can use the `cache` command to store and
restore the `vendor` directory. In the following configuration example, we
install dependencies and warm the cache in the first block, then use the cache
in subsequent blocks.

``` yaml
version: "v1.0"
name: PHP Example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Install dependencies
    task:
      jobs:
        - name: Composer install
          commands:
            - checkout
            - cache restore
            - composer install
            - cache store

  - name: Tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore
          # Prepend vendor/bin to the path so you can use dependency executables
          - export "PATH=./vendor/bin:${PATH}"
      jobs:
        - name: Everything
          commands:
            - codecept test
```

## Environment variables

Semaphore does not set specific environment variables, like `APP_ENV`. You can
set these at the task level.

``` yaml
blocks:
  - name: Tests
    task:
      env_vars:
        - name: APP_ENV
          value: test
      jobs:
        - name: Everything
          commands:
            - codecept run
```

## System dependencies

Projects may need system packages to install libraries for things like
database drivers. Semaphore provides full `sudo` access so you can install
all required packages. Here's an example:

``` yaml
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
```

[laravel-tutorial]: https://docs.semaphoreci.com/examples/laravel-php-continuous-integration/
[laravel-demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-php-laravel
[ubuntu2004-php]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/#php
[ubuntu2204-php]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-22.04-image/#php
[docker-env]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/
