---
Description: This guide shows you how to use Semaphore 2.0 to set up a continuous integration (CI) pipeline for Go (Golang) projects.
---

# Golang Continuous Integration

This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for Go (Golang) projects.

## Demo project

Semaphore 2.0 has support for building Go projects, using the supported Go
versions that are listed in the [Ubuntu 20.04 image documentation][ubuntu2004].
You can select the desired Go version using the
[`sem-version`][sem-version] utility.

Semaphore maintains an example Go project that you can use:

- [Demo Go project on GitHub][demo-project]

The `webServer.go` file included in the GitHub repository is a Go implementation
of a web server, whereas the `webServer_test.go` file includes the Go `test`
package.

## Overview of the CI/CD pipeline

The Semaphore pipeline performs the following tasks:

- Builds the Go project and stores the executable file on the Semaphore Server
- Scans the code for stylistic errors
- Runs Unit and Integration tests

The pipeline looks like this:

![Go CI pipeline](https://github.com/semaphoreci-demos/semaphore-demo-go/raw/master/public/ci-pipeline.png)

## About the application

The application uses:

- Go 1.12
- The `gofmt` Go tool
- The Postgres database server
- The [lib/pq Go library](https://github.com/lib/pq) for interacting with Postgres

## Sample configuration

The contents of the `.semaphore/semaphore.yml` file are as follows:

``` yaml
version: v1.0
name: Go project example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Build project
    task:
      jobs:
      - name: Get Go packages
        commands:
          - checkout
          - sem-version go 1.12
          - go get github.com/lib/pq
          - go build webServer.go
          - mkdir bin
          - mv webServer bin
          - cache store $(checksum webServer.go) bin

  - name: Check code style
    task:
      jobs:
      - name: gofmt
        commands:
          - checkout
          - sem-version go 1.12
          - yes | sudo apt install gccgo-go
          - gofmt webServer.go | diff --ignore-tab-expansion webServer.go -

  - name: Smoke tests
    task:
      jobs:
      - name: go test
        commands:
          - checkout
          - sem-version go 1.12
          - sem-service start postgres
          - psql -p 5432 -h localhost -U postgres -c "CREATE DATABASE s2"
          - go get github.com/lib/pq
          - go test ./... -v

      - name: Test Web Server
        commands:
          - checkout
          - sem-version go 1.12
          - cache restore $(checksum webServer.go)
          - ./bin/webServer 8001 &
          - curl --silent localhost:8001/time | grep "The current time is"
```

## Explaining the sample project

Each `.semaphore/semaphore.yml` file begins with a preamble that defines the
environment you are going to work with. In this case, the preamble is as
follows:

``` yaml
version: v1.0
name: Go project example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
```

In this preamble, we define the version of the YAML grammar, the name of
the pipeline, and the agent that is going to be used to run our code.

In this case, the agent runs
[Linux (`ubuntu2004`)][ubuntu2004] on an
[`e1-standard-2` machine type][machine-types].

Now, it is time to explain what each `block` of the `.semaphore/semaphore.yml`
file does. Blocks are the heart of a pipeline and are executed sequentially.
Each block has a task that defines one or more jobs. Jobs define the commands to
execute.

The first `block` is defined as follows:

``` yaml
blocks:
  - name: Build project
    task:
      jobs:
      - name: Get Go packages
        commands:
          - checkout
          - sem-version go 1.12
          - go get github.com/lib/pq
          - go build webServer.go
          - mkdir bin
          - mv webServer bin
          - cache store $(checksum webServer.go) bin
```

The [`sem-version` utility][sem-version] allows us to select and use Go version
1.12 instead of the default Go version found in the Semaphore VM.

The [`checkout` utility][checkout] is used for checking out the source code from
a connected GitHub repository.

The [`cache store` command][cache] is used for keeping the compiled binary file
in the Semaphore cache in order to reuse it in upcoming blocks.

The second block is defined as follows:

``` yaml
blocks:
  # ...
  - name: Check code style
    task:
      jobs:
      - name: gofmt
        commands:
          - checkout
          - sem-version go 1.12
          - yes | sudo apt install gccgo-go
          - gofmt webServer.go | diff --ignore-tab-expansion webServer.go -
```

`gofmt`, which is manually installed, makes sure that the Go code follows
Go code standards. The `yes | sudo apt install gccgo-go` command is used
for installation.

The last block, that runs two parallel jobs, is defined with the following commands:

``` yaml
blocks:
  # ...
  - name: Smoke tests
    task:
      jobs:
      - name: go test
        commands:
          - checkout
          - sem-version go 1.12
          - sem-service start postgres
          - psql -p 5432 -h localhost -U postgres -c "CREATE DATABASE s2"
          - go get github.com/lib/pq
          - go test ./... -v

      - name: Test Web Server
        commands:
          - checkout
          - sem-version go 1.12
          - cache restore $(checksum webServer.go)
          - ./bin/webServer 8001 &
          - curl --silent localhost:8001/time | grep "The current time is"
```

The first job runs automated tests, whereas the second job runs a simple
integration test on the web server.

The [`sem-service` utility][sem-service]
is used for starting the desired version of the Postgres database server.

The `curl` utility, which is installed by default on Semaphore VM, is used as
an HTTP client for connecting to the desired URL of the web server.

## Run the Go demo project yourself

A good way to start using Semaphore is to take one of our demo projects and run it
yourself. Here’s how to build the Go demo project with your own account:

1. [Fork the project on GitHub][demo-project] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
   Follow the instructions to install the `sem` CLI and connect it to your
   organization.
4. Run `sem init` in your repository.
5. Edit the `.semaphore/semaphore.yml` file and make a commit. When you push a
   commit to GitHub, Semaphore will run the CI pipeline.

## Managing module dependencies in private repositories on GitHub

You can keep your Go modules private and automate installation with the
help of [GitHub tokens](https://github.com/settings/tokens):

1. [Generate a GitHub token](https://github.com/settings/tokens/new).
2. [Create a secret](https://docs.semaphoreci.com/essentials/using-secrets/#creating-and-managing-secrets) named `my-token` with the environment variable 
`GITHUB_TOKEN`, containing the information obtained above.
3. After checking out your code, configure `git` to use the token, as shown below:

`git config --global url."https://${GITHUB_TOKEN}:x-oauth-basic@github.com/mycompany".insteadOf "https://github.com/mycompany"`

where `mycompany` is the name of your account/organization.

The `.semaphore/semaphore.yml` file should have the following additions:

``` yaml
version: v1.0
name: Go project example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Build project
    task:
      secrets:
        - name: my-token
      jobs:
      - name: Get Go packages
        commands:
          - checkout
          - git config --global url."https://${GITHUB_TOKEN}:x-oauth-basic@github.com/mycompany".insteadOf "https://github.com/mycompany"
          - sem-version go 1.12
```

### See also

- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [Sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Ubuntu 20.04 image](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/)

[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-go
[ubuntu2004]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/
[machine-types]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[sem-version]: https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/
[checkout]: https://docs.semaphoreci.com/reference/toolbox-reference/#checkout
[cache]: https://docs.semaphoreci.com/reference/toolbox-reference/#cache
[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
