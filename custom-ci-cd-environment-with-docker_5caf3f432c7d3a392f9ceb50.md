Note: *This is a beta feature. Updates might not be backward compatible.*

Semaphore CI/CD jobs can be run inside Docker images. This allows you to define
a custom build environment with pre-installed tools and dependencies needed for
your project.

- [Using a Docker container as your pipelines' CI/CD environment](#using-a-docker-container-as-your-pipelines-ci-cd-environment)
- [Using multiple Docker containers](#using-multiple-docker-containers)
- [Pre-built convenience Docker images for Semaphore CI/CD jobs](#pre-built-convenience-docker-images-for-semaphore-ci-cd-jobs)
- [Building custom Docker images](#building-custom-docker-images)
  - [Building a minimal Docker image for Semaphore](#building-a-minimal-docker-image-for-semaphore)
  - [Extending Semaphore's pre-build convenience Docker images](#extending-semaphores-pre-built-convenience-docker-images)
  - [Optimizing Docker images for fast CI/CD](#optimizing-docker-images-for-fast-ci-cd)
- [Pulling private Docker images from DockerHub](#pulling-private-docker-images-from-dockerhub)

Note: This document explains how to define a Docker based build environment and
how run jobs inside of Docker containers. For building and running Docker
images, refer to the [Working with Docker Images][working-with-docker].

## Using a Docker container as your pipelines' CI/CD environment

To run your commands inside of Docker container, define the `containers` section in
your agent specification.

For example, in the following pipeline we will use the `semaphoreci/ruby-2.6.1`
image for our tests.

``` yaml
# .semaphore/semaphore.yml

version: v1.0
name: Hello Docker

agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

  containers:
    - name: main
      image: semaphoreci/ruby:2.6.1

blocks:
  - name: "Hello"
    task:
      jobs:
      - name: Hello
        commands:
          - checkout
          - ruby --version
```

Note: *The example image `semaphoreci/ruby.2.6.1` is part of the pre-built
Docker images optimized for Semaphore CI/CD jobs.*

## Using multiple Docker containers

An Agent can use multiple Docker containers to set up an environment for your
jobs. In this scenario, the job's commands are run in the first container,
while the rest of the containers are linked via DNS to the first container.

For example, if your tests need a running Postgres database and a Redis
key-value store you can define them in the containers section.

``` yaml
# .semaphore/semaphore.yml

version: v1.0
name: Hello Docker
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

  containers:
    - name: main
      image: semaphoreci/ruby:2.6.1

    - name: db
      image: postgres:9.6
      env_vars:
        - name: POSTGRES_PASSWORD
          value: keyboard-cat

    - name: cache
      image: redis:5.0

blocks:
  - name: "Hello"
    task:
      jobs:
      - name: Hello
        commands:
          # install postgres and redis clients
          - apt-get -y update && apt-get install postgresql-client redis-tools

          # create a database by connecting to 'db' container
          - PGPASSWORD="keyboard-cat" createdb -U postgres -h db -p 5432

          # list key in redis container by connecting to the cache container
          - redis-cli -h cache "KEYS *"
```

The `hostname` of linked containers is set based on the name of container. In
the previous example our Postgres database is named `db` and it is available
on the `db` hostname in the first container.

## Pre-built convenience Docker images for Semaphore CI/CD jobs

For convenience, Semaphore comes with a [repository of pre-built images hosted
on Dockerhub](https://hub.docker.com/u/semaphoreci). The source code of the Semaphore Docker
images is [hosted on Github](https://github.com/semaphoreci/docker-images).

- [Android](https://hub.docker.com/r/semaphoreci/android/tags)
- [Ruby](https://hub.docker.com/r/semaphoreci/ruby/tags)
- [Python](https://hub.docker.com/r/semaphoreci/python/tags)
- [Haskell](https://hub.docker.com/r/semaphoreci/haskell/tags)
- [Ubuntu](https://hub.docker.com/r/semaphoreci/ubuntu/tags)
- [Rust](https://hub.docker.com/r/semaphoreci/rust/tags)
- [Golang](https://hub.docker.com/r/semaphoreci/golang/tags)

## Building custom Docker images

Semaphore Agents can use any public Docker image to run your jobs, if the
following requirements are met:

- The container is Linux based
- `bash >= 3.0` is installed in the image
- `git >= 2.0` is installed in the image

To enable caching support, the following requirements need to be met:

- `lftp` is installed in the main image

To enable running Docker-in-Docker the `docker` executable needs to be installed.

### Building a minimal Docker image for Semaphore

An example `Dockerfile` that meets the minimal requirements can be constructed
with the following Dockerfile:

``` Dockerfile
FROM ubuntu:18.04

RUN apt-get -y update && apt-get install -y git lftp docker
```

### Extending Semaphore's pre-build convenience Docker images

An alternative to building a fully custom Docker image from scratch is to extend
one of the pre-built images from [Semaphore's DockerHub repository][dockerhub-semaphore].

For example, to extend one of Semaphore's Ruby based images and install MySQL
libraries use the following Dockerfile:

``` Dockerfile
FROM semaphoreci/ruby:2.6.2

RUN apt-get -y install -y mysql-client libmysqlclient-dev
```

### Optimizing Docker images for fast CI/CD

To achieve the best CI/CD experience and fastest results make sure to follow
these guidelines:

- Pre-install all the tools and languages in your Docker image. Avoid
  downloading and installing tools every time you run a job as it increases
  build time.

- Keep the size of the Docker images small to avoid unnecessary boot time of
  your environment. Install only the tools you need. A handful of tips for
  building small Docker images can be found in the [Lightweight Docker Images
  in 5 Steps][lightweight-docker-images] article.

Semaphore's pre-built images are created for a wide range of customers and
include tools that you might not use in your test suite. For best results
create a tailor made Docker image for your test suite and CI/CD needs.

## Pulling private Docker images from DockerHub

Semaphore allows you to use private Docker image hosted on DockerHub to run
your CI/CD pipelines.

First, set up a secret to store your DockerHub credentials:

``` yaml
sem create secret dockerhub-pull-secrets \
  -e DOCKER_CREDENTIAL_TYPE=DockerHub \
  -e DOCKERHUB_USERNAME=<your-dockerhub-username> \
  -e DOCKERHUB_PASSWORD=<your-dockerhub-password> \
```

Attach the created secret to your agent's to pull private images:

``` yaml
agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main
      image: <your-private-repository>/<image>

  image_pull_secrets:
    - name: dockerhub-pull-secrets
```

[working-with-docker]: https://docs.semaphoreci.com/article/78-working-with-docker-images
[dockerhub-semaphore]: https://hub.docker.com/u/semaphoreci
[docker-images-repo]: https://github.com/semaphoreci/docker-images
[lightweight-docker-images]: https://semaphoreci.com/blog/2016/12/13/lightweight-docker-images-in-5-steps.html
