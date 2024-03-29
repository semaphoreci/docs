---
Description: Semaphore 2.0 lets you model very complex CI/CD processes by defining your pipeline as a dependency graph. This guide shows you how.
---

# Workflows and Pipelines

![complex pipeline](https://raw.githubusercontent.com/semaphoreci/docs/master/public/complex-pipeline.png)

With Semaphore 2.0 there are two approaches to how you can model your CI/CD
process.

You can model your CI/CD with an unlimited number of blocks in a
sequence. These blocks run sequentially in the same order as you define them
in the [Pipeline YAML file](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/).
In each of those blocks, you can split the work across an arbitrary number of
parallel jobs.

This guide is for teams which need to model CI/CD processes with much higher
complexity. Semaphore lets you do that by defining your pipeline as a dependency
graph.

If a sequential pipeline doesn't meet your team's needs, then this guide is
for you.

## Defining block dependencies

To define your pipeline as a dependency graph, specify a set of dependencies for
each block.

![simple](https://github.com/semaphoreci/docs/raw/master/public/simple.png)

To make block C start once blocks A and B finish, define the blocks in the
following way:

``` yaml
blocks:
  - name: "A"
    dependencies: []
...

  - name: "B"
    dependencies: []
...

  - name: "C"
    dependencies: ["A", "B"]
```

Using block dependencies, you can model any kind of complex workflow.

## Fan-in and Fan-out

In this example, we build a Docker container once, run tests in parallel in the
container and then release a new version of an app.

<img src="https://github.com/semaphoreci/docs/raw/master/public/fan-in-fan-out.png" width="600"></img>

First, specify that your testing blocks depend on the block that builds the
Docker image. The release block can run if all tests have passed. The following
snippet represents the part of the `semaphore.yml` file that is relevant to setting up a fan-in/fan-out pipeline.

``` yaml
blocks:
  - name: "Build"
    dependencies: []
    ...

  - name: "Unit tests"
    dependencies: ["Build"]
    ...

  - name: "Integration tests"
    dependencies: ["Build"]
    ...

  - name: "E2E tests"
    dependencies: ["Build"]
    ...

  - name: "Release candidate"
    dependencies: ["Integration tests", "Unit tests", "E2E tests"]
    ...
```

To checkout the full specification of the Fan-in/Fan-out pipeline, read this [blog post](https://github.com/semaphoreci-demos/semaphore-demo-workflows/blob/fan-in-fan-out/.semaphore/semaphore.yml).

## Monorepo

In a monorepo workflow, you need to run multiple pipelines for multiple
projects within a single repository. For instance, you can run pipelines for
both the Backend and Frontend in parallel.

<img src="https://github.com/semaphoreci/docs/raw/master/public/monorepo.png"></img>

This pipeline has dependencies defined in the following way:

``` yaml
blocks:
  - name: "Backend Lint"
    dependencies: []
    ...

  - name: "Backend Build"
    dependencies: ["Backend Lint"]
    ...

  - name: "Backend Unit tests"
    dependencies: ["Backend Build"]
    ...

  - name: "Frontend Lint"
    dependencies: []
    ...

  - name: "Frontend Build"
    dependencies: ["Frontend Lint"]
    ...

  - name: "Frontend Unit tests"
    dependencies: ["Frontend Build"]
    ...

  - name: "E2E tests"
    dependencies: ["Backend Unit tests", "Frontend Unit tests"]
    ...

  - name: "Release candidate"
    dependencies: ["E2E tests"]
    ...
```

To checkout the full specification of the Monorepo pipeline, read this [blog post](https://github.com/semaphoreci-demos/semaphore-demo-workflows/blob/monorepo/.semaphore/semaphore.yml).

## Multi-platform builds

You can build and test your project for multiple platforms independently.

<img src="https://github.com/semaphoreci/docs/raw/master/public/cross-platform.png" width="600"></img>

In this example, we decided to release a new version across all platforms at once.
The following snippet describes the previous diagram.

``` yaml
blocks:
  - name: "Build for Android"
    dependencies: []
    ...

  - name: "Build for iOS"
    dependencies: []
    ...

  - name: "Build for Web"
    dependencies: []
    ...

  - name: "Test on Android"
    dependencies: ["Build for Android"]
    ...

  - name: "Test on iOS"
    dependencies: ["Build for iOS"]
    ...

  - name: "Test on Web"
    dependencies: ["Build for Web"]
    ...

  - name: "Release"
    dependencies: ["Test on Android", "Test on iOS", "Test on Web"]
    ...
```

To checkout the full specification of the pipeline used in this example, read this [blog post](https://github.com/semaphoreci-demos/semaphore-demo-workflows/blob/multi-platform/.semaphore/semaphore.yml).

## Next steps

Block dependencies provide you with the flexibility to define pipelines in the form
of a Directed Acyclic Graph, where blocks are the graph nodes.

In this guide, you learned how to model complex CI/CD process by defining
dependencies between blocks. We suggest you to have a look at how you can take your CI/CD
to the next level and [promote your pipelines][promotions] either manually or
automatically to delivery phases.


Happy building!

[promotions]: https://docs.semaphoreci.com/essentials/deploying-with-promotions/
