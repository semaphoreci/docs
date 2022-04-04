---
Description: The ubuntu2004 image is a customized image based on Ubuntu 20.04 LTS, which has been optimized for CI/CD. It comes with a set of preinstalled languages, databases, and utility tools.
---

# Ubuntu 20.04 Image


The `ubuntu2004` image is a customized image based on [Ubuntu 20.04 LTS](https://wiki.ubuntu.com/FocalFossa/ReleaseNotes), which has been
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Linux machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `ubuntu2004` image is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access. The image will be updated bi-weekly, on the first and third Mondays of every month.
Updates can be followed on the [Semaphore Changelog](https://docs.semaphoreci.com/reference/semaphore-changelog/).

The `ubuntu2004` VM uses an *APT mirror* located in the same data center as
Semaphore's build cluster, which means that caching packages will have little
effect.

## Using the ubuntu2004 image in your agent configuration

To use the `ubuntu2004` image, define it as the `os_image` of your agent's
machine, as shown below:

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


## Toolbox

The `ubuntu2004` image comes with two utility tools. One for managing background
services and databases, and one for managing language versions.

- [sem-version: Managing language version on Linux][sem-version]
- [sem-service: Managing databases and services on Linux][sem-service]

## Version control

Following version control tools are pre-installed:

- Git (2.x)
- Git LFS (Git Large File Storage)
- GitHub CLI (2.x)
- Mercurial (4.5.x)
- Svn (1.9.x)

### Browsers and Headless Browser Testing

- Firefox 78.1
- geckodriver 0.26.0
- Google Chrome 100
- ChromeDriver 100
- Xvfb (X Virtual Framebuffer)
- Phantomjs 2.1.1

Chrome and Firefox both support headless mode. You shouldn't need to do more
than install and use the relevant Selenium library for your language.
Refer to the documentation of associated libraries when configuring your project.

### Docker

Docker toolset is installed and the following versions are available:

- Docker 20.10
- docker-compose 1.29.2
- Buildah
- Podman
- Skopeo

### Cloud CLIs

- aws-cli v1 (used as `aws`)
- aws-cli v2 (used as `aws2`)
- azure-cli
- eb-cli
- ecs-cli
- doctl
- gcloud
- kubectl
- terraform
- heroku
- helm

### Network utilities

- httpie
- curl
- rsync

## Languages

### Erlang and Elixir

Erlang versions are installed and managed via [kerl](https://github.com/kerl/kerl).
Elixir versions are installed with [kiex](https://github.com/taylor/kiex).

- Erlang: 22.3, 23.3, 24.1, 24.2, 24.3 (default)
- Elixir: 1.9.x, 1.10.x, 1.11.x, 1.12.x, 1.13.x (1.13.3 as default)

Additional libraries:

- rebar3: 3.17.0

### Go

Versions:

- 1.10.x
- 1.11.x
- 1.12.x
- 1.13.x
- 1.14.x
- 1.15.x
- 1.16.x
- 1.17.x
- 1.18.x

### Java and JVM languages

- Java: 11, 17
- Scala: 2.12.10
- Leiningen: 2.9.1 (Clojure)
- sbt

#### Additional build tools

- Maven: 3.6.3
- Gradle: 7.3
- Bazel: 5

### JavaScript via Node.js

Node.js versions are managed by [nvm](https://github.com/creationix/nvm).
You can install any version you need with `nvm install [version]`.
Installed version:

- v16.14.2 (set as default, with alias 16.14), includes npm 8.5.0

#### Additional tools

- Yarn: 1.22.18

### PHP

PHP versions are managed by [phpbrew](https://github.com/phpbrew/phpbrew).
Installed versions:

- 7.4.x
- 8.0.x

The default installed PHP version is `7.4.28`.

#### Additional libraries

phpunit: 7.5.20

### Python

Python versions are installed and managed by
[virtualenv](https://virtualenv.pypa.io/en/stable/). Installed versions:

- 3.8
- 3.9

Supporting libraries:

- pypy: 7.3.8
- pypy3: 7.3.8
- pip: 22.0.4
- venv: 20.13.0

### Ruby

Available versions:

- 2.6.0 to 2.6.9
- 2.7.0 to 2.7.5
- 3.0.0 to 3.0.3
- 3.1.0 to 3.1.1
- jruby-9.2.11.1

### Installing dependencies with apt package manager

The Semaphore Ubuntu:20.04 image has most of the popular programming languages,
tools and databases preinstalled.

If the dependency you need is not present in the list above, you can install it
with the Ubuntu package manager, or using an alternative method such as 
compiling it from the source or manually downloading binaries.

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
[sem-version]: https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/
[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
