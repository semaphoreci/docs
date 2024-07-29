---
Description: The macos-xcode16 image is a customized image based on MacOS 14.5, which has been optimized for CI/CD. This guide shows you how to use it.
---

# macOS Sonoma Xcode 16 image


The `macos-xcode16` image is a customized image based on [MacOS 14.5][sonoma-release-notes],
which has been optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Apple machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `macos-xcode16` is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access.

## Using the macos-xcode16 OS image in your agent configuration

To use the `macos-xcode16` OS image, define it as the `os_image` of your agent's
machine.

``` yaml
version: 1.0
name: Apple Based Pipeline

agent:
  machine:
    type: a2-standard-4
    os_image: macos-xcode16

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

The `macos-xcode16` OS image can only be used in combination with the Apple 
 `a2-standard-4` machine type.

## System

- ProductVersion: 14.5
- BuildVersion: 23F79
- Kernel Version: Darwin 23.5.0

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

- fastlane (2.221.1)
- cocoapods (1.15.2)

## Languages

### Java

- openjdk 17

### JavaScript via Node.js

Installed version:

- v18.20.1

#### Additional tools

- Yarn: 1.22.22

### Python

Installed version:

- 3.12.44

Supporting libraries:

- pip3: 24

### Ruby

Installed versions:

- 2.6.10 (system)
- 3.3.4

## Flutter

- 3.22.2

## Xcode

Installed versions:

- 16_beta_3 (default)

The default installed Xcode version is `16.0`.


Xcode 15.3 has the following SDKs preinstalled:

- iOS 18.0
- macOS 15.0
- tvOS 18.0
- watchOS 11
- visionos 2.0


## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[sonoma-release-notes]: https://developer.apple.com/documentation/macos-release-notes/macos-14_5-release-notes
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[ios-guide]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
