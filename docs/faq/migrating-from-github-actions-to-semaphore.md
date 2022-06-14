---
description: This guide outlines the key differences between Github Actions and Semaphore 2.0 and provides you with a direction to migrate to Semaphore 2.0.
---

# Migrating from GitHub Actions to Semaphore

This document provides an overview of how to migrate your CI/CD from GitHub Actions to Semaphore.

## Why migrate to Semaphore?

Semaphore and GitHub Actions are modern CI/CD tools. Both tools allow you to create workflows and build, test and deploy software. 

While the two products share many similarities, here’s what sets Semaphore apart from GitHub Actions:

1. **Faster builds**. With the help of Semaphore, you can cut down your build time in half.
2. **End-to-end continuous delivery**. With features like [parametrized promotions][parametrized-promotions] and deployment queues, 
your team has the power to deploy to any environment, painlessly.
3. **Increased developer productivity**. Graphical Workflow Builder allows for an easy pipeline setup and editing. 
[SSH debugging][ssh-session] enables fast error recovery.

Semaphore and GitHub Actions have a lot in common in terms of configuration and setup. 
This makes migrating to Semaphore from GitHub Actions easy and straightforward.

There are other features that set Semaphore apart from other CI/CD tools. 
[Start a free 14-day trial][trial] or [book a demo][book-demo] to see Semaphore in action.

## Key concepts

### Using Docker containers

Both Github Actions and Semaphore support running jobs inside of a Docker container. 

Semaphore provides a series of convenience Docker images that are hosted on the Semaphore Container Registry. 
Using these images results in much faster downloads since the images will be pulled from the Semaphore Container Registry.

To see how to work with a Docker environment, refer to [Custom CI/CD Environment with Docker][custom-cicd-docker].
To see all available convenience images, refer to [Semaphore Registry Images][semaphore-registry-images].

### Using variables and secrets

Both Github Actions and Semaphore support adding environment variables to the jobs by configuring the pipeline file. 

Github Actions and Semaphore also support creating secrets via the UI. 
Additionally, Semaphore allows for creating and editing secrets using the sem CLI.

To see how to add environment variables to the jobs, refer to [Environment variables][environment-variables]. 
To see how to create encrypted secrets, refer to [Using Secrets][secrets].

### Caching

Both Github Actions and Semaphore support manually caching files. 
An example from each platform is shown below:


<table>
  <thead>
    <tr>
      <th>Github Actions</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
- name: Cache gems
  uses: actions/cache@v2
  with:
    path: vendor/bundle
    key: bundle-gems-${{ hashFiles('**/Gemfile.lock') }}
    restore-keys: bundle-gems-
    </pre>
      </td>
      <td valign="top">
        <pre lang=yaml>
- name: Cache gems
  commands:
    - cache restore bundle-gems-$(checksum Gemfile.lock)
    - bundle install --deployment --path vendor/bundle
    - cache store bundle-gems-$(checksum Gemfile.lock) vendor/bundle
      </td>
    </tr>
  </tbody>
  </table>
  
Additionally, Semaphore provides a method to automatically store or restore dependencies into or from default paths. 
This feature works with various languages and dependency managers.

To see how to use the cache mechanism, refer to [Caching][caching].

### Artifacts

Both Github Actions and Semaphore support a method to persist data between jobs called Artifacts. 

An example from each platform is shown below:

<table>
  <thead>
    <tr>
      <th>Github Actions</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
- name: Upload test.log
  uses: actions/upload-artifact@v2
  with:
    name: Make
    path: test.log
- name: Download test.log
  uses: actions/download-artifact@v2
  with:
    name: Unit tests
    </pre>
      </td>
      <td valign="top">
        <pre lang=yaml>
- name: Make
  commands:
    - artifact push job test.log
- name: Unit tests
  commands:
    - artifact pull job test.log
    </pre>
      </td>
    </tr>
  </tbody>
  </table>

Additionally, Semaphore allows the creation of Artifacts at the job, workflow and project level.

To see more details about this feature, refer to [Artifacts][artifacts].

### Specifying language versions

Both Github Actions and Semaphore allow you to use specific language versions. 
Github Actions uses the **ruby-setup** action while Semaphore incorporates **sem-version** in its toolbox. 

Examples from each platform are shown below:

<table>
  <thead>
    <tr>
      <th>Github Actions</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
steps:
- uses: ruby/setup-ruby@v1
  with:
    ruby-version: '3.1'
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

Both Github and Semaphore support starting a database via Docker container. 
Github Actions uses **service containers** while Semaphore incorporates **sem-service** in its toolbox.

Examples from each platform are shown below:

<table>
  <thead>
    <tr>
      <th>Github Actions</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
jobs:
  runner-job:
    runs-on: ubuntu-latest
    services:
      redis:
        image: redis
        ports:
          - 6379:6379
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
      <th>Github Actions</th>
      <th>Semaphore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td valign="top">
        <pre lang=yaml>
name: Containers
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    env:
      PGHOST: localhost
      PGUSER: administrate
      RAILS_ENV: test
    services:
      postgres:
        image: postgres:10.1-alpine
        env:
          POSTGRES_USER: administrate
          POSTGRES_DB: ruby25
          POSTGRES_PASSWORD: ""
        ports:
          - 5432:5432
    steps:
      - uses: actions/checkout@v2
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ‘3.1’
      - name: Cache dependencies
        uses: actions/cache@v2
        with:
          path: vendor/bundle
          key: bundle-gems-${{ hashFiles('**/Gemfile.lock') }}
      - name: Install postgres headers
        run: |
          sudo apt-get update
          sudo apt-get install libpq-dev
      - name: Install dependencies
        run: bundle install --path vendor/bundle
      - name: Setup environment configuration
        run: cp .sample.env .env
      - name: Setup database
        run: bundle exec rake db:setup
      - name: Run tests
        run: bundle exec rake
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
      jobs:
        - name: Bundle
          commands:
            - checkout
            - cache restore
            - sem-version ruby 3.1
            - sem-service start postgres 10
            - sudo apt-get update
            - sudo apt-get install libpq-dev
            - bundle install --path vendor/bundle
            - cp .sample.env .env
            - bundle exec rake db:setup
            - bundle exec rake
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
