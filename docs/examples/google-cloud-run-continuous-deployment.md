---
Description: This guide shows you how to use Semaphore 2.0 to set up continuous integration and deployment to Google Cloud Run for web applications written in any language.
---

# Google Cloud Run Continuous Deployment

This guide shows you how to use Semaphore to set up continuous integration and
deployment (CI/CD) to Google Cloud Run for web applications written in any
language.

You can use Semaphore to run tests, build Docker container images and push them to
Google Container Registry, and trigger deployments to multiple Cloud Run
environments.

For this guide you will need:

- [A Semaphore account][semaphore-account], which you can create for free.
- [A Google Cloud account][google-cloud-account], with a project and billing enabled.
- Basic familiarity with Docker.

## Demo project

Semaphore maintains an example Google Cloud Run project:

- [Demo Google Cloud Run project on GitHub][demo-project]

In the repository, you will find annotated Semaphore configuration files in the
`.semaphore` directory.

The application uses the Sinatra Ruby web framework with RSpec for tests.
Semaphore builds the application in a Docker container and deploys it to Google Cloud Run.

## Overview of the CI/CD pipeline

The example CI/CD pipeline performs the following tasks:

- Installs and caches project dependencies
- Runs RSpec unit tests
- Builds and tags a Docker container image
- Pushes the container to Google Container Registry
- Provides one-click deployment to a staging environment on Google Cloud Run
- Automatically deploys passed builds from the master branch to the production
  environment on Google Cloud Run

