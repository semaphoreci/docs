---
Description: Learn how to set up a Continuous Integration (CI) and Continuous Delivery (CD) pipeline for a microservice packaged in a Docker container and deployed to Kubernetes.
---

# CI/CD for Microservices on Kubernetes

This guide shows you how to use Semaphore to set up a Continuous Integration
(CI) and Continuous Delivery (CD) pipeline for a microservice packaged in a
Docker container and deployed to Kubernetes.

## Demo project

Semaphore maintains an example project that you can use to learn:

- [semaphore-demo-ruby-kubernetes][demo-project]

You will find annotated Semaphore pipeline configuration files
in the `.semaphore` directory of the repository.

The example microservice is based on the Sinatra web framework with RSpec tests.

## Overview of the CI/CD pipeline

The pipeline performs the following tasks:

- Installs and caches dependencies
- Runs unit tests
- Continuously builds and tags a Docker container
- Pushes the container to Docker Hub registry

On manual approval, the pipeline also:

- Deploys to Kubernetes cluster
- Tags the `latest` version of container image and pushes it to registry

![CI/CD pipeline for Kubernetes](https://github.com/semaphoreci-demos/semaphore-demo-ruby-kubernetes/raw/master/pipeline.png)

## Sample configuration

You can read a step-by-step tutorial for creating this pipeline [in this blog post](https://semaphoreci.com/blog/cicd-microservices-digitalocean-kubernetes).

`semaphore.yml` is the entrance of the pipeline and defines the Continuous
Integration phase.

### Continuous integration block

``` yaml
# .semaphore/semaphore.yml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name of your pipeline. In this example we connect multiple pipelines with
# promotions, so it helps to differentiate what's the job of each.
name: CI

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
  - name: Install dependencies
    task:
      jobs:
        - name: bundle install
          commands:
            # Check the code from a Git repository. This step is mandatory if the
            # job needs to work with your code.
            # Optionally you may use the --use-cache flag to avoid roundtrips to
            # remote repositories.
            # See https://docs.semaphoreci.com/reference/toolbox-reference/#checkout
            - checkout

            # Restore dependencies from the cache, this command won't fail if they're
            # missing.
            # More on caching: https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/
            - cache restore
            - bundle install --deployment --path vendor/bundle
            # Store the latest version of dependencies in the cache
            # to be used in the future:
            - cache store

  - name: Tests
    task:
      jobs:
        - name: rspec
          commands:
            - checkout
            - cache restore
            # Bundler requires `install` to run even though the cache has been
            # restored -- this is generally not the case with other package
            # managers. Installation will not actually run and the command will
            # finish quickly:
            - bundle install --deployment --path vendor/bundle
            # Run unit tests:
            - bundle exec rspec

# If all tests pass, we move on to building a Docker image.
# This is a job for a separate pipeline which we will link with a promotion.
#
# What happens outside of semaphore.yml will not appear in GitHub pull
# request status reports.
#
# In this example, we run docker build automatically on every branch.
# You may want to limit it by branch name, or trigger it manually.
# For more on such options, see:
# https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
promotions:
  - name: Dockerize
    pipeline_file: docker-build.yml
    auto_promote_on:
      - result: passed
```

### Docker build block

The next pipeline defines and builds a Docker container and pushes it to Docker Hub.
The pipeline also relies on the existence of [a secret][secrets-guide].
You can find an example of how to create secrets in the [Publishing Docker
images on Docker Hub][docker-hub-guide] guide.

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
  - name: Build
    task:
      # Mount a secret which defines the DOCKER_USERNAME and DOCKER_PASSWORD
      # environment variables.
      # For info on creating secrets, see:
      # https://docs.semaphoreci.com/essentials/using-secrets/
      secrets:
        - name: markoa-dockerhub
      jobs:
      - name: Docker build
        commands:
          # Authenticate with Docker Hub
          # using environment variables in markoa-dockerhub secret:
          - echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
          - checkout

          # Use docker layer caching and reuse unchanged layers to build a new
          # container image faster.
          # To do that, we first need to pull a previous version of the container:
          - docker pull semaphoredemos/semaphore-demo-ruby-kubernetes:latest || true

          # Build a new image based on the pulled image, if present.
          # Use the $SEMAPHORE_WORKFLOW_ID environment variable to produce a
          # unique image tag.
          # For a list of available environment variables on Semaphore, see:
          # https://docs.semaphoreci.com/ci-cd-environment/environment-variables/
          - docker build --cache-from semaphoredemos/semaphore-demo-ruby-kubernetes:latest -t semaphoredemos/semaphore-demo-ruby-kubernetes:$SEMAPHORE_WORKFLOW_ID .
          - docker images

          # Push a new image to the Docker Hub container registry:
          - docker push semaphoredemos/semaphore-demo-ruby-kubernetes:$SEMAPHORE_WORKFLOW_ID

# The deployment pipeline is defined to run on manual approval from the UI.
# Semaphore will show the time and name of the user who promotes each
# deployment.
#
# You could, for example, add another promotion to a pipeline that
# automatically deploys to a staging environment from branches named
# according to a certain pattern.
# https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
promotions:
  - name: Deploy to Kubernetes
    pipeline_file: deploy-k8s.yml
```

### Deploy to Kubernetes

The last pipeline defines deployment to Kubernetes, based on the 
previously-created Docker image.

Deployment is done with kubectl, the Kubernetes management CLI. To authenticate
with a cluster, we place a cluster configuration file inside the `~/.kube`
directory. Ask your system administrator to provide you with such a file for
your cluster.

``` yaml
# .semaphore/deploy-k8s.yml
version: v1.0
name: Deploy to Kubernetes
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: Deploy to Kubernetes
    task:
      # Mount a secret which defines /home/semaphore/.kube/dok8s.yaml.
      # By mounting it, we make the file available in the job environment.
      # For info on creating secrets, see:
      # https://docs.semaphoreci.com/essentials/using-secrets/
      secrets:
        - name: do-k8s

      # Define an environment variable which configures kubectl:
      env_vars:
        - name: KUBECONFIG
          value: /home/semaphore/.kube/dok8s.yaml
      jobs:
      - name: Deploy
        commands:
          - checkout
          - kubectl get nodes
          - kubectl get pods

          # Our deployment.yml instructs Kubernetes to pull the container image
          # named semaphoredemos/semaphore-demo-ruby-kubernetes:$SEMAPHORE_WORKFLOW_ID
          #
          # envsubst is a tool which will replace $SEMAPHORE_WORKFLOW_ID with
          # its current value. The same variable was used in docker-build.yml
          # pipeline to tag and push a container image.
          - envsubst < deployment.yml | tee deployment-kubernetes.yml

          # Perform declarative deployment:
          - kubectl apply -f deployment-kubernetes.yml

  # If deployment to production succeeded, let's create a new version of
  # our `latest` Docker image.
  - name: Tag latest release
    task:
      secrets:
        - name: markoa-dockerhub
      jobs:
      - name: docker tag latest
        commands:
          - echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
          - docker pull semaphoredemos/semaphore-demo-ruby-kubernetes:$SEMAPHORE_WORKFLOW_ID
          - docker tag semaphoredemos/semaphore-demo-ruby-kubernetes:$SEMAPHORE_WORKFLOW_ID semaphoredemos/semaphore-demo-ruby-kubernetes:latest
          - docker push semaphoredemos/semaphore-demo-ruby-kubernetes:latest
```

## Run the demo project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][demo-project] to your own account.
2. Clone the repository to your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Follow the instructions above to create secrets to authenticate with
   the container registry and Kubernetes cluster.
5. Edit the `.semaphore/semaphore.yml` (or any) file and make a commit. When you
   push the commit to GitHub, Semaphore will run the CI/CD pipeline.

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-ruby-kubernetes
[secrets-guide]: https://docs.semaphoreci.com/essentials/using-secrets/
[docker-hub-guide]: https://docs.semaphoreci.com/examples/publishing-docker-images-on-dockerhub/
