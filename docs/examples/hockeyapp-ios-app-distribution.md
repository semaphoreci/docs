HockeyApp iOS App Distribution

This guide shows how to configure iOS app distribution from
[Semaphore][semaphore] to [HockeyApp][hockeyapp] using
[Fastlane][fastlane].

For an introduction to building iOS apps on Semaphore, see the _[iOS
tutorial][ios-tutorial]_.

First, make sure to configure your project to use Fastlane, Match and code
signing by following the _[Code signing for iOS projects][code-signing]_ guide.

To submit your build to HockeyApp, you should install the Fastlane plugin that
provides the functionality:

```bash
$ bundle exec fastlane add_plugin appcenter
```

Consult with [AppCenter documentation][appcenter-docs] to learn how to obtain
API token and other configuration variables.

For Semaphore to have access to AppCenter, you can [create a secret][secrets]
with environment variables that hold the credentials, and pass them to Fastlane:

```bash
$ sem create secret hockeyapp-env \
    -e APPCENTER_API_TOKEN="<API token for AppCenter>" \
    -e APPCENTER_OWNER_NAME="<owner name>"
```

Define a Fastlane lane:

```ruby
# fastlane/Fastfile
platform :ios do
  desc "Submit the app to HockeyApp"
  lane :prerelease do
    match(type: "adhoc")
    gym
    appcenter_upload(
      app_name: "<your app name>",
      ipa: "<path to ipa (from gym), default is './<your app name>.ipa' >"
      notify_testers: true # Set to false if you don't want to notify testers of your new release (default: `false`)
    )
  end
end
```

Now, to make the AppCenter environment variables available during the CI build,
modify your Semaphore configuration file and add new block:

```yaml
# .semaphore/semaphore.yml
version: v1.0
name: Semaphore iOS example
agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave-xcode11
blocks:
  - name: Submit to HockeyApp
    task:
      env_vars:
        - name: LANG
          value: en_US.UTF-8
      secrets:
        - name: fastlane-env
        - name: ios-cert-repo
        - name: hockeyapp-env
      prologue:
        commands:
          - checkout
          - bundle install --path vendor/bundle
      jobs:
        - name: Fastlane build
          commands:
            - bundle exec fastlane prerelease
```

Semaphore maintains [an example open source iOS project][demo-project] with
working Fastlane and Semaphore configuration for your convenience.

[semaphore]: https://semaphoreci.com
[hockeyapp]: https://hockeyapp.net
[fastlane]: https://fastlane.tools
[ios-tutorial]: https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/
[code-signing]: https://docs.semaphoreci.com/examples/code-signing-for-ios-projects/
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
[appcenter-docs]: https://github.com/Microsoft/fastlane-plugin-appcenter/
[secrets]: https://docs.semaphoreci.com/guided-tour/environment-variables-and-secrets/
