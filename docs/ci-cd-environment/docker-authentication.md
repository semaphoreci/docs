---
description: This guide explains Docker Hub rate limits and how to pull public Docker images as an authenticated user.
---

# Docker Hub authentication
As announced in the [Docker blog post](https://www.docker.com/blog/scaling-docker-to-serve-millions-more-developers-network-egress/), on November 1<sup>st</sup> 2020, Docker Hub will introduce [rate limits](https://docs.docker.com/docker-hub/download-rate-limit/) on image pulls.  

Following rate limits will apply:

- 100 pulls per 6 hours for anonymous public image pulls
- 200 pulls per 6 hours for authenticated users on the free Docker Hub plan
- Unlimited pull rate for the authenticated users with Pro and Team Docker Hub accounts.  

Exceeding the explained rate limits will disrupt your Semaphore workflows. You can find the recommended steps to avoid it below.  

## Will this affect you
Semaphore runs jobs from a shared pool of IPs and anonymous public image pulls are counted based on the IP address. This means that if you are pulling images from a public Docker Hub repository as an anonymous user, **your Semaphore jobs will be affected by the new DockerHub rate limit**.

We want to help you reduce the impact of the Docker Hub rate limit introduction so feel free to reach out to our support team with any questions that you might have.  

## What are we doing to help  
For your convenience, we have created the [Semaphore Container Registry](/ci-cd-environment/semaphore-registry-images/) which contains some of the most frequently used Docker images. You can pull these images in your Semaphore environment without any restrictions or limitations.  

If you are using a [Docker-based CI/CD environment](/ci-cd-environment/custom-ci-cd-environment-with-docker/) in combination with convenience images Semaphore will **automatically redirect** any pulls from the `semaphoreci` Docker Hub repository to the Semaphore Container Registry.

## What should you do to minimize the effect of the rate limit  
- **Switch to Semaphore Container Registry** - if the image you need is available in [our Container Registry](/ci-cd-environment/semaphore-registry-images/) you can update your configuration to pull images from `registry.semaphoreci.com/`
- **Authenticate your pulls** - If you have a Docker Hub account start authenticating your pulls in your Semaphore configuration. 

## How to authenticate Docker pulls
### Create the Semaphore secret  
The first step is to store your Docker Hub credentials. You can use [Semaphore secret](/essentials/using-secrets/) to safely store any credentials and make them available in your projects.  

**Creating a secret from the UI**

- Click on the organization icon in the top right corner  
- From the menu select **Settings**  
- On the left side pick **Secrets**  
- Click on **New Secret**  
- Fill in a unique name for your secret  
- Add the first environment variable: `Variable name: "DOCKER_CREDENTIAL_TYPE", Value: "DockerHub"`  
- Click on **+ Add another** and add new variable: `Variable name: DOCKERHUB_USERNAME, Value:<your-dockerhub-username>`  
- Add the third environment variable: `Variable name: DOCKERHUB_PASSWORD, Value:<your-dockerhub-password>`  
- Click on **Save Secret**  

**Creating a secret through CLI**  
Before you begin, you'll need to [install the Semaphore CLI][install-cli].  

After connecting to your Semaphore organization update the details in the example command below and run it:  
```bash
sem create secret <name-of-your-secret> \
  -e DOCKER_CREDENTIAL_TYPE=DockerHub \
  -e DOCKERHUB_USERNAME=<your-dockerhub-username> \
  -e DOCKERHUB_PASSWORD=<your-dockerhub-password>
```
**Adding a secret to your pipeline YAML**  
To use the newly created secret in your jobs, you first need to attach it.  
You can attach a secret to individual blocks in your workflow or the whole pipeline.  
We suggest doing the latter so that it's available to **all jobs** in the workflow.  
You can achieve it by using `global_job_config` like this:  
```yaml
version: v1.0
name: My project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

global_job_config:
  # Connect secret to all jobs in the pipeline
  secrets:
    - name: <your-docker-hub-secret>

blocks:
  ...
```

### Use secret to authenticate Docker images pulls  
For your docker pulls to be authenticated you have to log into Docker Hub:  
```bash
echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
```
You should run this command before pulling any Docker images.  

Same as with secrets, to avoid having to add this to every job or block, we suggest that you include it in the `global_job_config` prologue of your pipeline:
```yaml
global_job_config:
  prologue:
  # Execute at the start of every job in the pipeline
    commands:
      - echo $DOCKERHUB_PASSWORD | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
  ...
```
This way the `docker login` command will be run at the start of each job in the pipeline.

If however, you prefer to log in to Docker Hub in individual jobs only, you can do it like in this example:
```yaml
# .semaphore/semaphore.yml
version: v1.0
name: Using a Docker image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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


### Running jobs inside a Docker image
When you're using Docker image as your pipeline CI/CD environment, make sure to attach the `docker-hub` secret to your agent's properties to pull the images:
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
The `docker login` command will display a **Login Succeeded** message as an output if authentication was successfull. 

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

## How can you know if you are hitting the limit
If you have exceeded the rate limit, Docker will throw the `Too Many Requests` error. Check the output of your `docker pull` command in the job log. If you have exceeded the rate limit, the output will be the following:  
```bash
Too Many Requests. Please see https://docs.docker.com/docker-hub/download-rate-limit/`
```
[install-cli]: /reference/sem-command-line-tool/
