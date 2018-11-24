Semaphore runs each job in a clean and isolated environment.
The default [Ubuntu environment][ubuntu] includes common tools needed by most
projects. With unrestricted `sudo` access and fast network, you can
install additional software and customize the environment however you need.

## Installing additional dependencies

Let's say that your project uses Bats, which is hosted on GitHub, to test
your Bash scripts. You can easily make it available on Semaphore by copying
the installation commands from the project's Readme into your prologue:

<pre><code># .semaphore/semaphore.yml
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

Let's say that your CI build needs Redis and PostgreSQL:

<pre><code># .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - sem-service start redis
          - sem-service start postgres
      jobs:
        - name: Tests
          commands:
            - createdb -U postgres -h 0.0.0.0 myapp_database
            - echo 'running tests'
</code></pre>

To manage database engines and other services on Semaphore,
use the [sem-service utility][sem-service].

Since you have unrestricted access to the job's environment, other options for
running services include installing native packages with `sudo` and using
Docker Compose.

### Using services and test data across blocks

Note that, since all jobs run in isolated environments, the services that you
start in one block are not automatically available in other blocks.
Likewise, starting a service in one job, doesn't automatically make it
available in other jobs of the same block.

To use a service or populate test data in all parallel jobs within a block,
specify that in the task [prologue][prologue]. Repeat the same steps in the definition of each block as needed.

## Next steps

Almost every project has dependencies, and we can save a lot of time by
installing them once and reusing them from a cache. Let's learn how to do that
in [the next section][next].

[ubuntu]: https://docs.semaphoreci.com/article/32-ubuntu-1804-image
[sem-service]: https://docs.semaphoreci.com/article/54-toolbox-reference#sem-service
[prologue]: https://docs.semaphoreci.com/article/50-pipeline-yaml#prologue
[next]: https://docs.semaphoreci.com/article/68-caching-dependencies
