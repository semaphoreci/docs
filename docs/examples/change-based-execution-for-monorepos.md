---
description: This guide shows you to how optimize a monorepo CI/CD with change-based block execution.
---

# Changed-Based Execution for Monorepos

This guide shows you how to use change detection to optimize a monorepo continuous integration (CI).

## Demo project

A monorepo is a container repository with multiple separate applications or projects. Semaphore
maintains a reference demo on GitHub:

- [Monorepo project on GitHub][demo-project]

You’ll find a Semaphore configuration file with a sample CI pipeline at `.semaphore/semaphore.yml`

The repository contains three individually deployable applications. They can be found under the `/services` folder.

- **Billing**: a billing system written in Go. Uses [mux][mux] to provide an HTTP endpoint on port 8000.
- **User**: a user account management application. Written in Ruby, it employs an in-memory database and uses [Sinatra][sinatra] to expose an HTTP endpoint.
- **UI**: is the Elixir-based Web application component.

These applications are meant to work together. After forking and cloning the repository, you can
start the suite with:

```bash
$ bash start.sh
```

## Overview of the pipeline

The pipeline performs the following tasks for the three applications in the monorepo:

- **Lint**: uses a linting tool to detect potential errors in the source code.
- **Test**: runs unit the application's tests.

To avoid re-running tasks for unchanged code, the pipeline uses the **change detection**, when an
application has been modified by recent commits, the related block runs. Otherwise, the block is
skipped.

The following screenshot shows the workflow resulting from changing a file inside the `/service/ui`
folder:

![CI pipeline for monorepo](https://raw.githubusercontent.com/semaphoreci-demos/semaphore-demo-monorepo/master/public/ci-pipeline.png)

## Sample configuration

The demo is using the following configuration. If you're new to Semaphore, we recommend going
through the [guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) and linked
documentation pages for more information.

```yaml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name your pipeline. In case you connect multiple pipelines with promotions,
# the name will help you differentiate between, for example, a CI build phase
# and delivery phases.
name: Monorepo Demo

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

  # This block tests the UI service application
  - name: "UI Service"
    dependencies: []

    # Run block only when a file changes in the /services/ui folder
    # except when is markdown
    run:
      when: "change_in('/services/ui', {exclude: '/services/ui/**/*.md'})"

    task:
      # The prologue runs *before* each job in the block
      # The prologues clones the repository, installs Elixir dependencies
      # and caches them
      # See https://docs.semaphoreci.com/article/50-pipeline-yaml#prologue
      prologue:
        commands:
          - checkout
          - cd services/ui
          - sem-version elixir 1.9
          - cache restore
          - mix local.hex --force
          - mix local.rebar --force
          - mix deps.get
          - mix deps.compile
          - cache store

      # This block runs two parallel jobs: a linter to check the code for
      # deficiencies and the application unit tests
      jobs:
        - name: Lint
          commands:
            - mix credo
        - name: Test
          commands:
            - mix test

  # This block tests the user service application
  - name: "User Service"
    dependencies: []

    # Run block only when a file changes in the /services/user folder
    # except when is markdown
    run:
      when: "change_in('/services/users', {exclude: '/services/users/**/*.md'})"

    task:
      # The prologue clones the repo, installs and caches Ruby dependencies
      prologue:
        commands:
          - checkout
          - cd services/users
          - sem-version ruby 2.5
          - cache restore
          - bundle install
          - cache store

      # This block runs two parallel jobs: a linter to check the code for
      # deficiencies and the application unit tests
      jobs:
        - name: Lint
          commands:
            - bundle exec rubocop

        - name: Test
          commands:
            - bundle exec ruby test.rb

  # This block tests the billing application
  - name: "Billing Service"
    dependencies: []

    # Run block only when a file changes in the /services/ui folder
    # except when is markdown
    run:
      when: "change_in('/services/billing', {exclude: '/services/billing/**/*.md'})"

    task:
      # The prologue installs Go modules and caches them after cloning the repo
      prologue:
        commands:
          - checkout
          - cd services/billing
          - sem-version go 1.14
          - cache restore
          - go get ./...
          - cache store

      # This block runs two parallel jobs: a linter to check the code for
      # deficiencies and the application unit tests
      jobs:
        - name: Lint
          commands:
            - gofmt -l .

        - name: Test
          commands:
            - go test ./...
```

## Run the demo yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][demo-project].
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the upper right side to create a new project.
4. Select the forked repository.
5. Modify or create a file inside one application folder and commit the changes to `master`.

## Next steps

You can use `change_in` to build smarter pipelines. The change function not only allows you to skip
or activate blocks, but it can also be used inside [promotions][promotions] to start additional
pipelines.

To continue learning about `change_in`, check these resources:
- [Monorepo workflows][monorepo-workflows]
- [Change_in reference][change-in]

## See also

- [Semaphore guided tour][guided-tour]
- [Pipelines reference][pipelines-ref]
- [Cache reference][cache-ref]
- [Go reference][go-ref]
- [Ruby reference][ruby-ref]
- [Elixir reference][elixif-ref]

[monorepo-workflows]: https://docs.semaphoreci.com/essentials/building-monorepo-projects/
[change-in]: https://docs.semaphoreci.com/reference/conditions-reference/#usage-examples-for-change_in
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-monorepo
[promotions-guide]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
[caching-guide]: https://docs.semaphoreci.com/guided-tour/caching-dependencies/
[guided-tour]: https://docs.semaphoreci.com/guided-tour/getting-started/
[pipelines-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
[cache-ref]: https://docs.semaphoreci.com/reference/toolbox-reference/#cache
[mux]: https://github.com/gorilla/mux
[elixir-ref]: https://docs.semaphoreci.com/programming-languages/elixir/
[ruby-ref]: https://docs.semaphoreci.com/programming-languages/ruby/
[go-ref]: https://docs.semaphoreci.com/programming-languages/go/
[promotions]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
