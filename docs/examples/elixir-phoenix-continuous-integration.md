---
description: This guide shows you how to use Semaphore 2.0 to set up a continuous integration (CI) pipeline for an Elixir Phoenix web application.
---

# Elixir Phoenix Continuous Integration

This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for an Elixir Phoenix web application.

## Demo project

Semaphore maintains an example Elixir Phoenix project:

- [Demo Elixir Phoenix project on GitHub][demo-project]

In the repository you will find an annotated Semaphore configuration file
`.semaphore/semaphore.yml`.

The application uses Mix, Phoenix, ExUnit, Wallaby with headless Chrome, Credo,
Dialyxir, and PostgreSQL as database.

## Overview of the CI pipeline

The demo Elixir Phoenix CI pipeline performs the following tasks:

- Builds the project using Mix
- Performs static code analysis using credo, format and dialyzer in parallel
  jobs.
- Runs ExUnit tests, including integration tests with Wallaby using headless
  Chrome.

When code scanning detects errors, it's a good idea to not run any further tests
and fail the build early. For fast feedback, we configured the pipeline to fail
the build before proceeding to automated tests.

The final example pipeline is composed of three [blocks][concepts]:

![Elixir Phoenix CI pipeline](https://github.com/semaphoreci-demos/semaphore-demo-elixir-phoenix/raw/master/public/ci-pipeline.png)

## Sample configuration

Project is using the following configuration. If you're new to Semaphore, we
recommend going through the [guided tour][guided-tour] and linked documentation
pages for more information

``` yaml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name of your pipeline. In this example we connect two pipelines with
# a promotion, so it helps to differentiate what's the job of each.
name: Elixir Phoenix example CI pipeline on Semaphore

# An agent defines the environment in which your code runs.
# It is a combination of one of available machine types and operating
# system images. See:
# https://docs.semaphoreci.com/ci-cd-environment/machine-types/
# https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

# Blocks make up the structure of a pipeline and are executed sequentially.
# Each block has a task that defines one or many parallel jobs. Jobs define
# the commands to execute.
# See https://docs.semaphoreci.com/guided-tour/concepts/
blocks:
  - name: Set up
    task:
      jobs:
      - name: compile and build plts
        commands:
          # Checkout code from Git repository. This step is mandatory if the
          # job is to work with your code.
          - checkout

          - bin/setup_ci_elixir
          - sem-version elixir 1.8.1

          # Restore dependencies from cache, command won't fail if it's
          # missing. More on caching:
          # - https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/
          # - https://docs.semaphoreci.com/programming-languages/elixir/
          - cache restore
          # Cache the PLT generated from the dialyzer to speed up pipeline process.
          # As suggested here - https://github.com/jeremyjh/dialyxir#continuous-integration
          # This will need to be rebuilt if elixir or erlang version changes.
          - cache restore dialyzer-plt

          - mix deps.get
          - mix do compile, dialyzer --plt
          - MIX_ENV=test mix compile

          # Store deps after compilation, otherwise rebar3 deps (that is, most
          # Erlang deps) won't be cached:
          - cache store
          - cache store dialyzer-plt priv/plts/

  - name: Analyze code
    task:
      # Commands in prologue run at the beginning of each parallel job.
      # https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
      prologue:
        commands:
        - checkout
        - bin/setup_ci_elixir
        - sem-version elixir 1.8.1
        - cache restore
        - cache restore dialyzer-plt
      # This block contains 3 parallel jobs:
      jobs:
      - name: credo
        commands:
        - mix credo -a

      - name: dialyzer
        commands:
        - mix dialyzer --halt-exit-status --no-compile

      - name: formatter
        commands:
        - mix format --check-formatted

  - name: Run tests
    task:
      prologue:
        commands:
        - checkout
        - bin/setup_ci_elixir
        - sem-version elixir 1.8.1
        - cache restore

      jobs:
      - name: ex_unit
        # Define an environment variable
        # See https://docs.semaphoreci.com/guided-tour/environment-variables-and-secrets/
        env_vars:
        - name: DATABASE_URL
          value: "ecto://postgres:@0.0.0.0:5432/sema_test"
        commands:
        # Start Postgres database service
        # https://docs.semaphoreci.com/reference/toolbox-reference/#sem-service
        - sem-service start postgres
        - mix test

```

### Database access

PostgreSQL and MySQL instances run inside each job and can be accessed with
a blank password. For more information on starting and using databases, see
[Ubuntu image][ubuntu1804] and [sem-service][sem-service] references.

### Browser testing

To enable headless Chrome support, add the following to your `config/test.exs`:

``` elixir
config :wallaby,
  driver: Wallaby.Experimental.Chrome
```

Semaphore provides [Chrome preinstalled][ubuntu1804], so no further action is
needed on your part.

## Run the demo Elixir project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][demo-project] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Create your secret as per instructions above.
5. Edit any file and push GitHub, and Semaphore will run the CI/CD pipeline.

## Next steps

Congratulations! You have set up your first Elixir continuous integration
project on Semaphore. As the next step you will probably want to configure
deployment. For more information and practical examples, see:

- [Deploying with promotions][promotions], a general introduction in Semaphore
  guided tour.
- [Deployment tutorials and example projects][deployment-tutorials]

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-elixir-phoenix
[concepts]: https://docs.semaphoreci.com/guided-tour/concepts/
[guided-tour]: https://docs.semaphoreci.com/guided-tour/getting-started/
[ubuntu1804]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/
[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
[promotions]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
[deployment-tutorials]: https://docs.semaphoreci.com/examples/tutorials-and-example-projects/#deployment
