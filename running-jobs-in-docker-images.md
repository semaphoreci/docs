Semaphore CI/CD jobs can be run inside custom of Docker images. This allows you
to define a custom build environment with pre-installed tools and dependencies
needed for your project.

Table of contents

* [Define the docker image for your Agents](#define-the-docker-image-for-your-agents]
* [Use multiple Docker images](#use-multiple-docker-images)
* [See also](#see-also)

## Define the container image for your Agents

To run your commands inside of Docker image, define the `containers` section in
your agent specification.

For example, in the following pipeline we will use the `semaphoreci/ruby-2.6.1`
image for our tests.

<pre><code class="language-yaml"># .semaphore/semaphore.yml
version: v1.0
name: Hello Docker
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

  containers:
    - name: main
      image: semaphoreci/ruby-2.6.1

blocks:
  - name: "Hello"
    task:
      jobs:
      - name: Hello
        commands:
          - checkout
          - ruby --version
</code></pre>

**Note: The example image `semaphoreci/ruby.2.6.1` is part of the pre-built
Docker images optimized for Semaphore CI/CD jobs.**

## Use multiple Docker image

An Agent can use multiple Docker images to run your jobs. In this scenario, the
job's commands are run in the first Docker image, while the rest of the Docker
images are linked and available to that first image.

For example, if your tests depend on a running Postgres database and a Redis
key-value store you can define them in the containers section.

<pre><code class="language-yaml"># .semaphore/semaphore.yml
version: v1.0
name: Hello Docker
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

  containers:
    - name: main
      image: semaphoreci/ruby-2.6.1

    - name: db
      image: postgres:9.6
      env_vars:
        - name: POSTGRES_PASSWORD
          value: keyboard-cat

    - name: cache
      image: redis:5.0

blocks:
  - name: "Hello"
    task:
      jobs:
      - name: Hello
        commands:
          # create a database by connecting to 'db' container
          - PGPASSWORD="keyboard-cat" createdb -U postgres -h db -p 5432

          # list key in redis container by connecting to the cache container
          - redis-cli -h cache "KEYS *"
</code></pre>

## Using custom Docker images in your jobs


