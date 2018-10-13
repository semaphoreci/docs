One of the largest factors affecting the job duration is the time used for
retreving dependencies from internet (e.g. Ruby gems, node modules etc).

A solution that does not require the data to be fetched from external services
is clearly the most ideal. In order to address this Semaphore 2.0 offers
the `cache` CLI, a script which communicates with the cache storage.

The following lines illustrate how you can exploit cache and keep setup time short.

* [Caching directory](#caching-directory)
* [Restoring the directory from cache](#restoring-the-directory-from-cache)
  * [Using the fallback key option](#using-the-fallback-key)
* [Expiring the cache](#expiring-the-cache)

## Saving the directory to cache

    cache store gems-v1 vendor/bundle
    cache store gems-$SEMAPHORE_GIT_BRANCH vendor/bundle

## Restoring the directory from cache

    cache restore gems-v1
    cache restore gems-$SEMAPHORE_GIT_BRANCH,gems-master,gems

### Using the fallback key option

## Expiring the cache

Since cache is available to every job it is not recommended to store sensitive data.
