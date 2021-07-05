---
description: This guide provides an explanation on how to configure Java projects on Semaphore 2.0. It provides example projects as well that should help you get started.
---

# Java

This guide will help you get started with a Java project on Semaphore.
If you’re new to Semaphore please read our
[Guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) first.

## Hello world

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Java example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Hello world
    task:
      jobs:
        - name: Run java
          commands:
            - java --version
            - mvn -v
```

## Example project with Spring Boot and Docker

Semaphore provides a tutorial and demo application with a working
CI/CD pipeline that you can use to get started quickly:

- [Java Spring CI/CD tutorial][tutorial]
- [Demo project on GitHub][demo-project]

## Supported Java versions

Semaphore supports all versions of Java. You have the following options:

- Linux: Java and related tools are available out-of-the-box in the
  [Ubuntu 18.04 VM image][ubuntu-java].
- Docker: Use [your own Docker image][docker-env] with the version of Java and other
  packages that you need.

Follow the links above for details on currently available language versions and
additional tools.

#### Selecting a Java version on Linux

The [Linux VM][ubuntu1804] provides multiple versions of Java.
You can switch between them using the [`sem-version` tool][sem-version].

For example, in your `semaphore.yml`:

```
sem-version java 11
```

If the version of Java that you need is not currently available in the Linux VM,
we recommend running your jobs in [a custom Docker image][docker-env].

## Dependency caching

Here's an example of [caching dependencies][caching] using Maven.
You may also cache compiled code and tests as well. The exact
implementation varies depending on your tools.
In the following configuration example, we download dependencies, compile
code and warm the cache in the first block, then use the cache in
subsequent blocks.

``` yaml
version: v1.0
name: Java & Maven Example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Setup
    task:
      env_vars:
        # Set maven to use a local directory. This is required for
        # the cache util. It must be set in all blocks.
        - name: MAVEN_OPTS
          value: "-Dmaven.repo.local=.m2"
      jobs:
        - name: Dependencies
          commands:
            - checkout
            - cache restore
            # Download all JARs possible and compile as much as possible
            # Use -q to reduce output spam
            - mvn -q dependency:go-offline test-compile
            - cache store
  - name: Tests
    task:
      env_vars:
        - name: MAVEN_OPTS
          value: "-Dmaven.repo.local=.m2"
      prologue:
        commands:
          - checkout
          - cache restore
      jobs:
        - name: Everything
          commands:
            # Again, -q to reduce output spam. Replace with command
            # that executes tests
            - mvn -q package
```

[tutorial]: https://docs.semaphoreci.com/examples/java-spring-continuous-integration/
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-java-spring
[ubuntu-java]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/#java-and-jvm-languages
[ubuntu1804]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/
[macos-java]: https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/#java
[docker-env]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/
[sem-version]: https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/
[caching]: https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/
