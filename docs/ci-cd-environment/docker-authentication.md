---
Description: This guide explains Docker Hub rate limits and how to pull public Docker images as an authenticated user.
---

# Docker Hub authentication
As announced in this [Docker blog post](https://www.docker.com/blog/scaling-docker-to-serve-millions-more-developers-network-egress/), Docker Hub introduced [rate limits](https://docs.docker.com/docker-hub/download-rate-limit/) on image pulls on November 1<sup>st</sup>, 2020.  

Exceeding rate limits will disrupt your Semaphore workflows. You can find the recommended steps to avoid it below.  

## Does this affect you?
Semaphore runs jobs from a shared pool of IPs and anonymous public image pulls are counted based on the IP address. This means that if you are pulling images from a public Docker Hub repository as an anonymous user, **your Semaphore jobs will be affected by the DockerHub rate limit**.

## How Semaphore is helping?
Semaphore provides the [Semaphore Container Registry](/ci-cd-environment/semaphore-registry-images/) which hosts some of the most frequently-used Docker images. You can pull these images in your Semaphore environment without any restrictions or limitations.  

If you are using a [Docker-based CI/CD environment](/ci-cd-environment/custom-ci-cd-environment-with-docker/) in combination with convenience images, Semaphore will **automatically redirect** any pulls from the `semaphoreci` Docker Hub repository to the Semaphore Container Registry.

## What should you do to minimize the effects of rate limits?  
- **Switch to the Semaphore Container Registry** - if the image you need is available in [our Container Registry](/ci-cd-environment/semaphore-registry-images/), you can update your configuration to pull images from `registry.semaphoreci.com`
- **Authenticate your pulls** - If you have a Docker Hub account, start authenticating your pulls in your Semaphore configuration. 

## How to authenticate Docker pulls
### Step 1: Create a Semaphore secret  
The first step is to store your Docker Hub credentials. You can use [Semaphore secrets](/essentials/using-secrets/) to safely store any credentials and make them available in your projects.  

**Creating a secret from the UI**  

1. Click on the organization icon in the top right corner  
2. Select **Settings**  
3. Select **Secrets**  
4. Click **New Secret**  
5. Enter a unique name for your secret  
6. Add the first environment variable: `Variable name: "DOCKER_CREDENTIAL_TYPE", Value: "DockerHub"`  
7. Click **+ Add another** and add new variable: `Variable name: DOCKERHUB_USERNAME, Value:<your-dockerhub-username>`  
8. Add the third environment variable: `Variable name: DOCKERHUB_PASSWORD, Value:<your-dockerhub-password>`  
9. Click **Save Secret**  

**Creating a secret through the CLI**  
Before you begin, you'll need to [install the Semaphore CLI][install-cli].  

After connecting to your Semaphore organization, update the details in the example command below and run it:  
```bash
sem create secret <name-of-your-secret> \
  -e DOCKER_CREDENTIAL_TYPE=DockerHub \
  -e DOCKERHUB_USERNAME=<your-dockerhub-username> \
  -e DOCKERHUB_PASSWORD=<your-dockerhub-password>
```
### Step 2: Add the secret to your pipeline YAML
To use the newly-created secret in your jobs, you first need to attach it. You can attach a secret to individual blocks in your workflow or the whole pipeline. We suggest doing the latter, so that it's available to **all jobs** in the workflow.  

You can achieve this by using `global_job_config`, as shown below:  
```yaml
version: v1.0
name: My project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

global_job_config:
  # Connect secret to all jobs in the pipeline
  secrets:
    - name: <your-docker-hub-secret>

blocks:
  ...
```

### Step 3-a: Use the secret to authenticate Docker images pulls  
For your docker pulls to be authenticated, you have to log into Docker Hub:  
```bash
echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
```
You should run this command before pulling any Docker images.  

As with secrets, to avoid having to add this to every job or block, we suggest that you include this command in the `global_job_config` prologue of your pipeline:
```yaml
global_job_config:
  prologue:
  # Execute at the start of every job in the pipeline
    commands:
      - echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
  ...
```
This way, the `docker login` command will be run at the start of each job in the pipeline.

If, however, you prefer to log in to Docker Hub for individual jobs only, you can do it with the following command:
```yaml
# .semaphore/semaphore.yml
version: v1.0
name: Using a Docker image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Run container from Docker Hub
    task:
      jobs:
      - name: Authenticate docker pull
        commands:
          - checkout
          - echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
          - docker pull <repository>/<image>
          - docker images
          - docker run <repository>/<image>
      secrets:
      - name: docker-hub
```


### Step 3-b: Running jobs inside a Docker image
If you're using a Docker image as your pipeline CI/CD environment, you only need to attach the `docker-hub` secret to your agent's properties:
```yaml
agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main
      image: <repository>/<image>

  image_pull_secrets:
    - name: <your-docker-hub-secret>
```

## How to check if you are logged in
The `docker login` command will display a **Login Succeeded** message as an output if authentication was successful. 

Another way to check is to open `~/.docker/config.json` and check the `auths` field. 

If you have been successfully logged in, then the `auths` field will be updated accordingly:  
```json
{
	"auths": {
		"https://index.docker.io/v1/": {....
    }
```

If you are not logged in, the `auths` field will be empty:
```json
{
	"auths": {},
```

## How do you know if you are hitting the limit?
If you have exceeded the rate limit, Docker will throw the `Too Many Requests` error. Check the output of your `docker pull` command in the job log. If you have exceeded the rate limit, the output will be the following:  
```bash
You have reached your pull rate limit. You may increase the limit by authenticating and upgrading: https://www.docker.com/increase-rate-limit`
```

Docker published [this guide](https://www.docker.com/blog/checking-your-current-docker-pull-rate-limits-and-status/) that can also help in determining how close you are to reaching the rate limit.


[install-cli]: /reference/sem-command-line-tool/
