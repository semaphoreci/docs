The `macos-mojave` is a customized image based on [MacOS 10.14.5][mojave-release-notes]
optimized for CI/CD. It comes with a set of preinstalled languages, databases,
and utility tools commonly used for CI/CD workflows. The image can be paired
with any [Apple machine type][machine-types] when defining the [agent][agent]
of your pipeline or block.

The `macos-mojave` is a virtual machine (VM) image. The user in the environment,
named `semaphore`, has full `sudo` access.

[[__TOC__]]

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

- fastlane 2.128.1
- xcode-install 2.6.0
- cocoapods 1.7.5
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

- v1.7.8+hotfix.4

## Xcode

Installed versions:

- 10.2.1
- 10.3
- 11.0

Xcode 10.2.1 images have the following SDKs preinstalled:

- macosx10.14
- iphoneos12.2
- iphonesimulator12.2
- appletvos12.2
- appletvsimulator12.2
- watchos5.2
- watchsimulator5.2

Xcode 10.3 images have the following SDKs preinstalled:

- macosx10.14
- iphoneos12.2
- iphonesimulator12.2
- appletvos12.2
- appletvsimulator12.2
- watchos5.2
- watchsimulator5.2

Xcode 11.0 images have the following SDKs preinstalled:

- macosx10.15
- iphoneos13
- iphonesimulator13
- appletvos13
- appletvsimulator13
- watchos6
- watchsimulator6

Additional preinstalled simulators:

- iOS 11.4
- iOS 12.1

## See Also

- [iOS Continuous Integration guide][ios-guide]
- [sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
- [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)

[mojave-release-notes]: https://developer.apple.com/documentation/macos_release_notes/macos_mojave_10_14_5_release_notes
[machine-types]: https://docs.semaphoreci.com/article/20-machine-types
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/article/50-pipeline-yaml#agent
[ios-guide]: https://docs.semaphoreci.com/article/124-ios-continuous-integration
