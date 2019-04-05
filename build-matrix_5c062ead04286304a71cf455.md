Build matrix
============

This guide shows how to use [build
matrices](https://docs.semaphoreci.com/article/50-pipeline-yaml#matrix)
to quickly set multiple combinations of environment variables.

Build matrices can be used, for example, to build an application with
different language versions or for trying various combinations of
compilation flags.

To create a build matrix, you must set on `matrix` property on the job
definition. `matrix` takes a list of `env_var` and its possible
`values`.

A build matrix will produce as many job instances as its cartesian
product, i.e. all the possible variable state combinations. Thus, for
example, a matrix of a single variable with 3 values generates 3 job
executions. A matrix of 2 variables with 3 values each will cause 3 \* 3
= 9 job instances to be created.

A simple example
----------------

This is a simple example of a build matrix in action. The matrix has 2
variables, each with 3 possible values:

<pre><code class="language-yaml">
version: v1.0
name: Test matrix
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: "Matrix"
    task:
      jobs:
      - name: Matrix
        # here we define a 3 by 3 matrix with 2 variables
        matrix:
          - env_var: VAR1
            values: [ "A", "B", "C" ]
          - env_var: VAR2
            values: [ "1", "2", "3" ]
        # all possible combinations are executed: a total of 9 job instances
        commands:
          - echo VAR1=$VAR1 VAR2=$VAR2
</code></pre>

After the pipeline completes, the job will have been executed 9 times to
cover all possible combinations of variable states:

-   VAR1=A VAR2=1
-   VAR1=A VAR2=2
-   VAR1=A VAR2=3
-   VAR1=B VAR2=1
-   VAR1=B VAR2=2
-   VAR1=B VAR2=3
-   VAR1=C VAR2=1
-   VAR1=C VAR2=2
-   VAR1=C VAR2=3

Building with various C versions
--------------------------------

In the following example, a C project is built against multiple GCC
versions.

-   Based on
    <https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/tree/.semaphore/semaphore.yml>

<pre><code class="language-yaml">
blocks:
  - name: "Build gcc"
    task:

      prologue:
        commands:
          - sudo apt update
          - sudo apt --yes install docbook-xsl liblzma-dev zlib1g-dev cython linux-headers-generic libssl-dev
          - checkout

      jobs:
        - name: Build gcc
          matrix:
            - env_var: GCC_VERSION
              values: ["6", "7", "8"]
          commands:
            - sem-version c $GCC_VERSION

      epilogue:
        commands:
          - ./autogen.sh c
          - make
</code></pre>

The resulting build matrix run the job 3 times. The `prologue` and
`epilogue` are also executed, respectively, at the start of end of each
job instance, thus these sections are also run 3 times in total.

Testing with different Java versions
------------------------------------

This example shows how to test a Scala project with different Java
versions.

-   Based on:
    <https://github.com/semaphoreci-demos/semaphore-demo-scala-play>

<pre><code class="language-yaml">
blocks:
  - name: "Scala with Play"
    task:

      env_vars:
        - name: SCALA_VERSION
          value: "2.12.6"

      prologue:
        commands:
          - cd $HOME
          - ls -lah
          - checkout
          - sem-version scala 2.12
          # notice we use the JAVA_VERSION defined in the build matrix
          # this allows for version-dependent caches
          - cache restore sbt-java$JAVA_VERSION-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt),sbt-java$JAVA_VERSION-$SEMAPHORE_GIT_BRANCH,sbt-java$JAVA_VERSION-master
          - cache restore ivy2-java$JAVA_VERSION-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt),ivy2-java$JAVA_VERSION-$SEMAPHORE_GIT_BRANCH,ivy2-java$JAVA_VERSION-master
          - cache restore gradle-java$JAVA_VERSION-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt),gradle-java$JAVA_VERSION-$SEMAPHORE_GIT_BRANCH,gradle-java$JAVA_VERSION-master

      jobs:
        - name: Tests
          # here we ask to run the job twice: JAVA_VERSION=8 and JAVA_VERSION=11
          matrix:
            - env_var: JAVA_VERSION
              values: ["8", "11"]
          commands:
            - sem-version java $JAVA_VERSION
            - ./scripts/test-sbt
            - ./scripts/test-gradle

      epilogue:
        commands:
        - cd $HOME
        - ls -lah
          # notice we use the JAVA_VERSION defined in the build matrix
          # this allows for version-dependent caches
        - cache store sbt-java$JAVA_VERSION-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt) .sbt
        - cache store ivy2-java$JAVA_VERSION-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt) .ivy2/cache
        - cache store gradle-java$JAVA_VERSION-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt) .gradle/caches
</code></pre>

In total, the job will be run twice with the following environment
variables

-   `JAVA_VERSION=8`
-   `JAVA_VERSION=11`

Notice that `$JAVA_VERSION` has been added to both `cache store` and
`cache restore` commands. This effectively makes for version-dependent
caches, the generated files for different Java versions are stored on
separate caches.
