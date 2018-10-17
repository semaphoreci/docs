
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
status of background services based on Docker images hosted on
[Docker Hub Library][dockerhub-lib].
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
of available Docker images is available on [Docker Hub Library][dockerhub-lib].

#### Examples

The following are valid uses of `sem-service`:

	sem-service start redis
	sem-service stop redis
	sem-service status redis
	sem-service start postgres:9.6 -e POSTGRES_PASSWORD=password

The last example uses `additional parameters`.

If you don't specify the container image tag, `latest` will be pulled.
Note that some images don't support the `latest` tag; you can check that in the
"Supported tags" section of the image on Docker Hub.

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

Semaphore cache helps reducing the job duration by reusing dependencies
retreived from external services (e.g. Ruby gems, node_modules etc).
Cache is created on a per project basis and it is available to every project's job.

Project's dependencies are not automatically cached and
Semaphore 2.0 offers the `cache` tool for exploiting the caching mechanism efficently.

`cache` CLI is a script which uses key-path pairs for managing cached archives.

#### Commands

`cache` supports the following options:

    store [key] [path]
        example:
            cache store gems-master-branch vendor/bundle
        Archives file or directory specified by `path` and associates it with the `key`.
        When an archive with a specific `key` is saved,
        next command execution does not update it. The command always passes.
    restore [first-key,second-key]
        example:
            cache restore gems-master-revision-1234445
            cache restore gems-master-revision-1234445,gems-master
        Checks if an archive with name KEY exists in the cache.
        In case of a cache hit, archive is retrieved and available at its path
        in the job environment. Otherwise, the fallback takes over
        and command looks up the next key.
        Eventually, if no archives are restored command does not fail.
    has_key [key]
        example:
            cache has_key gems-master-revision-1234445
        It checks if archive named `key` exists in cache.
        Command passes if KEY is found in the cache, otherwise is fails.
    list
        example:
            cache list
        Lists cache for the project.
    delete [key]
        example:
            cache delete gems-master-revision-1234445
        Removes an archive under `key` if it is found in cache.
        The command always passes.
    clear
        example:
            cache clear
        Removes all cached archives for the project.
        The command always passes.

Note that only `cache has_key` command might fail.
Specifically it fails in case when specified archive is not found in cache.

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

You can store the contents of a directory under a key which utilizes available
environment variables.
For example, every job environment includes `SEMAPHORE_GIT_BRANCH` variable.
Let's use it and make sure that jobs on the each branch always the same cache.

    cache store gems-$SEMAPHORE_GIT_BRANCH vendor/bundle

Later on, all of the project's succeeding jobs could retrive
the `vendor/bundle` from cache with the following command in the yaml file:

    cache restore gems-$SEMAPHORE_GIT_BRANCH

Additionally, we can also use the fallback key option.

    cache restore gems-$SEMAPHORE_GIT_BRANCH,gems-master

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
[dockerhub-lib]: https://hub.docker.com/u/library/
