---
Description: This guide shows you how to use Semaphore 2.0 to set up a continuous integration (CI) pipeline for a Java Spring application.
---

# Java Spring Continuous Integration

This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for a Java Spring application.

## Demo project

Semaphore maintains an example Java Spring project:

- [Demo Java Spring project on GitHub][demo-project]

In the repository, you will find an annotated Semaphore configuration file
`.semaphore/semaphore.yml`.

The application uses Spring Boot, Maven, and JUnit for unit and integration tests,
JMeter for performance testing, and Docker for deployment.

## Overview of the CI/CD pipeline

The Semaphore pipeline performs the following tasks:

1. Builds the project.
2. Runs unit and integration tests in parallel.
3. Runs performance tests.
4. Builds the Docker image.
5. Pushes image to a container registry.

![Java Spring CI/CD pipeline](https://github.com/semaphoreci-demos/semaphore-demo-java-spring/raw/master/assets/pipeline-result.png)

## Sample configuration

The entry pipeline performs the build and test steps:

``` yaml
# .semaphore/semaphore.yml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name of your pipeline. In this example we connect two pipelines with
# a promotion, so it helps to differentiate what's the job of each.
name: Java Spring example CI pipeline on Semaphore

# An agent defines the environment in which your code runs.
# It is a combination of one of available machine types and operating
# system images. See:
# https://docs.semaphoreci.com/ci-cd-environment/machine-types/
# https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

# Blocks are the heart of a pipeline and are executed sequentially.
# Each block has a task that defines one or more jobs. Jobs define the
# commands to execute.
# See https://docs.semaphoreci.com/essentials/concepts/
blocks:

  - name: "Build"
    task:
      # Set environment variables that your project requires.
      # See https://docs.semaphoreci.com/essentials/environment-variables/
      env_vars:
        - name: MAVEN_OPTS
          value: "-Dmaven.repo.local=.m2"

      jobs:
      - name: Build
        commands:
          # Checkout code from Git repository. This step is mandatory if the
          # job is to work with your code.
          - checkout

            # Restore dependencies from cache, command won't fail if it's
            # missing.
            # More on caching: https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/
          - cache restore

          - mvn -q package jmeter:configure -Dmaven.test.skip=true

            # Store the latest version of dependencies in cache,
            # to be used in next blocks and future workflows:
          - cache store

  - name: "Test"
    task:
      env_vars:
        - name: MAVEN_OPTS
          value: "-Dmaven.repo.local=.m2"

      # This block runs two jobs in parallel and they both share common
      # setup steps. We can group them in a prologue.
      # See https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#prologue
      prologue:
        commands:
          - checkout
          - cache restore
          - mvn -q test-compile -Dmaven.test.skip=true
      jobs:
      - name: Unit tests
        commands:
          - mvn test
      - name: Integration tests
        commands:
          - mvn test -Pintegration-testing

  - name: "Performance tests"
    task:
      env_vars:
        - name: MAVEN_OPTS
          value: "-Dmaven.repo.local=.m2"
      prologue:
        commands:
          - checkout
          - cache restore
      jobs:
      - name: Benchmark
        commands:
          - java -version
          # Run application in detached mode:
          - java -jar target/spring-pipeline-demo.jar > /dev/null &
          # Wait for the spring boot application to boot
          - sleep 20
          - mvn -q jmeter:jmeter
          - mvn jmeter:results


# If all tests pass, we move on to build a Docker image.
# This is a job for a separate pipeline which we link with a promotion.
#
# What happens outside semaphore.yml will not appear in GitHub pull
# request status report.
#
# In this example we run docker build automatically on every branch.
# You may want to limit it by branch name, or trigger it manually.
# For more on such options, see:
# https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
promotions:
  - name: Dockerize
    pipeline_file: docker-build.yml
    auto_promote_on:
      - result: passed
```

The pipeline ends with a promotion, which is triggered automatically if all
blocks finished successfully.

### Authenticating with a Docker registry

The Docker build pipeline produces a container image and pushes it to a
Docker registry. In this case, the registry is Docker Hub, but you can use any
registry. For the pipeline to work, you need to authenticate with your credentials.

Add your container registry credentials to `./docker-hub-secret.yml`, which is
provided in the repository as a template. The credentials should remain
private, so don't publish them to your Git repository by mistake.

Create a [secret][secrets-guide] on Semaphore so that you can safely export the
`DOCKER_USERNAME` and `DOCKER_PASSWORD` environment variables to your pipeline,
as shown below:

``` bash
sem create -f docker-hub-secret.yml
```

### The Docker build pipeline

``` yaml
# .semaphore/docker-build.yml
version: v1.0
name: Docker build
agent:
  machine:
    # Use a machine type with more RAM and CPU power for faster container
    # builds:
    type: e1-standard-4
    os_image: ubuntu2004

blocks:
  - name: "Build"
    task:
      env_vars:
        - name: MAVEN_OPTS
          value: "-Dmaven.repo.local=.m2"
        - name: ENVIRONMENT
          value: "dev"

      # Mount a secret which defines DOCKER_USERNAME and DOCKER_PASSWORD
      # environment variables.
      # For info on creating secrets, see:
      # https://docs.semaphoreci.com/essentials/using-secrets/
      secrets:
      - name: docker-hub

      prologue:
        commands:
          - checkout
          - cache restore

      jobs:
      - name: Build and deploy docker container
        commands:
          - mvn -q package -Dmaven.test.skip=true

          # Authenticate with Docker Hub
          # using environment variables docker-hub secret:
          - echo $DOCKER_PASSWORD | docker login  --username "$DOCKER_USERNAME" --password-stdin

          # Use docker layer caching and reuse unchanged layers to build a new
          # container image faster.
          # To do that, we first need to pull a previous version of container:
          - docker pull semaphoredemos/semaphore-demo-java-spring:latest || true


          # Build a new image based on pulled image, if present.
          # You could use $SEMAPHORE_WORKFLOW_ID environment variable to
          # produce a unique image tag.  For a list of available environment
          # variables on Semaphore, see:
          # https://docs.semaphoreci.com/ci-cd-environment/environment-variables/
          - docker build --cache-from semaphoredemos/semaphore-demo-java-spring:latest --build-arg ENVIRONMENT="${ENVIRONMENT}" -t semaphoredemos/semaphore-demo-java-spring:latest .

          # Push a new image to container registry:
          - docker push semaphoredemos/semaphore-demo-java-spring:latest
```

## Run the demo project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][demo-project] to your own account.
2. Clone the repository to your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Create a secret as per the instructions above.
5. Edit any file and push to GitHub, and Semaphore will run the CI/CD pipeline.

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-java-spring
[secrets-guide]: https://docs.semaphoreci.com/essentials/using-secrets/
