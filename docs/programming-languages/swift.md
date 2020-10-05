---
description: Semaphore 2.0 allows building, testing and releasing Swift, Objective-C and React Native applications with customizable CI/CD workflows. 
---

# Swift

Semaphore allows building, testing and releasing Swift, Objective-C and
React Native applications with customizable CI/CD workflows.

If you’re new to Semaphore, we recommend reading our
[guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) first.

The macOS Xcode 11 is available with a full complement of useful tools and utilities pre-installed.
Information on the exact version numbers of macOS, Xcode, fastlane, CocoaPods,
and all other tools are below:

* [macOS Xcode 12 Image](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/)

# Configuring Continuous Integration

Below is a minimal `semaphore.yml` which starts an
[Xcode 11 image](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/) and runs `xcodebuild`:

``` yaml
version: v1.0
name: Semaphore iOS Swift example
agent:
  machine:
    type: a1-standard-4
    os_image: macos-xcode12
blocks:
  - name: Build
    task:
      jobs:
        - name: Checkout and build
          commands:
            - checkout
            - xcodebuild
```

## Example project

Semaphore maintains an [example project](https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode) built with Swift and
SwiftUI demonstrating how to set build an app and run tests. A
[full tutorial showing how to configure an iOS project for CI with Semaphore](https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/)
is also available.

[macos-xcode-12]: https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/
[example-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
[ios-tutorial]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
