
* [Overview](#overview)
* [About Layer Caching in Docker](#about-layer-caching-in-docker)
   - [The RUN Command](#the-run-command)
   - [The COPY Command](#the-copy-command)
   - [The ADD Command](#the-add-command)
* [About --cache-from](#about---cache-from)
* [An example Semaphore 2.0 project](#an-example-semaphore-2.0-project)
* [See Also](#see-also)

## Overview

This document will show you how you can use Layer Caching in Docker in order to
make your builds faster and is indented for Semaphore 2.0 users that create
Docker containers in their Semaphore 2.0 projects.

## About Layer Caching in Docker

Docker creates container images using layers. Each command that is found in a
`Dockerfile` creates a new layer. Each layers contains the filesystem changes
of the image between the state before the execution of the command and the
state after the execution of the command.

Docker uses a layer cache to optimize that process and make it faster. This
works as follows:

Docker Layer Caching mainly works on `RUN`, `COPY` and `ADD` commands, which are
going to be explained in more detail.

### The RUN Command

The `RUN` command

### The COPY Command


In order to take advantage of Layer Caching in Docker you should structure your
`Dockerfile` in a way that frequently changing steps such as `COPY` to be
located towards the end of the `Dockerfile` file. This will ensure that the
steps concerned with doing the same action are not unnecessarily rebuilt.

### The ADD Command


In order to take advantage of Layer Caching in Docker you should structure your
`Dockerfile` in a way that frequently changing steps such as `ADD` to be
located towards the end of the `Dockerfile` file. This will ensure that the
steps concerned with doing the same action are not unnecessarily rebuilt.

## About --cache-from

The `--cache-from` command line option in the `docker` utility allows to build
a new image using a pre-existing one as the cache source.


## An example Semaphore 2.0 project



To ensure a good cache hit, you should choose The BRANCH_NAME Semaphore 2.0
environment variable as a tag. This way, each branch will have its own cache
and therefore avoid cache collision.

In order to improve the speed of pushing and pulling images in your Semaphore
builds, the Docker container registry should be geographically as close as
possible to the Semaphore 2.0 build servers that are located in Germany.

## See Also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Toolbox Reference](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Environment Variables Reference](https://docs.semaphoreci.com/article/12-environment-variables)
