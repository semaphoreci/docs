Pushing images to the official registry is straightforward. You'll
need to create a secret for the login username and password. Then,
call `docker login` with the appropriate environment variables. The
first step is create a secret for `DOCKER_USERNAME` and
`DOCKER_PASSWORD` with the `sem` tool.

## Creating The Secret

Open a new `secret.yml` file:

```yml
# secret.yml
apiVersion: v1alpha
kind: Secret
metadata:
  name: docker
data:
  env_vars:
    - name: DOCKER_USERNAME
      value: "REPLACE WITH YOUR USERNAME"
    - name: DOCKER_PASSWORD
      value: "REPLACE WITH YOUR PASSWORD"
```

Then create it:

```
sem create -f secret.yml
```

Now add the secret to your pipeline and authenticate.

## Configuring the Pipeline

This simple example authenticates in the `prologue`. This is not
strictly required, it's just an example of covering all jobs in
authentication.

```
# .semaphore/pipeline.yml
version: "v1.0"
name: Build and push
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Build and push
    task:
      # Pull in environment variables from the "docker" secret
      secrets:
        - name: docker
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
