---
description: This guide shows you how to use Semaphore 2.0 to publish Docker Images on DockerHub.
---

# Publishing Docker Images on DockerHub

Pushing images to the official registry is straightforward. You'll
need to create a secret for your login username and password. Then,
call `docker login` with the appropriate environment variables. The
first step is create a secret for `DOCKER_USERNAME` and
`DOCKER_PASSWORD` with the `sem` tool.

## Creating the secret

Use the command shown below to create the new secret:

``` bash
sem create secret dockerhub-secrets \
  -e DOCKER_USERNAME=<your-dockerhub-username> \
  -e DOCKER_PASSWORD=<your-dockerhub-password>
```

Now add the secret to your pipeline and authenticate.

## Configuring the Pipeline

This simple example authenticates in the `prologue`. This is not
strictly required, it's just an example showing all the steps in
authentication.

``` yaml
# .semaphore/pipeline.yml

version: "v1.0"
name: Build and push
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Build and push
    task:
      # Pull in environment variables from the "docker" secret
      secrets:
        - name: dockerhub-secrets
      prologue:
        commands:
          # Authenticate to the registry for all jobs in the block
          - echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
      jobs:
        - name: Build and push
          commands:
            - checkout
            - docker-compose build
            - docker-compose push
```
