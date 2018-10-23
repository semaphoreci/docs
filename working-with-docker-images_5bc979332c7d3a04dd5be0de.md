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

The `secret` that will be used in this documentation page is as follows:

	$ sem get secrets docker-hub
	apiVersion: v1beta
	kind: Secret
	metadata:
	  name: docker-hub
	  id: a2aaefdb-a4ff-4bc2-afd9-2afa9c7f3e51
	  create_time: "1538456457"
	  update_time: "1538456537"
	data:
	  env_vars:
	  - name: DOCKER_USERNAME
	    value: docker-username
	  - name: DOCKER_PASSWORD
	    value: docker-password
	  files: []

Please note that the names of the two environment variables used can be
anything you want. It is just more convenient to use descriptive names.

## Using an existing Docker image from a repository

In order to use an existing Docker image from a public Docker Hub repository,
you just have to execute `docker run` as follows:

    docker run -d -p 1234:80 nginx:alpine
    wget http://localhost:1234

The `docker run -d -p 1234:80 nginx:alpine` command will also download the
`nginx:alpine` image as it will not be on the Semaphore Virtual Machine (VM).

The `wget http://localhost:1234` command just verifies that the Docker image
with the Nginx web server is working and listening to TCP port number 1234 on
the VM.

So, your Semaphore pipeline file will look as follows:

	version: v1.0
	name: Using a public Docker image
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Pull Nginx image
	    task:
	      jobs:
	      - name: Docker Hub
	        commands:
	          - checkout
	          - docker run -d -p 1234:80 nginx:alpine
	          - wget http://localhost:1234
	          - docker images

In order to use a Docker image from a **private** Docker Hub repository, you will
need to login to that repository first using the Docker credentials you stored
in your `secret`. The necessary commands are the following:

    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
    docker pull REPOSITORY_NAME/IMAGE_NAME

The previous command implies that you want to download a Docker image that is
called `IMAGE_NAME` from a private repository named `REPOSITORY_NAME`. After
that you can use your Docker image as before.

The Semaphore pipeline file for that case will look as follows:

    version: v1.0
    name: Using a private Docker image
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    
    blocks:
      - name: Using private Docker image
        task:
          jobs:
          - name: Docker Hub
            commands:
              - checkout
              - docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
              - docker pull "$DOCKER_USERNAME"/semaphore
              - docker images
			  - docker run "$DOCKER_USERNAME"/semaphore
    
          secrets:
          - name: docker-hub

In this case the Docker repository is named `semaphore`. In order to use that
repository, you will have to attach the username of the Docker user in front of
it.

## Building a Docker image from a Dockerfile

The task of this section is to build a Docker image from a `Dockerfile` in
Semaphore 2.0.

The contents of the `Dockerfile` will be as follows:

    FROM golang:alpine
    
    RUN mkdir /files
    COPY hw.go /files
    WORKDIR /files
    
    RUN go build -o /files/hw hw.go
    ENTRYPOINT ["/files/hw"]

You should already have a file named `hw.go` in your GitHub repository. The
`Dockerfile` creates a new directory in the Docker image and puts `hw.go` in
there. Then, it compiles that Go file and the executable is stored as
`files/hw`. The `ENTRYPOINT` Docker command will automatically execute
`files/hw` when the Docker image is run.

After that, the contents of your Semaphore 2.0 pipeline file should look as
follows:

    version: v1.0
    name: Building Docker images
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    
    blocks:
      - name: Build Go executable
        task:
          jobs:
          - name: Docker Hub
            commands:
              - checkout
              - docker build -t go_hw:v1 .
			  - docker run go_hw:v1

The name of the image will be `go_hw:v1` – you can choose any name you want.

The `docker run` command executes the image to make sure that it works.

## Pushing a Docker image to a registry

The task of this section is to push a Docker image that you have built into
Docker Hub. For this purpose you will need to login to your Docker Hub first.

The contents of the Semaphore 2.0 pipeline file will be as follows:

	version: v1.0
	name: Pushing a Docker image
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Push Docker image to Docker Hub
	    task:
	      jobs:
	      - name: Docker Hub
	        commands:
	          - checkout
	          - docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
	          - docker build -t go_hw:v1 .
	          - docker tag go_hw:v1 "$DOCKER_USERNAME"/go_hw:v1
	          - docker push "$DOCKER_USERNAME"/go_hw:v1
	          - docker pull "$DOCKER_USERNAME"/go_hw:v1
	          - docker images
    
	      secrets:
	      - name: docker-hub

The name of the image will be `"$DOCKER_USERNAME"/go_hw` and its tag will be
`v1`. Therefore, in order to `docker pull` that image, you will have to use its
full name that is `"$DOCKER_USERNAME"/go_hw:v1`.

The `docker images` command executed at the end verifies that the desired image
was downloaded.

## Using a specific version of docker-compose

In this section you will learn how to use a specific version of `docker-compose` in
the Virtual Machine of Semaphore 2.0.

As `docker-compose` is installed by default the first thing that you will need
to do is to delete the existing version of `docker-compose`.

The contents of the Semaphore 2.0 pipeline file will be as follows:

	version: v1.0
	name: Install docker-compose
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Install desired version of docker-compose
	    task:
	      env_vars:
	      - name: DOCKER_COMPOSE_VERSION
	        value: 1.4.2
	      jobs:
	      - name: Get docker-compose
	        commands:
	          - checkout
	          - docker-compose -v
	          - curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
	          - chmod +x docker-compose
	          - ./docker-compose -v
	          - sudo mv docker-compose /usr/bin
	          - docker-compose -v

The only thing that you should take care of is using a valid value for the
`DOCKER_COMPOSE_VERSION` environment variable.

## Installing a newer Docker version

The task of this section is to learn how to update Docker into a newer version.

The Virtual Machine that will be used in this section uses Linux Ubuntu. For
other OS versions you will need to modify the presented commands.

The contents of the Semaphore 2.0 pipeline file will be as follows:

TODO

    sudo apt-get update
    sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce


## See also

* [sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
