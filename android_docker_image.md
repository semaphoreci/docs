The semaphore `android` docker image is a customized image based on `ubuntu:16.04`
optimized for CI/CD. It comes with a set of preinstalled utility tools commonly
used for CI/CD workflows.

[[__TOC__]]

## Using the semaphoreci/android docker image in your semaphore.yml configuration

To use the images in this repository for your CI/CD pipelines, set up your Semaphore YAML with:

``` yaml
version: v1.0
name: Hello andorid
agent:
  machine:
    type: e1-standard-2
  containers:
    - name: main
      image: semaphoreci/android:28
blocks:
  - name: "Hello"
    task:
      jobs:
      - name: Hello
        commands:
          - checkout
          - echo "Hello"
```

## Dockerhub repository
The full list of android docker containers can be found under [SemaphoreCI docker registry](https://hub.docker.com/repository/docker/semaphoreci/android).

## Dockerfiles
Dockerfiles used to build an android image can be found under [Docker images repository](https://github.com/semaphoreci/docker-images/tree/master/dockerfiles/android).

## Image Variants

The android image.

 - andorid:version is the basic image that comes with development utilities and is an optimal first choice for andorid.
 - andorid:version-node is the extension of the basic image and it comes with Node.js (10.x) pre-installed.

Detailed examples and documentation about setting up a CI/CD environment with Docker is covered in [Custom CI/CD environment with Docker](https://docs.semaphoreci.com/article/127-custom-ci-cd-environment-with-docker) documentation page.

## Supported Android SDK version

- platforms;android-29
- platforms;android-28
- platforms;android-27
- platforms;android-26
- platforms;android-25
- build-tools;29.0.2
- build-tools;29.0.1
- build-tools;29.0.0
- build-tools;28.0.3
- build-tools;28.0.2
- build-tools;28.0.1
- build-tools;28.0.0
- build-tools;27.0.3
- build-tools;27.0.2
- build-tools;27.0.1
- build-tools;27.0.0
- build-tools;26.0.2
- build-tools;26.0.1
- build-tools;25.0.3

### Installed software
- git
- mercurial
- xvfb
- vim
- apt
- locales
- sudo
- apt-transport-https
- ca-certificates
- openssh-client
- software-properties-common
- build-essential
- tar
- lsb-release
- gzip
- parallel
- net-tools
- netcat
- unzip
- zip
- bzip2
- lftp
- gnupg
- curl
- wget
- jq
- tree
- docker
- docker-compose
- maven
- gradle
- ruby 2.6.1
- Google Cloud SDK
- ARM simmulator (libqt5widgets5)


## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
- [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
