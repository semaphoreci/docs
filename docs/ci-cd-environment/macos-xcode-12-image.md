---
description: The macos-xcode12 is a customized image based on MacOS 11.3.1 optimized for CI/CD. It is a virtual machine (VM) image and here is how to use it.
---

# macOS Big Sur Xcode 12 Image

The `macos-xcode12` is a customized image based on [MacOS 11.5.1][bigsur-release-notes]
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

- ProductVersion: 11.5.1
- BuildVersion: 20G80
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

- fastlane (2.191.0)
- cocoapods (1.10.2)

## Languages

### Java

- openjdk 14

### JavaScript via Node.js

Installed version:

- v13.12.0

#### Additional tools

- Yarn: 1.22.11

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

- 2.2.3

## Xcode

Installed versions:

- 12.2
- 12.3
- 12.4
- 12.5.1

The default installed Xcode version is `12.5.1`.

To switch between versions use `xcversion select <version>` e.g `xcversion select 12.3`


Xcode 12.2 has the following SDKs preinstalled:

- iphoneos14.2
- iphonesimulator14.2
- driverkit.macosx20.0
- macosx11.0
- appletvos14.2
- appletvsimulator14.2
- watchos7.1
- watchsimulator7.1

Xcode 12.3 has the following SDKs preinstalled:

- iphoneos14.3
- iphonesimulator14.3
- driverkit.macosx20.2
- macosx11.1
- appletvos14.3
- appletvsimulator14.3
- watchos7.2
- watchsimulator7.2

Xcode 12.4 has the following SDKs preinstalled:

- iphoneos14.4
- iphonesimulator14.4
- driverkit.macosx20.2
- macosx11.1
- appletvos14.3
- appletvsimulator14.3
- watchos7.2
- watchsimulator7.2

Xcode 12.5 has the following SDKs preinstalled:

- iphoneos14.5
- iphonesimulator14.5
- driverkit.macosx20.4
- macosx11.3
- appletvos14.5
- appletvsimulator14.5
- watchos7.4
- watchsimulator7.4


## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[bigsur-release-notes]: https://developer.apple.com/documentation/macos-release-notes/macos-big-sur-11_3-release-notes
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[ios-guide]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
