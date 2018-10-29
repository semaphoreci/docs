* [Environment variables](#environment-variables)
* [Two Examples](#two-examples)

## Overview

This document will illustrate how you can reuse Docker images between the
blocks of the same Semaphore 2.0 project and its promotions.

The problem that we are trying to solve has to do with creating unique
filenames that can be discovered in all the blocks of a Semaphore pipeline as
well as in promoted pipelines.

In order to be able to reuse a Docker image, you will need to use the `cache`
utility from the Semaphore Toolbox or push the Docker image to Docker Hub and
pull it from there. For reasons of simplicity all the presented examples will
use the `cache` utility from the Semaphore Toolbox. You can find more about
the `cache` utility in the
[Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference).

## Environment variables

In this section you will learn about the Semaphore 2.0 environment variables
that can help you create filenames that are unique while discoverable.

### SEMAPHORE\_WORKFLOW\_ID

The `SEMAPHORE_WORKFLOW_ID` environment variable remains the same during
a pipeline run and is available in all the blocks of a pipeline as well as in
all promoted or auto promoted pipelines.

### SEMAPHORE\_PIPELINE\_ID

The `SEMAPHORE_PIPELINE_ID` environment variable remains the same throughout
all the blocks of a pipeline, which makes it a perfect candidate for sharing
data inside the same pipeline.

### SEMAPHORE\_PIPELINE\_ARTEFACT_ID

This section will explain the use of the `SEMAPHORE_PIPELINE_ARTEFACT_ID` environment
variable and its derivatives in caching and reusing Docker images in Semaphore
2.0 projects that include promotions.


### SEMAPHORE\_PIPELINE\_0\_ARTEFACT\_ID

The `SEMAPHORE_PIPELINE_0_ARTEFACT_ID` environment variable will only appear if
there is a promotion in the pipeline. This means that it will only appear in
the promoted pipeline.

### SEMAPHORE\_PIPELINE\_1\_ARTEFACT\_ID

The `SEMAPHORE_PIPELINE_1_ARTEFACT_ID` environment variable will only appear if
there are two promotions in a pipeline. This means that it will only appear in
the second promoted pipeline.

The numbering will continue for as long as there exist more promotions in a
pipeline. This means that you might have `SEMAPHORE_PIPELINE_2_ARTEFACT_ID`,
`SEMAPHORE_PIPELINE_3_ARTEFACT_ID`, etc.


## Two Examples

Please note that although both examples are using caching, they can be easily
modified in order to store the generated Docker images to Docker Hub or to a
similar service.

### Using SEMAPHORE\_WORKFLOW\_ID

There is a Docker image that is created in a pipeline that is defined in
`.semaphore/semaphore.yml` and stored in the cache. You want to be able
to access that Docker image from all the blocks of `.semaphore/semaphore.yml`
as well as two pipelines that are auto promoted and are defined in
`.semaphore/p1.yml` and `.semaphore/p2.yml`.

This section will explain how you can do that by presenting a sample pipeline
file that auto promotes two other pipelines. All three pipelines are using the
`SEMAPHORE_WORKFLOW_ID` environment variable.

The contents of `.semaphore/semaphore.yml` are as follows:

    version: v1.0
    name: Testing Auto Promoting
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    
    promotions:
    - name: Staging
      pipeline_file: p1.yml
      auto_promote_on:
        - result: passed
          branch:
            - "master"
    
    blocks:
      - name: Create Docker image
        task:
          jobs:
            - name: Store Docker image in cache
              commands:
                - checkout
                - echo $SEMAPHORE_WORKFLOW_ID
                - docker build -t go_hw:v1 .
                - mkdir docker_image
                - docker save go_hw:v1 -o docker_image/go_hw.tar
                - ls -l docker_image
                - cache store docker-image-$SEMAPHORE_WORKFLOW_ID docker_image
      - name: Test Docker image
        task:
          jobs:
            - name: restore Docker image from cache
              commands:
                - echo $SEMAPHORE_WORKFLOW_ID
                - cache restore docker-image-$SEMAPHORE_WORKFLOW_ID
                - ls -l docker_image
                - docker load -i docker_image/go_hw.tar
                - docker images
                - docker run -d -p 8000:80 go_hw:v1
                - wget localhost:80

The contents of `.semaphore/p1.yml` are as follows:

    version: v1.0
    name: 1st promotion
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    
    promotions:
    - name: Publish image
      pipeline_file: p2.yml
      auto_promote_on:
        - result: passed
          branch:
            - "master"
    
    blocks:
      - name: Test Docker image
        task:
          jobs:
            - name: Restore Docker image from cache
              commands:
                - echo $SEMAPHORE_WORKFLOW_ID
                - cache restore docker-image-$SEMAPHORE_WORKFLOW_ID
                - ls -l docker_image
                - docker load -i docker_image/go_hw.tar
                - docker images
                - docker run -d -p 8000:80 go_hw:v1
                - wget localhost:80

The contents of `.semaphore/p2.yml` are as follows:

    version: v1.0
    name: 2nd promotion
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    
    blocks:
      - name: Test Docker image
        task:
          jobs:
            - name: Restore Docker image from cache
              commands:
                - echo $SEMAPHORE_WORKFLOW_ID
                - cache restore docker-image-$SEMAPHORE_WORKFLOW_ID
                - ls -l docker_image
                - docker load -i docker_image/go_hw.tar
                - docker images

### Using Artefacts

For the purposes of this section we will use three pipeline files. The scenario
that is going to be used is the following: the initial pipeline begins using a
`.semaphore/semaphore.yml` file. That file auto promotes another pipeline using
the `.semaphore/p1.yml` pipeline. Last, `.semaphore/p1.yml` auto promotes another
pipeline that is defined using `.semaphore/p2.yml`.

There is a Docker image that is created in `.semaphore/semaphore.yml`. That
Docker image needs to be accessible in both `.semaphore/p1.yml` and
`.semaphore/p2.yml` using caching. Additionally, `.semaphore/p1.yml` creates
another Docker image that we want to make available to `.semaphore/p2.yml`
through caching.

This section will explain how you can do that.

The contents of the `.semaphore/semaphore.yml` file are the following:


In this pipeline, the values of `SEMAPHORE_PIPELINE_ID` and
`SEMAPHORE_PIPELINE_ARTEFACT_ID` are the same as this is the initial
pipeline.

There is a Docker images created inside `.semaphore/semaphore.yml` that is
stored in the caching server – the name of that Docker image will be
`SEMAPHORE_PIPELINE_ID`.


`.semaphore/semaphore.yml` auto promotes `p1.yml`, which is as follows:


In `.semaphore/p1.yml`, the value of `SEMAPHORE_PIPELINE_ID` is new. However,
the value of `SEMAPHORE_PIPELINE_0_ARTEFACT_ID` will be the value of the
`SEMAPHORE_PIPELINE_ID` environment value of `.semaphore/semaphore.yml`.
At this point there is not need for having defined a
`SEMAPHORE_PIPELINE_1_ARTEFACT_ID` environment variable.

In order for `.semaphore/p1.yml` to access the Docker image defined in 
`.semaphore/semaphore.yml`, it has to use the value of the
`SEMAPHORE_PIPELINE_0_ARTEFACT_ID` environment variable.

As discussed, the pipeline of `p1.yml` auto promotes `p2.yml`, which has the
following contents:

In `.semaphore/p2.yml`, the value of `SEMAPHORE_PIPELINE_ID` is new. However,
the value of `SEMAPHORE_PIPELINE_0_ARTEFACT_ID` will be the same of the value
of the `SEMAPHORE_PIPELINE_ID` environment variable in `.semaphore/p1.yml`.
This time, there exist a `SEMAPHORE_PIPELINE_1_ARTEFACT_ID` environment variable
that holds the value of the `SEMAPHORE_PIPELINE_ID` environment variable defined
in the pipeline of `.semaphore/semaphore.yml`.

So, in order for `.semaphore/p2.yml` to access the Docker image defined in
`.semaphore/semaphore.yml`, it has to be the value of the
`SEMAPHORE_PIPELINE_1_ARTEFACT_ID` environment variable.

## See Also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Toolbox Reference](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Environment variables Reference](https://docs.semaphoreci.com/article/12-environment-variables)

