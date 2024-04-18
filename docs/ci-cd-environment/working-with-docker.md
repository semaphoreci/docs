---
Description: Semaphore CI/CD jobs can run and build Docker images, and also push images to Docker repositories or other remote storage.
---

# Working with Docker

Semaphore CI/CD jobs can run and build Docker images, as well as push images
to Docker repositories or other remote storage.

Docker CLI comes [preinstalled][ubuntu-vm] on Semaphore VMs, so you don't have to install it yourself.

ℹ️  *This article describes the process of building, publishing, and testing 
Docker containers on Semaphore. If you want to run jobs inside of a Docker image,
refer to the [custom CI/CD environment with Docker][docker-environment]
documentation.*

## Hello world

``` yaml
version: v1.0
name: Hello Docker
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: "Build"
    task:
      jobs:
      - name: Docker build
        commands:
          - checkout
          - docker build -t awesome-image .
          - docker images
```

## Example projects

Semaphore provides tutorials and demo applications with working CI/CD pipelines
that you can use to get started quickly:

- [CI/CD for Microservices on
  Kubernetes][microservices-k8s-tutorial] and [demo project on
  GitHub][semaphore-demo-ruby-kubernetes]
- [Java Spring CI/CD][java-spring-tutorial] and [demo project on
  GitHub][semaphore-demo-java-spring]

## Using a public Docker image in CI/CD jobs

In order to use an existing Docker image from a public Docker Hub repository,
you need to execute `docker run` as follows:

``` bash
docker run -d -p 1234:80 nginx:alpine
```

The previous command will download the public `nginx:alpine` image and run it in your
Semaphore job.

