---
Description: The macos-xcode13 image is a customized image based on MacOS 11.6, which has been optimized for CI/CD. This guide shows you how to use it.
---

# macOS Monterey Xcode 13 image

The `macos-xcode13` image is a customized image based on [MacOS 12.3][monterey-release-notes],
which has been optimized for CI/CD. It comes with a set of preinstalled languages, databases,
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

The `macos-xcode13` OS image can only be used in combination with the Apple 
`a1-standard-4` machine type.

## System

- ProductVersion: 12.3
- BuildVersion: 21E230
- Kernel Version: Darwin 21.4.0

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

- fastlane (2.205.1)
- cocoapods (1.11.3)

## Languages

### Java

- openjdk 14

### JavaScript via Node.js

Installed version:

- v17.8.0

#### Additional tools

- Yarn: 1.22.18

### Python

Installed version:

- 3.9.11

Supporting libraries:

- pip3: 22.0.4

### Ruby

Installed versions:

- 2.5.1 (system)
- 2.6.9

## Flutter

- 3.0.0

## Xcode

Installed versions:

- 13.2.1
- 13.3
- 13.4

The default installed Xcode version is `13.3`.


Xcode 13.3 has the following SDKs preinstalled:

- iphoneos 15.4
- iphonesimulator 15.4
- driverkit.macos 21.0.1
- macos 12
- appletvos 15.4
- appletvsimulator 15.4
- watchos 8.5
- watchsimulator 8.5


## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[monterey-release-notes]: https://developer.apple.com/documentation/macos-release-notes/macos-12_3-release-notes
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[ios-guide]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
