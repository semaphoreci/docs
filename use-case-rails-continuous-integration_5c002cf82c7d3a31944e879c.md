This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for a Ruby on Rails web application.
Before starting, [create a new Semaphore project][create-project].

## Define the pipeline

Our Rails CI pipeline will perform the following tasks:

- Scan the code for style and security issues using Rubocop and Brakeman;
- Run unit tests, using RSpec;
- Run integration tests.

Mature applications usually have many tests and optimizing their runtime saves
a lot of valuable time for development. So for demonstration we'll run
different types of unit tests in parallel jobs.

When code scanning detects errors, it's a good idea to not run any further
tests and fail the build early. Similarly, in case any unit tests fail,
it usually signals a fundamental problem in code. In that case we want fast
feedback, so we'll configure the pipeline to fail the build before proceeding
to time consuming integration tests.

For these reasons our pipeline is composed of three blocks of tests:

<pre><code class="language-yaml"># .semaphore/semaphore.yml
version: v1.0
name: Demo Rails 5 app
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Setup
    task:
      jobs:
        - name: bundle
          commands:
          - checkout
          # Partial cache key matching ensures that new branches reuse gems
          # from the last build of master.
          - cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock),gems-$SEMAPHORE_GIT_BRANCH-,gems-master-
          - bundle install --deployment -j 4 --path vendor/bundle
          - cache store gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock) vendor/bundle

  - name: Code scanning
    task:
      jobs:
        - name: check style + security
          commands:
            - checkout
            - cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock),gems-$SEMAPHORE_GIT_BRANCH-,gems-master-
            - bundle install --deployment --path vendor/bundle
            - bundle exec rubocop
            - bundle exec brakeman

  - name: Unit tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock),gems-$SEMAPHORE_GIT_BRANCH-,gems-master-
          - sem-service start postgres
          - bundle install --deployment --path vendor/bundle
          - bundle exec rake db:setup

      jobs:
      - name: RSpec - model tests
        commands:
          - bundle exec rspec spec/models

      - name: RSpec - controller tests
        commands:
          - bundle exec rspec spec/controllers

  - name: Integration tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock),gems-$SEMAPHORE_GIT_BRANCH-,gems-master-
          - sem-service start postgres
          - bundle install --deployment --path vendor/bundle
          - bundle exec rake db:setup

      jobs:
      - name: RSpec - feature specs
        commands:
          - bundle exec rspec spec/features
</code></pre>

The example is based on a Rails 5 application, with the following database
configuration:

<pre><code class="language-yaml"># config/database.yml
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
</code></pre>

PostgreSQL and MySQL instances run inside each job and can be accessed with
a blank password. For more information on configuring database access,
including tips for older versions of Rails, see the
[Ruby language guide][ruby-guide].

Firefox, Chrome, and Chrome Headless drivers for Capybara work out of the box,
so you will not need to make any adjustment for browser tests to work on
Semaphore.

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

[create-project]: https://docs.semaphoreci.com/article/63-your-first-project
[ruby-guide]: https://docs.semaphoreci.com/article/73-ruby
[guided-tour]: https://docs.semaphoreci.com/category/56-guided-tour
[pipelines-ref]: https://docs.semaphoreci.com/article/50-pipeline-yaml
[cache-ref]: https://docs.semaphoreci.com/article/54-toolbox-reference#cache
[sem-service]: https://docs.semaphoreci.com/article/54-toolbox-reference#sem-service
[heroku-guide]: https://docs.semaphoreci.com/article/100-heroku-deployment
