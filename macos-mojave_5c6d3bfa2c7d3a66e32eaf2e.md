* [Overview](#overview)
* [Version control](#version-control)
* [Utilities](#utilities)
* [Gems](#gems)
* [Java](#java)
* [JavaScript via Node.js](#javascript-via-node-js)
* [Python](#python)
* [Ruby](#ruby)
* [Xcode](#xcode)
* [See also](#see-also)

## Overview

The `macos-mojave` image is based on [MacOS 10.14][mojave-release-notes].
You can use it to build, test and deliver iOS and MacOS projects.
The user in the environment is named `semaphore`, and has full `sudo` access.

Image name: `macos-mojave`

OS: `Darwin Kernel Version 18.2.0`

This image can be paired with [Apple machine types][machine-types] when defining
the [agent][agent] of your pipeline or block.

Note: MacOS support on Semaphore is currently in private beta. To get access,
[please apply][beta-form].

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

- fastlane 2.115.0 2.116.0
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

## Xcode

Installed versions:

- 10.1

Xcode 10.1 images have the following SDKs preinstalled:

- macosx10.14
- iphoneos12.1
- iphonesimulator12.1
- appletvos12.1
- appletvsimulator12.1
- watchos5.1
- watchsimulator5.1


The Xcode 10.1 image comes with the following simulators:

- iOS 11.4
- iOS 12.1
- tvOS 12.1
- watchOS 5.1

## See Also

* [sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)

[mojave-release-notes]: https://developer.apple.com/documentation/macos_release_notes/macos_mojave_10_14_release_notes
[machine-types]: https://docs.semaphoreci.com/article/20-machine-types
[beta-form]: https://semaphoreci.com/product/ios
[agent]: https://docs.semaphoreci.com/article/50-pipeline-yaml#agent
