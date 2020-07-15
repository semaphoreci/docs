---
description: This guide gives an overview of CI/CD with Semaphore for apps created with Xcode that run on iOS, macOS, watchOS, or tvOS.
---

# iOS Continuous Integration with Xcode

This guide gives an overview of CI/CD with Semaphore for apps created with
Xcode that run on iOS, macOS, watchOS, or tvOS.

Semaphore supports building, testing, and deploying Swift, Objective-C and
React Native projects. Projects can be built with
[Xcode 11][macos-xcode11] running on
macOS Mojave on an `a1-standard-4` or higher [machine type][machine-types].

## Example project

Semaphore maintains an example iOS app written in Swift 5.1 with SwiftUI to
demonstrate how to get an Xcode CI/CD environment up and running:

- [TallestTowers example project on GitHub][example-project]

This example project includes an annotated Semaphore configuration file,
[`.semaphore/semaphore.yml`][example-semaphore-yml] and uses
[fastlane][fastlane] for its CI pipeline with the
[Semaphore fastlane plugin][fastlane-plugin].

## Overview of the CI pipeline

The Semaphore pipeline is configured to:

- Run all unit and UI tests.
- Build the app and generate an `ipa` archive.
- Generate automated App Store screenshots.
- Upload the archived `ipa` and screenshots as job [artifacts][artifacts].

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

# Name your pipeline. If you choose to connect multiple pipelines with
# promotions, the pipeline name will help you differentiate between
# them. For example, you might have a build phase and a delivery phase.
# For more information on promotions, see:
# https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
name: Tallest Towers

# The agent defines the environment in which your CI runs. It is a combination
# of a machine type and an operating system image. For a project built with
# Xcode you must use one of the Apple machine types, coupled with a macOS image
# running Xcode 11.
# See https://docs.semaphoreci.com/ci-cd-environment/machine-types/
# https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/
agent:
  machine:
    type: a1-standard-4
    os_image: macos-xcode11

