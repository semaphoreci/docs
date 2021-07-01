---
description: In this guide, we will show you how to use Semaphore 2.0 to implement continuous integration and deployment for a Clojure Luminus web application.
---

# Clojure Luminus CI/CD

In this guide, we will show you how to use Semaphore to implement
continuous integration and deployment for a Clojure Luminus web application.

## Demo Project

Semaphore maintains an example Clojure demo:

  - [semaphore-demo-clojure-luminus](https://github.com/semaphoreci-demos/semaphore-demo-clojure-luminus)

The project is written for the [Luminus](http://www.luminusweb.net/) web 
application framework, and is based on the 
[guestbook sample app](http://www.luminusweb.net/docs#guestbook_application),

## Overview of the Pipelines

The example project ships with CI and CD pipelines, found in 
the `.semaphore` directory:

  - Continuous Integration
      - Install dependencies, using a cache for faster builds.
      - Run the unit tests.
      - Package the app as a single, standalone jar file.
  - Continuous Deployment
      - Prepare files for deployment.

![CI+CD](https://raw.githubusercontent.com/semaphoreci-demos/semaphore-demo-clojure-luminus/master/.semaphore/semaphore-demo-clojure-luminus-cicd.png)


### Continuous Integration Pipeline

If you are new to Semaphore, be sure to read the 
[guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) 
and the linked pages for more information.

``` yaml
version: v1.0
name: Clojure+Semaphore example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: "Setup"
    task:
      prologue:
        commands:
          - checkout
          - cache restore lein-deps-$(checksum project.clj)
          - mv home/semaphore/.m2 ~/.m2 2>/dev/null || true
          - cache restore lein-$(checksum `which lein`)
          - mv home/semaphore/.lein ~/.lein 2>/dev/null || true
      jobs:
        - name: Dependencies
          commands:
            - lein with-profile +dev,+test,+uberjar deps
            - cache store lein-deps-$(checksum project.clj) ~/.m2
            - cache store lein-$(checksum `which lein`) ~/.lein
  - name: "Tests"
    task:
      prologue:
        commands:
          - checkout
          - cache restore lein-deps-$(checksum project.clj)
          - mv home/semaphore/.m2 ~/.m2
          - cache restore lein-$(checksum `which lein`)
          - mv home/semaphore/.lein ~/.lein 2>/dev/null || true
      jobs:
        - name: Clojure tests
          commands:
            - lein test
  - name: "Build"
    task:
      prologue:
        commands:
          - checkout
          - cache restore lein-deps-$(checksum project.clj)
          - mv home/semaphore/.m2 ~/.m2
          - cache restore lein-$(checksum `which lein`)
          - mv home/semaphore/.lein ~/.lein 2>/dev/null || true
      jobs:
        - name: Uberjar build
          commands:
            - lein uberjar
            - cache delete uberjar-latest
            - cache store uberjar-latest target/uberjar/guestbook.jar
promotions:
  - name: Production deploy
    pipeline_file: production-deploy.yml
    auto_promote_on:
      - result: passed
```

Semaphore's
[Ubuntu 18.04](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/)
Virtual Machine comes with [leiningen](https://leiningen.org/)
preinstalled. `lein` automates Clojure projects and manages
dependencies.

The CI pipeline is made of 3 blocks:

  - Setup: installs the project dependencies and stores them in the
    [cache](https://docs.semaphoreci.com/reference/toolbox-reference/#cache)
    to speed up subsequent jobs.
  - Tests: runs the luminus 
    [unit tests](http://www.luminusweb.net/docs/testing.html).
  - Build: uses [uberjar](https://imagej.net/Uber-JAR) to generate a
    standalone package.

In order to reduce build times, each block includes a 
[prologue](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#prologue)
that attempts to retrieve dependencies using Semaphore's
[cache](https://docs.semaphoreci.com/reference/toolbox-reference/#cache)
utility.
The prologue is run before each job in the the block.

### Promotion

You can create complex workflows with
[promotions](https://docs.semaphoreci.com/essentials/deploying-with-promotions/).
A promotion can trigger the start of the next pipeline either manually
or on user-defined conditions. The
[auto_promote_on](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#auto_promote_on)
keyword is used to automatically start the deployment pipeline once
integration has completed successfully.

### Continuous Delivery Pipeline

``` yaml
version: v1.0
name: Deploy to production
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Deploy
    task:
      prologue:
        commands:
          - cache restore uberjar-latest
      jobs:
        - name: Deploying
          commands:
            - echo 'Deploying to production!'
            - ls -la target/uberjar/
```

The CD pipeline has only one block. In truth, it doesn't deploy anywhere,
but leaves the files set up so developers can quickly
pick up and continue with the chosen deployment target.

Luminus automatically generates some deployment files for your
convenience:

  - Dockerfile: for building [Docker](https://www.docker.com/) images.
  - Procfile: for [Heroku](https://www.heroku.com) deployments.
  - Capstanfile: to run the app with the 
    [OSv unikernel](http://osv.io/).

For more details, consult the 
[Luminus deployment manual](http://www.luminusweb.net/docs/deployment.html).

## Run the Demo Yourself

No better way of learning about Semaphore than by using it. Here is how
you can run the demo:

1.  Fork the
    [repository](https://github.com/semaphoreci-demos/semaphore-demo-clojure-luminus)
    on GitHub.
2.  Clone the repository on your local machine.
3.  In Semaphore, follow the link on the sidebar to create a new
    project.
4.  Edit any file and push a commit to the repository. Semaphore will
    start the pipeline automatically.

## Next Steps

Excellent work\! You now have integration and delivery pipelines for
your Clojure projects. The next step is implementing a deployment scenario. 
For further information, consult the following tutorials:

  - [Publishing Docker images on Docker Hub](https://docs.semaphoreci.com/examples/publishing-docker-images-on-dockerhub/)
  - [Heroku Deployment](https://docs.semaphoreci.com/examples/heroku-deployment/)
  - [Google Cloud Run Continuous Deployment](https://docs.semaphoreci.com/examples/google-cloud-run-continuous-deployment/)

## See Also

  - [Tutorials and sample Projects](https://docs.semaphoreci.com/examples/tutorials-and-example-projects/)
  - [Clojure support on Semaphore](https://docs.semaphoreci.com/programming-languages/clojure/)
  - [Pipeline YAML Reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
