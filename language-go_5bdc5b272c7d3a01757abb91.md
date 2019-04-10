This guide covers configuring Golang projects on Semaphore.
If you’re new to Semaphore we recommend reading the
[Guided tour](https://docs.semaphoreci.com/article/77-getting-started) first.

- [Example project](#example-project)
- [Supported Go Versions](#supported-go-versions)
- [Using GOPATH](#using-gopath)
- [Dependency Caching](#dependency-caching)

## Example project

Semaphore provides a tutorial and example Go application with a working
CI pipeline that you can use to get started quickly:

- [Golang Continuous Integration tutorial][go-tutorial]
- [Demo project on GitHub][go-demo-project]

## Supported Go Versions

Go 1.10 is the default version in the [Ubuntu1804 VM image][ubuntu1804].  Go
1.11 and Go 1.12 are supported as well. You can change versions with
`sem-version`. Here is an example of how you can select and use Go 1.11:

``` yaml
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sem-version go 1.11
      jobs:
        - name: Tests
          commands:
            - go version
```

## Using GOPATH

If you are not using Go 1.11 then you will need to prepare the directory
structure Go tooling expects. This requires creating `$GOPATH/src` and
cloning your code into the correct directory. This is possible by changing some
environment variables and using the existing Semaphore 2.0 toolbox.

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Go Example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - export "SEMAPHORE_GIT_DIR=$(go env GOPATH)/src/github.com/${SEMAPHORE_PROJECT_NAME}"
          - export "PATH=$(go env GOPATH)/bin:${PATH}"
          - mkdir -vp "${SEMAPHORE_GIT_DIR}" "$(go env GOPATH)/bin"
      jobs:
        - name: Test Suite
          commands:
            # Uses the redefined SEMAPHORE_GIT_DIR to clone code into the correct directory
            - checkout
            # Further setup from this point on
```

## Dependency Caching

Go projects use multiple approaches to dependency management. If you are using
`dep` then the strategy is similar to other projects.

After downloading `dep`, you should use the `cache` utility to store and
restore the directory you put your source code files, which for the purposes
of this document will be named `vendor`.

You can download and install `dep` as follows:

``` bash
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
```

You can initialize the cache as follows:

``` yaml
blocks:
  - name: Warm cache
    task:
      prologue:
        commands:
          # Go project boiler plate
          - export "SEMAPHORE_GIT_DIR=$(go env GOPATH)/src/github.com/${SEMAPHORE_PROJECT_NAME}"
          - export "PATH=$(go env GOPATH)/bin:${PATH}"
          - mkdir -vp "${SEMAPHORE_GIT_DIR}" "$(go env GOPATH)/bin"
          # Dep install db
          - curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
          - checkout
      jobs:
        - name:
          commands:
            - cache restore deps-$SEMAPHORE_GIT_BRANCH-$(checksum Gopkg.lock),deps-$SEMAPHORE_GIT_BRANCH,deps-master
            - dep ensure -v
            - cache store deps-$SEMAPHORE_GIT_BRANCH-$(checksum Gopkg.lock) vendor
```

After that you can reuse that cache as follows:

``` yaml
blocks:
  - name: Tests
      prologue:
        commands:
          # Go project boiler plate
          - export "SEMAPHORE_GIT_DIR=$(go env GOPATH)/src/github.com/${SEMAPHORE_PROJECT_NAME}"
          - export "PATH=$(go env GOPATH)/bin:${PATH}"
          - mkdir -vp "${SEMAPHORE_GIT_DIR}" "$(go env GOPATH)/bin"
          # Dep install db
          - curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
          - checkout
          - cache restore deps-$SEMAPHORE_GIT_BRANCH-$(checksum Gopkg.lock),deps-$SEMAPHORE_GIT_BRANCH,deps-master
      jobs:
        - name: Suite
          commands:
            - make test
```

[ubuntu1804]: https://docs.semaphoreci.com/article/32-ubuntu-1804-image
[go-tutorial]: https://docs.semaphoreci.com/article/115-golang-continuous-integration
[go-demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-go
