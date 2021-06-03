---
description: The ubuntu2004 is a customized image based on Ubuntu 20.04 LTS optimized for CI/CD. It comes with a set of preinstalled languages, databases, and utility tools.
---

# Ubuntu 20.04 Image


The `ubuntu2004` is a customized image based on [Ubuntu 20.04 LTS](https://wiki.ubuntu.com/FocalFossa/ReleaseNotes)
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Linux machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `ubuntu2004` is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access. The image will be updated bi-weekly, on first and third Monday of every month.
Updates can be followed on [Semaphore Changelog](https://docs.semaphoreci.com/reference/semaphore-changelog/).

The `ubuntu2004` VM uses an *APT mirror* that is in the same data center as
Semaphore's build cluster, which means that caching packages will have little
effect.

## Using the ubuntu2004 OS image in your agent configuration

To use the `ubuntu2004` OS image, define it as the `os_image` of your agent's
machine.

``` yaml
version: 1.0
name: Ubuntu18 Based Pipeline

agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

!!! warning "Available machine types"
    The `ubuntu2004` image will only work on `e1-standard-2` agents for now. 

    When switching the `os_image` to `ubuntu2004` make sure that the `e1-standard-2` machine type is selected.

## Toolbox

The `ubuntu2004` comes with two utility tools. One for managing background
services and database, and one for managing language versions.

- [sem-version: Managing language version on Linux][sem-version]
- [sem-service: Managing databases and services on Linux][sem-service]

## Version control

Following version control tools are pre-installed:

- Git (2.x)
- Git LFS (Git Large File Storage)
- Mercurial (4.5.x)
- Svn (1.9.x)

### Browsers and Headless Browser Testing

- Firefox 78.1
- geckodriver 0.26.0
- Google Chrome 88
- Chrome_driver 88
- Xvfb (X Virtual Framebuffer)
- Phantomjs 2.1.1

Chrome and Firefox both support headless mode. You shouldn't need to do more
than install and use the relevant Selenium library for your language.
Refer to the documentation of associated libraries when configuring your project.

### Docker

Docker toolset is installed and following versions are available:

- Docker 20.10
- docker-compose 1.28.2
- Buildah
- Podman
- Skopeo

### Cloud CLIs

- aws-cli
- azure-cli
- eb-cli
- ecs-cli
- doctl
- gcloud
- kubectl
- heroku

### Network utilities

- httpie
- curl
- rsync

## Languages

### Erlang and Elixir

Erlang versions are installed and managed via [kerl](https://github.com/kerl/kerl).
Elixir versions are installed with [kiex](https://github.com/taylor/kiex).

- Erlang: 23.2
- Elixir: 1.11.3

Additional libraries:

- rebar3: 3.14.3

### Go

Versions:

- 1.10.8
- 1.11.13
- 1.12.17
- 1.13.15
- 1.14.9
- 1.14.13
- 1.15.2
- 1.15.6

### Java and JVM languages

- Java: 11, 13
- Scala: 2.12.10
- Leiningen: 2.9.1 (Clojure)
- sbt

#### Additional build tools

- Maven: 3.6.3
- Gradle: 6.8

### JavaScript via Node.js

Node.js versions are managed by [nvm](https://github.com/creationix/nvm).
You can install any version you need with `nvm install [version]`.
Installed version:

- v10.15.3 (set as default)

#### Additional tools

- Yarn: 1.22.5

### PHP

PHP versions are managed by [phpbrew](https://github.com/phpbrew/phpbrew).
Installed versions:

- 7.4.x
- 8.0.x

The default installed PHP version is `7.4.12`.

#### Additional libraries

phpunit: 7.5.20

### Python

Python versions are installed and managed by
[virtualenv](https://virtualenv.pypa.io/en/stable/). Installed versions:

- 3.8
- 3.9

Supporting libraries:

- pypy: 7.3.3
- pypy3: 7.3.3
- pip: 21.0
- venv: 16.0.0

### Ruby

Available versions:

- 2.6.0 to 2.6.6
- 2.7.0 to 2.7.2
- 3.0.0
- jruby-9.2.11.1

### Installing dependencies with apt package manager

The Semaphore Ubuntu:20.04 image has most of the popular programming languages,
tools and databases preinstalled.

If the dependency you need is not present in the list above, you can install it
with the Ubuntu package manager
or using an alternative method such as compiling it from the source, or 
manually downloading binaries.

To install dependecies using the package manager (apt-get) you can use the
template command below and add it to your pipeline:

```bash
sudo apt-get update
sudo apt-get install -y [your-dependency]
```

## See Also

- [sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[sem-version]: hhttps://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/
[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
