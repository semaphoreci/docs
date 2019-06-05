# Modeling complex workflows

![complex pipeline](https://raw.githubusercontent.com/semaphoreci/docs/next-gen-pipeline-guide/public/complex-pipeline.png)

With Semaphore 2.0 there are two approaches in terms of how you can model your CI/CD
process.

You can model your CI/CD with unlimited number of blocks put in a
sequence. These blocks are run one after another in the same order as they were
defined in the [Pipeline YAML file](https://docs.semaphoreci.com/article/50-pipeline-yaml).
At the same time, inside each of those blocks, one can split the work across arbitrary number of jobs
and run things in parallel.

This guide is intended for teams which need to model CI/CD processes with much higher
complexity. Semaphore 2.0 allows you to do so by providing you with ability
to define your pipeline as dependency graph.

If sequential pipeline doesn't meet your team needs, then this guide is just for
you.

## Define block dependencies

To define your pipeline as dependency graph, you need to specify set of
dependencies for each block.

Let's start simple with the following pipeline.

![simple](https://github.com/semaphoreci/docs/raw/next-gen-pipeline-guide/public/simple.png)

To make block C start once blocks A and B finish define the blocks the following way:

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

With dependencies, you can model any sort of complex workflow.

## Fan-in/Fan-out

Run tests in parallel in a Docker container and then release the new version of your code.

<img src="https://github.com/semaphoreci/docs/raw/next-gen-pipeline-guide/public/fan-in-fan-out.png" width="600"></img>

Specify your testing blocks to depend on the block where Docker image is built. The release block depends on all kind of tests. The following snippet represents part of the semaphore.yml relevant to set up Fan-in/Fan-out pipeline.

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

## Monorepos

You can run separate pipelines against multiple projects within single repository. For instance, you can run pipelines for both Backend and Frontend in parallel.

<img src="https://github.com/semaphoreci/docs/raw/next-gen-pipeline-guide/public/monorepo.png"></img>

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

## Multiple platforms

You can build and test your project against multiple platforms independently.

<img src="https://github.com/semaphoreci/docs/raw/next-gen-pipeline-guide/public/cross-platform.png" width="600"></img>

In this example we decided to release new version across all platforms at once. The following snippet describes the diagram above.

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

## Next step

In general, dependencies provides you with flexibility to define pipelines in a form
of Directed Acyclic Graph - where blocks are the graph nodes.

In this guide you learned how to model complex CI/CD process by defining
dependencies between blocks. We suggest you to have a look how you can take your CI/CD
to the next level and promote your pipeline either manually or automatically to the next phase.


Happy building!
