# PHP

This guide covers configuring PHP projects on Semaphore. If you are new to
Semaphore we recommend reading our
[Guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) first.

## Hello world

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: PHP example
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
            - echo '<?php print "Hello World!\n"; ?>' > hello.php && php hello.php
```

## Laravel example

Semaphore provides a tutorial and demo Laravel application with a working
CI pipeline that you can use to get started quickly:

- [Laravel Continuous Integration tutorial][laravel-tutorial]
- [Demo project on GitHub][laravel-demo-project]

## Supported PHP versions

Semaphore supports all versions of PHP. You have the following options:

- Linux: PHP and related tools are available out-of-the-box in the
  [Ubuntu 18.04 VM image][ubuntu-php].
- Docker: use [semaphoreci/php][php-docker-image] or
  [your own Docker image][docker-env] with the version of PHP and other
  packages that you need.

Follow the links above for details on currently available language versions and
additional tools.

#### Selecting a PHP version on Linux

Semaphore uses [phpbrew](https://github.com/phpbrew/phpbrew) to manage
PHP versions. Any version installable with `phpbrew` is supported on
Semaphore. Version 7.2 is pre-installed. You can install and switch
versions using `phpbrew` and `sem-version`.  Here's an example:

``` yaml
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - phpbrew --no-progress install 5.6
          - sem-version php 5.6
      jobs:
        - name: Tests
          commands:
            - php --version
```

If the version of PHP that you need is not currently available in the Linux VM,
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
    os_image: ubuntu1804

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

Semaphore does not set specific environment variables like `APP_ENV`. You can
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
[ubuntu-php]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/#php
[docker-env]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/
[php-docker-image]: https://hub.docker.com/r/semaphoreci/php
