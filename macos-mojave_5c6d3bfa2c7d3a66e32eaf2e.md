The `macos-mojave` is a customized image based on [MacOS 10.14][mojave-release-notes]
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Apple machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `macos-mojave` is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access.

[[__TOC__]]

Note: MacOS support on Semaphore is currently in beta.

## Using the macos-mojave OS image in your agent configuration

To use the `macos-mojave` OS image, define it as the `os_image` of your agent's
machine.

``` yaml
version: 1.0
name: Apple/Mojave Based Pipeline

agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

The `macos-mojave` OS image can only be used in combination with an Apple
machine type `a1-standard-4`.

## Version control

Following version control tools are pre-installed:

- Git (2.x)
- Git LFS (Git Large File Storage)
- Svn

### Utilities

- homebrew
- bundler
- rbenv
- curl
- wget
- jq

### Gems

Following gems are pre-installed:

- fastlane 2.220
- xcode-install 2.5.0
- cocoapods 1.5.3
- xcpretty 0.3.0

## Languages

### Java

- openjdk 11.0.2

### JavaScript via Node.js

Installed version:

- v11.10.0

#### Additional tools

- Yarn: 1.13.0

### Python

Installed version:

- 2.7
- 3.7

Supporting libraries:

- pip3: 18.1

### Ruby

Installed versions:

- 2.3.7 (system)
- 2.5.1

## Flutter

- v1.2.1-stable (macOS)

## Xcode

Installed versions:

- 10.2

Xcode 10.2 images have the following SDKs preinstalled:

- macosx10.14
- iphoneos12.2
- iphonesimulator12.2
- appletvos12.2
- appletvsimulator12.2
- watchos5.2
- watchsimulator5.2

The Xcode 10.2 image comes with the following simulators:

- iOS 11.4
- iOS 12.2
- tvOS 12.2
- watchOS 5.2

## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
- [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)

[mojave-release-notes]: https://developer.apple.com/documentation/macos_release_notes/macos_mojave_10_14_release_notes
[machine-types]: https://docs.semaphoreci.com/article/20-machine-types
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/article/50-pipeline-yaml#agent
[ios-guide]: https://docs.semaphoreci.com/article/124-ios-continuous-integration
