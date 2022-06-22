---
Description: This document describes additional open source command line tools that are provided by Semaphore and available in all VMs.
---

# Toolbox Reference

This document describes additional
[open source command line tools](https://github.com/semaphoreci/toolbox) that
are provided by Semaphore and available in all VMs.

## cache

Semaphore's `cache` tool helps optimize CI/CD runtime by reusing files that your
project depends on, but are not part of version control. You should typically
use caching to:

- Reuse your project's dependencies, so that Semaphore fetches and installs
them only when the dependency list changes.
- Propagate a file from one block to the next.

A cache is created on a per-project basis and is available in every pipeline job.
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

The `cache store` command archives a file or directory specified by `path`, and
associates it with a given `key`.

As `cache store` uses `tar`, which automatically removes any leading `/` from a
given `path` value.
Any further changes of `path` after the store command completes will not
be automatically propagated to cache. This command always passes, i.e. exits
with return code 0.

In the event of insufficient disk space, `cache store` frees disk space by deleting
the oldest keys.

### cache restore key[,second-key,...]

Examples:

``` bash
cache restore our-gems
cache restore gems-$SEMAPHORE_GIT_BRANCH
cache restore gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock),gems-master
```

Restores an archive which *partially matches* any given `key`.
In the event of a cache hit, the archive is retrieved and available at its original
path in the job environment.
Each archive is restored in the current path from which the function is called.

In the event of a cache miss, the comma-separated fallback takes over and the command
looks up the next key.
If no archives are restored, this command exits with 0.

### cache has_key key

Example:

``` bash
cache has_key our-gems
cache has_key gems-$SEMAPHORE_GIT_BRANCH
cache has_key gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock)
```

Checks if an archive with the provided key exists in the cache.
This command passes if the key is found in the cache, otherwise it fails.

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

Removes any archive with the given key, if it is found in the cache.
This command always passes.

### cache clear

Example:

``` bash
cache clear
```

Removes all cached archives for the project.
This command always passes.

Note that in all commands related to the `cache`, only the `cache has_key` command can fail
(exit with non-zero status).

### Cache Dependencies

The `cache` tool depends on the following environment variables,
which are automatically set in every job environment:

- `SEMAPHORE_CACHE_URL`: stores the IP address and
    port number of the cache server (`x.y.z.w:29920`).
- `SEMAPHORE_CACHE_USERNAME`: stores the username
    that will be used for connecting to the cache server
  (`5b956eef90cb4c91ab14bd2726bf261b`).
- `SEMAPHORE_CACHE_PRIVATE_KEY_PATH`: stores the path to the
    SSH key that will be used for connecting to the cache server
  (`/home/semaphore/.ssh/semaphore_cache_key`).

Additionally, `cache` uses `tar` to archive specified directories or files.

## checkout

The repository used in a Semaphore project is not automatically
cloned for reasons of efficiency.

The `libcheckout` script includes the implementation of a single function
named `checkout()`, which is used for making the entire repository of the running Semaphore project available to the VM used for executing jobs in the pipeline. 
The `checkout()` function is called as `checkout` from the command line.

### Shallow clone

By default, the implementation of the `checkout` command uses *shallow clone*
during the clone operation.

With shallow clone, you get all the files in your repository and a small number
of recent revisions. This makes the checkout process faster than
downloading the entire history of the repository.

Note that some deployment scenarios, like Heroku, require the presence of a full
Git history.

If you'd like to do a full clone, execute `checkout` with the `--use-cache`
flag, or use the following code snippet:

```
checkout
git fetch --unshallow
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git fetch --all
```

The `checkout()` function of the `libcheckout` script depends on the following
three Semaphore environment variables:

- `SEMAPHORE_GIT_URL`: This environment variable holds the URL of the
 repository used in the Semaphore project
 (`git@github.com:mactsouk/S1.git`).

- `SEMAPHORE_GIT_DIR`: This environment variable holds the UNIX path where the
 repository will be placed in the VM (`/home/semaphore/S1`).

- `SEMAPHORE_GIT_SHA`: This environment variable holds the SHA key for the HEAD
  reference used when executing `git reset -q --hard`.
  
- `SEMAPHORE_GIT_DEPTH`: This environment variable holds the shallow clone depth
    level. By default, this value is `50`.

All these environment variables are automatically defined by Semaphore.

### The `--use-cache` flag

The `checkout` command supports the `--use-cache` flag. The purpose of this
flag is to tell `checkout` to get the contents of the repository from
the Semaphore Cache server instead of from the servers, because it is faster.

If there is no cache entry for the active repository, the functionality
of the `--use-cache` flag will create one.

When using the `--use-cache` flag, `checkout` supports the following
environment variables:

- `SEMAPHORE_GIT_CACHE_AGE`: This environment variable specifies how often
 the cache for that repository will be updated. Its value is always
 in seconds and by default it is `259200`, which is 3 days. The value that
 you are going to choose depends on your project and how often it gets
 updated.

- `SEMAPHORE_GIT_CACHE_KEEP`: Each time there is an update to the cache, the
 key in the Cache server is also updated. Before updating the key,
 the previous key related to the current project is deleted.
 This environment variable tells the Semaphore Cache server to keep a history.
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
to get the contents of the repository, instead of using git server:

``` bash
checkout --use-cache
```

If you set `SEMAPHORE_GIT_CACHE_KEEP` to `1`, it will keep two copies in
the Semaphore Cache server: the active one and its antecedent.

If you set `SEMAPHORE_GIT_CACHE_AGE=86400`, the cache for the
repository will be updated after 1 day.

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

The `retry` script is used for retrying a command at
given time intervals – waiting for resources to become available or waiting
for network connectivity issues to be resolved is the main reason for using
the `retry` command.

The `retry` bash script supports two command line parameters:

- `-t` or `--times`: this is used for defining the number of retries before
  giving up. The default value is 3.
- `-s` or `--sleep`: this is used for defining the time interval between
  retries. The default value is 0.

The `retry` bash script only depends on the `/bin/bash` executable.

Examples:

``` bash
$ retry bundle install
```

``` bash
$ retry --times 10 go get ./...
```

``` bash
$ retry --times 3 --sleep 5 make install.deps
```

## install-package

The `install-package` script can be used to cache missing packages and their dependencies.
It works by creating a "temporary package cache" folder (if its not present), downloading packages (that are not present),  
installing the packages from the "temporary package cache", and uploading the folder to the projects cache.

Usage:
```
install-package [--update|--skip-update|--update-new] pkg1[=version] [pkg2[=version]] 
```

-`--update` forces a repository list update before installing packages.  
-`--skip-update` skips the repository list update before installing packages.  
-`--update-new` updates only repository lists added in the last hour.

-`pkg1` is the desired package that accepts the `=version` parameter.
 Multiple package names with versions are supported.


## See also

- [Ubuntu image reference](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/)
- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
