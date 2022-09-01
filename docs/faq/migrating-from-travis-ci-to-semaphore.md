---
description: This guide outlines the key differences between Travis CI and Semaphore 2.0 and provides you with a direction to migrate to Semaphore 2.0.
---

# Migrating from Travis CI to Semaphore

In this document, you will find an overview of the main differences between Travis CI and Semaphore, 
as well as an overview of how to migrate from Travis CI to Semaphore.

## Why migrate from Travis CI to Semaphore?



## Key concepts

### Using Docker containers

Semaphore provides a series of convenience Docker images that are hosted on the Semaphore Container Registry. 
Using these images results in much faster downloads since the images will be pulled from the Semaphore Container Registry. 
And you’re not limited to the images in the registry, you can use any image from any provider.

To see how to work with a Docker environment, refer to [Custom CI/CD Environment with Docker][custom-cicd-docker]. 
To see all available convenience images, refer to [Semaphore Registry Images][semaphore-registry-images].

Travis CI doesn't support running your build inside a Docker container nor it provides a Docker Registry.

### Using variables and secrets

Both Travis CI and Semaphore support adding environment variables to the builds by configuring the pipeline file. 

Travis CI and Semaphore also support creating secrets via the UI. 
Additionally, Semaphore allows for creating and editing secrets using the sem CLI.

To see how to add environment variables to the jobs, refer to [Environment variables][environment-variables]. 
To see how to create encrypted secrets, refer to [Using Secrets][secrets].

### Caching

Both Travis CI and Semaphore support manually caching files. 
However, Travis CI doesn't allow for cache versioning because it's not possible to establish individual names for cache packages. 
Semaphore keeps the cache within its own infrastructure which makes for faster cache operation times.
An example from each platform is shown below:


<table>
  <thead>
    <tr>
      <th>Travis CI</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
language: ruby
cache: bundler
    </pre>
      </td>
      <td valign="top">
        <pre lang=yaml>
- name: Cache gems
  commands:
    - cache store bundle-gems-$(checksum Gemfile.lock) vendor/bundle
      </td>
    </tr>
  </tbody>
  </table>

Additionally, Semaphore provides a method to automatically store or restore dependencies into or from default paths. 
This feature works with various languages and dependency managers.

To see how to use the cache mechanism, refer to [Caching][caching].

### Artifacts

Both Travis CI and Semaphore support a method to persist data between jobs called Artifacts. 

An example from each platform is shown below:

<table>
  <thead>
    <tr>
      <th>Travis CI</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
addons:
  artifacts:
    # ⋮
    paths:
    - $HOME/project/test.log
    </pre>
      </td>
      <td valign="top">
        <pre lang=yaml>
- name: Make
  commands:
    - artifact push job test.log
    </pre>
      </td>
    </tr>
  </tbody>
  </table>
  
Additionally, Semaphore allows the creation of Artifacts at the job, workflow and project level.

To see more details about this feature, refer to [Artifacts][artifacts].

### Specifying language versions

Both Travis CI and Semaphore allow you to use specific language versions. 
Github Actions uses the **rvm** keyword while Semaphore incorporates **sem-version** in its toolbox. 

Examples from each platform are shown below:

<table>
  <thead>
    <tr>
      <th>Travis CI</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
language: ruby
rvm:
  - 3.1
    </pre>
      </td>
      <td valign="top">
        <pre lang=yaml>
jobs:
  - name: Using sem-version
      commands:
        - sem-version ruby 3.1
    </pre>
      </td>
    </tr>
  </tbody>
  </table>

To see more details about the **sem-version** tool, refer to [Selecting language versions][language-versions].

### Using databases

Both Travis CI and Semaphore support starting a database and other services. 
Travis CI uses **services** while Semaphore incorporates **sem-service** in its toolbox.

Examples from each platform are shown below:

<table>
  <thead>
    <tr>
      <th>Travis CI</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
services:
  - redis-server
    </pre>
      </td>
      <td valign="top">
        <pre lang=yaml>
 jobs:
 - name: Redis
     commands:
       - sem-service start redis
    </pre>
      </td>
    </tr>
  </tbody>
  </table>
  
To see how to use **sem-service** and all the supported databases and other services, 
refer to [sem-service: Managing Databases and Services on Linux][sem-service].

### Complete example

<table>
  <thead>
    <tr>
      <th>Travis CI</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
language: ruby
rvm:
  - 3.1
cache:
  - bundler
  - yarn
services:
  - postgresql
before_install:
  - nvm install --lts
before_script:
  - bundle install --jobs=3 --retry=3
  - yarn
  - bundle exec rake db:create
  - bundle exec rake db:schema:load
script:
  - bundle exec rake test
  - bundle exec rake test:system
    </pre>
      </td>
      <td valign="top">
        <pre lang=yaml>
version: v1.0
name: Example pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Setup
    task:     
      prologue:
        commands:
          - checkout
          - cache restore
          - sem-version ruby 3.1
          - sem-service start postgres
          - nvm install --lts
      jobs:
        - name: Bundle
          commands:
            - bundle install --path vendor/bundle
            - yarn
            - bundle exec rake db:create
            - bundle exec rake db:schema:load
            - bundle exec rake test
            - bundle exec rake test:system
            - cache store
    </pre>
      </td>
    </tr>
  </tbody>
  </table>


[parametrized-promotions]: ../essentials/deploying-with-promotions.md
[ssh-session]: ../essentials/debugging-with-ssh-access.md
[trial]: https://id.semaphoreci.com/
[book-demo]: https://semaphoreci.com/product/schedule-demo
[custom-cicd-docker]: ../ci-cd-environment/custom-ci-cd-environment-with-docker.md
[semaphore-registry-images]: ../ci-cd-environment/semaphore-registry-images.md
[environment-variables]: ../essentials/environment-variables.md
[secrets]: ../essentials/using-secrets.md
[caching]: ../essentials/caching-dependencies-and-directories.md
[artifacts]: ../essentials/artifacts.md
[language-versions]: ../ci-cd-environment/sem-version-managing-language-versions-on-linux.md
[sem-service]: ../ci-cd-environment/sem-service-managing-databases-and-services-on-linux.md
