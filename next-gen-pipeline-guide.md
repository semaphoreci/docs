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
to specify dependencies for each block within a pipeline.

If sequential pipeline doesn't meet your team needs, then this guide is just for
you.

## Define Semaphore pipeline via dependencies between blocks



## Next step

In this guide you learned how to model complex CI/CD process by defining
dependencies between blocks. We suggest you to have a look how you can take your CI/CD
to the next level and promote your pipeline either manually or automatically to the next phase.


Happy building!
