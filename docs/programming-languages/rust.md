---
description: This guide provides an explanation on how to configure Rust projects on Semaphore 2.0. It provides example projects as well that should help you get started.
---

# Rust

This guide will help you get started with a Rust project on Semaphore.
If you’re new to Semaphore, we recommend reading our
_[guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/)_ first.

## Hello World

Here is your beginning entry to getting started with Rust:
``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Rust example
agent:
  machine:
    type: e1-standard-2
  containers:
    - name: main
      image: 'registry.semaphoreci.com/rust:1.35'
blocks:
  - name: Hello world
    task:
      jobs:
      - name: Compile and run code
        commands:
          - printf 'fn main() { println!("Hello World!"); }' > hello.rs && rustc hello.rs
          - ./hello
```
**Important note**: "Semaphore convenience images redirection"

	Due to the introduction of [Docker Hub rate limits](/ci-cd-environment/docker-authentication/), if you are using a [Docker-based CI/CD environment](/ci-cd-environment/custom-ci-cd-environment-with-docker/) in combination with convenience images, Semaphore will **automatically redirect** any pulls from the `semaphoreci` Docker Hub repository to the [Semaphore Container Registry](/ci-cd-environment/semaphore-registry-images/).	

## Supported Rust versions

Semaphore supports all versions of Rust. To run Rust programs, you should define
[a Docker-based agent][docker-env] using one of the available Rust images
or build your own container image that matches your needs.

For more information about pre-built Rust images provided by Semaphore, see the
[semaphoreci/rust](/ci-cd-environment/semaphore-registry-images/#rust) documentation page.

[docker-env]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/
