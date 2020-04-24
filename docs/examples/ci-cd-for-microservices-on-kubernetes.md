# CI/CD for Microservices on Kubernetes

This guide shows you how to use Semaphore to set up a Continuous Integration
(CI) and Continuous Delivery (CD) pipeline for a microservice packaged in a
Docker container and deployed to Kubernetes.

## Demo project

Semaphore maintains an example project:

- [semaphore-demo-ruby-kubernetes][demo-project]

In the repository you will find annotated Semaphore pipeline configuration files
within the `.semaphore` directory.

The example microservice is based on the Sinatra web framework with RSpec tests.

## Overview of the CI/CD pipeline

The pipeline performs the following tasks:

- Install and cache dependencies
- Run unit tests
- Continuously build and tag a Docker container
- Push container to Docker Hub registry

On manual approval:

- Deploy to Kubernetes cluster
- Tag the `latest` version of container image and push it to registry

![CI/CD pipeline for Kubernetes](https://github.com/semaphoreci-demos/semaphore-demo-ruby-kubernetes/raw/master/pipeline.png)

## Sample configuration

You can read a step-by-step tutorial to creating this pipeline [on
Semaphore blog](https://semaphoreci.com/blog/cicd-microservices-digitalocean-kubernetes).

`semaphore.yml` is the entry of the pipeline and defines the Continuous
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
# https://docs.semaphoreci.com/article/20-machine-types
# https://docs.semaphoreci.com/article/32-ubuntu-1804-image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

# Blocks are the heart of a pipeline and are executed sequentially.
# Each block has a task that defines one or more jobs. Jobs define the
# commands to execute.
# See https://docs.semaphoreci.com/article/62-concepts
blocks:
  - name: Install dependencies
    task:
      jobs:
        - name: bundle install
          commands:
            # Checkout code from Git repository. This step is mandatory if the
            # job is to work with your code.
            # Optionally you may use --use-cache flag to avoid roundtrip to
            # remote repository.
            # See https://docs.semaphoreci.com/article/54-toolbox-reference#checkout
            - checkout

            # Restore dependencies from cache, command won't fail if it's
            # missing.
            # More on caching: https://docs.semaphoreci.com/article/149-caching
            - cache restore
            - bundle install --deployment --path vendor/bundle
            # Store the latest version of dependencies in cache,
            # to be used in next blocks and future workflows:
            - cache store

  - name: Tests
    task:
      jobs:
        - name: rspec
          commands:
            - checkout
            - cache restore
            # Bundler requires `install` to run even though cache has been
            # restored, but generally this is not the case with other package
            # managers. Installation will not actually run and command will
            # finish quickly:
            - bundle install --deployment --path vendor/bundle
            # Run unit tests:
            - bundle exec rspec

# If all tests pass, we move on to build a Docker image.
# This is a job for a separate pipeline which we link with a promotion.
#
# What happens outside semaphore.yml will not appear in GitHub pull
# request status report.
#
# In this example we run docker build automatically on every branch.
# You may want to limit it by branch name, or trigger it manually.
# For more on such options, see:
# https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions
promotions:
  - name: Dockerize
    pipeline_file: docker-build.yml
    auto_promote_on:
      - result: passed
```

### Docker build block

The next pipeline defines builds a Docker container and pushes it to Docker Hub.
It relies on existence of [a secret][secrets-guide].
You can find an example of how to create such a secret in [_Publishing Docker
images on Docker Hub_][docker-hub-guide].

``` yaml
# .semaphore/docker-build.yml
version: v1.0
name: Docker build
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
          # To do that, we first need to pull a previous version of container:
          - docker pull semaphoredemos/semaphore-demo-ruby-kubernetes:latest || true

          # Build a new image based on pulled image, if present.
          # Use $SEMAPHORE_WORKFLOW_ID environment variable to produce a
          # unique image tag.
          # For a list of available environment variables on Semaphore, see:
          # https://docs.semaphoreci.com/article/12-environment-variables
          - docker build --cache-from semaphoredemos/semaphore-demo-ruby-kubernetes:latest -t semaphoredemos/semaphore-demo-ruby-kubernetes:$SEMAPHORE_WORKFLOW_ID .
          - docker images

          # Push a new image to Docker Hub container registry:
          - docker push semaphoredemos/semaphore-demo-ruby-kubernetes:$SEMAPHORE_WORKFLOW_ID

# The deployment pipeline is defined to run on manual approval from the UI.
# Semaphore will the time and the name of the person who promotes each
# deployment.
#
# You could, for example, add another promotion to a pipeline that
# automatically deploys to a staging environment from branches named
# after a certain pattern.
# https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions
promotions:
  - name: Deploy to Kubernetes
    pipeline_file: deploy-k8s.yml
```

### Deploy to Kubernetes block

The last pipeline defines deployment to Kubernetes, based on the previously
created Docker image.

Deployment is done with kubectl, the Kubernetes management CLI. To authenticate
with a cluster, we place a cluster configuration file inside `~/.kube`
directory. Ask your system administrator to provide you with such a file for
your cluster.

``` yaml
# .semaphore/deploy-k8s.yml
version: v1.0
name: Deploy to Kubernetes
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Deploy to Kubernetes
    task:
      # Mount a secret which defines /home/semaphore/.kube/dok8s.yaml.
      # By mounting it, we make file available in the job environment.
      # For info on creating secrets, see:
      # https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
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

          # Our deployment.yml instructs Kubernetes to pull container image
          # named semaphoredemos/semaphore-demo-ruby-kubernetes:$SEMAPHORE_WORKFLOW_ID
          #
          # envsubst is a tool which will replace $SEMAPHORE_WORKFLOW_ID with
          # its current value. The same variable was used in docker-build.yml
          # pipeline to tag and push a container image.
          - envsubst < deployment.yml | tee deployment.yml

          # Perform declarative deployment:
          - kubectl apply -f deployment.yml

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
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Follow the instructions above to create secrets to authenticate with
   a container registry and Kubernetes cluster.
5. Edit the `.semaphore/semaphore.yml` (or any) file and make a commit. When you
   push the commit to GitHub, Semaphore will run the CI/CD pipeline.

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-ruby-kubernetes
[secrets-guide]: https://docs.semaphoreci.com/guided-tour/environment-variables-and-secrets/
[docker-hub-guide]: https://docs.semaphoreci.com/examples/publishing-docker-images-on-dockerhub/
