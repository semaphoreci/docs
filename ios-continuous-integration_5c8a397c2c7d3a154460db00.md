This is a guide to continuous integration for iOS applications created with Xcode.
Semaphore supports building, testing and deploying Swift, Objective-C and React Native
projects via [macOS Mojave VM image][macos-mojave] and [a1-standard machine
types][machine-types].

**Table of contents**

- [Demo project](#demo-project)
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
- [Run the demo project yourself](#run-the-demo-project-yourself)

## Demo project

Semaphore maintains an example iOS Swift project:

- [Demo Swift Xcode project on GitHub][demo-project]

In the repository you will find an annotated Semaphore configuration file
`.semaphore/semaphore.yml`.

The application uses Swift, Xcode and Fastlane with the [Semaphore
plugin][fastlane-plugin].

## Overview of the CI pipeline

The Semaphore pipeline is configured to:

- Run application tests;
- Build the app using [gym][gym], which would generate an `ipa` file signed by
  your developer certificate.

![iOS Xcode CI pipeline](https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode/raw/master/public/ci-pipeline.png)

You can extend the example pipeline to run additional tasks and configuring
beta and release deployment.

Related guides:

- [Code signing for iOS projects][code-signing]
- [TestFlight integration][testflight]
- [HockeyApp integration][hockeyapp]

## Sample configuration

The following configuration is used in the provided [demo
project][demo-project]:

``` yaml
# .semaphore/semaphore.yml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name your pipeline. In case you connect multiple pipelines with promotions,
# the name will help you differentiate between, for example, a CI build phase
# and delivery phases.
name: Semaphore iOS Swift example with Fastlane

# An agent defines the environment in which your code runs.
# It is a combination of one of available machine types and operating
# system images.
# See https://docs.semaphoreci.com/article/20-machine-types
# and https://docs.semaphoreci.com/article/161-macos-mojave-xcode-10-image
agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave-xcode10

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
        - name: Fastlane test
          commands:
            # Select an Xcode version, for available versions
            # See https://docs.semaphoreci.com/article/120-macos-mojave-image
            - bundle exec xcversion select 10.2
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
        - name: Fastlane build
          commands:
            - bundle exec xcversion select 10.2
            # Gym builds and packages iOS apps.
            # See https://docs.fastlane.tools/actions/build_app/
            - bundle exec fastlane build
```

## Configuration walkthrough

### Naming your pipeline

In case you connect multiple pipelines with promotions,
the name will help you differentiate between, for example, a CI build phase
and delivery phases.

``` yaml
version: v1.0
name: Semaphore iOS example
```

### Defining the agent

An agent defines the environment in which your code runs. It is a combination
of one of available machine types and operating system images.

In case of iOS or macOS builds, we want to use one of the Apple [machine
types][machine-types],
coupled with the [macOS Mojave OS image][macos-mojave].

``` yaml
agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave-xcode10
```

### Defining blocks

Blocks are the heart of a pipeline and are executed sequentially.
Each block has a task that defines one or many parallel jobs. Jobs define the
commands to execute. Blocks, tasks and jobs are Semaphore's [core
concepts][concepts].

``` yaml
blocks:
  - name: Run tests
    task:
      env_vars:
        # This environment variable is exported in every job within this block:
        - name: LANG
          value: en_US.UTF-8
      prologue:
        commands:
          - # this runs before every parallel job
      jobs:
        - name: Fastlane test
        commands:
          - # ...
        - name: 2nd parallel job
        commands:
          - # ...
        - name: 3rd parallel job
        commands:
          - # ...
  - name: Build app
    task:
      jobs:
        - name: Fastlane app
        commands:
          - # ...
```

### Downloading code

To download your code in a job, use the [`checkout` command][checkout], an [open
source script][checkout-source] provided by Semaphore.

By default this performs a shallow git clone from remote origin. If you want a
full clone which will be cached by Semaphore, use `checkout --use-cache`.

``` yaml
        commands:
          - checkout
```

### Installing dependencies

Semaphore can install dependencies from any supported language.
Using the versatile [cache tool][cache], you can save time by reusing them
across blocks and workflows.

``` yaml
        commands:
          - cache restore
          - bundle install --path vendor/bundle
          - cache store
```

In example configuration, the first command restores dependencies from cache
using partial cache key matching:

1. Ideal scenario is to match `gems-$SEMAPHORE_GIT_BRANCH-$(checksum Gemfile.lock)`.
   This means that we've found dependencies from the current Git branch, and
   current content of dependencies' lock file. `$SEMAPHORE_GIT_BRANCH` is one of
   the [environment variables][env-vars] provided by Semaphore in every job.
   [`checksum`][checksum] is a script that returns MD5 sum of provided file.
2. The second best option is to find any previous version of dependencies for
   the current Git branch, using `gems-$SEMAPHORE_GIT_BRANCH-` as key.
3. Last option is to reuse the last available cache from the master branch.

The `cache restore` command will not fail in case of a cache miss. In case of a
cache hit, `bundle install` will complete in about a second.

After installing the dependencies, we store them in cache for reuse in upcoming
blocks and future workflows.

### Selecting Xcode version

You can find the list of currently available versions of Xcode in the [macOS
Mojave image reference][macos-mojave].

``` yaml
        commands:
          - bundle exec xcversion select 10.2
```

### Running tests

Semaphore can run tests of iOS and Mac apps on a simulator or connected device.
If you're using Fastlane, see documentation regarding [fastlane
scan][fastlane-scan].

