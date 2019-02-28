
* [Overview](#overview)
* [The sample project](#the-sample-project)
* [Explaining the sample project](#explaining-the-sample-project)
* [See also](#see-also)

## Overview

Semaphore 2.0 has support for building Go projects using the supported Go
versions that are listed in the
[VM reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image#go).
The way to select the desired Go version is by using the
[`sem-version`](https://docs.semaphoreci.com/article/54-toolbox-reference#sem-version)
utility.

You can find all required files in a GitHub
[repository](https://github.com/renderedtext/semaphore-demo-go).

## The sample project

The contents of the `.semaphore/semaphore.yml` file are as follows:


The contents of `webServer.go`, which is a Go implementation of a web server
are as follows:


The contents of `webServer_test.go`, which is the Go test package used in the
Go project are as follows:


## Explaining the sample project

Now, it is time to explain what each `block` of the `.semaphore/semaphore.yml`
file does.


### See also

* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
