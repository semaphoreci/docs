- [Environment variables](#environment-variables)
- [The Rules of Artefacts](#the-rules-of-artefacts)
- [Two Examples](#two-examples)

## Overview

This document will illustrate how you can reuse Docker images among the
blocks of the same Semaphore 2.0 project and its promoted pipelines.

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
all promoted and auto promoted pipelines.

If you need to reuse just a single resource, using the `SEMAPHORE_WORKFLOW_ID`
environment variable is simplest and quickest solution.

### SEMAPHORE\_PIPELINE\_ID

The `SEMAPHORE_PIPELINE_ID` environment variable remains the same throughout
all the blocks of a pipeline, which, at first, makes it the perfect candidate
for sharing data inside the same pipeline.

However, using `SEMAPHORE_PIPELINE_ARTEFACT_ID` is the recommended way because
the value of `SEMAPHORE_PIPELINE_ARTEFACT_ID` does not change if there are
rebuilds in a pipeline.

### SEMAPHORE\_PIPELINE\_ARTEFACT_ID

The `SEMAPHORE_PIPELINE_ARTEFACT_ID` environment variable always exists. Its
value is the same as the value of the `SEMAPHORE_PIPELINE_X_ARTEFACT_ID`
environment variables, where `X` is the biggest number among all
the `SEMAPHORE_PIPELINE_X_ARTEFACT_ID` environment variables of a given
pipeline.

So, in the pipeline that is initiated by `.semaphore/semaphore.yml`, you will
have both `SEMAPHORE_PIPELINE_ARTEFACT_ID` and `SEMAPHORE_PIPELINE_0_ARTEFACT_ID`
and their values will be the same.

### SEMAPHORE\_PIPELINE\_0\_ARTEFACT\_ID

The `SEMAPHORE_PIPELINE_0_ARTEFACT_ID` environment variable always exists and
always points to the `SEMAPHORE_PIPELINE_ARTEFACT_ID` value of the pipeline
created by `.semaphore/semaphore.yml`.

### SEMAPHORE\_PIPELINE\_1\_ARTEFACT\_ID

The `SEMAPHORE_PIPELINE_1_ARTEFACT_ID` environment variable will only appear if
there is at least one promotion in a pipeline. This means that it will begin
appearing in the first promoted pipeline.

The numbering and the creation of new `ARTEFACT_ID` environment variables
will continue for as long as there exist more promotions in a pipeline. This
means that you might have `SEMAPHORE_PIPELINE_2_ARTEFACT_ID`,
`SEMAPHORE_PIPELINE_3_ARTEFACT_ID`, `SEMAPHORE_PIPELINE_4_ARTEFACT_ID`, etc,
depending on the number of promotions that exist.

As the numbering begins with `0`, the `10th` pipeline will have a
`SEMAPHORE_PIPELINE_9_ARTEFACT_ID` environment variable.

## The Rules of Artefacts

In this section you will learn more about Artefacts in Semaphore 2.0 and the
rules that govern them and their values.

- The value of `SEMAPHORE_PIPELINE_0_ARTEFACT_ID` always references the
  `SEMAPHORE_PIPELINE_ARTEFACT_ID` of the pipeline specified in
  `.semaphore/semaphore.yml`.

- Each promotion adds a new `SEMAPHORE_PIPELINE_X_ARTEFACT_ID`, where the value
  of `X` is increased by 1 from the biggest value of the previous pipeline.

- The value of `SEMAPHORE_PIPELINE_1_ARTEFACT_ID` will always reference the
  `SEMAPHORE_PIPELINE_ARTEFACT_ID` of the pipeline of the first promotion
  of the current branch.

- The value of `SEMAPHORE_PIPELINE_2_ARTEFACT_ID` will always reference the
  `SEMAPHORE_PIPELINE_ARTEFACT_ID` environment variables of the pipeline
  on the second promotion of the current branch. This rule keeps going.

- If the values of `SEMAPHORE_PIPELINE_ARTEFACT_ID` and
  `SEMAPHORE_PIPELINE_ARTEFACT_ID` are the same, then you are not on a
  rebuild.

- Promotions work **linearly**. Therefore pipelines can use the Artefact IDs of
  all previously defined pipelines as long as there is a shared path among
  them. Put simply, there must be a **direct**, linear connection between the
  pipelines you want to connect using Artefact IDs.

- This means that if there is a split somewhere, only the Artefact IDs of the
  common path of one or more pipelines can be used as you cannot reference
  the pipelines from the other branch(es).

- The `SEMAPHORE_PIPELINE_ARTEFACT_ID` environment variable offers a convenient
  and standard way of using the Artefact ID of the current pipeline without
  the need for knowing the name of the environment variable with the biggest
  number that holds the current Artefact ID
  (`SEMAPHORE_PIPELINE_9_ARTEFACT_ID`).

- If you promote a pipeline more than once, the Artefact ID of that pipeline, as
  well as the Artefact IDs of the pipelines that are after that pipeline will
  change. However, the values of all previous Artefact IDs will remain the same.

## Two Examples

Please note that both examples are using -caching- for reasons of simplicity.
They can be easily modified in order to store the generated Docker images to
Docker Hub or to a similar service.

### Using SEMAPHORE\_WORKFLOW\_ID

There is a Docker image that is created in a pipeline that is defined in
`.semaphore/semaphore.yml` and stored in the cache. You want to be able
to access that Docker image from all the blocks of `.semaphore/semaphore.yml`
as well as the two pipelines that are auto promoted and are defined in
`.semaphore/p1.yml` and `.semaphore/p2.yml`. `.semaphore/semaphore.yml` auto
promotes `.semaphore/p1.yml`, which auto promotes `.semaphore/p2.yml`.

This section will explain how you can do that by presenting three sample
pipeline files. All three pipelines are using the `SEMAPHORE_WORKFLOW_ID`
environment variable.

The contents of `.semaphore/semaphore.yml` are as follows:

``` yaml
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
```

The contents of `Dockerfile` are the following:

``` Dockerfile
FROM golang:alpine

RUN mkdir /files
COPY hw.go /files
WORKDIR /files

RUN go build -o /files/hw hw.go
ENTRYPOINT ["/files/hw"]
```

The contents of `hw.go` are the following:

``` go
package main

import (
    "fmt"
)

func main() {
    fmt.Println("Hello World!")
}
```

The contents of `.semaphore/p1.yml` are as follows:

``` yaml
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
```

The contents of `.semaphore/p2.yml` are as follows:

``` yaml
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
```

### Using Artefacts

For the purposes of this section we will use three pipeline files. The scenario
that is going to be used is the following: the initial pipeline begins using the
`.semaphore/semaphore.yml` file. That file auto promotes another pipeline using
the `.semaphore/p1.yml` pipeline. Last, `.semaphore/p1.yml` auto promotes another
pipeline that is defined using `.semaphore/p2.yml`.

As the third pipeline is promoted by the second pipeline, we have a linear path,
which means that there are no splits.

There is a Docker image that is created in `.semaphore/semaphore.yml`. That
Docker image needs to be accessible from both `.semaphore/p1.yml` and
`.semaphore/p2.yml` using caching. Additionally, `.semaphore/p1.yml` creates
another Docker image that we also want to make available to `.semaphore/p2.yml`
through caching.

This section will explain how you can do that.

The contents of the `.semaphore/semaphore.yml` file are the following:

``` yaml
version: v1.0
name: Reuse Docker Images in S2
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
  - name: Create and Store Docker image
    task:
      jobs:
        - name: Store Docker image in cache
          commands:
            - checkout
            - echo $SEMAPHORE_PIPELINE_ARTEFACT_ID
            - cp v1.go hw.go
            - docker build -t go_hw:v1 .
            - mkdir v1
            - docker save go_hw:v1 -o v1/go_hw.tar
            - ls -l v1
            - cache store $SEMAPHORE_PIPELINE_ARTEFACT_ID v1

  - name: Test Docker image
    task:
      jobs:
        - name: Restore Docker image from cache
          commands:
            - echo $SEMAPHORE_PIPELINE_ARTEFACT_ID
            - echo $SEMAPHORE_PIPELINE_0_ARTEFACT_ID
            - cache restore $SEMAPHORE_PIPELINE_0_ARTEFACT_ID
            - ls -l v1
            - docker load -i v1/go_hw.tar
            - docker images
            - docker run go_hw:v1
```

In this pipeline, the values of `SEMAPHORE_PIPELINE_ARTEFACT_ID` and
`SEMAPHORE_PIPELINE_0_ARTEFACT_ID` are the same as this is the initial
pipeline. If this is the **initial build** of this pipeline, then
`SEMAPHORE_PIPELINE_ID` will also have the same value as the values of both
`SEMAPHORE_PIPELINE_ARTEFACT_ID` and `SEMAPHORE_PIPELINE_0_ARTEFACT_ID`.

If you rebuild that pipeline only, then the value of `SEMAPHORE_PIPELINE_ID`
will change whereas the values of both `SEMAPHORE_PIPELINE_ARTEFACT_ID` and
`SEMAPHORE_PIPELINE_0_ARTEFACT_ID` will remain the same.

Last, a Docker image was created in `.semaphore/semaphore.yml` that is
stored in the caching server – the name of that Docker image will be the
value of the `SEMAPHORE_PIPELINE_ARTEFACT_ID` environment variable.

The contents of `Dockerfile` are the following:

``` Dockerfile
FROM golang:alpine

RUN mkdir /files
COPY hw.go /files
WORKDIR /files

RUN go build -o /files/hw hw.go
ENTRYPOINT ["/files/hw"]
```

The contents of `v1.go` are the following:

``` go
package main

import (
    "fmt"
)

func main() {
    fmt.Println("Hello from v1!")
}
```

The `.semaphore/semaphore.yml` pipeline auto promotes `p1.yml`, which is as
follows:

``` yaml
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
  - name: Create and Store Docker image
    task:
      jobs:
        - name: Store Docker image in cache
          commands:
            - checkout
            - echo $SEMAPHORE_PIPELINE_ARTEFACT_ID
            - cp v2.go hw.go
            - docker build -t go_hw:v2 .
            - mkdir v2
            - docker save go_hw:v2 -o v2/go_hw.tar
            - ls -l v2
            - cache store $SEMAPHORE_PIPELINE_ARTEFACT_ID v2

  - name: Test Docker image
    task:
      jobs:
        - name: Restore Docker image from cache
          commands:
            - echo $SEMAPHORE_PIPELINE_ARTEFACT_ID
            - cache restore $SEMAPHORE_PIPELINE_ARTEFACT_ID
            - ls -l v2
            - docker load -i v2/go_hw.tar
            - docker images
            - docker run go_hw:v2
```

The contents of `v2.go` are the following:

``` go
package main

import (
    "fmt"
)

func main() {
    fmt.Println("Hello from v2!")
}
```

There is a Docker image created inside `.semaphore/p1.yml` that is
stored in the caching server – the name of that Docker image will be
the current value of `SEMAPHORE_PIPELINE_ARTEFACT_ID`.

In `.semaphore/p1.yml`, the value of `SEMAPHORE_PIPELINE_ID` is new. However,
the value of `SEMAPHORE_PIPELINE_0_ARTEFACT_ID` will be the value of the
`SEMAPHORE_PIPELINE_ARTEFACT_ID` environment value of `.semaphore/semaphore.yml`.
There is also a `SEMAPHORE_PIPELINE_1_ARTEFACT_ID` environment variable that is
the same as the value of `SEMAPHORE_PIPELINE_ARTEFACT_ID`.

In order for `.semaphore/p1.yml` to access the Docker image defined in
`.semaphore/semaphore.yml`, it has to use the value of the
`SEMAPHORE_PIPELINE_0_ARTEFACT_ID` environment variable.

As discussed, the pipeline of `p1.yml` auto promotes `p2.yml`, which has the
following contents:

``` yaml
version: v1.0
name: 2nd promotion
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Test Docker images
    task:
      jobs:
        - name: Restore Docker image from cache
          commands:
            - echo $SEMAPHORE_PIPELINE_0_ARTEFACT_ID
            - echo $SEMAPHORE_PIPELINE_1_ARTEFACT_ID
            - cache restore $SEMAPHORE_PIPELINE_0_ARTEFACT_ID
            - docker load -i v1/go_hw.tar
            - cache restore $SEMAPHORE_PIPELINE_1_ARTEFACT_ID
            - docker load -i v2/go_hw.tar
            - docker images
            - docker run go_hw:v1
            - docker run go_hw:v2
```

In `.semaphore/p2.yml`, the value of `SEMAPHORE_PIPELINE_ID` is new. However,
the value of `SEMAPHORE_PIPELINE_1_ARTEFACT_ID` will be the same of the value
of the `SEMAPHORE_PIPELINE_ARTEFACT_ID` environment variable in `.semaphore/p1.yml`.
There exist a `SEMAPHORE_PIPELINE_0_ARTEFACT_ID` environment variable
that holds the value of the `SEMAPHORE_PIPELINE_ARTEFACT_ID` environment variable
defined in the pipeline of `.semaphore/semaphore.yml`.

So, in order for `.semaphore/p2.yml` to access the Docker image defined in
`.semaphore/semaphore.yml`, it has to use the value of the
`SEMAPHORE_PIPELINE_0_ARTEFACT_ID` environment variable.

Last, in order for `.semaphore/p2.yml` to access the Docker image defined in
`.semaphore/p1.yml`, it has to use the value of the
`SEMAPHORE_PIPELINE_1_ARTEFACT_ID` environment variable.

## See Also

- [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
- [Toolbox Reference](https://docs.semaphoreci.com/article/54-toolbox-reference)
- [Environment variables Reference](https://docs.semaphoreci.com/article/12-environment-variables)
