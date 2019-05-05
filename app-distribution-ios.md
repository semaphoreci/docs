This document gives examples of configuring app distribution of iOS app to HockeyApp and TestFlight using `fastlane`.

- [Configuring the project](#configuring-the-project)
- [TestFlight](#testflight)
- [Hockey App](#hockey-app)

## Configuring the project
Make sure to configure your project to use `fastlane`, `match` and code signing by following our [Code Signing for iOS Guide](/docs/code-signing-ios).

## TestFlight
To enable publishing to TestFlight, create a separate lane where you'll invoke the appropriate commands.

    # fastlane/Fastfile

    # ...

    desc "Submit the app to TestFlight"
    lane :release do
        match(type: "appstore")
        gym
        pilot
    end

For the whole process to work, make sure you configure environment variables required for `match` and `pilot`. Namely, the URL for `match`'s certificate repository, encryption password for it, and Apple ID for logging in to the Apple Developer portal and submitting new build. This is described in the [Code Signing for iOS Guide](/docs/code-signing-ios).

In your `.semaphore/semaphore.yml` file, you can now use `bundle exec fatlane build` command in a job.

    # .semaphore/semaphore.yml

    # ...
    blocks:

    ...

      - name: Submit to TestFlight
      task:
      env_vars:
          - name: LANG
          value: en_US.UTF-8
      prologue:
          commands:
          - checkout
          ...
      jobs:
          - name: Fastlane build
          commands:
              - ...
              - bundle exec fastlane release
      secrets:
          ...


## Hockey App
To submit your build to HockeyApp, you should install the fastlane plugin that provides the functionality:

    bundle exec fastlane add_plugin appcenter

Consult with [AppCenter documentation](https://github.com/Microsoft/fastlane-plugin-appcenter/) to learn how to obtain API token and other configuration variables.

To enable the Semaphore CI the access to the App Center, you can configure the fastlane to use envrionment variables from Semaphore CI.

    $> sem create secret hockeyapp-env \
         -e APPCENTER_API_TOKEN="<API token for App Center>" \
         -e APPCENTER_OWNER_NAME="<owner name>"

Then, in your Fastfile:

    # fastlane/Fastfile

    # ...

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

Now, to make the App Center environment variables available during the CI build, modify your `semaphore.yml` file and add new block:

    # .semaphore/semaphore.yml

    # ...
    blocks:

    ...

      - name: Submit to Hockey App
      task:
      env_vars:
          - name: LANG
          value: en_US.UTF-8
      prologue:
          commands:
          - checkout
          ...
      jobs:
          - name: Fastlane build
          commands:
              - ...
              - bundle exec fastlane prerelase
      secrets:
          ...
          - name: hockeyapp-env




            