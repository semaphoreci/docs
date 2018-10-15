One of the largest factors affecting the job duration is the time used for
retrieving dependencies from other external services (e.g. Ruby gems, node modules etc).

A solution that does not require the data to be fetched from open internet
is clearly the most ideal. In order to address this Semaphore 2.0 offers
the cache storage and the [`cache` CLI](todo: add toolbox url).

Since cache is available to every job it is not recommended to store sensitive data.

* [Saving and retrieving cache](#saving-and-retrieving-cache)
* [The fallback key](#the-fallback-key)
* [Removing dependencies from cache](#removing-dependencies-from-cache)

## Saving and retrieving cache

Every cached archive is associated with a key-path pair.
`cache` archives a dependency specified by `path` in the job environment.
This action makes a cached archive accessible to every succeeding job
and it is available under the `key` value.

The following command sequence saves and restores `vendor/bundle` from cache:

    cache store gems-v1 vendor/bundle
    cache restore gems-v1

To achieve that jobs on the each branch always use the same cache, we can add
the following commands to Semaphore yaml file:

    cache store gems-$SEMAPHORE_GIT_BRANCH vendor/bundle
    cache restore gems-$SEMAPHORE_GIT_BRANCH

Yet, with this setup jobs on the master branch will restore the archive cached
by the first execution of the `cache store` on this branch.
To always store the newest gems version to the cache,
you can  use the `checksum` function.

    cache store gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock) vendor/bundle
    cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock)

### The fallback key

Next lines illustrate the fallback key method which the restore command follows.

    cache restore gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock),gems-$SEMAPHORE_GIT_BRANCH,gems-master

In this case, Semaphore will take the following steps
when looking up the archive in cache:

1. If an archive with `gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock)` key
is available in cache, it will be restored
2. Otherwise, `cache` will fallback to the most recent key which includes previous key
3. If there is no such archive in the cache, `cache` will repeat steps 1-2
with the next key in the sequence (`gems-$SEMAPHORE_GIT_BRANCH`)
4. Steps 1-3 are repeated until an archive is restored from the cache or
command tried restoring all specified keys

## Removing dependencies from cache

Command `cache delete gems-master` removes the archive under `gems-master` key
from cache. Also, the `cache clear` command is used to clear project's dependency
cache.
