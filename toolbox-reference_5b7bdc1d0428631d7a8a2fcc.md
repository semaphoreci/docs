- [Overview](#overview)
- [cache](#cache)
- [checkout](#checkout)
- [checksum](#checksum)
- [retry](#retry)
- [See also](#see-also)

## Overview

This document describes additional
[open source command line tools](https://github.com/semaphoreci/toolbox) that
are provided by Semaphore and available in all VMs.

## cache

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

`cache` supports the following options:

### cache store key path

Examples:

``` bash
cache store our-gems vendor/bundle
cache store gems-$SEMAPHORE_GIT_BRANCH vendor/bundle
cache store gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock) vendor/bundle
```

The `cache store` command archives a file or directory specified by `path` and
associates it with a given `key`.

As `cache store` uses `tar`, it automatically removes any leading `/` from the
given `path` value.
Any further changes of `path` after the store command completes will not
be automatically propagated to cache. The command always passes, i.e. exits
with return code 0.

In case of insufficient disk space, `cache store` frees disk space by deleting
the oldest keys.

### cache restore key[,second-key,...]

Examples:

``` bash
cache restore our-gems
cache restore gems-$SEMAPHORE_GIT_BRANCH
cache restore gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock),gems-master
```

Restores an archive which *partially matches* any given `key`.
In case of a cache hit, archive is retrieved and available at its original
path in the job environment.
Each archive is restored in the current path from where the function is called.

In case of cache miss, the comma-separated fallback takes over and command
looks up the next key.
If no archives are restored command exits with 0.

### cache has_key key

Example:

``` bash
cache has_key our-gems
cache has_key gems-$SEMAPHORE_GIT_BRANCH
cache has_key gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock)
```

Checks if an archive with provided key exists in cache.
Command passes if key is found in the cache, otherwise it fails.

### cache list

Example:

``` bash
cache list
```

Lists all cache archives for the project.

### cache delete key

Example:

``` bash
cache delete our-gems
cache delete gems-$SEMAPHORE_GIT_BRANCH
cache delete gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock)
```

Removes an archive with given key if it is found in cache.
The command always passes.

### cache clear

Example:

``` bash
cache clear
```

Removes all cached archives for the project.
The command always passes.

Note that in all commands of `cache`, only `cache has_key` command can fail
(exit with non-zero status).

### Cache Dependencies

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

## checkout

The GitHub repository used in a Semaphore 2.0 project is not automatically
cloned for reasons of efficiency.

The `libcheckout` script includes the implementation of a single function
named `checkout()` that is used for making available the entire GitHub
repository of the running Semaphore 2.0 project to the VM used for executing a
job of the pipeline. The `checkout()` function is called as `checkout` from the
command line.

### Shallow clone

By default, the implementation of the `checkout` command uses *shallow clone*
during the clone operation. Without shallow clone, every clone gets not only
the files found on a repository but every revision of every file ever
committed, which can be a slow process. So using shallow clone makes the
process faster. However, some services do not work will with shallow clone.
Heroku is such as example.

Should you wish not to use shallow clone, you should execute `checkout` with
the `--use-cache` flag.

The `checkout()` function of the `libcheckout` script depends on the following
three Semaphore environment variables:

- `SEMAPHORE_GIT_URL`: This environment variable holds the URL of the GitHub
 repository that is used in the Semaphore 2.0 project
 (`git@github.com:mactsouk/S1.git`).

- `SEMAPHORE_GIT_DIR`: This environment variable holds the UNIX path where the
  GitHub repository will be placed on the VM (`/home/semaphore/S1`).

- `SEMAPHORE_GIT_SHA`: This environment variable holds the SHA key for the HEAD
  reference that is used when executing `git reset -q --hard`.

All these environment variables are automatically defined by Semaphore 2.0.

### The `--use-cache` flag

The `checkout` command supports the `--use-cache` flag. The purpose of that
flag is to tell `checkout` to get the contents of the GitHub repository from
the Semaphore Cache server instead of the GitHub servers because it is faster.

If there is no cache entry for the active GitHub repository, the functionality
of the `--use-cache` flag will create it.

When using the `--use-cache` flag, `checkout` supports the following
environment variables:

- `SEMAPHORE_GIT_CACHE_AGE`: This environment variable specifies how often
 the cache for that GitHub repository will get updated. Its value is always
 in seconds and by default it is `259200`, which is 3 days. The value that
 you are going to choose depends on your project and how ofter it gets
 updated.

- `SEMAPHORE_GIT_CACHE_KEEP`: Each time there is an update to the cache, the
 key in the Cache server is also being updated. Before updating the key,
 the previous key that is related to the current project is deleted.
 This environment variable tells Semaphore Cache server to keep a history.
 The default value of `SEMAPHORE_GIT_CACHE_KEEP` is `0`.

**Note**: When used with the `--use-cache` flag, `checkout` does not use
shallow clone.

Examples:

``` bash
checkout
```

Notice that the `checkout` command automatically changes the current working
directory in the Operating System of the VM to the directory defined in the
`SEMAPHORE_GIT_DIR` environment variable.

The following command will tell `checkout` to use the Semaphore Cache server
to get the contents of the GitHub repository instead of using GitHub server:

``` bash
checkout --use-cache
```

If you set `SEMAPHORE_GIT_CACHE_KEEP` to `1` then it will keep two copies in
the Semaphore Cache server: the active one and the previous one.

If you set `SEMAPHORE_GIT_CACHE_AGE=86400`, then the cache for the GitHub
repository will get updated after 1 day.

## checksum

The `libchecksum` scripts provides the `checksum` command. `checksum` is
useful for tagging artifacts or generating cache keys. It takes a
single argument, a file path, and outputs an `md5` hash value.

Examples:

``` bash
$ checksum package.json
3dc6f33834092c93d26b71f9a35e4bb3
```

## retry

The `retry` script is used for retrying a command for a given amount of times at
given time intervals – waiting for resources to become available or waiting
for network connectivity issues to be resolved is the main reason for using
the `retry` command.

The `retry` bash script supports two command line parameters:

- `-t` or `--times`: this is used for defining the number of retries before
  giving up. The default value is 3.
- `-s` or `--sleep`: this is used for defining the time interval between
  retries  The default value is 0.

The `retry` bash script only depends on the `/bin/bash` executable.

Examples:

``` bash
$ retry lsa -l
/usr/bin/retry: line 46: lsa: command not found
[1/3] Execution Failed with exit status 127. Retrying.
/usr/bin/retry: line 46: lsa: command not found
[2/3] Execution Failed with exit status 127. Retrying.
/usr/bin/retry: line 46: lsa: command not found
[3/3] Execution Failed with exit status 127. No more retries.
```

In the previous example the `retry` command will never be successful because
the `lsa` command does not exist.

``` bash
$ retry.sh -t 5 -s 10 lsa -l
./retry.sh: line 46: lsa: command not found
[1/5] Execution Failed with exit status 127. Retrying.
./retry.sh: line 46: lsa: command not found
[2/5] Execution Failed with exit status 127. Retrying.
./retry.sh: line 46: lsa: command not found
[3/5] Execution Failed with exit status 127. Retrying.
total 8
-rwxr-xr-x   1 mtsouk  staff  1550 Aug 30 10:58 retry.sh
```

In the previous example, the `retry` script succeeded after three failed tries.

## See also

- [Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image)
- [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