!!! warning "Docker Hub rate limits"
    Please note that due to the introduction of the [rate limits](https://docs.docker.com/docker-hub/download-rate-limit/) on Docker Hub, all pulls have to be authenticated. 
    If you are pulling any images from the Docker Hub public repository, please make sure you are logged in to avoid any failiures. You can find more information on how to authenticate in our [Docker authentication](/ci-cd-environment/docker-authentication/) documentation.


Here is an example Semaphore pipeline file:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Using a public Docker image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Pull Nginx image
    task:
      jobs:
      - name: Docker Hub
        commands:
          - checkout
          - echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
          - docker run -d -p 1234:80 nginx:alpine
          - wget http://localhost:1234
      secrets:
      - name: docker-hub
```

The `wget http://localhost:1234` command is an example to verify that the
Docker image with the Nginx web server is working and listening to TCP port
number 1234, as specified in the `docker run` command.

For more information on using Docker, refer to the
[Docker user documentation](https://docs.docker.com/).

## Using a Docker image from a private registry

In order to use a Docker image from a private Docker registry, you will first
need to log in to that registry. The commands that you need to run for this are shown below:

``` bash
echo $DOCKER_PASSWORD | docker login --username "$DOCKER_USERNAME" --password-stdin registry.example.com
docker pull registry-owner/image-name
```

We also need a secure way to store and use account credentials, without storing
them in version control. We can do this in Semaphore by
[using secrets][using-secrets].

In this case, the Semaphore configuration file would appear as follows:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Using a private Docker image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Using private Docker image
    task:
      jobs:
      - name: Run container from Docker Hub
        commands:
          - checkout
          - echo $DOCKER_PASSWORD | docker login --username "$DOCKER_USERNAME" --password-stdin
          - docker pull "$DOCKER_USERNAME"/myimage
          - docker images
          - docker run "$DOCKER_USERNAME"/myimage
      secrets:
      - name: docker-hub
```

Define the `docker-hub` secret referenced in the example using
[sem CLI][sem-reference], as shown below:

``` yaml
$ sem get secrets docker-hub
apiVersion: v1beta
kind: Secret
metadata:
  name: docker-hub
  id: a2aaefdb-a4ff-4bc2-afd9-2afa9c7f3e51
  create_time: "1538456457"
  update_time: "1538456537"
data:
  env_vars:
  - name: DOCKER_USERNAME
    value: docker-username
  - name: DOCKER_PASSWORD
    value: docker-password
  files: []
```

Note that the names of the two environment variables used can be anything
you want. We recommend always using descriptive names.

You can learn more about working with secrets in Semaphore 2.0 in the
[secrets documentation][using-secrets].

## Building a Docker image from a Dockerfile

You can use Semaphore to build Docker images directly from a `Dockerfile`
in your source code repository.

For example, let's say that you have the following `Dockerfile`:

``` Dockerfile
FROM golang:alpine

RUN mkdir /files
COPY hello.go /files
WORKDIR /files

RUN go build -o /files/hello hello.go
ENTRYPOINT ["/files/hello"]
```

This example assumes that you have a file named `hello.go` in your Git repository. The
`Dockerfile` creates a new directory in the Docker image and puts `hello.go` in
it. Then, it compiles the Go file and the executable file is stored as
`files/hello`. The `ENTRYPOINT` Docker command will automatically execute
`files/hello` when the Docker image is run.

Please note that the `Dockerfile` should be committed to Git as it will be
used by Semaphore 2.0.

After that, the contents of your Semaphore 2.0 pipeline file should appear as
follows:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Building Docker images
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Build Go executable
    task:
      jobs:
      - name: Docker Hub
        commands:
          - checkout
          - docker build -t hello:v1 .
          - docker run hello:v1
```

The default name of the image, in this case, will be `hello:v1` – you can, however, rename it as you see fit.

## Pushing a Docker image to a registry

Once you create a container image, you need to push it to a registry in most cases.
For this purpose you will first need to authenticate via `docker login`.

Here's an example Semaphore configuration file, in which we push to a private
registry on Docker Hub. You can use this for any other container registry as well:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Pushing a Docker image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Push Docker image to registry
    task:
      jobs:
      - name: Docker Hub
        commands:
          - checkout
          - echo $DOCKER_PASSWORD | docker login --username "$DOCKER_USERNAME" --password-stdin
          - docker build -t hello:v1 .
          - docker tag hello:v1 "$DOCKER_USERNAME"/hello:v1
          - docker push "$DOCKER_USERNAME"/hello:v1
          - docker pull "$DOCKER_USERNAME"/hello:v1
          - docker images

      secrets:
      - name: docker-hub
```

The name of the image will be `"$DOCKER_USERNAME"/hello` and its tag will be
`v1`. Therefore, in order to `docker pull` this image, you will have to use its
full name: `"$DOCKER_USERNAME"/hello:v1`.

The `docker images` command executed at the end of the job is an example to
verify that the desired image has been downloaded and is available for further
commands.

In this example, we are using a `docker-hub` secret as defined in a
[here](#using-a-docker-image-from-a-private-registry), dealing with pulling
from a private registry.

Note that you can only use promotions to build images in certain branches. Refer to the [promotions documentation][using-promotions] and the
[pipeline reference][pipeline-reference] for more information on orchestrating
workflows.

### More examples of pushing to Docker registries

- [Pushing Docker images to AWS Elastic Container Registry
  (ECR)][ecr-tutorial]
- [Pushing Docker images to Google Container Registry (GCR)][gcr-tutorial]

## Using Docker Compose

You can use Docker Compose in your Semaphore jobs as you would on any Linux machine.
For a detailed example, see [Using Docker Compose in CI][using-docker-compose].

## Using databases and background services

For example, let's say that your CI build needs Redis and PostgreSQL:

``` yaml
# .semaphore/semaphore.yml

version: v1.0
name: Docker Based Builds

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
          - PGPASSWORD="keyboard-cat" createdb -U postgres -h db -p 5432 -e hello

          # list key in redis container by connecting to the cache container
          - redis-cli -h cache KEYS *
```

In this example, we used the Semaphore-hosted [Postgres](/ci-cd-environment/semaphore-registry-images/#postgres) and [Redis](/ci-cd-environment/semaphore-registry-images/#redis)
images to start the services.

### Using services and test data across blocks

Note that the services that you start in one job are not automatically available in other jobs, since all jobs run in isolated environments.
The isolation of jobs from each other within their blocks also means that
services are not shared across blocks or pipelines.

To use a service or populate test data in all parallel jobs within a block,
you have to specify it in the task [prologue][prologue]. Repeat the same steps in the
definition of each block as needed.

## Installing a newer Docker version

A recent version of Docker toolchain is [preinstalled by default][ubuntu-vm].
In the event that there's a newer version which hasn't yet been added to Semaphore,
you can use the example below to set it up:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Update Docker
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Update docker-ce
    task:
      jobs:
      - name: Update docker
        commands:
          - checkout
          - docker --version
          - sudo apt-get update
          - sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce
          - docker --version
```

## See also

- [sem command line tool Reference][sem-reference]
- [Pipeline YAML Reference][pipeline-reference]
- [Using secrets to manage sensitive data][using-secrets]

[microservices-k8s-tutorial]: https://docs.semaphoreci.com/examples/ci-cd-for-microservices-on-kubernetes/
[semaphore-demo-ruby-kubernetes]: https://github.com/semaphoreci-demos/semaphore-demo-ruby-kubernetes
[java-spring-tutorial]: https://docs.semaphoreci.com/examples/java-spring-continuous-integration/
[semaphore-demo-java-spring]: https://github.com/semaphoreci-demos/semaphore-demo-java-spring
[ecr-tutorial]: https://docs.semaphoreci.com/examples/pushing-docker-images-to-aws-elastic-container-registry-ecr/
[gcr-tutorial]: https://docs.semaphoreci.com/examples/pushing-docker-images-to-google-container-registry-gcr/
[using-secrets]: https://docs.semaphoreci.com/essentials/using-secrets/
[ubuntu-vm]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/#docker
[sem-reference]: https://docs.semaphoreci.com/reference/sem-command-line-tool/
[using-promotions]: https://docs.semaphoreci.com/essentials/deploying-with-promotions/
[pipeline-reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
[docker-environment]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/
[using-docker-compose]: https://docs.semaphoreci.com/examples/using-docker-compose-in-ci/
[prologue]: ../reference/pipeline-yaml-reference.md#prologue
