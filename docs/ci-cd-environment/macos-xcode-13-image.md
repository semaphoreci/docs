---
description: The macos-xcode13 is a customized image based on MacOS 11.6 optimized for CI/CD. It is a virtual machine (VM) image and here is how to use it.
---

# macOS Big Sur Xcode 13 Image

The `macos-xcode13` is a customized image based on [MacOS 11.5][bigsur-release-notes]
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Apple machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `macos-xcode13` is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access.

## Using the macos-xcode13 OS image in your agent configuration

To use the `macos-xcode13` OS image, define it as the `os_image` of your agent's
machine.

``` yaml
version: 1.0
name: Apple Based Pipeline

agent:
  machine:
    type: a1-standard-4
    os_image: macos-xcode13

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

The `macos-xcode13` OS image can only be used in combination with an Apple
machine type `a1-standard-4`.

## System

- ProductVersion: 11.6
- BuildVersion: 20G165
- Kernel Version: Darwin 20.6.0

## Version control

Following version control tools are pre-installed:

- Git (2.x)
- Git LFS (Git Large File Storage)
- Svn

### Utilities

- homebrew
- bundler
- rbenv
- nvm
- curl
- wget
- jq
- carthage

### Browsers

- Safari
- google-chrome
- firefox
- microsoft-edge

### Gems

Following gems are pre-installed:

- fastlane (2.199.0)
- cocoapods (1.11.2)

## Languages

### Java

- openjdk 14

### JavaScript via Node.js

Installed version:

- v17.2.0

#### Additional tools

- Yarn: 1.22.17

### Python

Installed version:

- 2.7
- 3.7

Supporting libraries:

- pip: 20.2b1
- pip3: 20.0.2

### Ruby

Installed versions:

- 2.5.1 (system)
- 2.6.8

## Flutter

- 2.8.1

## Xcode

Installed versions:

- 13
- 13.1
- 13.2.1

The default installed Xcode version is `13.2.1`.


Xcode 13.2.1 has the following SDKs preinstalled:

- iphoneos 15
- iphonesimulator 15
- driverkit.macos 21.0.1
- macos 12
- appletvos 15
- appletvsimulator 15
- watchos 8
- watchsimulator 8


## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[bigsur-release-notes]: https://developer.apple.com/documentation/macos-release-notes/macos-big-sur-11_5-release-notes
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[ios-guide]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
