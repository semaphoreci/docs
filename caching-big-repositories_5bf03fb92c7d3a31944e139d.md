
* [Overview](#overview)
* [The scenario](#the-scenario)
* [The logic behind the recipe](#the-logic-behind-the-recipe)
* [An example project](#an-example-project)
* [See Also](#see-also)

## Overview

The purpose of this document is to provide a recipe for caching big
repositories in order to reuse them faster.

## The scenario

Imagine that you have one or more large files on a GitHub repository and that
you want to make the downloading of them as fast as possible.

## The logic behind the recipe

Using the Cache server provided by Semaphore 2.0 for getting the files of your
GitHub repository is much faster than using the GitHub server machines for the
same task because the Semaphore 2.0 Cache server in on the same network as the
Virtual Machines used for executing the jobs of the Semaphore 2.0 pipeline.
Therefore using the Semaphore 2.0 Cache server is faster than downloading files
from the GitHub servers.

What the example project that follows will do is getting all the files of the
GitHub repository using `checkout` in the first job and the storing them into
the Semaphore 2.0 Cache server. The remaining jobs of the project will use
these files from the Cache server without calling `checkout` again.

Note that for this recipe to work, the files of the GitHub repository should
remain intact during the lifetime of the Semaphore 2.0 project.

## An example project

The example project of this section will use a single large file.

The `semaphore.yml` file for the example project will be the following:


The Semaphore 2.0 environment variables that will be used are the following:

* `SEMAPHORE_GIT_REPO_NAME`:
* `SEMAPHORE_GIT_SHA`:

## Evaluating the results

The same project was executed with and without using

## See Also

* [Installing sem](https://docs.semaphoreci.com/article/63-your-first-project)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
