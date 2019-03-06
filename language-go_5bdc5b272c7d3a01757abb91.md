* [Supported Go Versions](#supported-go-versions)
* [Using GOPATH](#using-gopath)
* [Dependency Caching](#dependency-caching)
* [A sample Semaphore 2.0 Go project](#a-sample-go-project)

## Supported Go Versions

Go 1.10 is the default version in the Virtual Machine used by Semaphore 2.0.
Go 1.11 and Go 1.12 are supported as well. You can change versions with
`sem-version`. Here is an example of how you can select and use Go 1.11:

<pre><code class="language-yaml">blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sem-version go 1.11
      jobs:
        - name: Tests
          commands:
            - go version
</code></pre>

## Using GOPATH

If you are not using Go 1.11 then you will need to prepare the directory
structure Go tooling expects. This requires creating `$GOPATH/src` and
cloning your code into the correct directory. This is possible by changing some
environment variables and using the existing Semaphore 2.0 toolbox.

<pre><code class="language-yaml">
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
</code></pre>

## Dependency Caching

Go projects use multiple approaches to dependency management. If you are using
`dep` then the strategy is similar to other projects.

After downloading `dep`, you should use the `cache` utility to store and
restore the directory you put your source code files, which for the purposes
of this document will be named `vendor`.

You can download and install `dep` as follows:

    curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

You can initialize the cache as follows:

<pre><code class="language-yaml">
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
</code></pre>

After that you can reuse that cache as follows:

<pre><code class="language-yaml">
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
</code></pre>

## A sample Go project

The following is a simple Semaphore 2.0 project that works with a Go source
file named `hw.go`:

<pre><code class="language-yaml">
 version: v1.0
 name: A Go project in Semaphore 2.0
 agent:
   machine:
     type: e1-standard-2
     os_image: ubuntu1804

 blocks:
  - name: Build with default Go version
    task:
       jobs:
         - name: Build and Execute hw.go
           commands:
             - checkout
             - go build hw.go
             - ./hw

  - name: Run with Go 1.11
    task:
       jobs:
         - name: Run hw.go
           commands:
             - checkout
             - sem-version go 1.11
             - go run hw.go
</code></pre>
