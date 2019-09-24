This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for a Ruby on Rails web application.

## Demo project

Semaphore maintains an example Ruby on Rails project:

- [Demo Ruby on Rails project on GitHub][rails-demo-project]

In the repository you will find an annotated Semaphore configuration file
`.semaphore/semaphore.yml`.

The application uses the latest stable version of Rails, Rubocop, Brakeman,
RSpec, Capybara, with PostgreSQL as the database.

## Overview of the CI pipeline

The demo Rails CI pipeline performs the following tasks:

- Scans the code for style and security issues using Rubocop and Brakeman;
- Runs unit tests, using RSpec;
- Runs integration tests.

Mature applications usually have many tests and optimizing their runtime saves
a lot of valuable time for development. So for demonstration we run
different types of unit tests in parallel jobs.

When code scanning detects errors, it's a good idea to not run any further
tests and fail the build early. Similarly, in case any unit tests fail,
it usually signals a fundamental problem in code. In that case we want fast
feedback, so we configured the pipeline to fail the build before proceeding
to time consuming integration tests.

For these reasons our pipeline is composed of three blocks of tests:

![Rails CI pipeline](https://github.com/semaphoreci-demos/semaphore-demo-ruby-rails/raw/master/public/ci-pipeline.png)

## Sample configuration

``` yaml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name your pipeline. In case you connect multiple pipelines with promotions,
# the name will help you differentiate between, for example, a CI build phase
# and delivery phases.
name: Demo Rails 5 app

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
  - name: Setup
    task:
      jobs:
        - name: bundle
          commands:
          # Checkout code from Git repository. This step is mandatory if the
          # job is to work with your code.
          # Optionally you may use --use-cache flag to avoid roundtrip to
          # remote repository.
          # See https://docs.semaphoreci.com/article/54-toolbox-reference#checkout
          - checkout
          # Restore dependencies from cache.
          # Read about caching: https://docs.semaphoreci.com/article/149-caching
          - cache restore
          # Set Ruby version:
          - sem-version ruby 2.6.0
          - bundle install --deployment -j 4 --path vendor/bundle
          # Store the latest version of dependencies in cache,
          # to be used in next blocks and future workflows:
          - cache store

  - name: Code scanning
    task:
      jobs:
        - name: check style + security
          commands:
            - checkout
            - cache restore
            # Bundler requires `install` to run even though cache has been
            # restored, but generally this is not the case with other package
            # managers. Installation will not actually run and command will
            # finish quickly:
            - sem-version ruby 2.6.0
            - bundle install --deployment --path vendor/bundle
            - bundle exec rubocop
            - bundle exec brakeman

  - name: Unit tests
    task:
      # This block runs two jobs in parallel and they both share common
      # setup steps. We can group them in a prologue.
      # See https://docs.semaphoreci.com/article/50-pipeline-yaml#prologue
      prologue:
        commands:
          - checkout
          - cache restore
          # Start Postgres database service.
          # See https://docs.semaphoreci.com/article/54-toolbox-reference#sem-service
          - sem-service start postgres
          - sem-version ruby 2.6.0
          - bundle install --deployment --path vendor/bundle
          - bundle exec rake db:setup

      jobs:
      - name: RSpec - model tests
        commands:
          - bundle exec rspec spec/models

      - name: RSpec - controller tests
        commands:
          - bundle exec rspec spec/controllers

  # Note that it's possible to define an agent on a per-block level.
  # For example, if your integration tests need more RAM, you could override
  # agent configuration here to use e1-standard-8.
  # See https://docs.semaphoreci.com/article/50-pipeline-yaml#agent-in-task
  - name: Integration tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore
          - sem-service start postgres
          - sem-version ruby 2.6.0
          - bundle install --deployment --path vendor/bundle
          - bundle exec rake db:setup

      jobs:
      - name: RSpec - feature specs
        commands:
          - bundle exec rspec spec/features
```

The project is using the following database configuration:

``` yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: localhost
  username: postgres

development:
  <<: *default
  database: demo-rails5_development

test:
  <<: *default
  database: demo-rails5_test
```

PostgreSQL and MySQL instances run inside each job and can be accessed with
a blank password. For more information on configuring database access,
including tips for older versions of Rails, see the
[Ruby language guide][ruby-guide].

Firefox, Chrome, and Chrome Headless drivers for Capybara work out of the box,
so you will not need to make any adjustment for browser tests to work on
Semaphore.

## Run the demo Ruby on Rails project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][rails-demo-project] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
   Follow the instructions to install sem CLI, connect it to your
   organization.
4. Run `sem init` inside your repository.
5. Edit the .semaphore/semaphore.yml file and make a commit. When you push a
   commit to GitHub, Semaphore will run the CI pipeline.

## Next steps

Congratulations! You have set up your first Rails 5 continuous integration
project on Semaphore. Here’s some recommended reading:

- [Heroku deployment guide][heroku-guide] shows you how to set up continuous
deployment to Heroku.

## See also

- [Semaphore guided tour][guided-tour]
- [Pipelines reference][pipelines-ref]
- [Caching reference][cache-ref]
- [sem-service reference][sem-service]

[rails-demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-ruby-rails
[ruby-guide]: https://docs.semaphoreci.com/article/73-ruby
[guided-tour]: https://docs.semaphoreci.com/category/56-guided-tour
[pipelines-ref]: https://docs.semaphoreci.com/article/50-pipeline-yaml
[cache-ref]: https://docs.semaphoreci.com/article/54-toolbox-reference#cache
[sem-service]: https://docs.semaphoreci.com/article/132-sem-service-managing-databases-and-services-on-linux
[heroku-guide]: https://docs.semaphoreci.com/article/100-heroku-deployment
