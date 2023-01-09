---
Description: Semaphore 2.0 allows you to build, test, and deploy Swift, Objective-C, and React Native applications with customizable CI/CD workflows. 
---

# Swift

Semaphore allows the building, testing, and releasing of Swift, Objective-C, and
React Native applications with customizable CI/CD workflows.

If you’re new to Semaphore, we recommend reading our
[guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) first.

The macOS Xcode 11 image is available with a full complement of useful tools and 
utilities pre-installed. Information regarding the exact version numbers of macOS, 
Xcode, fastlane, CocoaPods, and all other tools is found below:

* [macOS Xcode 12 Image](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/)

# Configuring continuous integration

Below is a minimal `semaphore.yml` file, which starts an
[Xcode 12 image](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/) 
and runs `xcodebuild`:

``` yaml
version: v1.0
name: Semaphore iOS Swift example
agent:
  machine:
    type: a1-standard-4
    os_image: macos-xcode13
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

Semaphore maintains an [example project](https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode) built with Swift and SwiftUI that demonstrates how to build an app and run tests. A
[full tutorial showing how to configure an iOS project for CI with Semaphore](https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/)
is also available.

[macos-xcode-12]: https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/
[example-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
[ios-tutorial]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
