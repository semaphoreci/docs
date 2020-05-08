# macOS Catalina Xcode 11 Image

The `macos-xcode11` is a customized image based on [MacOS 10.15.4][catalina-release-notes]
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Apple machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `macos-xcode11` is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access.

## Using the macos-xcode11 OS image in your agent configuration

To use the `macos-xcode11` OS image, define it as the `os_image` of your agent's
machine.

``` yaml
version: 1.0
name: Apple/Mojave Based Pipeline

agent:
  machine:
    type: a1-standard-4
    os_image: macos-xcode11

blocks:
  - name: "Unit tests"
    task:
      jobs:
        - name: Tests
          commands:
            - make test
```

The `macos-xcode11` OS image can only be used in combination with an Apple
machine type `a1-standard-4`.

## System

- ProductVersion: 10.14.6
- BuildVersion: 18G95
- Kernel Version: Darwin 18.7.0

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

- fastlane (2.145.0)
- cocoapods (1.9.1)

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

- v1.17.0

## Xcode

Installed versions:

- 11.2.1
- 11.3.1
- 11.4.1


Xcode 11.2.1 has the following SDKs preinstalled:

- macosx10.15
- driverkit.macosx19.0
- iphoneos13.1
- iphonesimulator13.2
- appletvos13.2
- appletvsimulator13.2
- watchos6.1
- watchsimulator6.1

Xcode 11.3.1 has the following SDKs preinstalled:

- macosx10.15
- driverkit.macosx19.0
- iphoneos13.2
- iphonesimulator13.2
- appletvos13.2
- appletvsimulator13.2
- watchos6.1
- watchsimulator6.1

Xcode 11.4.1 has the following SDKs preinstalled:

- macosx10.15
- driverkit.macosx19.0
- iphoneos13.4
- iphonesimulator13.4
- appletvos13.4
- appletvsimulator13.4
- watchos6.2
- watchsimulator6.2


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