# Blocks are the heart of a pipeline and are executed sequentially. Each block
# has a task that defines one or more parallel jobs. Jobs define commands that
# should be executed by the pipeline.
# See https://docs.semaphoreci.com/guided-tour/concepts/
blocks:
  - name: Run tests
    task:
      # Set environment variables that your project requires.
      # See https://docs.semaphoreci.com/guided-tour/environment-variables-and-secrets/
      env_vars:
        - name: LANG
          value: en_US.UTF-8
      prologue:
        commands:
          # Download source code from GitHub.
          - checkout

          # Restore dependencies from cache. This command will not fail in
          # case of a cache miss. In case of a cache hit, bundle  install will
          # complete in about a second.
          # See https://docs.semaphoreci.com/guided-tour/caching-dependencies/
          - cache restore
          - bundle install --path vendor/bundle
          - cache store
      jobs:
        - name: Test
          commands:
            # Select an Xcode version.
            # See https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/
            - bundle exec xcversion select 11.2.1

            # Run tests of iOS and Mac app on a simulator or connected device.
            # See https://docs.fastlane.tools/actions/scan/
            - bundle exec fastlane test

  - name: Build app
    task:
      env_vars:
        - name: LANG
          value: en_US.UTF-8
      secrets:
        # Make the SSH key for the certificate repository and the MATCH_PASSWORD
        # environment variable available.
        # See https://docs.semaphoreci.com/essentials/using-private-dependencies/
        - name: match-secrets
      prologue:
        commands:
          # Add the key for the match certificate repository to ssh
          # See https://docs.semaphoreci.com/essentials/using-private-dependencies/
          - chmod 0600 ~/.ssh/*
          - ssh-add ~/.ssh/match-repository-private-key

          # Continue with checkout as normal
          - checkout
          - cache restore
          - bundle install --path vendor/bundle
          - cache store
      jobs:
        - name: Build
          commands:
            - bundle exec xcversion select 11.2.1
            - bundle exec fastlane build

            # Upload the IPA file as a job artifact.
            # See https://docs.semaphoreci.com/essentials/artifacts/
            - artifact push job TallestTowers.ipa
  - name: Take screenshots
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
        - name: Screenshots
          commands:
            - bundle exec xcversion select 11.2.1
            - bundle exec fastlane screenshots

            # Upload the screenshots directory as a project artifact.
            # See https://docs.semaphoreci.com/essentials/artifacts/
            - artifact push job screenshots
```

## Configuration walkthrough

### Naming your pipeline

``` yaml
version: v1.0
name: Tallest Towers
```

**Note:** If you choose to connect multiple pipelines with
[promotions][promotions], the pipeline name will help you differentiate between
them. For example, you might have a build phase and a delivery phase.

### Defining the agent

The agent defines the environment in which your CI runs. It is a combination of
a machine type and an operating system image. For a project built with Xcode you
must use one of the Apple [machine types][machine-types], coupled with a macOS
image running [Xcode 11][macos-xcode11].

``` yaml
agent:
  machine:
    type: a1-standard-4
    os_image: macos-xcode11
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
            - bundle exec xcversion select 11.2.1
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
[open source script][checkout-source provided by Semaphore.

By default `checkout` performs a shallow git clone from a remote origin. If you
need a full clone that will be cached by Semaphore, use `checkout --use-cache`.

``` yaml
        commands:
          - checkout
```

### Installing dependencies

Your project dependencies can be cached by Semaphore to improve performance when
running your CI/CD workflows.

The `cache restore` command will not fail if there is a cache miss, and
`bundle install` will complete in about a second when the cache hits. More
information on the exact functionality of `cache` can be found in
[the Toolbox Reference][cache-command].

``` yaml
        commands:
          - cache restore
          - bundle install --path vendor/bundle
          - cache store
```

### Selecting an Xcode version

You can find the list of available versions of Xcode on the
[Xcode 11][macos-xcode11] image references. 
Select the desired version for your project with `xcversion`.

``` yaml
        commands:
          - bundle exec xcversion select 11.2.1
```

### Running tests

Semaphore can run both unit and UI tests using any of the iOS simulators that
are installed with Xcode. If you're using fastlane, see the
[fastlane scan][fastlane-scan] documentation.
.

``` yaml
        commands:
          - bundle exec fastlane test
```

### Building your app

The example project is set to build the app with `fastlane build`.
By default, the [Semaphore fastlane plugin][fastlane-plugin] creates a fresh,
temporary keychain.

``` yaml
        commands:
          - bundle exec fastlane build
```

### Accessing encrypted certificates and provisioning profiles

The `Fastfile` in this example project executes the [`match`][fastlane-match]
command, which requires access to a private certificate store or git repository.
Use [private dependencies][private-dependencies] to keep secrets separate from
the rest of the project.

``` yaml
      secrets:
        - name: match-secrets
```

The [example project README][example-project-readme] also includes a detailed
walkthrough of configuring the project to use a private git repository with
encrypted certificates and provisioning profiles.

### Uploading build artifacts

Any files generated by a continuous integration pipeline may be uploaded as
[artifacts][artifacts] to a job, workflow, or project store.

Once the `.ipa` file has been built and archived, the example project uploads
it as a job artifact.

``` yaml
        commands:
          - artifact push job TallestTowers.ipa
```

### Automating the generation App Store screenshots

The example project is also configured to run [`snapshot`][fastlane-snapshot]
to automate the generation of a small set of sample App Store screenshots and
upload them as job [artifacts][artifacts].

``` yaml
        commands:
          - bundle exec fastlane screenshots
          - artifact push job screenshots
```

### Fastfile

The example project uses the [Semaphore fastlane plugin][fastlane-plugin]:

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

## Run the example project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][example-project] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
4. Create your secret as per instructions above.
5. Edit any file and push GitHub, and Semaphore will run the CI/CD pipeline.

## Related guides:

- [Code signing for iOS projects][code-signing]
- [TestFlight integration][testflight]
- [HockeyApp integration][hockeyapp]

[macos-xcode11]: https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[example-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
[example-project-readme]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode/blob/master/README.md
[example-semaphore-yml]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode/blob/master/.semaphore/semaphore.yml
[concepts]: https://docs.semaphoreci.com/guided-tour/concepts/
[checkout]: https://docs.semaphoreci.com/reference/toolbox-reference/#checkout
[cache-command]: https://docs.semaphoreci.com/reference/toolbox-reference/#cache
[fastlane]: https://fastlane.tools/
[fastlane-scan]: https://docs.fastlane.tools/actions/scan/
[fastlane-match]: https://docs.fastlane.tools/actions/match/
[fastlane-plugin]: https://github.com/semaphoreci/fastlane-plugin-semaphore
[fastlane-snapshot]: https://docs.fastlane.tools/actions/snapshot/
[encrypted-secrets]: https://docs.semaphoreci.com/guided-tour/environment-variables-and-secrets/
[promotions]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
[code-signing]: https://docs.semaphoreci.com/examples/code-signing-for-ios-projects/
[testflight]: https://docs.semaphoreci.com/examples/testflight-ios-app-distribution/
[hockeyapp]: https://docs.semaphoreci.com/examples/hockeyapp-ios-app-distribution/
[artifacts]: https://docs.semaphoreci.com/essentials/artifacts/
[private-dependencies]: https://docs.semaphoreci.com/essentials/using-private-dependencies/
