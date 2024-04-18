---
Description: This guide shows you how to use Semaphore 2.0 to push Docker Images to AWS Elastic Container Registry (ECR). 
---

# Pushing Docker images to AWS Elastic Container Registry (ECR)

Pushing images to your AWS ECR is straightforward. Your workflow
simply needs to call the appropriate `aws` command to login to the
Docker registry, after which `docker push` works as expected. First, create a
secret to configure AWS access key environment variables.

## Creating the secret

``` bash
sem create secret AWS \
  -e AWS_ACCESS_KEY_ID=<your-aws-key-id> \
  -e AWS_SECRET_ACCESS_KEY=<your-aws-access-key>
```

Next, add the secret to your pipeline and authenticate.

## Configuring the Pipeline

This example authenticates in the `prologue`. This is not
strictly required, it's just an example of covering all aspects of
authentication.

``` yaml
# .semaphore/pipeline.yml

version: "v1.0"
name: First pipeline example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: "Push Image"
    task:
      env_vars:
        # TODO: change as required
        - name: AWS_DEFAULT_REGION
          value: ap-southeast-1
        - name: ECR_REGISTRY
          value: 828070532471.dkr.ecr.ap-southeast-1.amazonaws.com/semaphore2-ecr-example
      secrets:
        - name: AWS
      prologue:
        commands:
          # Install the most up-to-date AWS cli
          - sudo pip install awscli
          - checkout
          # ecr get-login outputs a login command, so execute that with bash
          - aws ecr get-login --no-include-email | bash

      jobs:
        - name: Push Image
          commands:
            - docker build -t example .
            - docker tag example "${ECR_REGISTRY}:${SEMAPHORE_GIT_SHA:0:7}"
            - docker push "${ECR_REGISTRY}:${SEMAPHORE_GIT_SHA:0:7}"
```
