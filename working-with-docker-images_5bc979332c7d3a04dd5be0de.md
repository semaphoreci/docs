* [Overview](#overview)
* [Using an existing Docker image from a repository](#using-an-existing-docker-image-from-a-repository)
* [Building a Docker image from a Dockerfile](#building-a-docker-image-from-a-dockerfile)
* [Pushing a Docker image to a registry](#pushing-a-docker-image-to-a-registry)
* [Using Docker compose](#using-docker-compose)
* [Installing a newer Docker version](#installing-a-newer-docker-version)
* [Examples](#examples)
* [See also](#see-also)

## Overview

The key idea behind using Docker in Semaphore 2.0 is to have the Docker username
and password stored inside Semaphore 2.0. The best way to do that is to use a
`secret`.

Additionally, the `docker` utility is installed on all Semaphore 2.0 Virtual
Machines, which means that you can use `docker` right away.


## Storing Docker credentials to a secret

TODO

## Using an existing Docker image from a repository

In order to use an existing Docker image from a public Docker Hub repository,
you just have to execute `docker run` as follows:

    docker run -d -p 1234:80 nginx:alpine
    wget http://localhost:1234

So, your Semaphore pipeline file will look as follows:

TODO

In order to use a Docker image from a private Docker Hub repository, you will
need to login to that repository first using the Docker credentials you stored
in your `secret`. The necessary commands are the following:

    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
    docker pull REPOSITORY_NAME/IMAGE_NAME

The previous command implies that you want to download a Docker image that is
called `IMAGE_NAME` from a private repository named `REPOSITORY_NAME`. After
that you can use your Docker image as before.

The Semaphore pipeline file for that case will look as follows:

TODO

## Building a Docker image from a Dockerfile

The task of this section is to build a Docker image from a Dockerfile in
Semaphore 2.0.

The contents of the Dockerfile will be as follows:

    FROM golang:alpine
    RUN mkdir /files
    COPY hw.go /files
    WORKDIR /files
    RUN go build -o /files/hw hw.go
    ENTRYPOINT ["/files/hw"]

You should already have a file named `hw.go` in your GitHub repository.

After that, the contents of your Semaphore 2.0 pipeline file should look as
follows:

TODO

## Pushing a Docker image to a registry

The task of this section is to push a Docker image that you have built into
Docker Hub. For this purpose you will need to login to your Docker Hub first.

The contents of the Semaphore 2.0 pipeline file will be as follows:

TODO


## Using a specific version of docker-compose

In this section you will learn how to use a specific version of `docker-compose` in
the Virtual Machine of Semaphore 2.0.

`docker-compose` is installed by default. Therefore, the first thing that you
will need to do is to delete the existing version of `docker-compose`.

The contents of the Semaphore 2.0 pipeline file will be as follows:

TODO

    export DOCKER_COMPOSE_VERSION=1.4.2
    curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
    chmod +x docker-compose
    ./docker-compose -v
    sudo mv docker-compose /usr/bin


## Installing a newer Docker version

The task of this section is to learn how to update Docker into a newer version.

The Virtual Machine that will be used in this section uses Linux Ubuntu. For
other OS versions you will need to modify the presented commands.

The contents of the Semaphore 2.0 pipeline file will be as follows:

TODO

    sudo apt-get update
    sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce


## See also

