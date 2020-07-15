---
description: This guide shows you how to optimize your Semaphore 2.0 workflow for monorepo projects. This page shows an example monorepo project setup.
---

# Monorepo Workflows

*Note*: The monorepo support is currently in `beta` stage of development.

This guide shows you how to optimize your Semaphore workflow for monorepo
projects.

A monorepo (short for monolithic repository) is a software development strategy
where code for many applications that may or may not be mutually dependent is
stored in the same version-controlled repository.

Some advantages of a monorepo approach are:

- Ease of code reuse - it is easy to abstract shared behavior into shared libraries
- Simplified dependency management - third-party dependencies can also be shared
- Atomic commits across multiple applications

Semaphore comes with out-of-box support for monorepos.

## An example monorepo project setup

Let's say you have a fairly simple monorepo project that consists of:

- A WEB server application located inside `/web-app/` directory
- An iOS client application located inside `/ios/` directory
- A separate docs web page located inside `/docs/` directory

A Semaphore pipeline for this monorepo project is the following:

```yaml
version: "v1.0"
name: Monorepo project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Test WEB server
    dependencies: []
    run:
      when: "change_in('/web-app/')"
    task:
      jobs:
        - commands:
            - checkout
            - cd web-app
            - make test

  - name: Test iOS client
    dependencies: []
    run:
      when: "change_in('/ios/')"
    task:
      agent:
        machine:
          type: a1-standard-4
          os_image: macos-mojave-xcode11
      jobs:
        - commands:
            - checkout
            - cd ios
            - make test

  - name: Test docs page
    dependencies: []
    run:
      when: "change_in('/docs/')"
    task:
      jobs:
        - commands:
            - checkout
            - cd docs
            - make test

  - name: Integration tests
    dependencies: ["Test WEB server", "Test iOS client"]
    run:
      when: "change_in(['/web-app/', '/ios/'])"
    task:
      jobs:
        - commands:
            - checkout
            - make integration-tests
```

With this setup, we run separate tests for each part of the system and
integration tests once both WEB server and iOS client tests pass.

The [run][run-ref] field is used to conditionally run blocks only if the
condition in its when sub-field is satisfied.

This, in combination with `change_in` function which checks whether there were
any changes on given location(s) for a particular workflow, allows us to only
run tests for those parts of the project that are currently being worked on.

In the example above this means that if we are working, for example, only on
the iOS client app within the `/ios/` directory of the repository, the only
blocks that will be executed are the `Test iOS client` and `Integration tests`.
Everything else will be skipped.

This can significantly reduce the time and cost and still provide you with
required feedback about the changes that are being introduced into your monorepo.

The `change_in` function, by default, calculates the changeset (all changed
files in the commits from commit range of interest for given workflow) in a
slightly different way for the `master` and the other branches or pull requests.
For more details and ways in which this can be modified please check the
[reference][change-in-ref].

## Set up the automatic deployments for a monorepo project

Here we will assume that you already have a `web-prod.yml`, `ios-prod.yml` and
`docs-prod.yml` deployments defined in your `.semaphore/` directory (you can find
examples for various kinds of deployments in the [Use cases][use-cases] section
of our docs) and we will focus on auto-promoting the right ones for a given
workflow.

To achieve this we need to introduce the following [promotions][promotions-ref]
block to our configuration from above.

```yaml
promotions:
  - name: Deploy Web Server
    pipeline_file: web-prod.yml
    auto_promote:
      when: "branch = 'master' and result = 'passed' and change_in('/web-app/')"
  - name: Deploy iOS client
    pipeline_file: ios-prod.yml
    auto_promote:
      when: "branch = 'master' and result = 'passed' and change_in('/ios/')"
  - name: Deploy docs page
    pipeline_file: docs-prod.yml
    auto_promote:
      when: "branch = 'master' and result = 'passed' and change_in('/docs/')"
```

With this, each part of the system will be automatically deployed when the tests
pass on the master branch only if the push that initiated workflow contains
changes in the location(s) given to the `change_in` function.

## The complete example

Here is the complete example for `.semaphore/semaphore.yml` file with the
promotions block from above included:

```yaml
version: "v1.0"
name: Monorepo project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Test WEB server
    dependencies: []
    run:
      when: "change_in('/web-app/')"
    task:
      jobs:
        - commands:
            - checkout
            - cd web-app
            - make test

  - name: Test iOS client
    dependencies: []
    run:
      when: "change_in('/ios/')"
    task:
      agent:
        machine:
          type: a1-standard-4
          os_image: macos-mojave-xcode11
      jobs:
        - commands:
            - checkout
            - cd ios
            - make test

  - name: Test docs page
    dependencies: []
    run:
      when: "change_in('/docs/')"
    task:
      jobs:
        - commands:
            - checkout
            - cd docs
            - make test

  - name: Integration tests
    dependencies: ["Test WEB server", "Test iOS client"]
    run:
      when: "change_in(['/web-app/', '/ios/'])"
    task:
      jobs:
        - commands:
            - checkout
            - make integration-tests

promotions:
  - name: Deploy Web Server
    pipeline_file: web-prod.yml
    auto_promote:
      when: "branch = 'master' and result = 'passed' and change_in('/web-app/')"

  - name: Deploy iOS client
    pipeline_file: ios-prod.yml
    auto_promote:
      when: "branch = 'master' and result = 'passed' and change_in('/ios/')"

  - name: Deploy docs page
    pipeline_file: docs-prod.yml
    auto_promote:
      when: "branch = 'master' and result = 'passed' and change_in('/docs/')"
```

## See also

- [Skip block execution][skip-ref]
- [Deploying with promotions][promotions-guided]
- [Defining 'when' conditions][conditions-ref]



[run-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#run-in-blocks
[change-in-ref]: https://docs.semaphoreci.com/reference/conditions-reference/#change_in
[use-cases]: https://docs.semaphoreci.com/examples/tutorials-and-example-projects/
[promotions-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
[skip-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#skip-in-blocks
[promotions-guided]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
[conditions-ref]: https://docs.semaphoreci.com/reference/conditions-reference/
