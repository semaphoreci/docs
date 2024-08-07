---
description: This guide provides an explanation on how to configure Scala projects on Semaphore 2.0. It provides example projects as well that should help you get started.
---

# Scala

This guide covers configuring Scala projects on Semaphore.
If you’re new to Semaphore, we recommend reading the
[guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) first.

## Hello world

The following Semaphore configuration file compiles and executes a Scala
program:

``` yaml
# .semaphore/semaphore.yml

version: v1.0
name: Using Scala in Semaphore
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: Choose version
    task:
      jobs:
      - name: Choose Scala version
        commands:
          - checkout
          - sem-version scala 2.12
          - scala hello.scala
```

The contents of the Scala program are as follows:

``` scala
// hello.scala

object HW {
    def main(args: Array[String]) {
      println("Hello World!")
    }
  }
```

## Scala Play example project

Semaphore provides a tutorial and demo Play application with a working
CI pipeline that you can use to get started quickly. You can find them here:

- [Scala Play Continuous Integration tutorial][tutorial]
- [Demo project on GitHub][demo-project]

## Supported Scala versions

For supported Scala versions check:

- [Ubuntu 20.04 image][ubuntu2004]
- [Ubuntu 22.04 image][ubuntu2204]

## Changing the Scala version

You can choose the Scala version to use with the help of the
[`sem-version` utility][sem-version]

Choosing Scala version 2.12 can be done with the following command:

``` bash
sem-version scala 2.12
```

## Dependency management

You can use Semaphore's [cache tool](https://docs.semaphoreci.com/reference/toolbox-reference/#cache)
to store and load any files or Scala libraries that you want to reuse between jobs.

## System dependencies

Scala projects might need packages like database drivers. As you have full
`sudo` access on each Semaphore 2.0 VM, you are free to install all required
packages.

## See Also

- [Ubuntu 20.04 image reference](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/)
- [Ubuntu 22.04 image reference](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-22.04-image/)
- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)

[tutorial]: https://docs.semaphoreci.com/examples/scala-play-continuous-integration/
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-scala-play
[ubuntu2004]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/
[ubuntu2204]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-22.04-image/
[sem-version]: https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/
