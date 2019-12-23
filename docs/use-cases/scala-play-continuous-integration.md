# Scala Play Continuous Integration

This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for Scala Play web application.

## Demo project

Semaphore maintains an example Scala Play project:

- [Demo Scala Play project on GitHub][demo-project]

In the repository you will find an annotated Semaphore configuration file
`.semaphore/semaphore.yml`.

The application uses sbt and Gradle.

## Overview of the CI pipeline

The demo Scala Play CI pipeline performs a build matrix with two parallel jobs,
each running on a different version of Java. The build runs sbt and Gradle
tasks.

## Sample configuration

Project is using the following configuration. If you're new to Semaphore, we
recommend going through the [guided tour][guided-tour] and linked documentation
pages for more information

``` yaml
# .semaphore/semaphore.yml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name of your pipeline. In this example we connect two pipelines with
# a promotion, so it helps to differentiate what's the job of each.
name: Semaphore example for Scala Play

# An agent defines the environment in which your code runs.
# It is a combination of one of available machine types and operating
# system images. See:
# - https://docs.semaphoreci.com/article/20-machine-types
# - https://docs.semaphoreci.com/article/32-ubuntu-1804-image
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

# Blocks define the structure of a pipeline and are executed sequentially.
# Each block has a task that defines one or many parallel jobs. Jobs define
# the commands to execute.
# - https://docs.semaphoreci.com/article/62-concepts
blocks:
  - name: "Scala with Play"
    task:
      env_vars:
        # Define an environment variable
        # Needed for use in scripts/test-sbt and scripts/test-gradle
        # - https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
        - name: SCALA_VERSION
          value: "2.12.6"
      # Commands in prologue run at the beginning of each parallel job.
      # - https://docs.semaphoreci.com/article/50-pipeline-yaml
      prologue:
        commands:
          - cd $HOME
          - ls -lah
          # Checkout code from Git repository. This step is mandatory if the
          # job is to work with your code.
          - checkout
          # sem-version expects binary version:
          - sem-version scala 2.12
          # Restore dependencies from cache, command won't fail if key is
          # missing. More on caching:
          # - https://docs.semaphoreci.com/article/54-toolbox-reference#cache
          - cache restore sbt-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt),sbt-$SEMAPHORE_GIT_BRANCH,sbt-master
          - cache restore ivy2-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt),ivy2-$SEMAPHORE_GIT_BRANCH,ivy2-master
          - cache restore gradle-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt),gradle-$SEMAPHORE_GIT_BRANCH,gradle-master
      jobs:
        - name: Tests
          # Define variables for a build matrix
          # - https://docs.semaphoreci.com/article/50-pipeline-yaml#matrix
          matrix:
            - env_var: JAVA_VERSION
              values: ["8", "11"]
          commands:
            - sem-version java $JAVA_VERSION
            - ./scripts/test-sbt
            - ./scripts/test-gradle
      # Commands in epilogue run at the end of each parallel job.
      epilogue:
        commands:
        - cd $HOME
        - ls -lah
        - cache store sbt-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt) .sbt
        - cache store ivy2-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt) .ivy2/cache
        - cache store gradle-$SEMAPHORE_GIT_BRANCH-$(checksum $SEMAPHORE_PROJECT_NAME/build.sbt) .gradle/caches
```

## Run the demo Play project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][demo-project] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Create your secret as per instructions above.
5. Edit any file and push GitHub, and Semaphore will run the CI/CD pipeline.

## Next steps

Congratulations! You have set up your first Scala continuous integration
project on Semaphore. As the next step you will probably want to configure
deployment. For more information and practical examples, see:

- [Deploying with promotions][promotions], a general introduction in Semaphore
  guided tour.
- [Deployment tutorials and example projects][deployment-tutorials]

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-scala-play
[guided-tour]: https://docs.semaphoreci.com/category/56-guided-tour
[promotions]: https://docs.semaphoreci.com/article/67-deploying-with-promotions
[deployment-tutorials]: https://docs.semaphoreci.com/article/123-tutorials-and-example-projects#deployment
