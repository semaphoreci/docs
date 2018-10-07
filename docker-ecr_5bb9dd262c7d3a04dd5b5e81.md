Pushing images to your AWS ECR is straight forward. Your workflow
simply needs to call the appropriate `aws` command to login to the
Docker registry. Then `docker push` works as expected. First, create a
secret to configure AWS access key environment variables.

## Creating the Secret

Open a new `secret.yml` file:

```yml
# secret.yml
apiVersion: v1alpha
kind: Secret
metadata:
  name: AWS
data:
  env_vars:
    - name: AWS_ACCESS_KEY_ID
      value: "YOUR_ACCESS_KEY"
    - name: AWS_SECRET_ACCESS_KEY
      value: "YOUR_SECRET_ACCESS_KEY"
```

Then create it:

```
sem create -f secret.yml
```

Now add the secret to your pipeline and authenticate

## Configuring the Pipeline


This example authenticates in the `prologue`. This is not
strictly required, it's just an example of covering all jobs in
authentication.

```yml
# .semaphore/pipeline.yml
version: "v1.0"
name: First pipeline example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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
