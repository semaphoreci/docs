---
description: The ubuntu1804 is a customized image based on Ubuntu 18.04 LTS optimized for CI/CD. It comes with a set of preinstalled languages, databases, and utility tools.
---

# Ubuntu 18.04 Image


The `ubuntu1804` is a customized image based on [Ubuntu 18.04 LTS](https://wiki.ubuntu.com/BionicBeaver/ReleaseNotes)
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Linux machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `ubuntu1804` is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access. The image will be updated bi-weekly, on first and third Monday of every month.
Updates can be followed on [Semaphore Changelog](https://docs.semaphoreci.com/reference/semaphore-changelog/).

The `ubuntu1804` VM uses an *APT mirror* that is in the same data center as
Semaphore's build cluster, which means that caching packages will have little
effect.

## Using the ubuntu1804 OS image in your agent configuration

To use the `ubuntu1804` OS image, define it as the `os_image` of your agent's
machine.

``` yaml
version: 1.0
name: Ubuntu18 Based Pipeline

agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

The `ubuntu1804` OS image can be used in combination with all Linux machine
types: `e1-standard-2`, `e1-standard-4`, `e1-standard-8`.

## Toolbox

The `ubuntu1804` comes with two utility tools. One for managing background
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
- Google Chrome 87
- Chrome_driver 87
- Xvfb (X Virtual Framebuffer)
- Phantomjs 2.1.1

Chrome and Firefox both support headless mode. You shouldn't need to do more
than install and use the relevant Selenium library for your language.
Refer to the documentation of associated libraries when configuring your project.

### Docker

Docker toolset is installed and following versions are available:

- Docker 20.10
- docker-compose 1.27.4

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

- Erlang: 20.3, 21.3, 22.3, 23.2
- Elixir: 1.8.0, 1.8.1, 1.8.2, 1.9.0, 1.9.1, 1.9.2, 1.9.3, 1.9.4, 1.10.0, 1.10.1, 1.10.2, 1.10.3, 1.10.4, 1.11.1, 1.11.2

Additional libraries:

- rebar: 2.6.4
- rebar3: 3.12.1

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

- Java: 8u275, 11.0.9
- Scala: 2.11.11, 2.12.10
- Leiningen: 2.9.1 (Clojure)
- sbt

#### Additional build tools

- Maven: 3.6.3
- Gradle: 5.2

### JavaScript via Node.js

Node.js versions are managed by [nvm](https://github.com/creationix/nvm).
You can install any version you need with `nvm install [version]`.
Installed version:

- v8.17.0 (set as default, with alias 8.17)
- v10.19.0
- v12.16.0

#### Additional tools

- Yarn: 1.22.5
- Bower: 1.8.8

### PHP

PHP versions are managed by [phpbrew](https://github.com/phpbrew/phpbrew).
Installed versions:

- 7.0.33
- 7.1.33
- 7.2.33
- 7.3.24
- 7.3.25
- 7.4.12
- 7.4.13
- 8.0.0

The default installed PHP version is `7.2.33`.

#### Additional libraries

phpunit: 7.5.20

### Python

Python versions are installed and managed by
[virtualenv](https://virtualenv.pypa.io/en/stable/). Installed versions:

- 2.7
- 3.6
- 3.7
- 3.8

Supporting libraries:

- pypy: 7.3.1
- pypy3: 7.3.1
- pip: 20.0.2
- pip3: 19
- venv: 16.0.0

### Ruby

Available versions:

- 1.8.7-p375
- 1.9.2-p330
- 1.9.3-p551
- 2.0.0-p648
- 2.1.0 to 2.1.10
- 2.2.0 to 2.2.10
- 2.3.0 to 2.3.8
- 2.4.0 to 2.4.10
- 2.5.0 to 2.5.8
- 2.6.0 to 2.6.6
- 2.7.0 to 2.7.2
- 3.0.0
- jruby-9.2.11.1

### Installing dependencies with apt package manager

The Semaphore Ubuntu:18.04 image has most of the popular programming languages,
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
