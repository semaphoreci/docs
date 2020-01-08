# Swift

Semaphore allows building, testing and releasing Swift, Objective-C and
React Native applications with customizable CI/CD workflows.

If you’re new to Semaphore, we recommend reading our
[guided tour](https://docs.semaphoreci.com/article/77-getting-started) first.

macOS Mojave images running *either* Xcode 10, *or* Xcode 11 are available. Each
image also has a full complement of useful tools and utilities pre-installed.
Information on the exact version numbers of macOS, Xcode, fastlane, CocoaPods,
and all other tools are below:

* [macOS Mojave Xcode 10 Image](macos-xcode-10)
* [macOS Mojave Xcode 11 Image](macos-xcode-11)

# Configuring Continuous Integration

Below is a minimal `semaphore.yml` which starts an
[Xcode 11 image](macos-xcode-11) and runs `xcodebuild`:

``` yaml
version: v1.0
name: Semaphore iOS Swift example
agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave-xcode11
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

Semaphore maintains an [example project](example-project) built with Swift and
SwiftUI demonstrating how to set build an app and run tests. A
[full tutorial showing how to configure an iOS project for CI with Semaphore](example-project)
is also available.

[macos-xcode-10]: https://docs.semaphoreci.com/ci-cd-environment/macos-mojave-xcode-10-image
[macos-xcode-11]: https://docs.semaphoreci.com/ci-cd-environment/macos-mojave-xcode-11-image
[example-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
[ios-tutorial]: http://docs.semaphoreci.com/use-cases/ios-continuous-integration-with-xcode
