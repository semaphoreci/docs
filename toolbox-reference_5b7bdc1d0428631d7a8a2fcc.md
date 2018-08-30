
- [Overview](#overview)
- [Essentials](#essentials)
  * [libcheckout](#libcheckout)
  * [sem-service](#sem-service)
  * [retry](#retry)
- [See also](#see-also)
  
## Overview

This document explains the use of the command line tools found in the
`https://github.com/semaphoreci/toolbox` repository and are automatically
available to Semaphore 2.0 and the Virtual Machines (VM) used for executing the
jobs of a pipeline.

## Essentials

This section contains the most frequently used tools of the Semaphore 2.0
toolbox.

### libcheckout

#### Description

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
status of background services based on Docker images. Started services will
listens on 0.0.0.0 and their default port. The 0.0.0.0 IP address includes
all the available network interfaces.

#### Command Line Parameters

The general form of a `sem-service` command is as follows:

    sem-service [start|stop|status] image_name [additional parameters]

Therefore, each `sem-service` command requires two parameters: the first one is
the task you want to perform and the second parameter is the Docker image that
will be used for the task.

All `additional parameters` will be forwarded directly to `docker run`.

#### Dependencies

The `sem-service` utility has no dependencies but it needs to be executed in a
Docker environment.

Additionally, `image_name` should be a valid Docker image name. The full list
of available Docker images is available at https://hub.docker.com/u/library/.

#### Examples

The following are valid uses of `sem-service`:

	sem-service start postgres:9.6
	sem-service start redis
	sem-service stop redis
	sem-service status redis
	sem-service start postgres:9.6 -e POSTGRES_PASSWORD=password

The last example uses `additional parameters`.

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

## See also

* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
