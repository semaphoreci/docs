* [Supported Java versions](#supported-java-versions)
* [Dependency Caching](#dependency-caching)

This guide covers configuring Java projects on Semaphore.
If you’re new to Semaphore please read our
[Guided tour](https://docs.semaphoreci.com/article/77-getting-started) first.

## Supported Java versions

Semaphore provides major Java versions and tools preinstalled.
You can find information about them in the
[Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image#java-and-jvm-languages).

Java 8 and 10 are supported. Java 8 is the default. You can switch to
Java 10 with `sem-version`. Here's an example:

<pre><code class="language-yaml">
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sem-version java 10
      jobs:
        - name: Tests
          commands:
            - java --version
</code></pre>

## Dependency caching

Assuming you're using Maven, it's possible to cache dependencies.
You may also cache compiled code and tests as well. The exact
implementation varies depending on your tools.
In the following configuration example, we download dependencies, compile
code and warm the cache in the first block, then use the cache in
subsequent blocks.

<pre><code class="language-yaml">version: v1.0
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
            - cache restore maven-$SEMAPHORE_GIT_BRANCH-$(checksum pom.xml),maven-$SEMAPHORE_GIT_BRANCH,maven-master
            # Download all JARs possible and compile as much as possible
            # Use -q to reduce output spam
            - mvn -q dependency:go-offline test-compile
            - cache store maven-$SEMAPHORE_GIT_BRANCH-$(checksum pom.xml) .m2
            - cache store build-$SEMAPHORE_GIT_SHA target
  - name: Tests
    task:
      env_vars:
        - name: MAVEN_OPTS
          value: "-Dmaven.repo.local=.m2"
      prologue:
        commands:
          - checkout
          - cache restore maven-$SEMAPHORE_GIT_BRANCH-$(checksum pom.xml),maven-$SEMAPHORE_GIT_BRANCH,maven-master
          - cache restore build-$SEMAPHORE_GIT_SHA
      jobs:
        - name: Everything
          commands:
            # Again, -q to reduce output spam. Replace with command
            # that executes tests
            - mvn -q package
</code></pre>
