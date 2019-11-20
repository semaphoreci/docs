# Environment Types

Semaphore supports two types of environments for running jobs. A Virtual Machine
(VM) based environment, and a Docker container based environment.

- [Virtual Machine based environments](virtual-machine-based-environments)
- [Docker based environments](docker-based-environments)

Both environment types have advantages and disadvantages compared to each other.
Use the following list to choose the best environment type for your project.

- [When should you use Virtual Machines for your projects?](#when-should-you-use-virtual-macines-for-your-project)
- [When should you use Docker based environments?](#when-should-you-use-docker-based-environments)

Sometimes the choice between Virtual Machines and Docker images is not clear.
Commonly asked questions include:

- [Can I use Docker images in Virtual Machines?](#can-i-use-docker-images-in-virtual-machines)
- [Can I build Docker-in-Docker?](#can-i-build-docker-in-docker?)

## Virtual Machine based environments

Virtual machines are maintained by engineers at Semaphore. Every two weeks, a
new release of the platform is released bundled with the latest software
packages.

To use a virtual machine based environment for your jobs, use the following type
of agent definition in your pipeline yaml file.

**Linux based virtual machines**

``` yaml
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
```

**Mac based virtual machines**

``` yaml
agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave-xcode11
```

Read more about [Machine Types][machine-types] and the [Ubuntu
18.04][ubuntu1804], [Mac OS XCode 10][xcode10], [Mac OS XCode 11][xcode11]
virtual machines images.

## Docker based environments

The Docker based environment is a composable environment that allows the usage
of one or more Docker containers to construct your test environment on
Semaphore.

The recommended way of using Docker images is to build and maintain your
custom-built image with the precise set of software that is necessary for your
project.

Alternatively, if you are just starting out with Docker based environments, you
can use one of Semaphore's images to get started.

To use a container based environment, define at least one container in your
agent deinition in your pipeline yaml file.

``` yaml
agent:
  machine:
    type: e1-standard-2

  containers:
    - name: main
      image: semaphoreci/ruby:2.6.1

    - name: db
      image: postgres:9.6
      env_vars:
        - name: POSTGRES_PASSWORD
          value: keyboard-cat

    - name: cache
      image: redis:5.0
```

Read more about [docker based environments][docker-based].

## When should you use Virtual Machines for your projects?

- **You want to have an up to data testing environment with the latest software
  packages.** The Virtual Machines are regularly updated by engineers at
  Semaphore with the latest software package.

- **You are building Docker images or spinning up local Kubernetes testing
  clusters in the jobs.** When working with Docker or Kubernetes directly, you
  usually need full control over sockets, network-devices and subnets.

- **You are running or testing nested Virtual Machines**. In these situations
  you need full control over the operating system, virtual machines are not
  limiting access to anything.

## When should you use Docker based environments?

- **You want to have full control over the software installed in your test
  environment**. Rolling software updates offered in the VM type are great to
  keep your tests up to date, but they can also introduce unwanted issues into
  your test suite. If you build and maintain your own Docker images, you will
  have full control over the release cycle of your testing environment.

- **You want to have the same testing environment on Semaphore as on your local
  development**. A docker image is the perfect choice in this case. With docker
  images you can guarantee that you will have the same software installed.

- **You need custom software that is not available in the VM images**.
  Semaphore's Virtual Machines are packed with a wide-variety of languages and
  tools, but it is impossible to pack everything. In the virtual machines, you
  can use `apt-get` to install them, but a more efficient way is to build a
  docker image that pre-installs everything necessary for your tests.

## Can I use Docker images in Virtual Machines?

Yes. Running Docker images in Virtual Machines is one of the most common ways to
start background services necessary for your jobs.

Instead of defining them in the containers section in the agent, use the
prologue commands to spin up your docker images.

For example, to start RabbitMQ in a Virtual Machine, use the following snippet:

``` yaml
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - docker run -d --hostname my-rabbit --name rabbit -p 15672:15672 -p 5672:5672 rabbitmq:3-management
          - sleep 5 # give some time for Rabbit to start up

      jobs:
        - name: Rabbit Test
          commands:
            - make rabbit.based.tests
```

## Can I build Docker-in-Docker?

Building Docker images in a container based environment is possible (the Docker
socket is mounted and available), but it is not the recommended way on
Semaphore.

Docker-in-Docker has a wide set of gotchas and issues that your need to be aware
before going down this route.

Jérôme Petazzoni — the author of the feature that made it possible for Docker to
run inside a Docker container — wrote a [blog post saying not to do it][blog-docker-in-docker].
The use case he describes matches the OP's exact use case of a CI Docker
container that needs to run jobs inside other Docker containers.

A lot has changed since 2015 in the Docker world, however some gotchas are still
present.

We recommend using Virtual Machines for building Docker images.

[machine-types]: https://docs.semaphoreci.com/article/20-machine-types
[ubuntu1804]: https://docs.semaphoreci.com/article/32-ubuntu-1804-image
[xcode10]: https://docs.semaphoreci.com/article/162-macos-mojave-xcode-10-image
[xcode11]: https://docs.semaphoreci.com/article/162-macos-mojave-xcode-10-image
[docker-based]: https://docs.semaphoreci.com/article/127-custom-ci-cd-environment-with-docker
[blog-docker-in-docker]: https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
