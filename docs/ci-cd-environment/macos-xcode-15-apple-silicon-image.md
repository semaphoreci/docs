---
Description: The macos-xcode15 image is a customized image based on MacOS 14.1, which has been optimized for CI/CD. This guide shows you how to use it.
---

# macOS Sonoma Xcode 15 image


The `macos-xcode15` image is a customized image based on [MacOS 14.4.1][sonoma-release-notes],
which has been optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Apple machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `macos-xcode15` is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access.

## Using the macos-xcode15 OS image in your agent configuration

To use the `macos-xcode15` OS image, define it as the `os_image` of your agent's
machine.

``` yaml
version: 1.0
name: Apple Based Pipeline

agent:
  machine:
    type: a2-standard-4
    os_image: macos-xcode15

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

The `a2-standard-4` OS image can only be used in combination with the Apple 
`macos-xcode15` machine type.

## System

- ProductVersion: 14.4.11
- BuildVersion: 23E224
- Kernel Version: Darwin 23.4.0

## Version control

Following version control tools are pre-installed:

- Git (2.x)
- Git LFS (Git Large File Storage)

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

- fastlane (2.220.0)
- cocoapods (1.15.2)

## Languages

### Java

- openjdk 17

### JavaScript via Node.js

Installed version:

- v18.20.1

#### Additional tools

- Yarn: 1.22.19

### Python

Installed version:

- 3.12.2

Supporting libraries:

- pip3: 24.0

### Ruby

Installed versions:

- 2.6.10 (system)
- 3.3.0

## Flutter

- 3.19.5

## Xcode

Installed versions:

- 15.3 (default)

The default installed Xcode version is `15.3`.


Xcode 15.3 has the following SDKs preinstalled:

- iphoneos 17.4
- iphonesimulator 17.4
- driverkit.macos 23.0
- macos 14.4
- appletvos 17.4
- appletvsimulator 17.4
- watchos 10.4
- watchsimulator 10.4
- visionos 1.1


## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[sonoma-release-notes]: https://developer.apple.com/documentation/macos-release-notes/macos-14_4-release-notes
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[ios-guide]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
