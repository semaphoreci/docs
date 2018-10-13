Semaphore runs each job in a clean and isolated environment.
The default [Ubuntu environment][ubuntu] includes common tools needed by most
projects. With unrestricted `sudo` access and fast network, you can
install additional software and customize the environment however you need.

## Installing additional dependencies

Let's say that your project uses Bats, which is hosted on GitHub, to test
your Bash scripts. You can easily make it available on Semaphore by copying
the installation commands from the project's Readme into your prologue:

<pre><code class="language-yaml"># .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - git clone https://github.com/bats-core/bats-core.git
          - cd bats
          - sudo ./install.sh /usr/local
      jobs:
        - name: Tests
          commands:
            - bats addition.bats
</code></pre>

## Using databases and other services

Let's say that your CI build needs Redis and a specific version of PostgreSQL:

<pre><code class="language-yaml"># .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - sem-service start redis
          - sem-service start postgres:9.6 -e POSTGRES_PASSWORD=password
      jobs:
        - name: Tests
          commands:
            - echo 'running tests'
</code></pre>

To manage database engines and other services on Semaphore 2.0,
use the [sem-service utility][sem-service]. Services are based on public Docker
images hosted on [Docker Hub Library](dockerhub-lib) and exposed on
default ports in localhost.

You can use any image available on Docker Hub Library.
Here's an example that starts RabbitMQ and ElasticSearch:

<pre><code class="language-yaml"># .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - sem-service start rabbitmq
          - sem-service start elasticsearch:6.4.2
      jobs:
        - name: Tests
          commands:
            - echo 'running tests'
</code></pre>

## Next steps

Production CI/CD often requires use of environment variables and private API
keys. Let's move on to learn how to
[manage sensitive data and environment  variables][next].

[ubuntu]: https://docs.semaphoreci.com/article/32-ubuntu-1804-image
[sem-service]: https://docs.semaphoreci.com/article/54-toolbox-reference#sem-service
[dockerhub-lib]: https://hub.docker.com/u/library/
[next]: https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
