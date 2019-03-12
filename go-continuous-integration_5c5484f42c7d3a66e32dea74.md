This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for Go project.

* [Demo project](#demo-project)
* [Overview of the CI pipeline](#overview-of-the-ci-pipeline)
* [What the application uses](#what-the-application-uses)
* [Explaining the sample project](#explaining-the-sample-project)
* [Run the demo Go project yourself](#run-the-go-demo-project-yourself)
* [See also](#see-also)

## Demo project

Semaphore 2.0 has support for building Go projects using the supported Go
versions that are listed in the
[VM reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image#go).
The way to select the desired Go version is by using the
[`sem-version`](https://docs.semaphoreci.com/article/54-toolbox-reference#sem-version)
utility.

Semaphore maintains an example Go project that you can use:

* [Demo Go project on GitHub](https://github.com/semaphoreci-demos/semaphore-demo-go)

The `webServer.go` file included in the GitHub repository is a Go implementation
of a web server whereas the `webServer_test.go` file includes the Go `test`
package used for testing the Go project.

## Overview of the CI/CD pipeline

The Semaphore pipeline performs the following tasks:

- Builds the Go project and stores the executable file in the Semaphore Server
- Scans the code for style
- Runs Unit and Integration tests

The pipeline looks as follows:

![Go CI pipeline](https://github.com/semaphoreci-demos/semaphore-demo-go/raw/master/public/ci-pipeline.png)

## What the application uses

The application uses:

- Go 1.12
- The `gofmt` Go tool
- The Postgres database server
- The [lib/pq Go library](https://github.com/lib/pq) for interacting with Postgres

## Sample configuration

The contents of the `.semaphore/semaphore.yml` file are as follows:

	# Use the latest stable version of Semaphore 2.0 YAML syntax:
	version: v1.0
    
	# Name your pipeline. In case you connect multiple pipelines with promotions,
	# the name will help you differentiate between, for example, a CI build phase
	# and delivery phases.
	name: Go project
    
	# An agent defines the environment in which your code runs.
	# It is a combination of one of available machine types and operating
	# system images.
	# See https://docs.semaphoreci.com/article/20-machine-types
	# and https://docs.semaphoreci.com/article/32-ubuntu-1804-image
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	# Blocks are the heart of a pipeline and are executed sequentially.
	# Each block has a task that defines one or more jobs. Jobs define the
	# commands to execute.
	# See https://docs.semaphoreci.com/article/62-concepts
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

## Explaining the sample project

Each `.semaphore/semaphore.yml` file begins with a preamble that defines the
environment you are going to work with. In this case the preamble is as
follows:

    version: v1.0
    name: Go project
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804

In this preamble we are defining the version of the YAML grammar, the name of
the pipeline and the agent that is going to be used. In this case the agent is
going to be running Linux (`ubuntu1804`) on a `e1-standard-2` machine (hardware).
You can learn more about machine types [here](https://docs.semaphoreci.com/article/20-machine-types).

Now, it is time to explain what each `block` of the `.semaphore/semaphore.yml`
file does.

The first `block` is defined as follows:

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

The `sem-version` utility allows us to select and use Go version 1.12 instead
of the default Go version found in the Semaphore VM. The `checkout` utility is
used for checking out the source code that can be found at the GitHub
repository. The `cache store` command is used for keeping the generated
executable binary file in the Semaphore Cache servers in order reuse it and not
having to build it again.

The second `block` is as follows:

    - name: Check code style
      task:
        jobs:
        - name: gofmt
          commands:
            - checkout
            - sem-version go 1.12
            - yes | sudo apt install gccgo-go
            - gofmt webServer.go | diff --ignore-tab-expansion webServer.go -

The `gofmt`, which is manually installed, makes sure that the Go code follows
the Go code standards. The `yes | sudo apt install gccgo-go` command is used
for its installation.

The last `block` that has two jobs is defined with the following commands:

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

The first job runs that automated tests whereas the second job makes sure that
the developed web server accepts incoming requests. The `sem-service` utility
is used for starting the desired version of the Postgres database server.
The `curl` utility, which is installed by default on Semaphore VM, is used as
an HTTP client for connecting to the desired URL of the web server.

## Run the Go demo project yourself

A good way to start using Semaphore is to take a demo project and run it
yourself. Here’s how to build the demo project with your own account:

1. [Fork the project on GitHub][https://github.com/semaphoreci-demos/semaphore-demo-go] to your own account.
2. Clone the repository on your local machine.
3. In Semaphore, follow the link in the sidebar to create a new project.
   Follow the instructions to install the `sem` CLI and connect it to your
   organization.
4. Run `sem init` inside your repository.
5. Edit the `.semaphore/semaphore.yml` file and make a commit. When you push a
   commit to GitHub, Semaphore will run the CI pipeline.

### See also

* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Ubuntu 18.04 image](https://docs.semaphoreci.com/article/32-ubuntu-1804-image)
