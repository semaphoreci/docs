
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


### The ADD Command


## About --cache-from

The `--cache-from` command line option in the `docker` utility


## An example Semaphore 2.0 project


## See Also

