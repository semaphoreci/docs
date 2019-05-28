# Modeling Your CI/CD via Next-Gen Semaphore Pipelines

## Introduction (What this is about?)

With Semaphore 2.0 there are two approaches in terms of how you can model your CI/CD
process.

You can model your CI/CD with unlimited number of blocks put in a
sequence. These blocks are run one after another in the same order as they were
defined in the (Pipeline YAML file)[link to pipeline reference]. At the same time,
inside each of those blocks, one can split the work across arbitrary number of jobs
and run things in parallel.

This guide is intended for teams which need to model CI/CD processes with much higher
complexity. Semaphore 2.0 allows you to do so by (providing you with ability |
giving you a freedom) to specify dependencies for each block within a pipeline.

If blocks put to run in a sequence, don't meet your team needs, then this guide is just for
you.

## Define Semaphore pipeline via dependencies between blocks

We will start with an example and show you how you can model the flow in your
pipeline by specifying dependencies for each block.

Let's have a look at the following `semaphore.yml` file:

``` yaml
version: "v1.0"
name: Mega pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Code quality checks"
    dependencies: []
    task:
      jobs:
      - name: "Lint"
        commands:
          - sleep 10
          - echo "Lint completed"

  - name: "Dockerize"
    dependencies: ["Code quality checks"]
    task:
      jobs:
      - name: "Build"
        commands:
          - sleep 10
          - echo "Build completed"

  - name: "Smoke tests"
    dependencies: ["Dockerize"]
    task:
      jobs:
        - name: "Smoke tests"
          commands:
            - sleep 1
            - echo "Smoke tests completed"

  - name: "Unit tests"
    dependencies: ["Smoke tests"]
    task:
      jobs:
      - name: "Unit tests 1/3"
        commands:
          - sleep 10
          - echo "Unit tests 1/3 completed"
      - name: "Unit tests 2/3"
        commands:
          - sleep 10
          - echo "Unit tests 2/3 completed"
      - name: "Unit tests 3/3"
        commands:
          - sleep 10
          - echo "Unit tests 3/3 completed"

  - name: "Integration tests"
    dependencies: ["Unit tests"]
    task:
      jobs:
      - name: "Integration tests 1/3"
        commands:
          - sleep 10
          - echo "Integration tests 1/3 completed"
      - name: "Integration tests 2/3"
        commands:
          - sleep 10
          - echo "Integration tests 2/3 completed"

  - name: "E2E tests"
    dependencies: ["Integration tests"]
    task:
      jobs:
      - name: "E2E tests 1/2"
        commands:
          - sleep 10
          - echo "E2E tests 1/2 completed"
      - name: "E2E tests 2/2"
        commands:
          - sleep 10
          - echo "E2E tests 2/2 completed"

  - name: "Long perf tests"
    dependencies: ["Dockerize"]
    task:
      jobs:
      - name: "Perf"
        commands:
          - sleep 60
          - echo "Perf completed"

  - name: "Release candidate"
    dependencies: ["E2E tests", "Long perf tests"]
    task:
      jobs:
      - name: "Release"
        commands:
          - sleep 10
          - echo "Release completed"
```

You can notice the whole trick is in `dependencies` property specified on each block.
However, in the following guide you will get a glimpse why this way of
modeling CI/CD pipelines is powerful.

In our example Pipeline we have the structure of following blocks:

- Code quality check
- Dockerize
- Smoke tests
- Unit tests
- Integration tests
- E2E tests
- Performance tests
- Release candidate

Each of these blocks are parts of the pipeline which need to be run before
deployment to any environment.

Now, lets take a look at how these blocks are put in order using [`dependencies`](link-to-deps-field-reference) property.

We specify that we want to run checks against our source code to verify that the
revision we are running pipeline against, is conforming to the
rules within our organization. We want to run this first. Therefore, we specify an empty array for
`dependencies` property since there isn't any block which code checks should
depend on.

```
  - name: "Code quality checks"
    dependencies: []

```

*Note*: In case any of your blocks can start immediately without depending on any other
block, you still have to specify `dependencies` property and put an empty array
there.

After running the style checks against our code we want to pack it up inside Docker
image. So we specified that Dockerize block depends on Code quality check block.

```
  - name: "Dockerize"
    dependencies: ["Code quality checks"]
```

Once we have our Docker image built and our code within, we want to perform all
kind of tests against this particular version of our software. So we run Smoke
tests, Unit tests, Integration tests and E2E tests in sequential order. That
leaves Performance tests to run in parallel since they consume much more time
than any other testing block.

Smoke tests are run as first to avoid uneccessary extra cost in case our basic
functionality doesn't work. In case they pass our pipeline with progress by
running other types of tests.

The following snippets show definition of `dependencies` property for each of
our block for testing:

```
  - name: "Long perf tests"
    dependencies: ["Dockerize"]
```

```
  - name: "Smoke tests"
    dependencies: ["Dockerize"]
```

```
  - name: "Unit tests"
    dependencies: ["Smoke tests"]
```

```
  - name: "Integration tests"
    dependencies: ["Unit tests"]
```

```
  - name: "E2E tests"
    dependencies: ["Integration tests"]
```

In the end of our pipeline when all of our tests are run, we tag this version as
release candidate.

```
  - name: "Release candidate"
    dependencies: ["E2E tests", "Long perf tests"]
```

## Next step

In this guide you learned how you can model complex CI/CD process by defining
dependencies between blocks. We suggest you to have a look how you can take your CI/CD
to the next level and promote either manually or automatically to the next phase.


Cheers/Happy building/Have fun
