# Deploy to DigitalOcean

This guide demonstrates how to deploy to DigitalOcean.

We will cover these steps to set up the deployment to DigitalOcean on Semaphore:

1. Create the Secrets to store the credentials. 
2. Store the Git Deploy key in a [Secret](secret) on Semaphore.
3. Create a deployment pipeline, and attach the Git Deploy key secret.
4. Run a deployment from Semaphore, and ship your code to production.

For this example you will need:

- [A working Semaphore project][create-project] with a basic CI pipeline. 
You can use one of the documented [use cases][use-cases] or [language guides][language-guides] as a starting point.
- A DigitalOcean account and a Personal Access Token. 
Follow [Create a Personal Access Token][create-personal-token] to set one up for your account.
- A [Docker Hub][docker-hub] account.
- Basic familiarity with Git and SSH.

## Storing credentials in Secrets

- Create the Secret to store the credentials for Docker Hub. 


```bash
sem create secret dockerhub \
  -e DOCKER_USERNAME=<your-dockerhub-username> \
  -e DOCKER_PASSWORD=<your-dockerhub-password>
```


```yaml
version: v1.0
name: Application
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804    
blocks:
  - name: Install dependencies
    task:
      env_vars:
        - name: NODE_ENV
          value: test
      prologue:
        commands:
          - checkout
          - nvm use
      jobs:
        - name: npm install and cache
          commands:
            - cache restore
            - npm install
            - cache store 
  - name: Tests
    task:
      env_vars:
        - name: NODE_ENV
          value: test
      prologue:
        commands:
          - checkout
          - nvm use
          - cache restore 
      jobs:
        - name: Static test
          commands:
            - npm run lint
        - name: Unit test
          commands:
            - sem-service start postgres
            - npm run test
promotions:
  - name: Dockerize
    pipeline_file: docker-build.yml
    auto_promote:
      when: "result = 'passed'"          
```


```yaml
version: v1.0
name: Docker build
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Build
    task:
      secrets:
        - name: dockerhub   
    task:
      prologue:
        commands:
          - checkout
          - echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
      jobs:
      - name: Docker build
        commands:
          - docker pull "${DOCKER_USERNAME}/addressbook:latest" || true
          - docker build --cache-from "${DOCKER_USERNAME}/addressbook:latest" -t "${DOCKER_USERNAME}/addressbook:$SEMAPHORE_WORKFLOW_ID" .
          - docker push "${DOCKER_USERNAME}/addressbook:$SEMAPHORE_WORKFLOW_ID"
promotions:
  - name: Deploy to Kubernetes
    pipeline_file: deploy-k8s.yml
    auto_promote:
      when: "result = 'passed'"         
 ```         
          
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
      secrets:
        - name: dockerhub
        - name: do-access-token
        - name: env-production
      env_vars:
        - name: CLUSTER_NAME
          value: your-server 
      prologue:
        commands:
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
