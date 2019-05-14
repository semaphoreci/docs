This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for a Ruby on Rails web application.

- [Demo project](#demo-project)
- [Overview of the CI pipeline](#overview-of-the-ci-pipeline)
- [Sample configuration](#sample-configuration)
- [Run the demo Ruby on Rails project yourself](#run-the-demo-ruby-on-rails-project-yourself)
- [Next steps](#next-steps)
- [See also](#see-also)

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

# An agent defines the environment in which your code runs. The agent's
# environment can be either a Virtual Machine, or a collection of containers.
#
# In this example we will use a Ruby container with a Postgres 10 sidecar
# container to run the jobs. The containers will run on a
# e1-standard-2 (2 CPU, 4 GB memory) machines type.
#
# See https://docs.semaphoreci.com/article/20-machine-types
# and https://docs.semaphoreci.com/article/127-custom-ci-cd-environment-with-docker.
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

  containers:
    # The first container in the list, usually called main, executes the commands.
    - name: main
      image: semaphoreci/ruby:2.6.1-node
      env_vars:
        # We construct a Rails friendly DATABASE_URL environment variable based
        # on the definition of the 'db' container bellow.
        #
        # The format that we follow is postgres://<username>:<password>@<hostname>
        - name: DATABASE_URL
          value: "postgres://postgres:keyboard-cat@db"
        - name: RAILS_ENV
          value: test

    # The rest of the containers in the list are sidecar containers that offer
    # additional services to the main container. They are connected to the first
    # container via DNS, in this case the hostname `db` will point to this
    # container.
    - name: db
      image: postgres:10
      env_vars:
        - name: POSTGRES_PASSWORD
          value: keyboard-cat

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
          # See https://docs.semaphoreci.com/article/54-toolbox-reference#libcheckout
          - checkout
          # Restore dependencies from cache.
          # Read about caching: https://docs.semaphoreci.com/article/54-toolbox-reference#cache
          - cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock),gems-$SEMAPHORE_GIT_BRANCH-,gems-master-
          - bundle install --deployment -j 4 --path vendor/bundle
          # Store the latest version of dependencies in cache,
          # to be used in next blocks and future workflows:
          - cache store gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock) vendor/bundle

  - name: Code scanning
    task:
      jobs:
        - name: check style + security
          commands:
            - checkout
            - cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock),gems-$SEMAPHORE_GIT_BRANCH-,gems-master-
            # Bundler requires `install` to run even though cache has been
            # restored, but generally this is not the case with other package
            # managers. Installation will not actually run and command will
            # finish quickly:
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
          - cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock),gems-$SEMAPHORE_GIT_BRANCH-,gems-master-
          - bundle install --deployment --path vendor/bundle
          - bundle exec rake db:migrate db:setup

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
          - cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock),gems-$SEMAPHORE_GIT_BRANCH-,gems-master-
          - bundle install --deployment --path vendor/bundle
          - bundle exec rake db:migrate db:setup

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
  url: <%= ENV['DATABASE_URL'] %>
```

A PostgreSQL container is attached to the environment as the database layer for
our test suite. MySQL, SQLite, and any other databases can be configured to run
with Semaphore. Refer to [our guide for custom CI/CD environments with
Docker][custom-ci-cd] for further information.

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
[custom-ci-cd]: https://docs.semaphoreci.com/article/127-custom-ci-cd-environment-with-docker
