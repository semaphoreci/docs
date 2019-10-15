# Caching Dependencies and Directories

Semaphore `cache` tool helps optimize CI/CD runtime by reusing files that your
project depends on but are not part of version control. You should typically
use caching to:

- Reuse your project's dependencies, so that Semaphore fetches and installs
them only when the dependency list changes.
- Propagate a file from one block to the next.

The cache is created on a per-project basis and available in every pipeline job.
All cache keys are scoped per-project. The total cache size is 9.6GB.

The `cache` tool uses key-path pairs for managing cached archives. An archive
can be a single file or a directory. Each archive automatically expires in 30 days.

## Basic usage

Semaphore caching script will try to recognize your project structure and automatically store or restore dependencies in to or from default paths.
Semaphore cache works for the following languages and dependency managers:

* **Ruby** (bundler) - default cache path: `vendor/bundle`, requires `Gemfile.lock` to be present in the repository.
* **Node.js** (npm or yarn) - default cache path: `node_modules` if `package-lock.json` is present or `node_modules` and `/$HOME/.cache/yarn` if `yarn.lock` exists in the repository.
* **Python** (pip) - default cache path: `.pip_cache` if `requirements.txt` is present.
* **PHP** (composer) - default cache path: `vendor`, requires `composer.lock` to be present in the repository.
* **Elixir** (mix) - default cache path: `deps` and `_build` if `mix.lock` is present.
* **Java** (maven) - default cache path: `.m2` and `target` if `pom.xml` is present.

### cache store

The `cache store` command that has zero arguments will lookup default paths
used to store dependencies and cache them.

Example YAML:

``` yaml
blocks:
  prologue:
    commands:
      - cache restore

  epilogue:
    commands:
      - cache store

  jobs:
    - name: Bundle Install
       commands:
         - bundle install --path vendor/bundle
```

The output of cache store in a project that has a Gemfile.lock and packages-lock.json
will look like this:

``` bash
$ cache store
==> Detecting project structure and storing it into the cache.

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

The `cache restore` command that has zero arguments would lookup cachable elements
and try to fetch them from the repository.

Example output:

``` bash
$ cache restore
==> Detecting project structure and storing it into the cache.

* Detected Gemfile.lock.
* Fetching 'vendor/bundle' directory with cache keys 'gems-your-branch-33a6002a37f59b6f1841636085a22fbc,gems-master-,gems-your-branch-'.
HIT: gems-your-branch-d17b3d82f1356d0c91469804e2fc320a, using key gems-your-branch-33a6002a37f59b6f1841636085a22fbc
Restored: vendor/bundle

* Detected package-lock.json.
* Fetching 'node_modules' directory with cache keys 'node-modules-your-branch-d17b3d82f1356d0c91469804e2fc320a,node-mdoules-master-,node-mdoules-your-branch-'.
HIT: node-mdoules-your-branch-d17b3d82f1356d0c91469804e2fc320a, using key node-mdoules-your-branch-d17b3d82f1356d0c91469804e2fc320a
Restored: node_modules/
```

## Advanced Usage

If a third party project, such as Bundler, changes the location where they store dependencies or your project the dependence location is different the default specified in [Basic Usage](#basic-usage), you might need to specify the key's path manually instead of using a caching shortcut.

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
be automatically propagated to the cache. The command always passes, i.e. exits
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
In case of a cache hit, the archive is retrieved and available at its original
path in the job environment.
Each archive is restored in the current path from where the function is called.

In case of a cache miss, the comma-separated fallback takes over and command
looks up the next key.
If no archives are restored command exits with 0.

### cache has_key key

Example:

``` bash
cache has_key our-gems
cache has_key gems-$SEMAPHORE_GIT_BRANCH
cache has_key gems-$SEMAPHORE_GIT_BRANCH-revision-$(checksum Gemfile.lock)
```

Checks if an archive with provided key exists in the cache.
Command passes if a key is found in the cache, otherwise, it fails.

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

Removes an archive with a given key if it is found in the cache.
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

### checksum

The `libchecksum` scripts provide the `checksum` command. `checksum` is
useful for tagging artifacts or generating cache keys. It takes a
single argument, a file path, and outputs an `md5` hash value.

Examples:

``` bash
$ checksum package.json 3dc6f33834092c93d26b71f9a35e4bb3
```

### Requirements

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

## Troubleshooting

### `cache restore` restores an archive with the corrupted archive message

If the `cache restore` output log includes lines similar to the following:

```bash
$ cache restore gems-$SEMAPHORE_GIT_SHA
==> HIT: gems-c964fbeac09ef1fad45c2b10c849a4e6b23763b4, using key gems-c964fbeac09ef1fad45c2b10c849a4e6b23763b4
gzip: stdin: unexpected end of file
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
Restored: vendor/bundle
```

You can make sure that only one job is creating an archive under the specific cache key.

Cache archives usually get corrupted when `cache store` is added to the [prologue command sequence][prologue commands],
resulting with its execution for all jobs in the related block.

To address the issue, structure Semaphore yml so that `cache store` for an archive
is executed in one job and `cache restore` in the succeeding jobs.

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
        - name: RSpec 1
          commands:
```

__Note:__ Launch a [debugging session][debug session] to clear corrupted archives for your project
by executing `cache clear` or `cache delete <key>`.

[debug session]: https://docs.semaphoreci.com/article/75-debugging-with-ssh-access
[prologue commands]: https://docs.semaphoreci.com/article/50-pipeline-yaml
