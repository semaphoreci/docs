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
