---
Description: Semaphore 2.0 jobs can be run inside Docker images. This allows you to define a custom build environment with pre-installed tools and dependencies.
---

# Custom CI/CD Environment with Docker

Semaphore CI/CD jobs can be run inside Docker images. This allows you to define
a custom build environment with pre-installed tools and dependencies needed for
your project.

Note: This document explains how to define a Docker-based build environment and
how run Semaphore jobs inside of Docker containers. For building and running Docker
images, refer to the [Working with Docker Images][working-with-docker] documentation.

## Using a Docker container as your pipeline's CI/CD environment
To run your commands inside a Docker container, define the `containers` section in
your agent specification.

For example, we will use the `semaphoreci/ruby-2.6`
image for our tests, as shown below:

``` yaml
# .semaphore/semaphore.yml

version: v1.0
name: Hello Docker

agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main
      image: 'registry.semaphoreci.com/ruby:2.6'

blocks:
  - name: "Hello"
    task:
      jobs:
      - name: Hello
        commands:
          - checkout
          - ruby --version
```

Note: *The example image `semaphoreci/ruby.2.6` is part of a pre-built
set of Docker images optimized for Semaphore CI/CD jobs.*

!!! info "Semaphore convenience images redirection"
	Due to the introduction of [Docker Hub rate limits](/ci-cd-environment/docker-authentication/), if you are using a [Docker-based CI/CD environment](/ci-cd-environment/custom-ci-cd-environment-with-docker/) in combination with convenience images, Semaphore will **automatically redirect** any pulls from the `semaphoreci` Docker Hub repository to the [Semaphore Container Registry](/ci-cd-environment/semaphore-registry-images/).	

## Using multiple Docker containers

An agent can use multiple Docker containers to set up an environment for your
jobs. In this scenario, the job's commands are run in the first container,
while the rest of the containers are linked to the first container via DNS.

For example, if your tests need a running Postgres database and a Redis
key-value store, you can define them in the containers section. This is shown below:

``` yaml
# .semaphore/semaphore.yml

version: v1.0
name: Hello Docker
agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main
      image: 'registry.semaphoreci.com/ruby:2.6'

    - name: db
      image: 'registry.semaphoreci.com/postgres:9.6'
      env_vars:
        - name: POSTGRES_PASSWORD
          value: keyboard-cat

    - name: cache
      image: 'registry.semaphoreci.com/redis:5.0'
      
    
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
the previous example, our Postgres database is named `db` and is available
on the `db` hostname in the first container.

## Pre-built convenience Docker images for Semaphore CI/CD jobs

For convenience, Semaphore comes with a [repository of pre-built images hosted
on the Semaphore Container Registry][semaphore-registry]. The source code of the Semaphore Docker
images is [hosted on Github][docker-images-repo].

You can find a list of all convenience Docker images on our [Semaphore Container Registry images][semaphore-registry] page.

## Building custom Docker images

Semaphore Agents can use any public Docker image to run your jobs, if the
following requirements are met:

- The container is Linux-based
- `bash >= 3.0` is installed in the image
- `git >= 2.0` is installed in the image
- `openssh-client` is installed in the image
- `curl` is installed in the image

To enable caching support, the following requirements need to be met:

- `lftp` is installed in the main image
- `coreutils` is installed in the main image

To enable Docker-in-Docker, the `docker` executable needs to be installed.

!!! warning "Docker Hub rate limits"
    Please note that due to the introduction of the [rate limits](https://docs.docker.com/docker-hub/download-rate-limit/) on Docker Hub, all pulls have to be authenticated. 
    If you are pulling any images from the Docker Hub public repository, please make sure you are logged in to avoid failiure. You can find more information on how to authenticate in our [Docker authentication](/ci-cd-environment/docker-authentication/) guide.
  
### Building a minimal Docker image for Semaphore

An example `Dockerfile` that meets the minimal requirements can be constructed
with the following Dockerfile, as shown below:

``` Dockerfile
FROM ubuntu:20.04

RUN apt-get -y update && apt-get install -y git lftp openssh-client coreutils curl
RUN curl -sSL https://get.docker.com/ | sh
```

### Extending Semaphore's pre-built convenience Docker images

An alternative to building a fully custom Docker image from scratch is to extend
one of the pre-built images from [Semaphore's Container Registry][semaphore-registry].

For example, to extend one of Semaphore's Ruby-based images and install MySQL
libraries use the following Dockerfile, as shown below:

``` Dockerfile
FROM registry.semaphoreci.com/ruby:2.6

