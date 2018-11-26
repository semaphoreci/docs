
* [Overview](#overview)
* [libcheckout](#libcheckout)
* [libchecksum](#libchecksum)
* [sem-service](#sem-service)
  * [Example Semaphore 2.0 project](#example-sem-service-project)
* [retry](#retry)
* [cache](#cache)
* [sem-version](#sem-version)
  * [Example Semaphore 2.0 project](#example-sem-version-project)
- [See also](#see-also)

## Overview

This document describes additional [open source command line tools][toolbox-repo]
that are provided by Semaphore and available in all VMs.

[toolbox-repo]: https://github.com/semaphoreci/toolbox

## libcheckout

### Description

The GitHub repository used in a Semaphore 2.0 project is not automatically
cloned for reasons of efficiency.

The `libcheckout` script includes the implementation of a single function
named `checkout()` that is used for making available the entire GitHub
repository of the running Semaphore 2.0 project to the VM used for executing a
job of the pipeline. The `checkout()` function is called as `checkout` from the
command line.

### Dependencies

The `checkout()` function of the `libcheckout` script depends on the following
three Semaphore environment variables:

   - `SEMAPHORE_GIT_URL`: This environment variable holds the URL of the GitHub
     repository that is used in the Semaphore 2.0 project (`git@github.com:mactsouk/S1.git`).
   - `SEMAPHORE_GIT_DIR`: This environment variable holds the UNIX path where the GitHub
     repository will be placed on the VM (`/home/semaphore/S1`).
   - `SEMAPHORE_GIT_SHA`: This environment variable holds the SHA key for the
     HEAD reference that is used when executing `git reset -q --hard`.

All these environment variables are automatically defined by Semaphore 2.0.

### Examples

    checkout

Notice that the `checkout` command automatically changes the current working
directory in the Operating System of the VM to the directory defined in the
`SEMAPHORE_GIT_DIR` environment variable.

## libchecksum

The `libchecksum` scripts provides the `checksum` command. `checksum` is
useful for tagging artifacts or generating cache keys. It takes a
single argument, a file path, and outputs an `md5` hash.

### Examples

    $ checksum package.json
    3dc6f33834092c93d26b71f9a35e4bb3

## sem-service

### Description

The `sem-service` script is a utility for starting, stopping and getting the
status of background services. Started services will listen on 0.0.0.0 and
their default port. The 0.0.0.0 IP address includes all available network
interfaces. Essentially, you will be using services as if they were natively
installed in the OS.

### Command Line Parameters

The general form of a `sem-service` command is as follows:

    sem-service start [mysql | postgres | redis | memcached]

Therefore, each `sem-service` command requires two parameters: the first one is
the task you want to perform and the second parameter is the name of the service
that will be used for the task.

### Assumptions

The `sem-service` utility has no dependencies. However, depending on the
service you want to use, you might need to install additional software such as
a client for connecting to the service.

### Examples

The following are valid uses of `sem-service`:

    sem-service start redis
    sem-service stop redis
    sem-service status postgres
    sem-service status mysql
    sem-service start memcached

### Example sem-service Project

    version: v1.0
    name: Testing sem-service
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804

    blocks:
      - name: Databases
        task:
          env_vars:
            - name: APP_ENV
              value: prod
          jobs:
          - name: MySQL
            commands:
              - sem-service start mysql
              - sudo apt-get install -y -qq mysql-client
              - mysql --host=0.0.0.0 -uroot -e "create database Project"
              - mysql --host=0.0.0.0 -uroot -e "show databases" | grep Project
              - sem-service status mysql

          - name: PostgreSQL
            commands:
              - sem-service start postgres
              - sudo apt-get install -y -qq postgresql-client
              - createdb -U postgres -h 0.0.0.0 Project
              - psql -h 0.0.0.0 -U postgres -c "\l" | grep Project
              - sem-service status postgres

          - name: Redis
            commands:
              - sem-service start redis
              - sem-service status redis

          - name: Memcached
            commands:
              - sem-service start memcached
              - sem-service status memcached

## retry

### Description

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

### Dependencies

The `retry` bash script only depends on the `/bin/bash` executable.

### Examples

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

## cache

### Description

Semaphore `cache` tool helps optimize CI/CD runtime by reusing files that your
project depends on but are not part of version control. You should typically
use caching to:

- Reuse your project's dependencies, so that Semaphore fetches and installs
them only when the dependency list changes.
- Propagate a file from one block to the next.

Cache is created on a per project basis and available in every pipeline job.
All cache keys are scoped per project. Total cache size is 9.6GB.

The `cache` tool uses key-path pairs for managing cached archives. An archive
can be a single file or a directory.

### Commands

`cache` supports the following options:

#### cache store key path

Examples:

    cache store our-gems vendor/bundle
    cache store gems-$SEMAPHORE_GIT_BRANCH vendor/bundle
    cache store gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock) vendor/bundle

The `cache store` command archives a file or directory specified by `path` and
associates it with a given `key`.

As `cache store` uses `tar`, it automatically removes any leading `/` from the
given `path` value.
Any further changes of `path` after the store command completes will not
be automatically propagated to cache. The command always passes, i.e. exits
with return code 0.

In case of insufficient disk space, `cache store` frees disk space by deleting
the oldest keys.

#### cache restore key[,second-key,...]

Examples:

    cache restore our-gems
    cache restore gems-$SEMAPHORE_GIT_BRANCH
    cache restore gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock),gems-master

Restores an archive with the given `key`.
In case of a cache hit, archive is retrieved and available at its original
path in the job environment.
Each archive is restored in the current path from where the function is called.

In case of cache miss, the comma-separated fallback takes over and command
looks up the next key.
If no archives are restored command exits with 0.

#### cache has_key key

Example:

    cache has_key our-gems
    cache has_key gems-$SEMAPHORE_GIT_BRANCH
    cache has_key gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock)

Checks if an archive with provided key exists in cache.
Command passes if key is found in the cache, otherwise is fails.

#### cache list

Example:

    cache list

Lists all cache archives for the project.

#### cache delete key

Example:

    cache delete our-gems
    cache delete gems-$SEMAPHORE_GIT_BRANCH
    cache delete gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock)

Removes an archive with given key if it is found in cache.
The command always passes.

#### cache clear

Example:

    cache clear

Removes all cached archives for the project.
The command always passes.

Note that in all commands of `cache`, only `cache has_key` command can fail
(exit with non-zero status).

### Dependencies

The `cache` tool depends on the following environment variables
which are automatically set in every job environment:

- `SEMAPHORE_CACHE_URL`: stores the IP address and
    the port number of the cache server (`x.y.z.w:29920`).
- `SEMAPHORE_CACHE_USERNAME`: stores the username
    that will be used for connecting to the cache server
  (`5b956eef90cb4c91ab14bd2726bf261b`).
- `SEMAPHORE_CACHE_PRIVATE_KEY_PATH`: stores the path to the
    SSH key that will be used for connecting to the cache server
  (`/home/semaphore/.ssh/semaphore_cache_key`).

Additionally, `cache` uses `tar` to archive the specified directory or file.

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
