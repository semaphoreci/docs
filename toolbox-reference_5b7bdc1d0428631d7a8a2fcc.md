
- [Overview](#overview)
- [Essentials](#essentials)
  * [libcheckout](#libcheckout)
  * [sem-service](#sem-service)
  * [retry](#retry)
  * [cache](#cache)
    - [Example Semaphore 2.0 project](#example-semaphore-project)
  * [sem-version](#sem-version)
    - [Example Semaphore 2.0 project](#example-sem-version-project)
- [See also](#see-also)

## Overview

This document explains the use of the command line tools found in the
open source [semaphoreci/toolbox][toolbox-repo] repository and are
preinstalled in all Semaphore 2.0 Virtual Machines (VM).

## Essentials

This section contains the most frequently used tools of the Semaphore 2.0
toolbox.

### libcheckout

#### Description

The GitHub repository used in a Semaphore 2.0 project is not automatically
cloned for reasons of efficiency.

The `libcheckout` script includes the implementation of a single function
named `checkout()` that is used for making available the entire GitHub
repository of the running Semaphore 2.0 project to the VM used for executing a
job of the pipeline. The `checkout()` function is called as `checkout` from the
command line.

#### Command Line Parameters

The `libcheckout` script and the `checkout` command require no command line
arguments.

#### Dependencies

The `checkout()` function of the `libcheckout` script depends on the following
three Semaphore environment variables:

   - `SEMAPHORE_GIT_URL`: This environment variable holds the URL of the GitHub
     repository that is used in the Semaphore 2.0 project (`git@github.com:mactsouk/S1.git`).
   - `SEMAPHORE_GIT_DIR`: This environment variable holds the UNIX path where the GitHub
     repository will be placed on the VM (`/home/semaphore/S1`).
   - `SEMAPHORE_GIT_SHA`: This environment variable holds the SHA key for the
     HEAD reference that is used when executing `git reset -q --hard`.

All these environment variables are automatically defined by Semaphore 2.0.

#### Examples

    checkout

Notice that the `checkout` command automatically changes the current working
directory in the Operating System of the VM to the directory defined in the
`SEMAPHORE_GIT_DIR` environment variable.

### sem-service

#### Description

The `sem-service` script is a utility for starting, stopping and getting the
status of background services based on Docker images hosted on Docker Hub.
Started services will listen on 0.0.0.0 and their default port.
The 0.0.0.0 IP address includes all available network interfaces.
Essentially, you'll be using services as if they were natively installed
in the OS.

#### Command Line Parameters

The general form of a `sem-service` command is as follows:

    sem-service [start|stop|status] image_name[:tag] [additional parameters]

Therefore, each `sem-service` command requires two parameters: the first one is
the task you want to perform and the second parameter is the Docker image that
will be used for the task.

All `additional parameters` will be forwarded directly to `docker run`.

#### Assumptions

The `sem-service` utility has no dependencies but presumes that Docker is
already installed, which is the case for every Semaphore VM.

Additionally, `image_name` should be a valid Docker image name. The full list
of available Docker images is available at [Docker Hub](dockerhub).

#### Examples

The following are valid uses of `sem-service`:

	sem-service start redis
	sem-service stop redis
	sem-service status redis
	sem-service start postgres:9.6 -e POSTGRES_PASSWORD=password

The last example uses `additional parameters`.

If you don't specify container image tag, the `latest` will be pulled.

If the first command line argument of `sem-service` is invalid, `sem-service`
will print its help screen:

	sem-service abc an_image
	#####################################################################################################
	service 0.5 | Utility for starting background services, listening on 0.0.0.0, using Docker
	service [start|stop|status] image_name
	#####################################################################################################

### retry

#### Description

The `retry` script is used for retrying a command for a given amount of times at
given time intervals – waiting for resources to become available or waiting
for network connectivity issues to be resolved is the main reason for using
the `retry` command.

#### Command Line Parameters

The `retry` bash script supports two command line parameters:

- `-t` or `--times`: this is used for defining the number of retries before
    giving up. The default value is 3.
- `-s` or `--sleep`: this is used for defining the time interval between retries.
    The default value is 0.

#### Dependencies

The `retry` bash script only depends on the `/bin/bash` executable.

#### Examples

	$ retry lsa -l
	/usr/bin/retry: line 46: lsa: command not found
	[1/3] Execution Failed with exit status 127. Retrying.
	/usr/bin/retry: line 46: lsa: command not found
	[2/3] Execution Failed with exit status 127. Retrying.
	/usr/bin/retry: line 46: lsa: command not found
	[3/3] Execution Failed with exit status 127. No more retries.

In the previous example the `retry` command will never be successful because
the `lsa` command does not exist.

	$ ./retry.sh -t 5 -s 10 lsa -l
    ./retry.sh: line 46: lsa: command not found
    [1/5] Execution Failed with exit status 127. Retrying.
    ./retry.sh: line 46: lsa: command not found
    [2/5] Execution Failed with exit status 127. Retrying.
    ./retry.sh: line 46: lsa: command not found
    [3/5] Execution Failed with exit status 127. Retrying.
    total 8
    -rwxr-xr-x   1 mtsouk  staff  1550 Aug 30 10:58 retry.sh

In the previous example, the `retry` script succeeded after three failed tries!

### cache

#### Description

Semaphore 2.0 offers the `cache` utility for storing the dependencies of
projects. As a result, the `cache` utility can be used for reducing
installation time by restoring installed packages quickly in order to be
reused between jobs.

Cache is created per project basis and it is exposed to every its job.

TODO: Describe paramets key and path. Point out that key is normalized, cache is
managed explicitly by using the commands.

#### Commands

The `cache` utility supports the following options:

    cache store
    cache restore
    cache has_key
    cache list
    cache delete
    cache clear

TODO: Add that only has_key can return non-zero exit status.

#### Dependencies

The `cache` utility depends on the following environment variables
which are automatically set in every job environment:

- `SEMAPHORE_CACHE_URL`: this environment variable stores the IP address and
    the port number of the cache server (`x.y.z.w:29920`).
- `SEMAPHORE_CACHE_USERNAME`: this environment variable stores the username
    that will be used for connecting to the cache server
	(`5b956eef90cb4c91ab14bd2726bf261b`).
- `SEMAPHORE_CACHE_PRIVATE_KEY_PATH`: this environment variable stores the path to the
    SSH key that will be used for connecting to the cache server
	(`/home/semaphore/.ssh/semaphore_cache_key`).

#### Examples

You can store the contents of the `cache_dir` directory under a new key that is
kept in the `KEY` environment variable as follows:

    cache store $KEY cache_dir

If the given `$KEY` value already exists in the cache of the current Semaphore
2.0 project, the `cache store` command *will not update* the contents of the
`cache_dir` directory.

You can restore the directory that is saved under the `KEY` environment variable
as follows:

    cache restore $KEY

#### Example Semaphore project

The following is a complete Semaphore 2.0 project that uses the `cache`
utility:

	version: v1.0
	name: Using cache utility
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804

	blocks:
	  - name: Create cache
	    task:
	      env_vars:
	        - name: APP_ENV
	          value: prod
	      jobs:
	      - name: Check environment variables
	        commands:
	          - echo $SEMAPHORE_CACHE_URL
	          - echo $SEMAPHORE_CACHE_USERNAME
	          - echo $SSH_PRIVATE_KEY_PATH
            - cat $SSH_PRIVATE_KEY_PATH
	      - name: Create cache key
	        commands:
	          - checkout
	          - export KEY=$(echo $(md5sum README.md) | grep -o "^\w*\b")
	          - mkdir -p cache_dir
	          - touch cache_dir/my_data
	          - echo $KEY > cache_dir/my_data
	          - echo $KEY
	          - cache store $KEY cache_dir/my_data
	          - cat cache_dir/my_data

	  - name: Use cache
	    task:
	      jobs:
	      - name: Get cache directory
	        commands:
	          - checkout
	          - export KEY=$(echo $(md5sum README.md) | grep -o "^\w*\b")
	          - echo $KEY
	          - cache restore $KEY
	          - ls -l cache_dir
	          - cat cache_dir/my_data


## sem-version

### Description

The `sem-version` utility is used for changing the version of a programming
language on the executed Virtual Machine (VM), which mainly happens for
compatibility issues.

The supported programming languages are `elixir`, `go`, `java`, `php`, `ruby`,
`python` and `node`.

### Command Line Parameters

The general form of the `sem-version` utility is as follows:

    sem-version [PROGRAMMING LANGUAGE] [VERSION]

where `[PROGRAMMING LANGUAGE]` is one of `elixir`, `go`, `java`, `php`, `ruby`,
`python` and `node`. The value of the `[VERSION]` parameter depends on the
programming language used as different programming languages have different
versioning systems.

### Dependencies

The `sem-version` utility mainly depends on the programming languages and the
versions of the programming languages that are installed on the Virtual
Machine (VM) used for executing a job of a pipeline.

### Examples

Changing the active Go version to 1.9 is as simple as executing the next
command in a job of a pipeline:

    sem-version go 1.9

### Example sem-version project

The following is an example Semaphore 2.0 project that uses `sem-version`:

	version: v1.0
	name: Testing sem-version
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804

	blocks:
	  - name: sem-version
	    task:
	      jobs:
	      - name: Using sem-version
	        commands:
	          - go version
	          - sem-version go 1.9
	          - go version

## See also

* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)

[toolbox-repo]: https://github.com/semaphoreci/toolbox
[dockerhub]: https://hub.docker.com/u/library/
