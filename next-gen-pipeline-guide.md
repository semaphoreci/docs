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

With this simple mechanism, you can model all CI/CD patterns one can think off.

### Fan-in/Fan-out

![Fan-in/Fan-out diagram](https://github.com/semaphoreci/docs/raw/next-gen-pipeline-guide/public/fan-in-fan-out.png)


### Parallel lanes

## Next step

In general, dependencies provides you with flexibility to define pipelines in a form
of Directed Acyclic Graph - where blocks are the graph nodes.

In this guide you learned how to model complex CI/CD process by defining
dependencies between blocks. We suggest you to have a look how you can take your CI/CD
to the next level and promote your pipeline either manually or automatically to the next phase.


Happy building!
