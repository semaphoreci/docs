---
Description: The ubuntu1804 image is a customized image based on Ubuntu 18.04 LTS that has been optimized for CI/CD. It comes with a set of preinstalled languages, databases, and utility tools.
---

# Ubuntu 18.04 Image


The `ubuntu1804` image is a customized image based on [Ubuntu 18.04 LTS](https://wiki.ubuntu.com/BionicBeaver/ReleaseNotes) that has been
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [E1 Generation Linux machine type][e1-machine-types] when defining the [agent][agent]
of your pipeline or block.

The `ubuntu1804` image is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access. 

The image will be updated bi-weekly, on the first and third Monday of every month.
Updates can be followed on the [Semaphore Changelog](https://docs.semaphoreci.com/reference/semaphore-changelog/).

The `ubuntu1804` image VM uses an *APT mirror* that is in the same data center as
Semaphore's build cluster, which means that caching packages will have little
effect.

## Using the ubuntu1804 image in your agent configuration

To use the `ubuntu1804` image, define it as the `os_image` of your agent's
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

The `ubuntu1804` image can be used in combination with the following Linux machine
types: `e1-standard-2`, `e1-standard-4`, and `e1-standard-8`.

## Toolbox

The `ubuntu1804` image comes with two utility tools. One for managing background
services and databases, and one for managing language versions.

- [sem-version: Managing language version on Linux][sem-version]
- [sem-service: Managing databases and services on Linux][sem-service]

## Version control

Following version control tools are pre-installed:

- Git 2.40.0
- Git LFS (Git Large File Storage) 3.3.0
- GitHub CLI 2.26.1
- Mercurial 4.5.3
- Svn 1.9.7

### Browsers and Headless Browser Testing

- Firefox 68.9 (`68`, `esr-old`), 78.1 (`78`, `default`, `esr`), 102.3.0 (`102`, `esr-new`, `esr-latest`)
- Geckodriver 0.26.0
- Google Chrome 112
- ChromeDriver 112
- Xvfb (X Virtual Framebuffer)
- Phantomjs 2.1.1

Chrome and Firefox both support headless mode. You shouldn't need to do more
than install and use the relevant Selenium library for your language.
Refer to the documentation of associated libraries when configuring your project.

### Docker

Docker toolset is installed and the following versions are available:

- Docker 23.0.3
- Docker-compose 1.29.2 (used as `docker-compose --version`)
- Docker-compose 2.17.2 (used as `docker compose version`)
- Docker-machine 0.16.2
- Dockerize 0.6.1

### Cloud CLIs

- Aws-cli v1 (used as `aws`) 1.27.108
- Aws-cli v2 (used as `aws2`) 2.11.10
- Azure-cli 2.47.0
- Eb-cli 3.19.1
- Ecs-cli 1.21.0
- Doctl 1.93.1
- Gcloud 425.0.0
- Gke-gcloud-auth-plugin 425.0.0
- Kubectl 1.26.3
- Heroku 7.69.1
- Terraform 1.4.4
- Helm 3.11.2

### Network utilities

- Httpie 1.0.3
- Curl 7.58.0
- Rsync 3.1.2

## Languages

### Erlang and Elixir

Erlang versions are installed and managed via [kerl](https://github.com/kerl/kerl).
Elixir versions are installed with [kiex](https://github.com/taylor/kiex).

- Erlang: 21.3, 22.3, 23.1, 23.2, 23.3, 24.0, 24.1, 24.2, 24.3 (default), 25.0, 25.1, 25.2, 25.3
- Elixir: 1.8.x, 1.9.x, 1.10.x, 1.11.x, 1.12.x, 1.13.x (1.13.4 as default), 1.14.x

Additional libraries:

- Rebar: 2.6.4
- Rebar3: 3.18.0

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
- 1.20.x (1.20 as default)

### Java and JVM languages

- Java: 8u362, 11.0.18 (default), 17.0.6
- Scala: 2.12.15, 3.1.3
- Leiningen: 2.10.0 (Clojure)
- Sbt 1.8.2

#### Additional build tools

- Maven: 3.6.3
- Gradle: 7.4.2
- Bazel: 6.1.1

### JavaScript via Node.js

Node.js versions are managed by [nvm](https://github.com/nvm-sh/nvm).
You can install any version you need with `nvm install [version]`.
Installed version:

- v16.17.1 (set as default, with alias 16.17), includes npm 8.15.0

#### Additional tools

- Yarn: 1.22.19

### PHP

PHP versions are managed by [phpbrew](https://github.com/phpbrew/phpbrew).
Installed versions:

- 7.0.x
- 7.1.x
- 7.2.x
- 7.3.x
- 7.4.x
- 8.0.x
- 8.1.x
- 8.2.x

The default installed PHP version is `7.4.33`.

#### Additional libraries

PHPUnit: 7.5.20

### Python

Python versions are installed and managed by
[virtualenv](https://virtualenv.pypa.io/en/stable/). Installed versions:

- 2.7.18
- 3.6.9
- 3.7.16
- 3.8.16
- 3.9.16

Supporting libraries:

- Pypy: 7.3.9
- Pypy3: 7.3.11
- Pip (for Python 2.7): 20.3.4
- Pip (for Python 3.6): 21.3.1
- Pip (for Python 3.7 and above): 23.0.1
- Venv: 20.15.1

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
- 2.5.0 to 2.5.9
- 2.6.0 to 2.6.10
- 2.7.0 to 2.7.8
- 3.0.0 to 3.0.6
- 3.1.0 to 3.1.4
- 3.2.0 to 3.2.2
- jruby-9.2.11.1
- jruby-9.3.9.0
- jruby-9.4.0.0

### Installing dependencies with apt package manager

The Semaphore Ubuntu:18.04 image has most of the popular programming languages,
tools, and databases preinstalled.

If the dependency you need is not present on the list above, you can install it
with the Ubuntu package manager
or using an alternative method such as compiling it from the source, or
manually downloading binaries.

To install dependecies using the package manager (`apt-get`) you can use the
template command below and add it to your pipeline:

```bash
sudo apt-get update
sudo apt-get install -y [your-dependency]
```

#### Disabled repositories

Due to occasional issues with some of the repositories that break the pipeline during `apt-get update` command, the following sources lists have been moved to `/etc/apt/sources.list.d/disabled`:

- `ansible.list`
- `git.list`
- `gradle.list`
- `pypy.list`
- `python.list`

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

[e1-machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/#e1-generation
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[sem-version]: https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/
[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
