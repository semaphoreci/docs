---
Description: The ubuntu2204 image is a customized image based on Ubuntu 22.04 LTS, which has been optimized for CI/CD. It comes with a set of preinstalled languages, databases, and utility tools.
---

# Ubuntu 22.04 Image

!!! plans "Available on: <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

!!! warning "The `ubuntu2204` image is in the Technical Preview stage. Documentation and the image itself are subject to change."

The `ubuntu2204` image is a customized image based on [Ubuntu 22.04 LTS](https://wiki.ubuntu.com/JammyJellyfish/ReleaseNotes), which has been
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows.
Please note that the image is only available for our newer generation agent type: `e2-standard-2` when defining the [agent][agent]
of your pipeline or block.

The `ubuntu2204` image is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access. The image will be updated bi-weekly, on the first and third Mondays of every month.
Updates can be followed on the [Semaphore Changelog](https://docs.semaphoreci.com/reference/semaphore-changelog/).

The `ubuntu2204` VM uses an *APT mirror* located in the same data center as
Semaphore's build cluster, which means that caching packages will have little
effect.

## Using the ubuntu2204 image in your agent configuration

To use the `ubuntu2204` image, define it as the `os_image` of your agent's
machine, as shown below:

``` yaml
version: 1.0
name: Ubuntu2204 Based Pipeline

agent:
  machine:
    type: e2-standard-2
    os_image: ubuntu2204

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

## Toolbox

The `ubuntu2204` image comes with two utility tools. One for managing background
services and databases, and one for managing language versions.

- [sem-service: Managing databases and services on Linux][sem-service]
- [sem-version: Managing language version on Linux][sem-version]

## Version control

Following version control tools are pre-installed:

- Git 2.41.0
- Git LFS (Git Large File Storage) 3.3.0
- GitHub CLI 2.32.0
- Mercurial 6.1.1

### Browsers and Headless Browser Testing

- Firefox 102.11.0 (`102`, `default`, `esr`)
- Geckodriver 0.33.0
- Google Chrome 112
- ChromeDriver 112
- Xvfb (X Virtual Framebuffer)
- Phantomjs 2.1.1

Chrome and Firefox both support headless mode. You shouldn't need to do more
than install and use the relevant Selenium library for your language.
Refer to the documentation of associated libraries when configuring your project.

### Docker

Docker toolset is installed and the following versions are available:

- Docker 24.0.4
- Docker-compose 1.29.2 (used as `docker-compose --version`)
- Docker-compose 2.20.0 (used as `docker compose version`)
- Docker-machine 0.16.2
- Dockerize 0.7.0
- Buildah 1.23.1
- Podman 3.4.4
- Skopeo 1.4.1

### Cloud CLIs

- Aws-cli v1 (used as `aws`) 1.29.2
- Aws-cli v2 (used as `aws2`) 2.13.0
- Azure-cli 2.50.0
- Eb-cli 3.20.3
- Doctl 1.97.0
- Gcloud 425.0.0
- Gke-gcloud-auth-plugin 425.0.0
- Kubectl 1.27.3
- Heroku 8.1.9
- Terraform 1.5.2
- Helm 3.12.1

### Network utilities

- Httpie 3.2.2
- Curl 7.81.0
- Rsync 3.2.7

## Compilers

- gcc: 11 (default), 12

## Languages

### Erlang and Elixir

Erlang versions are installed and managed via [kerl](https://github.com/kerl/kerl).
Elixir versions are installed with [kiex](https://github.com/taylor/kiex).

- Erlang: 25.3
- Elixir: 1.14.5

Additional libraries:

- Rebar3: 3.22.0

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
- 1.19.x
- 1.20.x (1.20.6 as default)

### Java and JVM languages

- Java: 17.0.7 (OpenJDK)
- Scala: 3.2.2
- Leiningen: 2.10.0 (Clojure)
- Sbt 1.9.2

#### Additional build tools

- Maven: 3.9.3
- Gradle: 7.4.2
- Bazel: 6.2.1

### JavaScript via Node.js

Node.js versions are managed by [nvm](https://github.com/nvm-sh/nvm).
You can install any version you need with `nvm install [version]`.
Installed version:

- v18.16.1 includes npm 9.5.1

#### Additional tools

- Yarn: 1.22.19

### PHP

PHP versions are managed by [phpbrew](https://github.com/phpbrew/phpbrew).
Available versions:

- 8.1.20 and above
- 8.2.x

The default installed PHP version is `8.2.2`.

#### Additional libraries

PHPUnit: 9.5.28

### Python

Python versions are installed and managed by
[virtualenv](https://virtualenv.pypa.io/en/stable/). Installed versions:

- 3.10

Supporting libraries:

- pypy: 7.3.9
- pypy3: 7.3.12
- pip: 23.1.2
- venv: 20.23.1

### Ruby

Available versions:

- 3.0.0 to 3.0.6
- 3.1.0 to 3.1.4
- 3.2.0 to 3.2.2
- jruby-9.4.1.0

The default installed Ruby version is `3.2.2`.

### Rust

- 1.71.0

### Installing dependencies with apt package manager

The Semaphore Ubuntu:22.04 image has most of the popular programming languages,
tools and databases preinstalled.

If the dependency you need is not present in the list above, you can install it
with the Ubuntu package manager, or using an alternative method such as 
compiling it from the source or manually downloading binaries.

To install dependecies using the package manager (`apt-get`) you can use the
template command below and add it to your pipeline:

```bash
sudo apt-get update
sudo apt-get install -y [your-dependency]
```

#### Disabled repositories

Due to occasional issues with some of the repositories that break the pipeline during `apt-get update` command, the following sources lists have been moved to `/etc/apt/sources.list.d/disabled`:

- `git.list`
- `gradle.list`
- `pypy.list`
- `python.list`
- `devel_kubic_libcontainers_stable.list`

If you need any of these before running the `apt-get update` command, please move them to the `/etc/apt/sources.list.d` directory.

Example:

```bash
sudo mv /etc/apt/sources.list.d/disabled/git.list /etc/apt/sources.list.d/
sudo apt-get update
```

## See Also

- [sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[sem-version]: https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/
[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
