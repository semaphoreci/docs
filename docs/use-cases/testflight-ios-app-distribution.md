# TestFlight iOS App Distribution

This guide shows how to configure iOS app distribution from
[Semaphore][semaphore] to [Apple TestFlight][testflight] using
[Fastlane][fastlane].

For an introduction to building iOS apps on Semaphore, see the _[iOS
tutorial][ios-tutorial]_.

First, make sure to configure your project to use Fastlane, Match and code
signing by following the _[Code signing for iOS projects][code-signing]_ guide.

To publish to TestFlight, create a separate Fastlane lane where you'll invoke
the appropriate commands:

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

For the whole process to work, make sure you've configured environment variables
required for `match` and `pilot`. Namely, the URL for `match`'s certificate
repository, the encryption password for it, and Apple ID for logging in to the
Apple Developer portal and submitting a new build. This is described in detail
in the _[Code signing for iOS projects][code-signing]_ guide.

In your Semaphore CI/CD configuration, you can now use `bundle exec fatlane build` command in a job:

```yaml
# .semaphore/semaphore.yml
version: v1.0
name: Semaphore iOS example
agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave-xcode10
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
working Fastlane and Semaphore configuration for your convenience.

[semaphore]: https://semaphoreci.com
[testflight]: https://developer.apple.com/testflight/
[fastlane]: https://fastlane.tools
[ios-tutorial]: https://docs.semaphoreci.com/article/124-ios-continuous-integration-xcode
[code-signing]: https://docs.semaphoreci.com/article/134-code-signing-for-ios-projects
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
