---
Description: The ubuntu2404 image is a customized image based on Ubuntu 24.04 LTS, which has been optimized for CI/CD. It comes with a set of preinstalled languages, databases, and utility tools.
---

# Ubuntu 24.04 Image

!!! warning "The `ubuntu2404` image is in the Technical Preview stage. Documentation and the image itself are subject to change."

The `ubuntu2404` image is a customized image based on [Ubuntu 24.04 LTS](https://wiki.ubuntu.com/NobleNumbat/ReleaseNotes), which has been
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows.
of your pipeline or block.

The `ubuntu2404` image is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access. The image will be updated bi-weekly, on the first and third Mondays of every month.
Updates can be followed on the [Semaphore Changelog](https://docs.semaphoreci.com/reference/semaphore-changelog/).

The `ubuntu2404` VM uses an *APT mirror* located in the same data center as
Semaphore's build cluster, which means that caching packages will have little
effect.

## Using the ubuntu2404 image in your agent configuration

To use the `ubuntu2404` image, define it as the `os_image` of your agent's
machine, as shown below:

``` yaml
version: 1.0
name: Ubuntu2404 Based Pipeline

agent:
  machine:
    type: f1-standard-4
    os_image: ubuntu2404

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

## Toolbox

The `ubuntu2404` image comes with two utility tools. One for managing background
services and databases, and one for managing language versions.

- [sem-service: Managing databases and services on Linux][sem-service]
- [sem-version: Managing language version on Linux][sem-version]

## Version control

Following version control tools are pre-installed:

- Git 2.46.0
- Git LFS (Git Large File Storage) 3.5.1
- GitHub CLI 2.55.0
- Mercurial 6.1.1
- Svn 1.14.1

### Browsers and Headless Browser Testing

- Firefox 102.11.0 (`102`, `default`, `esr`)
- Geckodriver 0.33.0
- Google Chrome 128
- ChromeDriver 128
- Xvfb (X Virtual Framebuffer)
- Phantomjs 2.1.1

Chrome and Firefox both support headless mode. You shouldn't need to do more
than install and use the relevant Selenium library for your language.
Refer to the documentation of associated libraries when configuring your project.

### Docker

 Docker toolset is installed and the following versions are available:

- Docker 27.2.0
- Docker-compose 1.29.2 (used as `docker-compose --version`)
- Docker-compose 2.29.2 (used as `docker compose version`)
- Docker-buildx 0.16.2
- Docker-machine 0.16.2
- Dockerize 0.7.0
- Buildah 1.23.1
- Podman 3.4.4
- Skopeo 1.4.1

### Cloud CLIs

- Aws-cli 2.17.40 (used as `aws`)
- Azure-cli 2.64.0
- Ecs-cli 1.21.0
- Doctl 1.111.0
- Gcloud 492.0.0
- Gke-gcloud-auth-plugin 492.0.0
- Kubectl 1.29.1
- Heroku 9.2.1
- Terraform 1.9.5
- Helm 3.15.4

### Network utilities

- Httpie 3.2.2
- Curl 8.5.0
- Rsync 3.2.7

## Compilers

- gcc: 11, 12, 13 (default)

## Languages

### Erlang and Elixir

Erlang versions are installed and managed via [kerl](https://github.com/kerl/kerl).
Elixir versions are installed with [kiex](https://github.com/taylor/kiex).

- Erlang: 24.3, 25.0, 25.1, 25.2, 25.3, 26.0, 26.1, 26.2, 27.0 (default)
- Elixir: 1.12.x, 1.13.x, 1.14.x, 1.15.x, 1.16.x, 1.17.x (1.17.2 as default)

Additional libraries:

- Rebar3: 3.22.1

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
- 1.20.x
- 1.21.x
- 1.22.x
- 1.23.x (1.23.0 as default)

### Java and JVM languages

- Java: 11.0.24, 17.0.12 (default), 21.0.4
- Scala: 3.2.2
- Leiningen: 2.11.2 (Clojure)
- Sbt 1.10.1

#### Additional build tools

- Maven: 3.9.6
- Gradle: 8.10
- Bazel: 7.3.1

### JavaScript via Node.js

Node.js versions are managed by [nvm](https://github.com/nvm-sh/nvm).
You can install any version you need with `nvm install [version]`.
Installed version:

- v20.17.0 (set as default, with alias 20.17), includes npm 10.8.2

#### Additional tools

- Yarn: 1.22.22

### PHP

PHP versions are managed by [phpbrew](https://github.com/phpbrew/phpbrew).
Available versions:

- 8.1.x
- 8.2.x
- 8.3.x

The default installed PHP version is `8.1.29`.

#### Additional libraries

PHPUnit: 9.5.28

### Python

Python versions are installed and managed by
[virtualenv](https://virtualenv.pypa.io/en/stable/). Installed versions:

- 3.10.14
- 3.11.9
- 3.12.3

Supporting libraries:

- pypy3: 7.3.17
- pip: 24.2
- venv: 20.26.3

### Ruby

Available versions:

- 3.0.x
- 3.1.x
- 3.2.x
- 3.3.x
- jruby-9.4.1.0

The default installed Ruby version is `3.3.4`.

### Rust

- 1.81.0

### Installing dependencies with apt package manager

The Semaphore Ubuntu:24.04 image has most of the popular programming languages,
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

- `azure-cli.list`
- `bazel.list`
- `devel_kubic_libcontainers_stable.list`
- `docker.list`
- `github_git-lfs.list`
- `git.list`
- `google-chrome.list`
- `google-cloud-sdk.list`
- `helm.list`
- `ppa_ondrej_php_jammy.list`
- `pypy.list`
- `python.list`
- `sbt.list`
- `sbt_old.list`
- `yarn.list`

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
