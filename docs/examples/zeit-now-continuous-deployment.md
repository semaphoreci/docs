---
Description: This guide shows you how to use Semaphore 2.0 to set up continuous integration and deployment to ZEIT Now.
---

# Zeit Now continuous deployment

ZEIT Now is a cloud service for web services and serverless functions. 
This guide shows you how to use Semaphore to set up continuous integration and
deployment to [ZEIT Now](https://zeit.co).

## Demo project

Semaphore provides a demo project that you can use to get started.

- [Demo ZEIT Now project on GitHub](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now)

The demo deploys a serverless function that replies “Hello World!” to all HTTP
requests.

Testing serverless functions can be challenging. To emulate the cloud
environment in Semaphore, the project uses a combination of
[Node.js](https://nodejs.org), [Express](http://expressjs.com/),
[Jest](https://jestjs.io/), and
[Supertest](https://github.com/visionmedia/supertest).

## Overview of the pipelines

The pipeline performs the following tasks:

- Install dependencies.
- Run unit tests.
- Continuously deploys the master branch to the production site.

On manual approval:

- Deploys to the staging site.

The complete CI/CD workflow looks like this:

![CI+CD Pipelines for ZEIT Now](https://raw.githubusercontent.com/semaphoreci-demos/semaphore-demo-zeit-now/master/images/ci-pipeline.png)


### Continuous integration pipeline (CI)

In the repository, the `.semaphore` directory contains the annotated pipeline 
configuration files.

The CI pipeline takes place in 2 blocks:

-   npm install and cache:
    -   Downloads and installs Node.js packages.
    -   Builds the app and saves it to the cache.
-   npm test:
    -   Runs unit and coverage tests.

```yaml
version: v1.0
name: Build and test 

# An agent defines the environment in which your code runs.
# It is a combination of one of the available machine types and operating
# system images.
# See https://docs.semaphoreci.com/ci-cd-environment/machine-types/
# and https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

# Blocks are the heart of a pipeline and are executed sequentially.
# Each block has a task that defines one or more jobs. Jobs define the
# commands to execute.
# See https://docs.semaphoreci.com/essentials/concepts/
blocks:
  - name: Install dependencies
    task:
      jobs:
        - name: npm install and cache
          commands:
            - checkout
            - nvm use
            - node --version
            - npm --version
            - cache restore
            - npm install
            - cache store

  - name: Run tests
    task:
      jobs:
        - name: npm test
          commands:
            - checkout
            - nvm use
            - cache restore
            - npm test

promotions:
  # Deployment to staging can be triggered manually:
  - name: Deploy to staging
    pipeline_file: deploy-staging.yml

  # Automatically deploy to production on successful builds on the master branch:
  - name: Deploy to production
    pipeline_file: deploy-production.yml
    auto_promote:
      when: "result = 'passed' and branch = 'master'"
```


Two [promotions](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions)
branch out of the CI pipeline:

-   Deploy to production: automatically started once all tests are green
    for the master branch.
-   Deploy to staging: can be manually initiated from a Semaphore workflow 
    on any branch.

### Continuous deployment pipeline (CD)

The CD pipeline consists of a block with a single job:

``` yaml
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
        - name: now
      jobs:
      - name: Deploy to ZEIT Now
        commands:
          - checkout
          - nvm use
          - npm install now -g
          - now --token $ZEIT_TOKEN -n semaphore-demo-zeit-now

```

Deployment with ZEIT Now is performed with the [Now
CLI](https://zeit.co/docs/v2/getting-started/installation/#now-cli). No
configuration file is required as long as the project files are located in
the following special directories:

- `public` for static files.
- `api` or `pages/api` for serverless functions.

In addition, ZEIT Now can automatically build using many 
[popular frameworks](https://zeit.co/docs/v2/build-step/#optimized-frameworks).

The staging and production pipelines are almost identical. They
only differ in the app's name, which maps to the final deployment URL 
as shown below:

- Production: `semaphore-demo-zeit-now.YOUR_USERNAME.now.sh`
- Staging: `semaphore-demo-zeit-now-staging.YOUR_USERNAME.now.sh`

## Running the demo yourself

You can get started right away with Semaphore. Running and deploying the
demo by yourself takes only a few minutes:

### Getting a Token

1.  Create a [ZEIT Now](https://zeit.co) account.
2.  Open your account **Settings**
3.  Go to the **Tokens** tab.
4.  Click on the **Create** button.
5.  Enter a name for the token. It should be something descriptive like:
    semaphore-zeit-now
6. Copy the generated token and keep it safe.

![Create Token](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now/raw/master/images/zeit-create-token.png)

### Creating the pipeline on Semaphore

Now, add the token to Semaphore:

1.  Create a [Semaphore](https://semaphoreci.com) account.
2.  In the left navigation bar, click on
    **Secrets** under **Configuration**.
3.  Hit the **Create New Secret** button.
4.  Create a secret, as shown below. Copy the token obtained earlier to it.

![Create Secret](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now/raw/master/images/semaphore-create-secret.png)

To run the project on Semaphore:

1.  Fork the [Demo
    project](https://github.com/semaphoreci-demos/semaphore-demo-zeit-now)
    on GitHub.
2.  Clone the repository to your local machine.
3.  In Semaphore, follow the link on the sidebar to create a new
    project.
4.  Edit any file and do a push to GitHub, Semaphore starts
    automatically.

Once the deployment is complete, the API service should be online. 
You can browse the production URL with the following command:

```bash
$ curl -w "\n" https://semaphore-demo-zeit-now.YOUR_USERNAME.now.sh/api/hello
Hello World!
```
## See also

-   [Semaphore guided
    tour](https://docs.semaphoreci.com/guided-tour/getting-started/)
-   [Pipelines
    reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
-   [JavaScript and Node.js](https://docs.semaphoreci.com/programming-languages/javascript-and-node-js/)
