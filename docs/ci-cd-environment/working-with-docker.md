---
description: Semaphore CI/CD jobs can run and build Docker images, and can also push images to Docker repositories or other remote storage.
---

# Working with Docker

Semaphore CI/CD jobs can run and build Docker images, and can also push images
to Docker repositories or other remote storage.

Docker CLI is [preinstalled][ubuntu-vm] on Semaphore VMs, so you can use Docker
right away.

ℹ️  *This article describes the process of building, publishing and testing 
Docker containers on Semaphore. If you want to run jobs inside of a Docker image,
refer to the [Custom CI/CD environment with Docker][docker-environment]
documentation.*

## Hello world

``` yaml
version: v1.0
name: Hello Docker
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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
you only need to execute `docker run` as follows:

``` bash
docker run -d -p 1234:80 nginx:alpine
```

The command will download the public `nginx:alpine` image and run it in your
Semaphore job.

An example Semaphore pipeline file:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Using a public Docker image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Pull Nginx image
    task:
      jobs:
      - name: Docker Hub
        commands:
          - checkout
          - docker run -d -p 1234:80 nginx:alpine
          - wget http://localhost:1234
```

The `wget http://localhost:1234` command is an example to verify that the
Docker image with the Nginx web server is working and listening to TCP port
number 1234, as specified in the `docker run` command.

For more information on using Docker, refer to the
[Docker user guide](https://docs.docker.com/).

## Using a Docker image from a private registry

In order to use a Docker image from a private Docker registry, you will first
need to log in to that registry. The commands that you need to run are:

``` bash
echo $DOCKER_PASSWORD | docker login --username "$DOCKER_USERNAME" --password-stdin registry.example.com
docker pull registry-owner/image-name
```

We also need a secure way to store and use account credentials, without storing
them in version control. A way to do that on Semaphore is by
[using secrets][using-secrets].

The Semaphore configuration file in this case would look as follows:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Using a private Docker image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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

Define the `docker-hub` secret referenced in the example using the
[sem CLI][sem-reference]:

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
[guided tour][using-secrets].

## Building a Docker image from a Dockerfile

You can use Semaphore to build Docker images directly from a `Dockerfile`
in your source code repository.

Let's say that you have the following `Dockerfile`:

``` Dockerfile
FROM golang:alpine

RUN mkdir /files
COPY hello.go /files
WORKDIR /files

RUN go build -o /files/hello hello.go
ENTRYPOINT ["/files/hello"]
```

This assumes that you have a file named `hello.go` in your Git repository. The
`Dockerfile` creates a new directory in the Docker image and puts `hello.go` in
there. Then, it compiles that Go file and the executable file is stored as
`files/hello`. The `ENTRYPOINT` Docker command will automatically execute
`files/hello` when the Docker image is run.

Please note that the `Dockerfile` should be committed to Git as it will be
used by Semaphore 2.0.

After that, the contents of your Semaphore 2.0 pipeline file should look as
follows:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Building Docker images
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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

The name of the image will be `hello:v1` – you can choose any name you want.

## Pushing a Docker image to a registry

Once you create a container image, you usually need to push it to a registry.
For this purpose you will first need to authenticate via `docker login`.

Here's an example Semaphore configuration file in which we push to a private
registry on Docker Hub. You can use any other container registry as well:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Pushing a Docker image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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
`v1`. Therefore, in order to `docker pull` that image, you will have to use its
full name that is `"$DOCKER_USERNAME"/hello:v1`.

The `docker images` command executed at the end of the job is an example to
verify that the desired image was downloaded and is available for further
commands.

In the example we are using the `docker-hub` secret as defined in a
[previous section](#using-a-docker-image-from-a-private-registry) on pulling
from a private registry.

Note that you can use promotions to build images only on certain branches,
for example. Refer to the [guided tour][using-promotions] and the
[pipeline reference][pipeline-reference] for more information on orchestrating
workflows.

### More examples of pushing to Docker registries

- [Pushing Docker images to AWS Elastic Container Registry
  (ECR)][ecr-tutorial]
- [Pushing Docker images to Google Container Registry (GCR)][gcr-tutorial]

## Using Docker Compose

You can use Docker Compose in your Semaphore jobs as you would on any Linux machine.
For a detailed example, see _[Using Docker Compose in CI][using-docker-compose]_.

## Installing a newer Docker version

A recent version of Docker toolchain is [preinstalled by default][ubuntu-vm].
In case there's a newer version which hasn't yet been added to Semaphore,
this is an example that you can use to set it up:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Update Docker
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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
[using-secrets]: https://docs.semaphoreci.com/guided-tour/environment-variables-and-secrets/
[ubuntu-vm]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/#docker
[sem-reference]: https://docs.semaphoreci.com/reference/sem-command-line-tool/
[using-promotions]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
[pipeline-reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
[docker-environment]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/
[using-docker-compose]: https://docs.semaphoreci.com/examples/using-docker-compose-in-ci/
