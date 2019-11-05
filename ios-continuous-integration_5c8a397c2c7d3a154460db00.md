This guide gives an overview of CI/CD with Semaphore for apps created with
Xcode that run on iOS, macOS, watchOS, or tvOS.

Semaphore supports building, testing, and deploying Swift, Objective-C and
React Native projects. Projects can be built with
[Xcode 10](macos-mojave-xcode10) or [Xcode 11](macos-mojave-xcode10) running on
macOS Mojave on an `a1-standard-4` [machine type][machine-types].

**Table of contents**

- [Demo project](#example-project)
- [Overview of the CI pipeline](#overview-of-the-ci-pipeline)
- [Sample configuration](#sample-configuration)
- [Configuration walkthrough](#configuration-walkthrough)
  - [Naming your pipeline](#naming-your-pipeline)
  - [Defining the agent](#defining-the-agent)
  - [Defining blocks](#defining-blocks)
  - [Downloading code](#downloading-code)
  - [Installing dependencies](#installing-dependencies)
  - [Selecting Xcode version](#selecting-xcode-version)
  - [Running tests](#running-tests)
  - [Fastfile](#fastfile)
  - [Building your app](#building-your-app)
  - [Releasing your app](#releasing-your-app)
- [Run the demo project yourself](#run-the-example-project-yourself)

## Example project

Semaphore maintains an example iOS app written in Swift 5.1 and SwiftUI to
demonstrate how to get an Xcode CI/CD environment up and running:

- [TallestTowers example project on GitHub][example-project]

This example project includes an annotated Semaphore configuration file,
[`.semaphore/semaphore.yml`](https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode/blob/master/.semaphore/semaphore.yml) and uses [fastlane](fastlane) for its CI pipeline with the
[Semaphore fastlane plugin][fastlane-plugin].

## Overview of the CI pipeline

The Semaphore pipeline is configured to:

- Run all unit and UI tests.
- Build the app and generate an `ipa` archive.

Taking the the `.semaphore/semaphore.yml` from this example project can be a
good way to get *your* app up and running on with Semaphore.

### Related guides:

- [Code signing for iOS projects][code-signing]
- [TestFlight integration][testflight]
- [HockeyApp integration][hockeyapp]

## Sample pipeline configuration

The following `.semaphore/semaphore.yml` configuration is used in the
[example project][example-project]:

``` yaml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name your pipeline. In case you connect multiple pipelines with promotions,
# the name will help you differentiate between, for example, a CI build phase
# and delivery phases.
name: Tallest Towers

# An agent defines the environment in which your code runs.
# It is a combination of one of available machine types and operating
# system images.
# See https://docs.semaphoreci.com/article/20-machine-types
# and https://docs.semaphoreci.com/article/162-macos-mojave-xcode-11-image
agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave-xcode11

# Blocks are the heart of a pipeline and are executed sequentially.
# Each block has a task that defines one or more jobs. Jobs define the
# commands to execute.
# See https://docs.semaphoreci.com/article/62-concepts
blocks:
  - name: Run tests
    task:
      # Set environment variables that your project requires.
      # See https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
      env_vars:
        - name: LANG
          value: en_US.UTF-8
      prologue:
        commands:
          # Download source code from GitHub:
          - checkout

          # Restore dependencies from cache. This command will not fail in
          # case of a cache miss. In case of a cache hit, bundle  install will
          # complete in about a second.
          # For more info on caching, see https://docs.semaphoreci.com/article/68-caching-dependencies
          - cache restore
          - bundle install --path vendor/bundle
          - cache store
      jobs:
        - name: Test
          commands:
            # Select an Xcode version, for available versions
            # See https://docs.semaphoreci.com/article/162-macos-mojave-xcode-11-image
            - bundle exec xcversion select 11.1

            # Run tests of iOS and Mac app on a simulator or connected device
            # See https://docs.fastlane.tools/actions/scan/
            - bundle exec fastlane test

  - name: Build app
    task:
      env_vars:
        - name: LANG
          value: en_US.UTF-8
      prologue:
        commands:
          - checkout
          - cache restore
          - bundle install --path vendor/bundle
          - cache store
      jobs:
        - name: Build
          commands:
            - bundle exec xcversion select 11.1
            - bundle exec fastlane build
```

## Configuration walkthrough

### Naming your pipeline

``` yaml
version: v1.0
name: Tallest Towers
```

**Note:** If you choose to connect multiple pipelines with
[promotions](promotions), the pipeline name will help you differentiate between
them. For example, you might have a build phase and a delivery phase.

### Defining the agent

The agent defines the environment in which your CI runs. It is a combination of
a machine type and an operating system image. For a project
built with Xcode you must use one of the Apple
[machine types][machine-types], coupled with a macOS Mojave image running either
[Xcode 10](macos-mojave-xcode10) or [Xcode 11](macos-mojave-xcode11).

``` yaml
agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave-xcode11
```

### Defining blocks

Blocks are the heart of a pipeline and are executed sequentially.
Each block has a task that defines one or more parallel jobs. Jobs define
commands that should be executed by the pipeline.

Blocks, tasks and jobs are Semaphore's [core concepts][concepts].

``` yaml
blocks:
  - name: Run tests
    task:
      # This environment variable is exported in every job within this block:
      env_vars:
        - name: LANG
          value: en_US.UTF-8
      prologue:
        commands:
          - # Commands to run before *every* parallel job
      jobs:
        - name: Run tests
          commands:
            - bundle exec xcversion select 11.1
            - bundle exec fastlane test
        - name: Second parallel job
          commands:
            - # Commands for the second parallel job
            - # ...
        - name: Third parallel job
          commands:
            - # Commands for the third parallel job
            - # ...
```

### Downloading code

To download your code in a job, use [`checkout`][checkout], an
[open source script][checkout-source] provided by Semaphore.

By default `checkout` performs a shallow git clone from a remote origin. If you
need a full clone that will be cached by Semaphore, use `checkout --use-cache`.

``` yaml
commands:
  - checkout
```

### Installing dependencies

Semaphore can install dependencies from *any* supported language. Using the
versatile [`cache`][cache-command] command, you can save time by reusing the
same dependencies across multiple blocks and workflows.

``` yaml
commands:
  - cache restore
  - bundle install --path vendor/bundle
  - cache store
```

In the example configuration, the first command restores dependencies from
cache using partial cache key matching:

1. The ideal scenario is to match `gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock)`.
   This means that we've found dependencies from the current Git branch, and
   current content of dependencies' lock file. `$SEMAPHORE_GIT_BRANCH` is one of
   the [environment variables][env-vars] provided by Semaphore in every job.
   [`checksum`][checksum] is a script that returns MD5 sum of provided file.
2. The second best option is to find any previous version of dependencies for
   the current Git branch, using `gems-$SEMAPHORE_GIT_BRANCH-` as key.
3. The last option is to reuse the last available cache from the master branch.

The `cache restore` command will not fail in case of a cache miss. In the case
of a cache hit, `bundle install` will complete in about a second.

After installing the dependencies, Semaphore stores them in cache for reuse in
upcoming blocks and future workflows.

### Selecting an Xcode version

You can find the list of available versions of Xcode on the
[Xcode 10](macos-mojave-xcode10) or [Xcode 11](macos-mojave-xcode10) image
references. Select the desired version for your project with `xcversion`.

``` yaml
commands:
  - bundle exec xcversion select 11.1
```

### Running tests

Semaphore can run tests of apps built with Xcode either on a simulator or a
connected device. If you're using fastlane, see the
[fastlane scan][fastlane-scan] documentation.
.

``` yaml
commands:
  - bundle exec fastlane test
```

### Building your app

The example project is set to build the app with `fastlane build`.
The [Semaphore fastlane plugin][fastlane-plugin] ensures that by default the
process runs smoothly with a temporary keychain.

``` yaml
commands:
  - bundle exec fastlane build
```

### Fastfile

The example project uses the [Semaphore fastlane plugin](fastlane-plugin):

``` ruby
default_platform(:ios)

before_all do
  # Install with `fastlane add_plugin semaphore`
  setup_semaphore
end

platform :ios do
  lane :build do
    gym(scheme: 'TallestTowers',
        skip_package_ipa: true,
        skip_archive: true,
        clean: true)
  end

  lane :test do
    run_tests(scheme: 'TallestTowers',
              devices: ['iPhone 8', 'iPhone 11 Pro'])
  end
end
```

### Releasing your app

To manage your developer credentials on Semaphore, use
[encrypted secrets][encrypted-secrets]. To manage releases,
[set up promotions][promotions] to trigger additional pipelines.

## Run the demo project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][example-project] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Create your secret as per instructions above.
5. Edit any file and push GitHub, and Semaphore will run the CI/CD pipeline.

### Related guides:

- [Code signing for iOS projects][code-signing]
- [TestFlight integration][testflight]
- [HockeyApp integration][hockeyapp]

[macos-mojave-xcode10]: https://docs.semaphoreci.com/article/161-macos-mojave-xcode-10-image
[macos-mojave-xcode11]: https://docs.semaphoreci.com/article/162-macos-mojave-xcode-11-image
[machine-types]: https://docs.semaphoreci.com/article/20-machine-types
[example-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
[gym]: https://docs.fastlane.tools/actions/build_app/
[concepts]: https://docs.semaphoreci.com/article/62-concepts
[checkout]: https://docs.semaphoreci.com/article/54-toolbox-reference#checkout
[checkout-source]: https://github.com/semaphoreci/toolbox/blob/master/libcheckout
[cache-command]: https://docs.semaphoreci.com/article/54-toolbox-reference#cache
[env-vars]: https://docs.semaphoreci.com/article/12-environment-variables
[checksum]: https://docs.semaphoreci.com/article/54-toolbox-reference#checksum
[fastlane]: https://fastlane.tools/
[fastlane-scan]: https://docs.fastlane.tools/actions/scan/
[fastlane-plugin]: https://github.com/semaphoreci/fastlane-plugin-semaphore
[encrypted-secrets]: https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
[promotions]: https://docs.semaphoreci.com/article/67-deploying-with-promotions
[code-signing]: https://docs.semaphoreci.com/article/134-code-signing-for-ios-projects
[testflight]: https://docs.semaphoreci.com/article/137-testflight-ios-app-distribution
[hockeyapp]: https://docs.semaphoreci.com/article/138-hockeyapp-ios-app-distribution
