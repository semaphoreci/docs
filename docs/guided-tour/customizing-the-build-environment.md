---
description: Learn more about the three types of build environments available in Semaphore 2.0 - Linux Ubuntu environment, MacOS environment and Docker environment.
---

# Customizing the Build Environment

Semaphore runs each job in a clean and isolated environment. Three types of
build environments are available:

- The [Linux Ubuntu environment][ubuntu] that includes common tools needed by
  projects. It offers full `sudo` access to the virtual machine.

- The [MacOS environment][macos] that includes common tools needed for iOS
  development. It offers full `sudo` access to the virtual machine.

- The [Docker environment][docker] that allows you to run your jobs in a custom
  Docker images.

All environments come with a fast network so you can install any additional
software and customize the environment however you need.

## Choosing the Machine Type and OS Image

To use the Linux Ubuntu build environment, define the agent's machine type and
OS image in your pipeline YAML file:

``` yaml
# .semaphore/semaphore.yml

agent:
  machine:
    type: e1-standard-2    # Linux machine type with 2 vCPUs, 4 GB of RAM
    os_image: ubuntu1804   # The Ubuntu 18.04 OS image.
```

Alternatively, if you want to run a MacOS based pipeline, configure it with:

``` yaml
# .semaphore/semaphore.yml

agent:
  machine:
    type: a1-standard-2    # Apple machine type with 2 vCPUs, 4 GB of RAM
    os_image: macos-xcode11 # MacOS os image
```

If you prefer to have a fully custom, containerized environment, define one or
more Docker images in your pipeline file:

``` yaml
# .semaphore/semaphore.yml

agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main             # The first container will be used to run your jobs
      image: bitnami/rails   # use any Docker image

    - name: db               # Additional containers can be started
      image: postgres:9.6    # and will be available in the first image
```

If your custom Docker images are privately hosted, follow the [private Docker
images section in the Custom CI/CD environment][private-images] to set up your
access credentials on Semaphore.

## Installing additional dependencies

Let's say that your project uses Bats, which is hosted on GitHub, to test
your Bash scripts. You can easily make it available on Semaphore by copying
the installation commands from the project's Readme into your prologue:

``` yaml
# .semaphore/semaphore.yml

blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - git clone https://github.com/bats-core/bats-core.git
          - cd bats-core
          - sudo ./install.sh /usr/local
      jobs:
        - name: Tests
          commands:
            - bats addition.bats
```

## Next steps

Running a CI build in practice usually requires one or more running Databases,
Cache servers, or other background services like RabbitMQ or Kafka.

Let's learn how to do that in [the next section][next].

[ubuntu]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/
[macos]: https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/
[docker]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/
[private-images]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/#pulling-private-docker-images-from-dockerhub
[next]: https://docs.semaphoreci.com/guided-tour/using-databases-and-services/
