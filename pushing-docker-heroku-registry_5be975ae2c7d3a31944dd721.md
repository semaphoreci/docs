* [Overview](#overview)
* [Storing data in a secret](#storing-data-in-a-secret)
* [A Semaphore 2.0 project](#a-semaphore-project)
* [See Also](#see-also)

## Overview

This document will describe how you can work with the Heroku Container Registry
from Semaphore 2.0.

## Storing data in a secret

The first thing that you will need is to create a `secret` in Semaphore 2.0. If
your `secret` with the Heroku Container Registry data is called
`heroku`-registry, you can find out more about it as follows:


## A Semaphore project

As the `heroku` CLI is already installed on the Semaphore 2.0 Virtual Machine
you do not have to install it manually, which simplifies the YAML file of the
Semaphore 2.0 pipeline.


The contents of the `Dockerfile` are the following:

	FROM golang:alpine
    
	RUN mkdir /files
	COPY hw.go /files
	WORKDIR /files
    
	RUN go build -o /files/hw hw.go
	ENTRYPOINT ["/files/hw"]

The contents of `hw.go` are as follows:

	package main
    
	import "fmt"
    
	func main() {
		fmt.Println("Hello World!")
	}



## See Also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Heroku CLI in GitHub](https://github.com/heroku/cli)

