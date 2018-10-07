Since each jobs runs on a fresh machine, common tasks like installing
dependencies must be repeated. This slows down builds and may make
them less reliable. Semaphore includes a utility to cache files and
directories backed by an extremely fast network, so even
gigabytes may be cached with ease.

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
            - cache store --key v1-node-modules-$(checksum package.json) node_modules
  - name: Tests
    task:
      jobs:
        - name: 'npm'
          commands:
            - checkout
            - cache restore --key v1-node-modules-$(checksum package.json)
            - npm test
```

This example generates a `VERSION` environment variable based on
`package.json`. This invalidates the cache and updates correctly as
`package.json` changes. The approach applies to other languages and
uses cases as well.

`cache store` must be called before `cache restore`. This is why the
example uses a block to warm the cache, then uses the cache in
subsequent blocks.

That wraps up the tour. We've covered configuring pipelines,
installing software, using databases, setting environment variables,
managing secrets, and connecting pipelines with promotions, and
caching dependencies. You're ready to start shipping with SeamphoreCI.
