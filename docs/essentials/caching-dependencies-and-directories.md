---
Description: The Semaphore 2.0 cache tool helps optimize CI/CD runtime by reusing files that your project depends on, but are not part of version control.
---

# Caching

The Semaphore `cache` tool helps optimize CI/CD runtime by reusing files that your
project depends on, but are not part of version control. You should typically
use caching to: 

- Reuse your project's dependencies so that Semaphore fetches and installs
them only when the dependency list changes.
- Propagate a file from one block to the next.

The cache is created on a per-project basis and is available in every pipeline job.
All cache keys are scoped per project.

The `cache` tool uses key pairs for managing cached archives. An archive
can be a single file or a directory.

When running jobs in Semaphore's hosted environment, the total cache size is 9.6GB and each
archive automatically expires in 30 days. When running jobs in a self-hosted environment,
you have full control over the cache size and archive expiration.

## Basic usage

The Semaphore caching script will try to recognize your project structure and automatically store or restore dependencies into or from default paths.
The Semaphore cache works for the following languages and dependency managers:

* **Ruby** (bundler) - default cache path: `vendor/bundle`, requires `Gemfile.lock` to be present in the repository.
* **Node.js** (npm, yarn) - default cache path: `node_modules` if `package-lock.json` is present or `node_modules` and `/$HOME/.cache/yarn` if `yarn.lock` exists in the repository.
* **Python** (pip) - default cache path: `.pip_cache` if `requirements.txt` is present.
* **PHP** (composer) - default cache path: `vendor`, requires `composer.lock` to be present in the repository.
* **Elixir** (mix) - default cache path: `deps` or `_build` if `mix.lock` is present.
* **Java** (maven) - default cache path: `.m2` or `target` if `pom.xml` is present.
* **nvm** - default cache path: `$HOME/.nvm` if `.nvmrc` is present in the repository.
* **golang** - default cache path: `$HOME/go/pkg/mod` if `go.sum` is present in the repository.

### cache store

A `cache store` command that has zero arguments will look up default paths
used to store dependencies and cache them.

Example YAML:

``` yaml
blocks:
- name: Cache bundle
  task:
    jobs:
      - name: Bundle install and cache
        commands:
          - bundle install --path vendor/bundle
          - cache store
- name: Use cache
  task:
    prologue:
      commands:
        - cache restore
    jobs:
      - name: Job 1
        commands: echo Use cache 1
      - name: Job 2
        commands: echo Use cache 2
      - name: Job 3
        commands: echo Use cache 3
```

The output of cache store in a project that has a Gemfile.lock and packages-lock.json
will look like this:

``` bash
$ cache store
==> Detecting project structure and storing it in the cache.

* Detected Gemfile.lock.
* Using default cache path 'vendor/bundle'.
Uploading 'vendor/bundle' with cache key 'gems-your-branch-33a6002a37f59b6f1841636085a22fbc'...
Upload complete.

* Detected package-lock.json.
* Using default cache path 'node_modules'.
Uploading 'node_modules' with cache key 'node-modules-your-branch-d17b3d82f1356d0c91469804e2fc320a'...
Upload complete.

```

### cache restore

A `cache restore` command that has zero arguments looks up cachable elements
and tries to pull them from the repository.

Example output:

``` bash
$ cache restore
==> Detecting project structure and storing it in the cache.

* Detected Gemfile.lock.
* Fetching 'vendor/bundle' directory with cache keys 'gems-your-branch-33a6002a37f59b6f1841636085a22fbc,gems-master-,gems-your-branch-'.
HIT: gems-your-branch-d17b3d82f1356d0c91469804e2fc320a, using key gems-your-branch-33a6002a37f59b6f1841636085a22fbc
Restored: vendor/bundle

* Detected package-lock.json.
* Fetching 'node_modules' directory with cache keys 'node-modules-your-branch-d17b3d82f1356d0c91469804e2fc320a,node-mdoules-master-,node-mdoules-your-branch-'.
HIT: node-mdoules-your-branch-d17b3d82f1356d0c91469804e2fc320a, using key node-mdoules-your-branch-d17b3d82f1356d0c91469804e2fc320a
Restored: node_modules/
```

## Advanced usage

