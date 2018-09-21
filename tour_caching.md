# Caching Dependencies

Since each jobs runs on a fresh machine, common tasks like install
dependencies must be repeated. This slows down builds and may make
things less reliable. Semaphore includes a utility to cache files and
directories backed by an exteremly fast local network, so even
Gigabytes may be cached with ease. The cache is specific to each
project, so cache entries may be shared between jobs.

Here's an example of caching `npm` dependencies:

```yml
# .semaphore/semaphore.yml
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Cache dependencies
    task:
      jobs:
        - name: 'npm'
          commands:
            - checkout
            - npm install
            - export VERSION="$(md5sum package.json | grep -o "^\w*\b")"
            - cache store --key v1-node-modules-$VERSION node_modules
  - name: Tests
    task:
      jobs:
        - name: 'npm'
          commands:
            - checkout
            - export VERSION="$(md5sum package.json | grep -o "^\w*\b")"
            - cache restore --key v1-node-modules-$VERSION
            - npm test
```

This example generates a `VERSION` environment variable based on
`package.json`. This way caches will be invalidated and updated
correctly as `package.json` changes. The approach applies to other
languages and uses cases as well.

Also note that `cache store` must be called before `cache restore`.
This is why the example uses a block to fill the cache, then use the
cache in subsequent blocks.
