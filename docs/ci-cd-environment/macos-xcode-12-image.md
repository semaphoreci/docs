---
description: The macos-xcode12 is a customized image based on MacOS 10.15.4 optimized for CI/CD. It is a virtual machine (VM) image and here is how to use it.
---

# macOS Catalina Xcode 12 Image

The `macos-xcode12` is a customized image based on [MacOS 10.15.4][catalina-release-notes]
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Apple machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `macos-xcode12` is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access.

## Using the macos-xcode12 OS image in your agent configuration

To use the `macos-xcode12` OS image, define it as the `os_image` of your agent's
machine.

``` yaml
version: 1.0
name: Apple Based Pipeline

agent:
  machine:
    type: a1-standard-4
    os_image: macos-xcode12

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

The `macos-xcode12` OS image can only be used in combination with an Apple
machine type `a1-standard-4`.

## System

- ProductVersion: 10.15.4
- BuildVersion: 19E266
- Kernel Version: Darwin 19.4.0

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

- fastlane (2.160.1)
- cocoapods (1.9.3)

## Languages

### Java

- openjdk 14

### JavaScript via Node.js

Installed version:

- v13.12.0

#### Additional tools

- Yarn: 1.22.4

### Python

Installed version:

- 2.7
- 3.7

Supporting libraries:

- pip: 20.2b1
- pip3: 20.0.2

### Ruby

Installed versions:

- 2.3.7 (system)
- 2.5.1

## Flutter

- v1.20.4

## Xcode

Installed versions:

- 12.0

The default installed Xcode version is `12.0`.

To switch between versions use `xcversion select <version>` e.g `xcversion select 12.0`

Xcode 12.0 has the following SDKs preinstalled:

- iphoneos14.0
- iphonesimulator14.0
- driverkit.macosx20.0
- sdk macosx11.0

## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[catalina-release-notes]: https://developer.apple.com/documentation/macos_release_notes/macos_catalina_10_15_4_release_notes
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[ios-guide]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