RUN apt-get -y install -y mysql-client libmysqlclient-dev
```

### Optimizing Docker images for fast CI/CD

To achieve the best CI/CD experience and the fastest results make sure to follow
these guidelines:

- Pre-install all tools and languages in your Docker image. Downloading and installing tools every time you run a job increases
  build time.

- Keep the size of Docker images small to avoid unnecessary boot time. Install only the tools you need. A handful of tips for
  building small Docker images can be found in the [Lightweight Docker Images
  in 5 Steps][lightweight-docker-images] article.

Semaphore's pre-built images have been created for a wide range of customers and
include tools that you might not use in your test suite. For the best results,
create a tailor-made Docker image for your test suite and CI/CD needs.

## Pulling private Docker images from DockerHub

Semaphore allows you to use private Docker images hosted on DockerHub to run
your CI/CD pipelines.

First, set up a secret to store your DockerHub credentials, as shown below:

``` bash
sem create secret dockerhub-pull-secrets \
  -e DOCKER_CREDENTIAL_TYPE=DockerHub \
  -e DOCKERHUB_USERNAME=<your-dockerhub-username> \
  -e DOCKERHUB_PASSWORD=<your-dockerhub-password> \
```

Attach this secret to your agent's properties to pull private images, as shown below:

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

## Pulling private Docker images from AWS ECR

Private Docker Images stored in AWS ECR can be used in your CI/CD pipelines.

First, set up secret to store your AWS credentials and the region in which ECR is provisioned, as shown below:

``` bash
sem create secret aws-ecr-pull-secrets \
  -e DOCKER_CREDENTIAL_TYPE=AWS_ECR \
  -e AWS_REGION=<aws-ecr-region>
  -e AWS_ACCESS_KEY_ID=<your-aws-access-key> \
  -e AWS_SECRET_ACCESS_KEY=<your-aws-secret-key> \
```

Attach your secret to the agent's properties to pull private images, as shown below:

``` yaml
agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main
      image: <your-private-repository>/<image>

  image_pull_secrets:
    - name: aws-ecr-pull-secrets
```

## Pulling private Docker images from Google GCR

Private Docker images stored in Google container registry can be used in your CI/CD pipelines.

First, set up the secret to store your GCR credential file and repository hostname, as shown below:

``` bash
sem create secret gcr-pull-secrets \
-e DOCKER_CREDENTIAL_TYPE=GCR \
-e GCR_HOSTNAME=gcr.io \
-f ~/keyfile.json:/tmp/gcr/keyfile.json \
```
It's important to set the destination path for the file to `/tmp/gcr/keyfile.json`,
as this is the default path and filename that the Semaphore agent will lookup for GCR credentials.

Attach your secret to the agent's properties to pull private images, as shown below:

``` yaml
agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main
      image: <your-private-repository>/<image>

  image_pull_secrets:
    - name: gcr-pull-secrets
```

## Pulling private Docker images from Quay.io

Private Docker images stored in [Quay.io](https://quay.io) can be used in your CI/CD pipelines.

First, set up a secret to store your Login credentials and Quay.io url, as shown below:

``` bash
sem create secret quay-pull-secrets \
-e DOCKER_CREDENTIAL_TYPE=GenericDocker \
-e DOCKER_URL=quay.io \
-e DOCKER_USERNAME=<your-quay-username> \
-e DOCKER_PASSWORD=<<your-quay-password> \
```

Attach the secret to your agent's properties to pull private images, as shown below:

``` yaml
agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main
      image: <your-private-repository>/<image>

  image_pull_secrets:
    - name: quay-pull-secrets
```

## Pulling private Docker images from Generic Docker Registries

Private Docker Images stored in [Docker Registry][docker-registry]
can be used in your CI/CD pipelines.

First, set up a secret to store your Login credentials and repository url, as shown below:

``` bash
sem create secret registry-pull-secrets \
-e DOCKER_CREDENTIAL_TYPE=GenericDocker \
-e DOCKER_URL=<your-repository-url> \
-e DOCKER_USERNAME=<your-registry-username> \
-e DOCKER_PASSWORD=<your-registry-password> \
```

Attach the secret to your agent's properties to pull private images, as shown below:

``` yaml
agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main
      image: <your-private-repository>/<image>

  image_pull_secrets:
    - name: registry-pull-secrets
```


[working-with-docker]: https://docs.semaphoreci.com/ci-cd-environment/working-with-docker/
[semaphore-registry]: /ci-cd-environment/semaphore-registry-images/
[dockerhub-semaphore]: https://hub.docker.com/u/semaphoreci
[docker-images-repo]: https://github.com/semaphoreci/docker-images
[lightweight-docker-images]: https://semaphoreci.com/blog/2016/12/13/lightweight-docker-images-in-5-steps.html
[docker-registry]: https://docs.docker.com/registry/
