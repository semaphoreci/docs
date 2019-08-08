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
            - cache restore
            - npm install
            - cache store

  - name: Tests
    task:
      prologue:
        commands:
          - checkout
          - cache restore
      jobs:
        - name: Everything
          commands:
            - npm test
```

The example above uses a cache command - `cache store` and `cache restore`.
The [cache][caching] command recognizes the project structure
and automatically store and restore dependencies.

If we change any of our dependencies, the content of `package-lock.json` will
change, and the cache would be invalidated. Since `cache restore` does partial
matching, Semaphore will attempt to reuse cache from any previous revision of
the current Git branch. If there is none, then it will reuse the last available
cache created by the master branch.

This strategy ensures best cache hit rate through the lifetime of your project.

## Next steps

Production CI/CD often requires use of environment variables and private API
keys. Let's move on to learn how to
[manage sensitive data and environment variables][next].

[caching]: (https://docs.semaphoreci.com/article/149-caching)
[toolbox]: https://docs.semaphoreci.com/article/54-toolbox-reference
[env-vars]: https://docs.semaphoreci.com/article/12-environment-variables
[next]: https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
