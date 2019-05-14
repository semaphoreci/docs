Note: *This is a beta feature. Updates might not be backward compatible.*

Semaphore CI/CD jobs can be run inside Docker images. This allows you to define
a custom build environment with pre-installed tools and dependencies needed for
your project.

- [Defining Docker images for your pipeline](#defining-docker-images-for-your-pipeline)
- [Using multiple Docker images](#using-multiple-docker-images)
- [Using custom Docker images](#using-custom-docker-images)
- [Pulling private Docker images from DockerHub](#pulling-private-docker-images-from-dockerhub)
- [Pre-built convenience Docker images for Semaphore CI/CD jobs](#pre-built-convenience-docker-images-for-Semaphore-ci-cd-jobs)

Note: This document explains how to define a Docker based build environment and
how run jobs inside of Docker containers. For building and running Docker
images, refer to the [Working with Docker Images][working-with-docker].

## Defining Docker images for your pipeline

To run your commands inside of Docker image, define the `containers` section in
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

## Using multiple Docker images

An Agent can use multiple Docker images to run your jobs. In this scenario, the
job's commands are run in the first Docker image, while the rest of the Docker
images are linked and available to that first image.

For example, if your tests depend on a running Postgres database and a Redis
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

## Using custom Docker images

Semaphore Agents can use any public Docker image to run your jobs, if the
following requirements are met:

- The container is Linux based
- `bash >= 3.0` is installed in the image
- `git >= 2.0` is installed in the image

To enable caching support, the following requirements need to be met:

- `lftp` is installed in the main image

To enable running Docker-in-Docker the `docker` executable needs to be installed.

An example `Dockerfile` that meets the above criteria would be:

``` Dockerfile
FROM ubuntu:18.04

RUN apt-get -y update && apt-get install -y git lftp docker
```

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

## Pre-built convenience Docker images for Semaphore CI/CD jobs

For convenience, Semaphore comes with a [repository of pre-built images hosted
on Dockerhub](https://hub.docker.com/u/semaphoreci). The source code of the
Semaphore Docker images is [hosted on Github](https://github.com/semaphoreci/docker-images).

- [Android](https://hub.docker.com/r/semaphoreci/android/tags)
- [Ruby](https://hub.docker.com/r/semaphoreci/ruby/tags)

[working-with-docker]: https://docs.semaphoreci.com/article/78-working-with-docker-images