If a third party project, such as Bundler, changes the location where they store dependencies or your project then dependency location is different than the default specified in [Basic Usage](#basic-usage); you might need to specify the key's path manually instead of using a caching shortcut.

### cache store key path

Here are a few examples of a cache store key path:

``` bash
cache store our-gems vendor/bundle
cache store gems-$SEMAPHORE_GIT_BRANCH vendor/bundle
cache store gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock) vendor/bundle
```

The `cache store` command archives a file or directory specified by `path` and
associates it with a given `key`.

Because `cache store` uses `tar`, it automatically removes the preceding `/` from the
given `path` value.
Any further changes of `path` after the store command completes will not
be automatically propagated to the cache. The command always passes, i.e. exits
with a return code of 0.

In case of insufficient disk space, `cache store` frees disk space by deleting
the oldest keys.

**Note:** `cache store` does not overwrite data for an existing key.
You need to [delete the key](https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/#cache-delete-key) first to update the associated information.

### cache restore key [,second-key,...]

Some examples of cache restore keys are:

``` bash
cache restore our-gems
cache restore gems-$SEMAPHORE_GIT_BRANCH
cache restore gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock),gems-master
```

These will restore an archive which *partially matches* any given `key`.
In case of a cache hit, the archive is retrieved and available at its original
path in the job environment.
Each archive is restored in the current path from where the function is called.

In case of a cache miss, the comma-separated fallback takes over and the command
looks up the next key.
If no archives are restored, the command exits with 0.

### cache has_key key

Example:

``` bash
cache has_key our-gems
cache has_key gems-$SEMAPHORE_GIT_BRANCH
cache has_key gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock)
```

This command checks if an archive with the provided key exists in the cache.
The command passes if a key is found in the cache, otherwise it fails.

### cache list

Example:

``` bash
cache list
```

This command lists all cache archives for the project.

### cache delete key

Example:

``` bash
cache delete our-gems
cache delete gems-$SEMAPHORE_GIT_BRANCH
cache delete gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock)
```

This will remove an archive with a given key if it is found in the cache.
The command always passes.

### cache clear

Example:

``` bash
cache clear
```

Using this command will remove all cached archives for the project.
The command always passes.

Note that in all commands of `cache`, only the `cache has_key` command can fail
(exit with non-zero status).

### checksum

The `libchecksum` scripts provide the `checksum` command. The `checksum` command is
useful for tagging artifacts or generating cache keys. It takes a
single argument - a file path - and outputs an `md5` hash value.

Examples:

``` bash
$ checksum package.json 3dc6f33834092c93d26b71f9a35e4bb3
```

## SFTP backend

This is the default backend for jobs running in Semaphore's hosted environment. The
following environment variables are required and automatically set in every hosted job:

| Environment variable               | Description |
|------------------------------------|-------------|
| `SEMAPHORE_CACHE_BACKEND`          | Controls the storage backend used by the cache CLI. For the hosted environment, it is set to `sftp`. |
| `SEMAPHORE_CACHE_URL`              | The IP address and port number of the cache sftp server (`x.y.z.w:29920`). |
| `SEMAPHORE_CACHE_USERNAME`         | The username that will be used to connect to the cache sftp server (`5b956eef90cb4c91ab14bd2726bf261b`). |
| `SEMAPHORE_CACHE_PRIVATE_KEY_PATH` | The path to the SSH key that will be used to connect to the cache sftp server (`/home/semaphore/.ssh/semaphore_cache_key`). |

For jobs in a self-hosted environment, these environment variables are not automatically set on every job.

## AWS S3 backend

The following environment variables are required for the `s3` storage backend to work:

| Environment variable               | Description |
|------------------------------------|-------------|
| `SEMAPHORE_CACHE_BACKEND`          | To use the S3 storage backend, this should be set to `s3`. |
| `SEMAPHORE_CACHE_S3_BUCKET`        | The S3 bucket name. |

Additionally, the `cache` CLI also needs your `~/.aws` folder to be properly configured with the appropriate credentials in order to access your AWS S3 bucket. You can [follow this guide][aws s3 setup] to set this up.

## Troubleshooting

### `cache restore` restores an archive with a corrupted archive message

If the `cache restore` output log includes lines similar to the following, you can make sure that only one job is creating an archive under the specific cache key:

```bash
$ cache restore gems-$SEMAPHORE_GIT_SHA
==> HIT: gems-c964fbeac09ef1fad45c2b10c849a4e6b23763b4, using key gems-c964fbeac09ef1fad45c2b10c849a4e6b23763b4
gzip: stdin: unexpected end of file
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Restored: vendor/bundle
```

Cache archives usually get corrupted when `cache store` is added to the [prologue command sequence][prologue commands],
resulting in its execution for all jobs in the related block.

To address the issue, structure Semaphore yml's so that `cache store` for an archive
is executed in one job and `cache restore` is in the successive jobs.

Example YML:

```
blocks:
  - name: Cache dependencies
    task:
      jobs:
        - name: Cache gems
          commands:
            - checkout
            - cache restore bundle-gems-$(checksum Gemfile.lock)
            - bundle install --deployment --path vendor/bundle
            - cache store bundle-gems-$(checksum Gemfile.lock) vendor/bundle

  - name: Tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore bundle-gems-$(checksum Gemfile.lock)
          - bundle install --deployment --path vendor/bundle
      jobs:
        - name: RSpec 0
          commands:
        - name: RSpec 1
          commands:
        - name: RSpec 2
          commands:
```

__Note:__ Launch a [debugging session][debug session] to clear corrupted archives for your project
by executing `cache clear` or `cache delete <key>`.


[debug session]: https://docs.semaphoreci.com/essentials/debugging-with-ssh-access/
[prologue commands]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
[aws s3 setup]: ../../ci-cd-environment/set-up-caching-on-aws-s3
