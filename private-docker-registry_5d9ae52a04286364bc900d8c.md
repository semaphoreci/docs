__Note__: *Semaphore private Docker Registry is available on [request](mailto:support@semaphoreci.com?subject=Beta Request: private Docker Registry).
Using the Docker Registry during the beta period is free.
Once the feature is in the general additional charges will apply based on
the usage.*

Semaphore provides private a Docker Registry for a project
to help you speed up its workflows and reduce costs.
You should typically use it to cache Docker images.

The registry size is fixed to 15GB.

### Usage

The following environment variables are available in each job environment:

- `SEMAPHORE_REGISTRY_USERNAME` - Semaphore private Docker Registry username
- `SEMAPHORE_REGISTRY_PASSWORD` - Semaphore private Docker Registry password
- `SEMAPHORE_REGISTRY_URL` - Semaphore private Docker Registry url

To log in to private Docker Registry add the following command to the job

`docker login -u $SEMAPHORE_REGISTRY_USERNAME -p $SEMAPHORE_REGISTRY_PASSWORD $SEMAPHORE_REGISTRY_URL`
