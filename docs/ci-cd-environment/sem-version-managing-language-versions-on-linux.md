---
Description: The `sem-version` utility is used for changing the version of a programming language. This guide shows you how it works.
---

The `sem-version` utility in Linux-based virtual machines is used for changing
the version of a programming language.

!!! warning "The `sem-version` utility does not work in a [Docker based build environment](https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/)."

The supported programming languages are `elixir`, `erlang`, `go`, `java`, `kubectl`, 
`php`, `ruby`, `python`, `scala`, and `node`.

The general form of the `sem-version` utility is shown below:

``` bash
sem-version [PROGRAMMING LANGUAGE] [VERSION] [-i|--ignore]
```

where `[PROGRAMMING LANGUAGE]` is one of the following: `elixir`, `erlang`, `go`, `java`, `kubectl`, 
`php`, `ruby`, `python`, `scala`, or `node`. The value of the `[VERSION]`
parameter depends on the programming language used. The `sem-version` utility will
fail the job if it cannot execute the requested change, unless flag `-i` or `--ignore`
is specified.

Here is an example of `sem-version` in a pipeline:

``` yaml
version: v1.0
name: Testing sem-version
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: sem-version
    task:
      jobs:
      - name: Using sem-version
        commands:
          - sem-version go 1.9
          - go version
```
