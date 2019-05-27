# Docker Compose in CI

This guide shows you how to use Docker Compose to build and test
multi-container applications in Semaphore.

Semaphore provides a demo project that takes advantage of Docker
Compose:

  - [semaphore-demo-python-flask](https://github.com/semaphoreci-demos/semaphore-demo-python-flask)

The demo consists of a simple task manager composed of two containers:
the web application and a mongodb database.

# Overview of the pipeline

The pipeline performs the following tasks:

- Build a docker image with the app and dependencies.
- Tag the image and push it to Docker Hub.
- Start the app and database containers.
- Run tests on the live app.

``` yaml
# .semaphore/semaphore.yml

version: v1.0
name: Semaphore Python / Flask / Docker Example Pipeline
agent:
  machine:
    # Use a machine type with more RAM and CPU power for faster container
    # builds:
    type: e1-standard-4
    os_image: ubuntu1804
blocks:
  - name: Build
    task:
      # Mount a secret which defines DOCKER_USERNAME and DOCKER_PASSWORD
      # environment variables.
      # For info on creating secrets, see:
      # https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
      secrets:
        - name: pyflask-semaphore
      jobs:
      - name: Docker build
        commands:
          # Authenticate with Docker Hub
          - echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
          - checkout
          - docker-compose build
          - docker tag pyflasksemaphore:latest "$DOCKER_USERNAME"/pyflasksemaphore:latest
          - docker tag pyflasksemaphore:latest "$DOCKER_USERNAME"/pyflasksemaphore:$SEMAPHORE_WORKFLOW_ID
          - docker push "$DOCKER_USERNAME"/pyflasksemaphore:latest
          - docker push "$DOCKER_USERNAME"/pyflasksemaphore:$SEMAPHORE_WORKFLOW_ID
          - docker pull "$DOCKER_USERNAME"/pyflasksemaphore:$SEMAPHORE_WORKFLOW_ID
          - docker images

  - name: Run & Test Docker image
    task:
      # Mount a secret which defines DOCKER_USERNAME and DOCKER_PASSWORD
      # environment variables.
      # For info on creating secrets, see:
      # https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
      secrets:
        - name: pyflask-semaphore
      prologue:
        commands:
          # Authenticate with Docker Hub
          - echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
          - checkout
          - docker pull "$DOCKER_USERNAME"/pyflasksemaphore
          - docker-compose up -d
      jobs:
      - name: Check Running Images
        commands:
          - docker ps
      - name: Run Unit test
        commands:
          - docker exec -it semaphore-pyflask-docker_flasksemaphore_1 python -m unittest
```

The pipeline consists of two blocks:

![CI pipeline](https://raw.githubusercontent.com/semaphoreci-demos/semaphore-demo-python-flask/master/.semaphore/pipeline.png)

### Agent

Building with docker tends to be a resource intensive process. Consider
using a more powerful [machine
type](https://docs.semaphoreci.com/article/20-machine-types) for the
pipelines that create images. The `e1-standard-4` machine is a good,
cost-effective option.

### Docker

Semaphore supports Docker and Docker Compose out of the box, no
additional components required. The
[Ubuntu 18.04](https://docs.semaphoreci.com/article/32-ubuntu-1804-image#docker)
image includes everything you need to get started right away.

On Semaphore, Docker works just like in any other machine. Just keep in
mind that:

  - Each job runs in a fully isolated environment. This means that
    Docker images are not shared among jobs, not even on the same block.
    You should use a registry to pass images between jobs.
  - `$SEMAPHORE_WORKFLOW_ID` is a unique id that is shared among all
    pipelines in a workflow. This makes it a great candidate for tagging
    images.
  - Don't forget to
    [checkout](https://docs.semaphoreci.com/article/54-toolbox-reference#checkout)
    if you have any `Dockerfiles` or `docker-compose.yml` in your
    project.

### Docker build

This block is in charge of building and pushing the app image to Docker
Hub:

1.  `checkout` the code.
2.  [Login](https://docs.docker.com/engine/reference/commandline/login/)
    to Docker Hub.
3.  Build the app image with [docker-compose
    build](https://docs.docker.com/compose/reference/build/).
4.  [Tag](https://docs.docker.com/engine/reference/commandline/tag/) the
    image with your Docker Hub username.
5.  [Push](https://docs.docker.com/engine/reference/commandline/push/)
    the image to the registry.

### Run and test the image

A
[prologue](https://docs.semaphoreci.com/article/50-pipeline-yaml#prologue)
is executed before every job in the block:

1.  Checkout to get `docker-compose.yml`.
2.  Login to Docker Hub.
3.  [Pull](https://docs.docker.com/engine/reference/commandline/pull/)
    the app image from the registry.
4.  Start the application in background: 
    [docker-compose up -d](https://docs.docker.com/compose/reference/up/).
    
Docker Compose takes care of dependencies, environment and networking.

Tests are split in two concurrent jobs:

  - Run unit test: start the test script inside the container.
  - Check running images: shows docker containers running.

# Run the demo yourself

The best way to get familiarized with Semaphore is to run the project
yourself:

1.  Create a [Docker Hub](https://hub.docker.com) account.
2.  Fork the 
    [demo project](https://github.com/semaphoreci-demos/semaphore-demo-python-flask)
    in GitHub.
3.  Clone the repository to your local machine.
4.  In [Semaphore](https://semaphoreci.com), follow the link in the
    sidebar to create a new project.
5.  Create a secret to store your Docker Hub username and password:
    ![Create Secret](https://raw.githubusercontent.com/semaphoreci-demos/semaphore-demo-python-flask/master/.semaphore/semaphore-create-secret-pyflasksemaphore.png)
6.  To start the pipeline, edit any file and push the change to your
    repository.

That's it. From now on, every change commited will trigger automatic
docker builds and tests.

# See also

  - [Semaphore guided
    tour](https://docs.semaphoreci.com/category/56-guided-tour)
  - [Pipelines
    reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
  - [Storing sensitive
    data](https://docs.semaphoreci.com/article/66-environment-variables-and-secrets)
  - [Working with docker
    images](https://docs.semaphoreci.com/article/78-working-with-docker-images)
  - [Custom CI/CD environment with
    Docker](https://docs.semaphoreci.com/article/127-custom-ci-cd-environment-with-docker)
