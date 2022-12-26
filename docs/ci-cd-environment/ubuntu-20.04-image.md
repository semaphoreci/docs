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

- Git 2.39.0
- Git LFS (Git Large File Storage) 3.3.0
- GitHub CLI 2.20.2
- Mercurial 5.3.1
- Svn 1.13.0

### Browsers and Headless Browser Testing

- Firefox 68.9 (`68`, `esr-old`), 78.1 (`78`, `default`, `esr`), 102.3.0 (`102`, `esr-new`, `esr-latest`)
- geckodriver 0.26.0
- Google Chrome 108
- ChromeDriver 108
- Xvfb (X Virtual Framebuffer)
- Phantomjs 2.1.1

Chrome and Firefox both support headless mode. You shouldn't need to do more
than install and use the relevant Selenium library for your language.
Refer to the documentation of associated libraries when configuring your project.

### Docker

Docker toolset is installed and the following versions are available:

- Docker 20.10.22
- Docker-compose 1.29.2 (used as `docker-compose --version`)
- Docker-compose 2.14.2 (used as `docker compose version`)
- Docker-machine 0.16.2
- Dockerize 0.6.1
- Buildah 1.22.3
- Podman 3.4.2
- Skopeo 1.5.0

### Cloud CLIs

- aws-cli v1 (used as `aws`) 1.27.35
- aws-cli v2 (used as `aws2`) 2.9.9
- azure-cli 2.43.0
- eb-cli 3.20.3
- ecs-cli 1.21.0
- doctl 1.91.0
- gcloud 412.0.0
- gke-gcloud-auth-plugin 412.0.0
- kubectl 1.26.0
- heroku 7.67.1
- terraform 1.3.6
- helm 3.10.3

### Network utilities

- httpie 1.0.3
- curl 7.68.0
- rsync 3.1.3

## Languages

### Erlang and Elixir

Erlang versions are installed and managed via [kerl](https://github.com/kerl/kerl).
Elixir versions are installed with [kiex](https://github.com/taylor/kiex).

- Erlang: 22.3, 23.3, 24.1, 24.2, 24.3 (default), 25.0, 25.1
- Elixir: 1.9.x, 1.10.x, 1.11.x, 1.12.x, 1.13.x (1.13.4 as default), 1.14.0, 1.14.1, 1.14.2

Additional libraries:

- rebar: 2.6.4
- rebar3: 3.18.0

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
- 1.19.x (1.19.4 as default)

### Java and JVM languages

- Java: 11.0.17 (default), 17.0.5
- Scala: 2.12.15, 3.1.3
- Leiningen: 2.10.0 (Clojure)
- sbt 1.8.0

#### Additional build tools

- Maven: 3.6.3
- Gradle: 7.4.2
- Bazel: 6.0.0

### JavaScript via Node.js

Node.js versions are managed by [nvm](https://github.com/creationix/nvm).
You can install any version you need with `nvm install [version]`.
Installed version:

- v18.12.1 (set as default, with alias 18.12), includes npm 8.19.2

#### Additional tools

- Yarn: 1.22.19

### PHP

PHP versions are managed by [phpbrew](https://github.com/phpbrew/phpbrew).
Installed versions:

- 7.4.x
- 8.0.x
- 8.1.x
- 8.2.x

The default installed PHP version is `7.4.33`.

#### Additional libraries

phpunit: 7.5.20

### Python

Python versions are installed and managed by
[virtualenv](https://virtualenv.pypa.io/en/stable/). Installed versions:

- 3.8.10
- 3.9.16
- 3.10.9

Supporting libraries:

- pypy: 7.3.9
- pypy3: 7.3.10
- pip: 22.3.1
- venv: 20.14.1

### Ruby

Available versions:

- 2.6.0 to 2.6.10
- 2.7.0 to 2.7.7
- 3.0.0 to 3.0.5
- 3.1.0 to 3.1.3
- jruby-9.2.11.1

### Installing dependencies with apt package manager

The Semaphore Ubuntu:20.04 image has most of the popular programming languages,
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
