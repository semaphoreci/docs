# Scala

This guide covers configuring Scala projects on semaphore.
If you’re new to semaphore we recommend reading the
[guided tour](https://docs.semaphoreci.com/article/77-getting-started) first.

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
    os_image: ubuntu1804
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
CI pipeline that you can use to get started quickly:

- [Scala Play Continuous Integration tutorial][tutorial]
- [Demo project on GitHub][demo-project]

## Supported Scala versions

The supported Scala versions via the [Ubuntu1804 image][ubuntu1804] are:

- 2.11.11
- 2.12.6

## Changing Scala version

You can choose the Scala version to use with the help of the
[`sem-version` utility][sem-version]

Choosing Scala version 2.11 can be done with the following command:

``` bash
sem-version scala 2.11
```

In order to go back to Scala 2.12, which is the default version of the
Semaphore Virtual Machine, you should execute the following command:

``` bash
sem-version scala 2.12
```

## Dependency management

You can use Semaphore's [cache tool](https://docs.semaphoreci.com/article/54-toolbox-reference#cache)
to store and load any files or Scala libraries that you want to reuse between jobs.

## System dependencies

Scala projects might need packages like database drivers. As you have full
`sudo` access on each Semaphore 2.0 VM, you are free to install all required
packages.

## See Also

- [Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image)
- [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
- [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)

[tutorial]: https://docs.semaphoreci.com/article/126-scala-play-continuous-integration
[demo-project]: https://github.com/semaphoreci-demos/semaphore-demo-scala-play
[ubuntu1804]: https://docs.semaphoreci.com/article/32-ubuntu-1804-image
[sem-version]: https://docs.semaphoreci.com/article/131-sem-version-managing-language-version-on-linux
