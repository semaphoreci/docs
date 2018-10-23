

## Overview

This document will illustrate how you can reuse Docker images between the
blocks of the same Semaphore 2.0 project and its promotions.

The problem that we are trying to solve has to do with creating unique
filenames that can be discovered in all the blocks of a Semaphore pipeline as
well as in promoted pipelines.

## Environment variables

In this section you will learn about the Semaphore 2.0 environment variables
that can help you create filenames that are unique while discoverable.

### SEMAPHORE\_WORKFLOW\_ID

The `SEMAPHORE_WORKFLOW_ID` environment variable

### SEMAPHORE\_PIPELINE\_ID

The `SEMAPHORE_PIPELINE_ID` environment variable


### SEMAPHORE\_ARTEFACT\_ID

This section will explain the use of the `SEMAPHORE_ARTEFACT_ID` environment
variable and its derivatives in caching and reusing Docker images in Semaphore
2.0 projects that include promotions.


## Using SEMAPHORE\_WORKFLOW\_ID


A sample pipeline file that uses `SEMAPHORE_WORKFLOW_ID` will look as follows:



## Using Artefacts

For the purposes of this section we will use three pipeline files.

The contents of the `.semaphore/semaphore.yml` file are the following:


There is a Docker images created inside `.semaphore/semaphore.yml` that is
stored in the caching server.


`.semaphore/semaphore.yml` auto promotes `p1.yml`, which is as follows:


The pipeline of `p1.yml` auto promotes `p2.yml`, which is as follows:





## See Also

* [sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Toolbox reference](https://docs.semaphoreci.com/article/54-toolbox-reference)
