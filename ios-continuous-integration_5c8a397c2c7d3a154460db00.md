This is a guide to continuous integration for iOS applications.  Semaphore
supports building, testing and deploying Swift, Objective-C and React Native
projects via [macOS Mojave VM image][macos-mojave] and [a1-standard machine
types][machine-types].

iOS support is currently in closed beta. [You can apply for access][beta-apply].

Here's an example configuration for a project using XCode and Fastlane.

<pre><code class="language-yaml"># .semaphore/semaphore.yml
version: v1.0
name: Semaphore iOS example with Fastlane
agent:
  machine:
    type: a1-standard-2
    os_image: macos-mojave

# Blocks are the heart of a pipeline and are executed sequentially.
# Each block has a task that defines one or more jobs. Jobs define the
# commands to execute.
# See https://docs.semaphoreci.com/article/62-concepts
blocks:
  - name: Run tests
    task:
      env_vars:
        - name: LANG
          value: en_US.UTF-8
      prologue:
        commands:
          - checkout
          - bundle install --path vendor/bundle
      jobs:
        - name: Fastlane test
          commands:
            # Select xcode version for available versions
            # See https://docs.semaphoreci.com/article/120-macos-mojave-image
            - bundle exec xcversion select 10.1
            # Run tests of iOS and Mac app on a simulator or connected device
            # See https://docs.fastlane.tools/actions/scan/
            - bundle exec fastlane ios test

  - name: Build app
    task:
      env_vars:
        - name: LANG
          value: en_US.UTF-8
      prologue:
        commands:
          - checkout
          - bundle install --path vendor/bundle
      jobs:
        - name: Fastlane build
          commands:
            # Select xcode version for available versions
            # See https://docs.semaphoreci.com/article/120-macos-mojave-image
            - bundle exec xcversion select 10.1
            # Create a temporary keychain
            # See https://docs.fastlane.tools/codesigning/getting-started/
            # and https://docs.fastlane.tools/actions/create_keychain/
            - bundle exec fastlane certificates refresh_certificates:true
            # Gym builds and packages iOS apps.
            # See https://docs.fastlane.tools/actions/build_app/
            - bundle exec fastlane build use_temporary_keychain:true
</code></pre>

This guide is a work in progress, more examples will be added soon.

[macos-mojave]: https://docs.semaphoreci.com/article/120-macos-mojave-image
[machine-types]: https://docs.semaphoreci.com/article/20-machine-types
[beta-apply]: https://semaphoreci.com/product/ios
