---
Description: This guide shows you how to use Semaphore 2.0 to set up a continuous integration (CI) pipeline for a Laravel PHP web application.
---

# Laravel PHP Continuous Integration

This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for a Laravel PHP web application.

## Demo project

Semaphore maintains an example Laravel project that you can use to learn:

- [Demo Laravel project on GitHub][demo-project]

In the repository you will find an annotated Semaphore configuration file:
`.semaphore/semaphore.yml`.

The application uses the latest stable version of Laravel, Composer, NPM, PHP
Mess Detector, Code Sniffer, Copy Detector, PHPUnit, Laravel Dusk with
Chrome, Sensiolabs, and PostgreSQL as the database.

## Overview of the CI pipeline

The demo Laravel PHP CI pipeline performs the following tasks:

- Analyses code by running:
  - PHP Mess Detector
  - Code Sniffer
  - Copy Detector
- Runs PHPUnit unit tests
- Runs browser tests using Laravel Dusk
- Runs security tests using Sensiolabs checker

The CI pipeline is composed of a dependency installation block and four blocks
of tests:

![Laravel PHP CI pipeline](https://github.com/semaphoreci-demos/semaphore-demo-php-laravel/raw/master/public/ci-pipeline.png)

## Sample configuration

``` yaml
# .semaphore/semaphore.yml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name your pipeline. In the event that you connect multiple pipelines with promotions,
# the names will help you differentiate between them, e.g. a CI build phase
# and delivery phases.
name: Semaphore PHP Example Pipeline

# An agent defines the environment in which your code runs.
# It is a combination of one of the available machine types and operating
# system images.
# See https://docs.semaphoreci.com/ci-cd-environment/machine-types/
# and https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

# Blocks are the heart of a pipeline and are executed sequentially.
# Each block has a task that defines one or more jobs. Jobs define the
# commands to execute.
# See https://docs.semaphoreci.com/essentials/concepts/
blocks:
  - name: "Install Dependencies"
    task:
      env_vars:
        - name: APP_ENV
          value: prod
      jobs:
        - name: composer
          commands:
            # Checkout code from Git repository. This step is mandatory if the
            # job has to work with your code.
            # Optionally, you may use --use-cache flag to avoid roundtrips to
            # a remote repository.
            # See https://docs.semaphoreci.com/reference/toolbox-reference/#checkout
            - checkout
            # Try and find a cached version of our /vendor dependencies folder.
            # Semaphore tries to find a partial match.
            # Read about caching: https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/
            - cache restore
            # Install our project composer
            - composer install
            # Install node dependencies
            - npm install
            # Store the /vendor and node_modules folders in the cache for later use.
            - cache store
            # We are setting up the .env file from our example file which contains Semaphore DB data and proper app URL
            - cp .env.example .env
            # We need to generate an application key for Laravel to work.
            - php artisan key:generate

  - name: "Run Code Analysis"
    task:
      prologue:
        commands:
          - checkout
          - cache restore
      jobs:
        - name: phpmd
          commands:
            # Run the PHP Mess Detector from our project dependency binary
            - php vendor/bin/phpmd app/ text phpmd_ruleset.xml
        - name: phpcs
          commands:
            # Run the PHP Code Sniffer from our project dependency binary
            - php vendor/bin/phpcs app --report-full --standard=PSR2
        - name: phpcpd
          commands:
            # Run the PHP Copy Paste Detector from the online repository.
            - curl -L https://phar.phpunit.de/phpcpd.phar -o phpcpd.phar
            - php phpcpd.phar app/ --min-lines=50

  - name: "Run Unit tests"
    task:
      jobs:
      - name: phpunit
        commands:
          - checkout
          - cache restore
          # Run the unit tests from the phpunit binary in the vendor folder
          - ./vendor/bin/phpunit

  - name: "Run Browser tests"
    task:
      jobs:
        - name: laravel dusk
          commands:
            - checkout
            - cp .env.example .env
            # Create an empty .sqlite DB
            - touch database/database.sqlite
            - cache restore
            # Create an application key again.
            - php artisan key:generate
            - php artisan dusk:update --detect
            # Start Laravel's built-in web server, so the web driver used by Dusk can connect.
            # We start the server using the .env.dusk.local environment file that uses SQLITE.
            - php artisan serve --env=dusk.local --port=8010 &
            # Run the tests
            - php artisan dusk

  - name: "Run Security Tests"
    task:
      jobs:
        - name: sensiolabs
          commands:
            - checkout
            # We clone the Security Checker repository and cd into it.
            - git clone https://github.com/sensiolabs/security-checker.git
            - cd security-checker
            # Install Secuirity Checker dependencies (not to be confused with our project dependencies)
            - composer install
            # Finally, run the check
            - php security-checker security:check ../composer.lock

```

## Run the demo Laravel project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][demo-project] to your own account.
2. Clone the repository to your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
   Follow the instructions to install the sem CLI and connect it to your
   organization.
4. Run `sem init` inside your repository.
5. Edit the .semaphore/semaphore.yml file and make a commit. When you push a
   commit to GitHub, Semaphore will run the CI pipeline.

## Next steps

Congratulations! You have set up your first PHP continuous integration
project on Semaphore. Here’s some recommended reading:

- [Heroku deployment guide][heroku-guide] shows you how to set up continuous
deployment to Heroku.

## See also

- [Semaphore guided tour][guided-tour]
- [General PHP tips][php-guide]
- [Pipelines reference][pipelines-ref]
- [Caching reference][cache-ref]
- [sem-service reference][sem-service]

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-php-laravel
[php-guide]: https://docs.semaphoreci.com/programming-languages/php/
[guided-tour]: https://docs.semaphoreci.com/guided-tour/getting-started/
[pipelines-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
[cache-ref]: https://docs.semaphoreci.com/reference/toolbox-reference/#cache
[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
[heroku-guide]: https://docs.semaphoreci.com/examples/heroku-deployment/
