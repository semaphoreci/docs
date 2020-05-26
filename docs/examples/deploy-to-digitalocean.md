# Deploy to DigitalOcean

This guide demonstrates how to deploy to DigitalOcean's Kubernetes.

We will cover these steps to set up the deployment to DigitalOcean on Semaphore:

1. Create Semaphore secrets to store the credentials. 
2. Create a deployment pipeline, attaching the Secrets.
3. Run a deployment from Semaphore, and ship your code to production.

For this example you will need:

- [A working Semaphore project][create-project] with a basic CI pipeline. 
You can use one of the documented [use cases][use-cases] or [language guides][language-guides] as a starting point.
- A DigitalOcean account and a Personal Access Token. 
Follow [Create a Personal Access Token][create-personal-token] to set one up for your account.
- A [Docker Hub][docker-hub] Account
- A Kubernetes Cluster in DigitalOcean.
- Basic familiarity with Git and SSH.

## Connect CI and deployment pipelines with a promotion

Start by defining a [promotion][promotions-intro] at the end of your `semaphore.yml` file:

```yaml
# .semaphore/semaphore.yml
promotions:
  - name: Deploy to DigitalOcean
    pipeline_file: deploy-k8s.yml
```

This defines a simple deployment pipeline which can be triggered manually on every revision on every branch. You can generally define as many pipelines for a project as you need using a variety of options and conditions. For designing custom delivery pipelines, consult the [promotions reference documentation][promotions-ref].

## Storing credentials in secrets

Create three new [Semaphore secrets][secrets-guide] using the [sem CLI][sem-create-ref].

- Store the Docker Hub credentials.

```bash
sem create secret dockerhub \
  -e DOCKER_USERNAME=<your-dockerhub-username> \
  -e DOCKER_PASSWORD=<your-dockerhub-password>
```  

- Store the DigitalOcean Personal Access Token. 


```bash
sem create secret do-access-token \
  -e DO_ACCESS_TOKEN=<your-do-access-token>
```

- Store the .env file in the project root.

```bash
sem create secret env-production \
  --file /Users/joe/.env:/home/semaphore/env-production
```

You can verify the existance of the secrets:

```bash
sem get secrets
NAME             AGE
dockerhub        16s
do-access-token  45s
env-production  59s
```

You can also view the content of a secret:

```bash
sem get secret do-access-token
apiVersion: v1beta
kind: Secret
metadata:
  name: do-access-token
  id: 28e4d935-2697-4ade-ba00-e456869b3005
  create_time: "1590491283"
  update_time: "1590491283"
data:
  env_vars:
  - name: DO_ACCESS_TOKEN
    value: AHSNFMWOWEN...
  files: []
```

## Define the deployment pipeline  
          
Finally, let's define our `deploy-k8s.yml` pipeline:          
          
 ```yaml
version: v1.0
name: Deploy to Kubernetes
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Deploy to Kubernetes
    task:
      # Import all the secrets
      secrets:
        - name: dockerhub
        - name: do-access-token
        - name: env-production
      # Store your Kubernetes cluster name in an environment variable so you can reference it later
      env_vars:
        - name: CLUSTER_NAME
          value: your-server 
      prologue:
        commands:
          # Add the login commands in the prologue
          - doctl auth init --access-token $DO_ACCESS_TOKEN
          - doctl kubernetes cluster kubeconfig save "${CLUSTER_NAME}"
          - checkout 
      jobs:
      - name: Deploy
        commands:
          - source $HOME/env-production
          - envsubst < deployment.yml | tee deploy.yml
          - kubectl apply -f deploy.yml 
   - name: Tag latest release
    task:
      secrets:
        - name: dockerhub
      prologue:
        commands:
          - checkout
          - echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
          - checkout
      jobs:
      - name: docker tag latest
        commands:
          - docker pull "${DOCKER_USERNAME}/addressbook:$SEMAPHORE_WORKFLOW_ID" 
          - docker tag "${DOCKER_USERNAME}/addressbook:$SEMAPHORE_WORKFLOW_ID" "${DOCKER_USERNAME}/addressbook:latest"
          - docker push "${DOCKER_USERNAME}/addressbook:latest"
```

## Verify it works

Push a new commit on any branch and open Semaphore to watch a new workflow run. 
If all goes well you'll see the `Promote` button next to your initial pipeline. 
Click on the button to launch the deployment.

[docker-hub]: https://docs.docker.com/docker-hub/
[create-personal-token]: https://www.digitalocean.com/docs/api/create-personal-access-token/
[create-project]: https://docs.semaphoreci.com/guided-tour/creating-your-first-project/
[use-cases]: https://docs.semaphoreci.com/examples/tutorials-and-example-projects/
[language-guides]: https://docs.semaphoreci.com/programming-languages/android/
[promotions-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
[promotions-intro]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
[secrets-guide]: https://docs.semaphoreci.com/guided-tour/environment-variables-and-secrets/
[sem-create-ref]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-create
[deployment-dashboards]: https://docs.semaphoreci.com/essentials/deployment-dashboards/
