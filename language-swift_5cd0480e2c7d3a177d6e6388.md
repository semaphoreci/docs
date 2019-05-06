Semaphore supports building, testing and releasing Swift applications in fully
customizable, autoscaling CI/CD workflows.

Details on available language and Xcode versions are provided in the [macOS
image reference][macos-mojave].

Minimal Swift project configuration example:

```yaml
# .semaphore/semaphore.yml
version: v1.0
name: Semaphore iOS Swift example
agent:
  machine:
    type: a1-standard-4
    os_image: macos-mojave
blocks:
  - name: Build
    task:
      jobs:
        - name: checkout code + build the project
          commands:
            - checkout
            - xcodebuild
```

Semaphore maintains an example Swift project demonstrating how to set up CI with
Fastlane:

- [Example project on GitHub][demo-project]
- [iOS continuous integration with Semaphore tutorial][ios-tutorial]

[macos-mojave]: https://docs.semaphoreci.com/article/120-macos-mojave-image
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode
[ios-tutorial]: https://docs.semaphoreci.com/article/124-ios-continuous-integration-xcode
