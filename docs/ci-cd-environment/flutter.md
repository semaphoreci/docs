# Using Semaphore's android image as CI/CD environment

The example uses our public [demo project](https://github.com/semaphoreci-demos/semaphore-demo-flutter)

```
version: v1.0
name: First pipeline example
agent:
  machine:
    type: a1-standard-4
    os_image: macos-xcode12
blocks:
  - name: Cache deps
    task:
      env_vars:
        - name: APP_ENV
          value: prod
      jobs:
        - name: Get deps
          commands:
            - checkout
            - flutter pub get
            - cache store flutter-packages .packages
    dependencies: []
  - name: Test IOS
    task:
      jobs:
        - name: Unit tests
          commands:
            - flutter test
        - name: Code analyse
          commands:
            - flutter analyze
      prologue:
        commands:
          - checkout
          - cache restore flutter-packages
    dependencies:
      - Cache deps
  - name: Test Android
    dependencies:
      - Cache deps
    task:
      prologue:
        commands:
          - checkout
          - flutter pub get
      agent:
        machine:
          type: e1-standard-2
          os_image: ubuntu1804
        containers:
          - name: main
            image: 'semaphoreci/android:29-flutter'
      jobs:
        - name: Unit Tests
          commands:
            - flutter test
        - name: Code analyse
          commands:
            - flutter analyze

```
