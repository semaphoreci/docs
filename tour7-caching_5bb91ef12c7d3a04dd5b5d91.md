Since each job runs in a clean and isolated VM, we need to explicitly configure
project dependencies. Installing them in every stage and every block from
scratch would slow down the pipeline and make it less reliable.

Semaphore includes a tool to cache files and directories backed by an extremely
fast network, so even gigabytes may be cached with ease.

Here's an example of installing and caching `npm` dependencies in one block,
then reusing them in subsequent blocks:

```yml
# .semaphore/semaphore.yml
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Install dependencies
    task:
      jobs:
        - name: npm install and cache
          commands:
            - checkout
            - cache restore node-modules-$(checksum package-lock.json)
            - npm install
            - cache store node-modules-$(checksum package-lock.json) node_modules

  - name: Tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore node-modules-$(checksum package-lock.json)
      jobs:
        - name: Everything
          commands:
            - npm test
```

In this example we dynamically generate a cache key based on the current
content of `package-lock.json`. If we change any our list of dependencies,
the content of `package-lock.json` will change, and the cache would be
invalidated. cache and checksum are part of the Semaphore [toolbox](toolbox).
The approach applies to other languages and uses cases as well.

## Next steps

Production CI/CD often requires use of environment variables and private API
keys. Let's move on to learn how to
[manage sensitive data and environment variables][next].

[toolbox]: https://docs.semaphoreci.com/article/54-toolbox-reference
[next]: https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
