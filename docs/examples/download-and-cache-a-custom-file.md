# Download and Cache a Custom File

This guide shows you how to download one or more files and store them in
Semaphore cache indefinitely.

## Example Semaphore project

The `.semaphore/semaphore.yml` file of the project is as follows:

``` yaml
version: v1.0
name: Cache custom file
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Use cache or create
    task:
      jobs:
        - name: Get .deb from cache or create cache
          commands:
            - checkout
            - source .semaphore/get_packages.sh
            - ls -l packages

  - name: Reuse from cache
    task:
      prologue:
        commands:
          - checkout
          - cache restore $SEMAPHORE_PROJECT_NAME-deps
          - sudo dpkg -i ./packages/enscript.deb
```

The `get_packages.sh` script referenced above has the following content:

``` bash
cache restore $SEMAPHORE_PROJECT_NAME-deps

if [ -d 'packages' ]; then
  echo 'Found packages in cache'
else
  mkdir packages
  wget http://ge.archive.ubuntu.com/ubuntu/pool/universe/e/enscript/enscript_1.6.5.90-3_amd64.deb -O ./packages/enscript.deb
  # (add more downloads here if needed)
  cache store $SEMAPHORE_PROJECT_NAME-deps packages
fi
```

In the example above, the deb package will be downloaded from external source
only once, and reused from cache in all subsequent workflows.

You can extend the example to download any additional files and store them all
together in the `packages` directory.

#### Notes

- `SEMAPHORE_PROJECT_NAME` is one of the [environment variables][env-vars]
that are available in all blocks of a pipeline.

- Semaphore cache is built on the idea of speed over high-availability.
Data availability is not 100% guaranteed and Semaphore isn't responsible
for data loss stored in the cache.
For this reason, cached files may not always be available in your jobs.

- `cache` utility returns exit code 0 in cases of unsuccessful writes and
reads from the cache store. If the cache is not available, your pipeline
should be able to recover — the same way caching works in a web application,
for example.

## See also

- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Pipeline YAML Reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [Toolbox Reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Environment variables][env-vars]

[env-vars]: https://docs.semaphoreci.com/ci-cd-environment/environment-variables/