``` yaml
        commands:
          - bundle exec fastlane test
```

### Building your app

We build our app by running `fastlane build`. [The Semaphore Fastlane
plugin][fastlane-plugin] ensures that by default the process runs smoothly with
a temporary keychain.

``` yaml
        commands:
          - bundle exec fastlane build
```

### Fastfile

The example is using the Semaphore Fastlane plugin:

```ruby
# fastlane/Fastfile
default_platform(:ios)

platform :ios do

  before_all do
    # installed via the semaphore plugin with `fastlane add_plugin semaphore`
    setup_semaphore
  end

  desc "Run Tests"
  lane :test do
    scan
  end

  desc "Build"
  desc "Build without code sign. Just to see if the build is working"
  lane :build do |options|
    gym(
      scheme: "HelloWorld",
      skip_package_ipa: true,
      skip_archive: true,
      silent: true,
      clean: true
    )
  end
end
```

### Releasing your app

To manage your developer credentials on Semaphore, use [encrypted
secrets][secrets].

To manage releases, [set up promotions][promotions] to trigger additional pipelines.

Related guides:

- [Code signing for iOS projects][code-signing]
- [TestFlight integration][testflight]
- [HockeyApp integration][hockeyapp]

## Run the demo project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][demo-project] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Create your secret as per instructions above.
5. Edit any file and push GitHub, and Semaphore will run the CI/CD pipeline.

[macos-mojave]: https://docs.semaphoreci.com/article/161-macos-mojave-xcode-10-image
[machine-types]: https://docs.semaphoreci.com/article/20-machine-types
[beta-apply]: https://semaphoreci.com/product/ios
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
[gym]: https://docs.fastlane.tools/actions/build_app/
[concepts]: https://docs.semaphoreci.com/article/62-concepts
[checkout]: https://docs.semaphoreci.com/article/54-toolbox-reference#checkout
[checkout-source]: https://github.com/semaphoreci/toolbox/blob/master/libcheckout
[cache]: https://docs.semaphoreci.com/article/54-toolbox-reference#cache
[env-vars]: https://docs.semaphoreci.com/article/12-environment-variables
[checksum]: https://docs.semaphoreci.com/article/54-toolbox-reference#checksum
[fastlane-scan]: https://docs.fastlane.tools/actions/scan/
[secrets]: https://docs.semaphoreci.com/article/66-environment-variables-and-secrets
[promotions]: https://docs.semaphoreci.com/article/67-deploying-with-promotions
[fastlane-plugin]: https://github.com/semaphoreci/fastlane-plugin-semaphore
[code-signing]: https://docs.semaphoreci.com/article/134-code-signing-for-ios-projects
[testflight]: https://docs.semaphoreci.com/article/137-testflight-ios-app-distribution
[hockeyapp]: https://docs.semaphoreci.com/article/138-hockeyapp-ios-app-distribution
