Semaphore provides a set of customized Docker images for building Android apps. It comes with a set of preinstalled utility tools commonly used for CI/CD workflows. These pre-built images are available in the [SemaphoreCI Docker Hub](https://hub.docker.com/repository/docker/semaphoreci/android). The source code and Dockerfiles for these images are available in [Semaphore public GitHub repository](https://github.com/semaphoreci/docker-images/tree/master/dockerfiles/android).

The Semaphore Android image is based on the `ubuntu:16.04` official Docker image, builds are run as root user.

[[__TOC__]]

## Image Variants

We have a different Docker image for each Android API and Android image variants with node installed
for React Native development.

 - `andorid:version` is the basic image that comes with development utilities and is an optimal first choice for Andorid.
 - `andorid:version-node` is the extension of the basic image and it comes with Node.js (10.x) pre-installed.

Detailed examples and documentation about setting up a CI/CD environment with Docker is covered in [Custom CI/CD environment with Docker](https://docs.semaphoreci.com/article/127-custom-ci-cd-environment-with-docker) documentation page.

## Sample Configuration for Android project on Semaphore.
The configuration below is a part of [example React Native application on GitHub](https://github.com/semaphoreci-demos/semaphore-demo-react-native).

``` yaml
version: v1.0
name: Semaphore React Native iOS Example Pipeline
agent:
  machine:
    type: e1-standard-2
  containers:
    - name: main
      # Docker image with Android API 29 and node pre-installed
      image: semaphoreci/android:29-node
blocks:
  - name: Install dependencies
    dependencies: []
    task:
      jobs:
        - name: npm install and cache
          commands:
            # Get the latest version of our source code from GitHub:
            - checkout
            # Restore dependencies from cache. This command will not fail in
            # case of a cache miss. In case of a cache hit, npm install will
            # run very fast.
            # For more info on caching, see https://docs.semaphoreci.com/article/68-caching-dependencies
            - cache restore
            - npm install

            # Store the latest version of node modules in cache to reuse in
            # further blocks:
            - cache store
  - name: Run linter
    dependencies:
      - Install dependencies
    task:
      prologue:
        commands:
          - checkout
      jobs:
        - name: run eslint
          commands:
            - cache restore
            - npm run lint
  - name: Run iOS tests
    dependencies:
      - Run linter
    task:
      agent:
        machine:
          type: a1-standard-4
          os_image: macos-mojave-xcode11
      prologue:
        commands:
          # Download source code from GitHub:
          - checkout
      jobs:
        - name: unit and integration tests
          commands:
            - cache restore
            - npm test
        - name: e2e tests
          commands:
            # Install dependencies for detox.js
            - brew tap wix/brew
            - brew install applesimutils
            - cache restore
            - cd ios
            - pod install
            - cd ..
            # build and test
            - npm run detox-clean-and-build-cache
            - npm run detox-ios-build-release
            - npm run detox-ios-test-release
            - artifact push workflow ios/build/Build/Products/Release-iphonesimulator/ReactNativeSemaphoreNew.app
  - name: Run Android tests
    dependencies:
      - Run linter
    task:
      prologue:
        commands:
          # Download source code from GitHub:
          - checkout
          # Install android emulator
          - sdkmanager "platform-tools" "platforms;android-24" "emulator"
          - sdkmanager "system-images;android-24;default;armeabi-v7a"
          - echo no | avdmanager create avd -n Nexus_S_API_24 -k "system-images;android-24;default;armeabi-v7a" --device "Nexus S"
      jobs:
        - name: unit and integration tests
          commands:
            - cache restore
            - npm test
        - name: e2e tests
          commands:
            - cache restore
            # build and test
            - npm run detox-clean-and-build-cache
            - npm run detox-android-build-release
            - npm run detox-android-test-release
            - artifact push workflow android/app/build/outputs/apk/release/app-release.apk
```

## Supported Android SDK version

- build-tools;25.0.3
- build-tools;26.0.1
- build-tools;26.0.2
- build-tools;27.0.0
- build-tools;27.0.1
- build-tools;27.0.2
- build-tools;27.0.3
- build-tools;28.0.0
- build-tools;28.0.1
- build-tools;28.0.2
- build-tools;28.0.3
- build-tools;29.0.0
- build-tools;29.0.1
- build-tools;29.0.2
- platforms;android-25
- platforms;android-26
- platforms;android-27
- platforms;android-28
- platforms;android-29

### Installed software

- ARM simmulator (libqt5widgets5)
- Google Cloud SDK
- apt
- apt-transport-https
- build-essential
- bzip2
- ca-certificates
- curl
- docker
- docker-compose
- git
- gnupg
- gradle
- gzip
- jq
- lftp
- locales
- lsb-release
- maven
- mercurial
- net-tools
- netcat
- openssh-client
- parallel
- ruby 2.6.1
- software-properties-common
- sudo
- tar
- tree
- unzip
- vim
- wget
- xvfb
- zip

## See Also

- [iOS Continuous Integration guide][https://docs.semaphoreci.com/article/124-ios-continuous-integration-xcode]
- [sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
- [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
