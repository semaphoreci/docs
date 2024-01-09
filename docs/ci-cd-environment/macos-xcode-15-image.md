---
Description: The macos-xcode15 image is a customized image based on MacOS 14.1, which has been optimized for CI/CD. This guide shows you how to use it.
---

# macOS Sonoma Xcode 15 image

!!! warning "Xcode 15 image is currently in the Technical Preview stage. If you're interested in trying them out, please contact our support team."

The `macos-xcode15` image is a customized image based on [MacOS 14.1][sonoma-release-notes],
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
    type: a1-standard-4
    os_image: macos-xcode15

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

The `macos-xcode15` OS image can only be used in combination with the Apple 
`a1-standard-4` machine type.

## System

- ProductVersion: 14.1
- BuildVersion: 23B74
- Kernel Version: Darwin 23.1.0

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

- fastlane (2.216.0)
- cocoapods (1.14.2)

## Languages

### Java

- openjdk 17

### JavaScript via Node.js

Installed version:

- v20.9.0

#### Additional tools

- Yarn: 1.22.19

### Python

Installed version:

- 3.9.11

Supporting libraries:

- pip3: 23.3.1

### Ruby

Installed versions:

- 2.6.10 (system)
- 3.2.2

## Flutter

- 3.13.9

## Xcode

Installed versions:

- 15.0.1

The default installed Xcode version is `15.0.1`.


Xcode 15.0.1 has the following SDKs preinstalled:

- iphoneos 17.0
- iphonesimulator 17.0
- driverkit.macos 23.0
- macos 14.0
- appletvos 17.0
- appletvsimulator 17.0
- watchos 10.0
- watchsimulator 10.0


## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[sonoma-release-notes]: https://developer.apple.com/documentation/macos-release-notes/macos-14_1-release-notes
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[ios-guide]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