![Google Cloud Run CI/CD pipeline with Semaphore](https://github.com/semaphoreci-demos/semaphore-demo-cloud-run/raw/master/pipeline.png)

## Sample configuration

The first pipeline, which runs unit tests, is defined in the `semaphore.yml` file, as shown below:

```yaml
# .semaphore/semaphore.yml
version: v1.0
name: Run tests
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Install dependencies
    task:
      jobs:
        - name: bundle install
          commands:
            - checkout
            - cache restore
            - bundle install --deployment --path vendor/bundle
            - cache store

  - name: Tests
    task:
      jobs:
        - name: rspec
          commands:
            - checkout
            - cache restore
            - bundle install --deployment --path vendor/bundle
            # Run unit tests:
            - bundle exec rspec

promotions:
  - name: Dockerize
    pipeline_file: docker-build.yml
    auto_promote:
      when: "result = 'passed'"
```

If all tests pass, we build a Docker container and push it to the registry as a
unique artifact:

```yaml
# .semaphore/docker-build.yml
version: v1.0
name: Docker build
agent:
  machine:
    type: e1-standard-4
    os_image: ubuntu1804
blocks:
  - name: Build
    task:
      secrets:
        - name: google-cloud-stg
      jobs:
      - name: Docker build
        commands:
          - gcloud auth activate-service-account --key-file=.secrets.gcp.json
          - gcloud auth configure-docker -q
          - checkout
          - docker build -t "gcr.io/semaphore2-stg/semaphore-demo-cloud-run:${SEMAPHORE_GIT_SHA:0:7}" .
          - docker push "gcr.io/semaphore2-stg/semaphore-demo-cloud-run:${SEMAPHORE_GIT_SHA:0:7}"

promotions:
  - name: Deploy to staging
    pipeline_file: deploy-staging.yml

  - name: Deploy to production
    pipeline_file: deploy-production.yml
    auto_promote:
      when: "result = 'passed' and branch = 'master'"
```

The staging and production deployment pipelines are configured in the same way -- 
the only difference is the name of the service:

```yaml
# .semaphore/deploy-production.yml
version: v1.0
name: Deploy to production
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Deploy to production
    task:
      secrets:
        - name: google-cloud-stg
      jobs:
      - name: run deploy
        commands:
          - gcloud auth activate-service-account --key-file=.secrets.gcp.json
          - gcloud auth configure-docker -q
          - gcloud beta run deploy semaphore-demo-cloud-run --project semaphore2-stg --image gcr.io/semaphore2-stg/semaphore-demo-cloud-run:${SEMAPHORE_GIT_SHA:0:7} --region us-central1
```

## Configuration walkthrough

### Running tests

`.semaphore.yml` is the entry point of every workflow, and defines the basic
continuous integration steps.

First, we declare that we want to use the latest stable version of Semaphore 2.0
YML syntax, and name our pipeline.

The name that we write here will appear in workflow reports, as shown in [the
screenshot above](#overview-of-the-ci-cd-pipeline). Because we connect [multiple
pipelines][concepts] with [promotions][promotions], giving descriptive names
helps to differentiate the purposes of various pipelines.

```yaml
version: v1.0
name: Run tests
```

Next, we define an agent, which sets up the environment in which our code runs.
An agent is a combination of one of the available [machine types][machine-types]
and [operating systems or Docker images][cicd-env]:

```yaml
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
```

Each pipeline is composed of blocks. Here we define two sequential blocks, one
which installs dependencies, and another which runs tests. 
Each block can define one job or multiple parallel jobs.

```yaml
blocks:
  - name: Install dependencies
    task:
      jobs:
        - name: bundle install
          commands:
            - checkout
            # ...

  - name: Tests
    task:
      jobs:
        - name: rspec
          commands:
            - checkout
            # ...
```

Because both blocks work with our source code, we need to run the
[`checkout` command][checkout] to get it from the connected Git repository.

When dealing with project dependencies, [caching them][caching] can speed up the CI/CD process. 
The general workflow for working with dependencies in Semaphore is to:

- Run `cache restore` to try to restore a recent version from the cache. Semaphore
  performs partial key matching and you can use multiple cache keys as
  fallbacks. This command will never fail.
- Run the dependency installation command of your package manager. If `cache
  restore` succeeded in the previous step, this command will execute very
  quickly.
- Run `cache store` to save the latest version of dependencies in the cache. For
  the best performance, generate a cache key based on the current git branch and
  revision of the dependency definition file.

```yaml
            - cache restore
            - bundle install --deployment --path .bundle
            - cache store
```

If all tests pass, we move on to building a Docker image.
This is a job for a separate pipeline, which we will link to our first
pipeline using a [promotion][promotions]:

```yaml
promotions:
  - name: Dockerize
    pipeline_file: docker-build.yml
    auto_promote:
      when: "result = 'passed'"
```

### Docker build

In order to automate [pushing Docker images to Google Container Registry][gcr],
Semaphore needs to authenticate with Google Cloud. To do
that securely, we need to create a [Semaphore secret][secrets] to hold our Google
Cloud service account’s authentication key.

Once we have our authentication key, we upload it to Semaphore as a
secret using the [Semaphore CLI][sem-cli] or in the web UI. The secret should
define a file, let’s call it `.secrets.gcp.json`:

```bash
sem create secret google-cloud-stg --file ~/Downloads/account-name-27f3a5bcea2d.json:.secrets.gcp.json
```

We can now put the secret in our Docker build pipeline, which will make the
file `.secrets.gcp.json` available in the job environment:

```yaml
blocks:
  - name: Build
    task:
      secrets:
        - name: google-cloud-stg
```

Now, we can authenticate with Google Cloud and configure access to the container
registry. By using the `-q` flag with `configure-docker`, we avoid an interactive
prompt:

```yaml
      jobs:
      - name: Docker build
        commands:
          - gcloud auth activate-service-account --key-file=.secrets.gcp.json
          - gcloud auth configure-docker -q
```

After we check out our code, we can proceed to build and tag a Docker image.
The tagging pattern that we follow is
`gcr.io/GOOGLE_CLOUD_PROJECT_NAME/SERVICE_NAME`. We will use the
`$SEMAPHORE_GIT_SHA` [environment variable][env-vars] to produce a unique
artifact name.

```yaml
          - checkout
          - docker build -t "gcr.io/semaphore2-stg/semaphore-demo-cloud-run:${SEMAPHORE_GIT_SHA:0:7}" .
          - docker push "gcr.io/semaphore2-stg/semaphore-demo-cloud-run:${SEMAPHORE_GIT_SHA:0:7}"
```

### Deployment

The Docker build pipeline defines two promotions, which can trigger two
parallel, independent deployment pipelines.

Deployment to staging can be triggered manually. Each deployment will be reported
in the UI with a timestamp and the username of the person who launched it.

```yaml
promotions:
  - name: Deploy to staging
    pipeline_file: deploy-staging.yml
```

Deployment to production is continuous, if the following conditions are
true:

- All previous steps have passed.
- We are on the master Git branch.

```yaml
  - name: Deploy to production
    pipeline_file: deploy-production.yml
    auto_promote:
      when: "result = 'passed' and branch = 'master'"
```

The deployment pipelines repeat the steps with the secret containing
our credentials and authenticate with Google Cloud. Finally, the
deployment process runs:

```yaml
blocks:
  - name: Deploy to staging
    task:
      secrets:
        - name: google-cloud-stg
      jobs:
      - name: run deploy
        commands:
          - gcloud auth activate-service-account --key-file=.secrets.gcp.json
          - gcloud auth configure-docker -q
          - gcloud beta run deploy semaphore-demo-cloud-run-stg --project semaphore2-stg --image gcr.io/semaphore2-stg/semaphore-demo-cloud-run:${SEMAPHORE_GIT_SHA:0:7} --region us-central1
```

## Run the demo Google Cloud Run project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][demo-project] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Create your secret as per the instructions above.
5. Modify the names of Google Cloud resources to match your account.
6. Push changes to GitHub, and Semaphore will run your CI/CD pipeline.

If you run into an issue, you can quickly [launch a Semaphore SSH session to
debug it][debugging].

For more CI/CD configuration options, see [Semaphore YML reference][reference].

[semaphore-account]: https://semaphoreci.com
[google-cloud-account]: https://cloud.google.com
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-cloud-run
[concepts]: https://docs.semaphoreci.com/essentials/concepts/
[promotions]: https://docs.semaphoreci.com/essentials/deploying-with-promotions/
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[cicd-env]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[checkout]: https://docs.semaphoreci.com/reference/toolbox-reference/#checkout
[caching]: https://docs.semaphoreci.com/reference/toolbox-reference/#cache
[gcr]: https://docs.semaphoreci.com/examples/pushing-docker-images-to-google-container-registry-gcr/
[secrets]: https://docs.semaphoreci.com/essentials/using-secrets/
[sem-cli]: https://docs.semaphoreci.com/reference/sem-command-line-tool/
[env-vars]: https://docs.semaphoreci.com/ci-cd-environment/environment-variables/
[debugging]: https://docs.semaphoreci.com/essentials/debugging-with-ssh-access/
[reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
