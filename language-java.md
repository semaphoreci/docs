* [Supported Versions](#supported-versions)
* [Dependency Caching](#dependency-caching)

## Supported Versions

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

## Dependency Caching

Assuming you're using Maven, then it's possible to cache dependencies.
You may also cache compiled code and tests as well. The extract
implementation varies depending on your tools. You'll need on block to
download all dependencies and compile the code. Then use the cache in
subsequent blocks.

<pre><code class="language-yaml">
version: v1.0
name: Java & Maven Example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Warm cache
    task:
      env_vars:
        # Set maven to use a local directory. This is required for
        # the cache util. It must be set for all blocks.
        - name: MAVEN_OPTS
          value: "-Dmaven.repo.local=.m2"
      jobs:
        - name: Dependencies
          commands:
            - checkout
            - cache restore v1-maven-$(checksum pom.xml)
            # Download all JARs possible and compile as much as possible
            # Use -q to reduce output spam
            - mvn -q dependency:go-offline test-compile
            - cache store v1-maven-$(checksum pom.xml) .m2
            - cache store v1-build-$SEMAPHORE_GIT_SHA target
  - name: Tests
    task:
      env_vars:
        - name: MAVEN_OPTS
          value: "-Dmaven.repo.local=.m2"
      prologue:
        commands:
          - checkout
          - cache restore v1-maven-$(checksum pom.xml)
          - cache restore v1-build-$SEMAPHORE_GIT_SHA
      jobs:
        - name: Everything
          commands:
            # Again, -q to reduce output spam. Replace with command
            # that executes tests
            - mvn -q package
</code></pre>
