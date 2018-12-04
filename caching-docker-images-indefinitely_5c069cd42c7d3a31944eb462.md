
* [Overview](#overview)
* [A sample Semaphore project](#a-sample-semaphore-project)
* [See also](#see-also)

## Overview

In this page you will learn how to cache one or more images in the Semaphore
Cache server *indefinitely*.

## A sample Semaphore project

The presented Semaphore project shows how to cache two Docker images in the
Semaphore Cache server. The first Docker image uses Go to compile a Go source
file and store the generated executable whereas the second Docker image
installs and executes MongoDB.

The `.semaphore/semaphore.yml` file is as follows:

	version: v1.0
	name: Docker bootstrap
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Make sure that Docker images exist
	    task:
	      jobs:
	      - name: MongoDB + Go Docker images
	        commands:
	          - checkout
	          - cache restore $(checksum go.Dockerfile)-$(checksum mongoDB.Dockerfile)
	          - "[ -d 's2_docker' ] && echo 'Found' || source ./createDockers.sh"
     
	  - name: Use Docker images
	    task:
	      jobs:
	      - name: Restore from cache and connect
	        commands:
	          - checkout
	          - cache restore $(checksum go.Dockerfile)-$(checksum mongoDB.Dockerfile)
	          - ls -l s2_docker
	          - docker load -i s2_docker/go.tar
	          - docker load -i s2_docker/mongodb.tar
	          - docker images
	          - docker run s2_go:v1
	          - docker run -d --name my_mongodb s2_mongodb:v1
	          - ls -al
	          - docker exec -i -t my_mongodb sh -c "echo $PATH"
	          - docker exec -i -t my_mongodb sh -c "which mongo"
	          - docker exec -i -t my_mongodb sh -c "mongo --version"
	          - docker exec -i -t my_mongodb sh -c "mongo /tmp/script.js"

The logic of the recipe can be found in the first job of the project. If the
key is not present in the Cache server, both images will be created from
scratch. The used key is a combination of the `checksum` output for the two
Docker files used. If you make any changes to any one of these, then a new
key will be created and the contents of the `s2_docker` directory will be
stored in the Semaphore Cache server.

The second job of the Semaphore 2.0 **assumes** that the first job made sure
that the desired Docker images are in cache and just uses the two Docker
images.

To make the Pipeline file simpler, an external shell script is used for
creating and storing the two Docker images to the Semaphore Cache server.

The name of the bash script is `createDockers.sh` and has the following
contents:

	cp go.Dockerfile Dockerfile
	docker build -t s2_go:v1 .
	mkdir s2_docker
	docker save s2_go:v1 -o s2_docker/go.tar
	cp mongoDB.Dockerfile Dockerfile
	docker build -t s2_mongodb:v1 .
	docker save s2_mongodb:v1 -o s2_docker/mongodb.tar
	ls -l s2_docker
	cache store $(checksum go.Dockerfile)-$(checksum mongoDB.Dockerfile) s2_docker

The contents of `go.Dockerfile` are as follows:

	FROM golang:alpine
    
	RUN mkdir /files
	COPY hw.go /files
	WORKDIR /files
    
	RUN go build -o /files/hw hw.go
	ENTRYPOINT ["/files/hw"]

The `hw.go` file used in `go.Dockerfile` is the following:

	package main
    
	import (
		"fmt"
	)
    
	func main() {
		fmt.Println("Hello World!")
	}

The contents of `mongoDB.Dockerfile` are as follows:

	FROM ubuntu:16.04
	RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
	RUN echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu/ xenial/mongodb-org/3.4 multiverse" |  tee /etc/apt/sources.list.d/mongodb-3.4.list
    
	RUN apt-get update && apt-get install -y mongodb-org
	RUN mkdir -p /data/db
	RUN chown -R mongodb:mongodb /data/db
	ADD mongodb.conf /etc/mongodb.conf
	ADD mongo-script.js /tmp/script.js
	# ADD mongodb.pem /etc/ssl/certs/mongodb.pem
    
	VOLUME ["/data/db"]
	EXPOSE 27017
	ENTRYPOINT ["/usr/bin/mongod", "--config", "/etc/mongodb.conf"]

The contents of `mongo-script.js`, which is transferred in the MongoDB Docker
image are as follows:

	db.createCollection('NewCollection')
	db.createCollection('AnotherNewCollection')
	print(db.getCollectionNames())

The `mongodb.conf` file, which contains the configuration of MongoDB and is
also being copied to the MongoDB Docker image has the following contents:

	# mongodb.conf
    
	# Where to store the data.
	dbpath=/var/lib/mongodb
    
	#where to log
	logpath=/var/log/mongodb/mongodb.log
    
	logappend=true
    
	bind_ip = 127.0.0.1
	port = 27017
    
	# Enable journaling, http://www.mongodb.org/display/DOCS/Journaling
	journal=true
    
	# Inspect all client data for validity on receipt (useful for
	# developing drivers)
	#objcheck = true
    
	smallfiles=true

## See also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
