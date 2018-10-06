Agents run each job in a clean environment. The default [Ubuntu
VM][machine] includes common tools and databases needed by most
projects. You also have full `sudo` access, so you can install new
software or change whatever you need.

Let's assume you need to start PostgreSQL before each job.

```yml
#.semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - sem-service start postgres:9.6 -e POSTGRES_PASSWORD=password
      jobs:
        - name: Tests
          commands:
            - echo 'running tests'
```

The [Ubuntu machine][machine] includes common databases installed as
services. If the proper version is not pre-installed or your
dependency is not available as a package, then you can start it as a
Docker container with `sem-service`. [sem-service][sem-service]
exposes default ports. Here's an example that starts [local
DynamoDB][local-dynamodb]:

```yml
#.semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - sem-service start amazon/dynamodb-local
      jobs:
        - name: Tests
          commands:
            - echo 'running tests'
```

You also have full access to install any other dependencies. Assume
your projects uses [bats][] for testing. Just add more commands to
prologue:

```yml
#.semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - sudo systemctl start postgresql
          - git clone https://github.com/sstephenson/bats.git
          - cd bats
          - sudo ./install.sh /usr/local
      jobs:
        - name: Tests
          commands:
            - echo 'running tests'
```

Refer back [Ubuntu VM][machine] reference to a complete list of
pre-installed databases and software. Next, [configure secrets and
environment variables][next].

[machine]: https://docs.semaphoreci.com/article/32-ubuntu-1804-image
[next]: https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
[sem-service]: https://docs.semaphoreci.com/article/54-toolbox-reference#sem-service
