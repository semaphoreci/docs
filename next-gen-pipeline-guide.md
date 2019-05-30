# Modeling Your CI/CD via Dependencies

With Semaphore 2.0 there are two approaches in terms of how you can model your CI/CD
process.

You can model your CI/CD with unlimited number of blocks put in a
sequence. These blocks are run one after another in the same order as they were
defined in the (Pipeline YAML file)[https://docs.semaphoreci.com/article/50-pipeline-yaml].
At the same time, inside each of those blocks, one can split the work across arbitrary number of jobs
and run things in parallel.

This guide is intended for teams which need to model CI/CD processes with much higher
complexity. Semaphore 2.0 allows you to do so by providing you with ability
to specify dependencies for each block within a pipeline.

If blocks put to run in a sequence, don't meet your team needs, then this guide is just for
you.

## Define Semaphore pipeline via dependencies between blocks

We will start with an example and show you how you can model the flow in your
pipeline by specifying dependencies for each block.

Let's have a look at the following
[`semaphore.yml`](https://github.com/semaphoreci-demos/semaphore-demo-workflows/blob/dependencies-intro/.semaphore/semaphore.yml) file:

``` yaml
blocks:
  - name: "Code quality checks"
    dependencies: []
    ...

  - name: "Security checks"
    dependencies: []
    ...

  - name: "Dockerize"
    dependencies: ["Code quality checks"]
    ...

  - name: "Unit tests"
    dependencies: ["Dockerize"]
    ...

  - name: "Integration tests"
    dependencies: ["Unit tests"]
    ...

  - name: "Long perf tests"
    dependencies: ["Dockerize"]
    ...

  - name: "Release candidate"
    dependencies: ["E2E tests", "Long perf tests", "Security checks"]
    ...
```

You can notice the whole trick is in `dependencies` property specified on each block.

In our example Pipeline we have the structure of following blocks:

- Code quality checks
- Security checks
- Dockerize
- Unit tests
- Integration tests
- Performance tests
- Release candidate

Each of these blocks are parts of the pipeline which need to be run before
we run deployment to any of ours environment.

Lets have a look at how these blocks are put in order by using [`dependencies`](link-to-deps-field-reference) property.

We specify that we want to run checks to verify that the
revision of code we are running pipeline against, is conforming to the
rules. We want to run this first. Therefore, we specify an empty array for
`dependencies` property since there isn't any block which code checks should
depend on.

```
  - name: "Code quality checks"
    dependencies: []

```

In case any of your blocks can start immediately without depending on any other
block, you still have to specify `dependencies` property and put an empty array
there. Otherwise you will get an error saying that your YAML isn't valid.

After running the style checks against our code we want to pack it up inside Docker
image. So we specified that Dockerize block depends on Code quality check block.

```
  - name: "Dockerize"
    dependencies: ["Code quality checks"]
```

Once we have our Docker image built and our code within, we want to perform
different kind of tests against this particular version of our software. So we run
Unit tests and Integration tests tests in sequential order. That
leaves Performance tests to run in parallel since they consume much more time
than any other kind of tests.

In the end of our pipeline after all sorts of tests are run, we tag docker image used as
release candidate.

```
  - name: "Release candidate"
    dependencies: ["E2E tests", "Long perf tests"]
```

## Next step

In this guide you learned how to model complex CI/CD process by defining
dependencies between blocks. We suggest you to have a look how you can take your CI/CD
to the next level and promote your pipeline either manually or automatically to the next phase.


Happy building!
