
* [Overview](#overview)
* [The scenario](#the-scenario)
* [The logic behind the recipe](#the-logic-behind-the-recipe)
* [An example project](#an-example-project)
* [See Also](#see-also)

## Overview

The purpose of this document is to provide a recipe for caching big
repositories for speed.

## The scenario

Imagine that you have one or more huge files on a GitHub repository and that
you want to make the downloading of them as fast as possible.

## The logic behind the recipe

Using the Cache server provided by Semaphore 2.0 is much faster than user the
GitHub server machines because the Semaphore 2.0 Cache server in on the same
network with the Virtual Machines used for executing the jobs of the Semaphore
2.0 pipeline. Therefore using the Semaphore 2.0 Cache server is faster than
downloading files from the GitHub servers.

## An example project

The `semaphore.yml` file for the example project will be the following:


The Semaphore 2.0 environment variables that will be used are the following:

* `SEMAPHORE_GIT_REPO_NAME`:
* `SEMAPHORE_GIT_SHA`:


## See Also

* [Installing sem](https://docs.semaphoreci.com/article/63-your-first-project)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
