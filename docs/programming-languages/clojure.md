---
description: This guide provides an explanation on how to configure Clojure projects on Semaphore 2.0. It provides example projects as well that should help you get started.
---

# Clojure

## Supported Clojure versions

Semaphore 2.0 Virtual Machine (VM) comes with the Leiningen tool preinstalled. The
name of the binary executable is `lein` which is what will be used in the
Semaphore 2.0 project presented in this page.

## Changing Clojure version

The version of Clojure that is going to be used on a project generated by
Leiningen depends on the contents of the `project.clj` file. It can be found
in the root directory of each Leiningen project. Therefore, there is no need to
execute a specific command in order to change the current Clojure version.

## Dependency management

You can use Semaphore's [cache tool](https://docs.semaphoreci.com/reference/toolbox-reference/#cache)
to store and load any files or Clojure libraries that you want to reuse between jobs.

## System dependencies

Clojure projects might need packages like database drivers. As you have full `sudo`
access on each Semaphore 2.0 VM, you are free to install all required packages.

## A sample Clojure project

The following `.semaphore/semaphore.yml` file illustrates how to execute two
Clojure projects created using the Leiningen tool:

``` yaml
version: v1.0
name: Clojure Language Guide
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Lein version
    task:
      jobs:
      - name: Print lein version
        commands:
          - lein version

  - name: Compile with Clojure 1.9.0
    task:
      jobs:
      - name: Hello World 1.9.0
        commands:
          - checkout
          - cd one
          - lein run

  - name: Compile with Clojure 1.10.0
    task:
      jobs:
      - name: Hello World 1.10.0
        commands:
          - checkout
          - cd two
          - lein run
```

For the `one` project, the contents of `project.clj` are as follows:

``` clojure
(defproject hw "0.1.0-SNAPSHOT"
  :main one.core
  :dependencies [[org.clojure/clojure "1.9.0"]])
```

This is where you specify the Clojure version you want to use for
your project which, in this case, is 1.9.0.

For the `two` project, the contents of `project.clj` are as follows:

``` clojure
(defproject hw "0.1.0-SNAPSHOT"
  :main two.core
  :dependencies [[org.clojure/clojure "1.10.0"]])
```

Again, this is where you specify the Clojure version you want to use
for your project which, in this case, is 1.10.0.

To sum up, project `one` uses Clojure version 1.9.0 whereas project `two` uses
Clojure version 1.10.0.

The contents of the `./src/one/core.clj` file from the `one` project are as
follows:

``` clojure
(ns one.core)

(defn -main [& args]
  (println "Hello World!")
  (println "Clojure 1.9.0"))
```

The contents of the `./src/two/core.clj` file from the `two` project are as
follows:

``` clojure
(ns two.core)

(defn -main [& args]
  (println "Hello World!")
  (println "Clojure 1.10.0!"))
```

## See Also

- [Ubuntu 20.04 image reference](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/)
- [Ubuntu 22.04 image reference](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-22.04-image/)
- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [The Leiningen home page](https://leiningen.org/)
