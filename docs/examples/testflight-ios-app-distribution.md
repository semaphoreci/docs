---
Description: This guide shows how to configure iOS app distribution from Semaphore to Apple TestFlight using Fastlane.
---

# TestFlight iOS app distribution

This guide shows how to configure iOS app distribution from
[Semaphore][semaphore] to [Apple TestFlight][testflight] using
[Fastlane][fastlane].

For an introduction to building iOS apps on Semaphore, see the [iOS
tutorial][ios-tutorial].

First, make sure to configure your project to use Fastlane, Match, and code
signing as detailed in the [code signing for iOS projects][code-signing] documentation.

To publish to TestFlight, create a separate Fastlane lane where you'll invoke
the appropriate commands, as shown below:

```ruby
# fastlane/Fastfile
platform :ios do
  desc "Submit the app to TestFlight"
  lane :release do
    match(type: "appstore")
    gym
    pilot
  end
end
```

For the whole process to work, you need to configure the environment variables
required for `match` and `pilot`. Namely, the URL for `match`'s certificate
repository, its encryption password, and the Apple ID for logging in to the
Apple Developer portal and submitting a new build. This is described in detail
in the [code signing for iOS projects][code-signing] documentation.

In your Semaphore CI/CD configuration, you can now use `bundle exec fastlane build` command in a job,
as shown below:

```yaml
# .semaphore/semaphore.yml
version: v1.0
name: Semaphore iOS example
agent:
  machine:
    type: a1-standard-4
    os_image: macos-xcode11
blocks:
  - name: Submit to TestFlight
    task:
      env_vars:
        - name: LANG
          value: en_US.UTF-8
      secrets:
        - name: fastlane-env
        - name: ios-cert-repo
      prologue:
        commands:
          - checkout
          - bundle install --path vendor/bundle
      jobs:
        - name: Fastlane build
          commands:
            - bundle exec fastlane release
```

Semaphore maintains [an example open source iOS project][demo-project] with
a working Fastlane and Semaphore configuration that you can use to get started.

[semaphore]: https://semaphoreci.com
[testflight]: https://developer.apple.com/testflight/
[fastlane]: https://fastlane.tools
[ios-tutorial]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
[code-signing]: https://docs.semaphoreci.com/examples/code-signing-for-ios-projects/
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
