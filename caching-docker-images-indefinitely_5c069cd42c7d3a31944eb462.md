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



The logic of the recipe can be found in the first job of the project. If the
key is not present in the Cache server, both images will be created from
scratch. The used key is a combination of the `$SEMAPHORE_PROJECT_NAME` and 
`$SEMAPHORE_GIT_SHA` environment variables. The former one remains the same for
a given Semaphore project whereas the latter changes each time you make a new
commit to the GitHub repository.

The second job of the Semaphore 2.0 **assumes** that the first job made sure
that the desired Docker images are in cache and just uses the two Docker
images.

To make the Pipeline file simpler, an external shell script is used for
creating and storing the two Docker images to the Semaphore Cache server.

The name of the bash script is `createDockers.sh` and has the following
contents:



The contents of `go.Dockerfile` are as follows:


The contents of `mongoDB.Dockerfile` are as follows:


The contents of `mongo-script.js`, which is transferred in the MongoDB Docker
image are as follows:

The `mongodb.conf` file, which contains the configuration of MongoDB and is
also being copied to the MongoDB Docker image has the following contents:




## See also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
