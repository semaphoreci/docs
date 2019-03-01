Semaphore CI/CD jobs can run and build Docker images, and can also push images
to Docker repositories or other remote storage.

Docker CLI is [preinstalled](ubuntu-vm) on Semaphore VMs, so you can use Docker
right away.

Table of contents

* [Hello world](#hello-world)
* [Example projects](#example-projects)
* [Using a public Docker image in CI/CD jobs](#using-a-public-docker-image-in-cicd-jobs)
* [Using a Docker image from a private registry](#using-a-docker-image-from-a-private-registry)
* [Building a Docker image from a Dockerfile](#building-a-docker-image-from-a-dockerfile)
* [Pushing a Docker image to a registry](#pushing-a-docker-image-to-a-registry)
* [Using a specific version of docker-compose](#using-a-specific-version-of-docker-compose)
* [Installing a newer Docker version](#installing-a-newer-docker-version)
* [See also](#see-also)

## Hello world

<pre><code class="language-yaml"># .semaphore/semaphore.yml
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
</code></pre>

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

    docker run -d -p 1234:80 nginx:alpine

The command will download the public `nginx:alpine` image and run it in your
Semaphore job.

An example Semaphore pipeline file:

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

The `wget http://localhost:1234` command is an example to verify that the
Docker image with the Nginx web server is working and listening to TCP port
number 1234, as specified in the `docker run` command.

For more information on using Docker, refer to the
[Docker user guide](https://docs.docker.com/).

## Using a Docker image from a private registry

In order to use a Docker image from a private Docker registry, you will first
need to log in to that registry. The commands that you need to run are:

    echo $DOCKER_PASSWORD | docker login --username "$DOCKER_USERNAME" --password-stdin registry.example.com
    docker pull registry-owner/image-name

We also need a secure way to store and use account credentials, without storing
them in version control. A way to do that on Semaphore is by
[using secrets](using-secrets).

The Semaphore configuration file in this case would look as follows:

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

Define the `docker-hub` secret referenced in the example using the
[sem CLI](sem-reference):

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

Note that the names of the two environment variables used can be anything
you want. We recommend always using descriptive names.

You can learn more about working with secrets in Semaphore 2.0 in the
[guided tour](using-secrets).

## Building a Docker image from a Dockerfile

You can use Semaphore to build Docker images directly from a `Dockerfile`
in your source code repository.

Let's say that you have the following `Dockerfile`:

    FROM golang:alpine

    RUN mkdir /files
    COPY hello.go /files
    WORKDIR /files

    RUN go build -o /files/hello hello.go
    ENTRYPOINT ["/files/hello"]

This assumes that you have a file named `hello.go` in your Git repository. The
`Dockerfile` creates a new directory in the Docker image and puts `hello.go` in
there. Then, it compiles that Go file and the executable file is stored as
`files/hello`. The `ENTRYPOINT` Docker command will automatically execute
`files/hello` when the Docker image is run.

Please note that the `Dockerfile` should be committed to Git as it will be
used by Semaphore 2.0.

After that, the contents of your Semaphore 2.0 pipeline file should look as
follows:

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

The name of the image will be `hello:v1` – you can choose any name you want.

## Pushing a Docker image to a registry

Once you create a container image, you usually need to push it to a registry.
For this purpose you will first need to authenticate via `docker login`.

Here's an example Semaphore configuration file in which we push to a private
registry on Docker Hub. You can use any other container registry as well:

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
for example. Refer to the [guided tour](using-promotions) and the
[pipeline reference](pipeline-reference) for more information on orchestrating
workflows.

### More examples of pushing to Docker registries

- [Pushing Docker images to AWS Elastic Container Registry
  (ECR)][ecr-tutorial]
- [Pushing Docker images to Google Container Registry (GCR)][gcr-tutorial]

## Using a specific version of docker-compose

A recent version of Docker Compose is [preinstalled by default](ubuntu-vm).
If you'd like to use another version, the first thing that you'll need
to do is to delete the existing version.

The contents of the Semaphore 2.0 pipeline file will be as follows:

    # .semaphore/semaphore.yml
    version: v1.0
    name: Install docker-compose
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804

    blocks:
      - name: Install desired version of docker-compose
        task:
          env_vars:
          - name: DOCKER_COMPOSE_VERSION
            value: 1.4.2
          jobs:
          - name: Get docker-compose
            commands:
              - checkout
              - docker-compose -v
              - curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
              - chmod +x docker-compose
              - ./docker-compose -v
              - sudo mv docker-compose /usr/bin
              - docker-compose -v

The only thing that you should take care of is using a valid value for the
`DOCKER_COMPOSE_VERSION` environment variable.

## Installing a newer Docker version

A recent version of Docker toolchain is [preinstalled by default](ubuntu-vm).
In case there's a newer version which hasn't yet been added to Semaphore,
this is an example that you can use to set it up:

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

## See also

* [sem command line tool Reference](sem-reference)
* [Pipeline YAML Reference](pipeline-reference)
* [Using secrets to manage sensitive data](using-secrets)

[microservices-k8s-tutorial]: https://docs.semaphoreci.com/article/119-ci-cd-for-microservices-on-kubernetes
[semaphore-demo-ruby-kubernetes]: https://github.com/semaphoreci-demos/semaphore-demo-ruby-kubernetes
[java-spring-tutorial]: https://docs.semaphoreci.com/article/122-java-spring-continuous-integration
[semaphore-demo-java-spring]: https://github.com/semaphoreci-demos/semaphore-demo-java-spring
[ecr-tutorial]: https://docs.semaphoreci.com/article/71-aws-elastic-container-registry-ecr
[gcr-tutorial]: https://docs.semaphoreci.com/article/72-google-container-registry-gcr
[using-secrets]: https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
[ubuntu-vm]: https://docs.semaphoreci.com/article/32-ubuntu-1804-image#docker
[sem-reference]: https://docs.semaphoreci.com/article/53-sem-reference
[using-promotions]: https://docs.semaphoreci.com/article/67-deploying-with-promotions
[pipeline-reference]: https://docs.semaphoreci.com/article/50-pipeline-yaml
