 # sem-version: Managing Language Versions on Linux

The `sem-version` utility in Linux based virtual machines is used for changing
the version of a programming language.

The supported programming languages are `elixir`, `erlang`, `go`, `java`,
`php`, `ruby`, `python`, `scala` and `node`.

The general form of the `sem-version` utility is:

``` bash
sem-version [PROGRAMMING LANGUAGE] [VERSION]
```

where `[PROGRAMMING LANGUAGE]` is one of `elixir`, `erlang`, `go`, `java`,
`php`, `ruby`, `python`, `scala` and `node`. The value of the `[VERSION]`
parameter depends on the programming language used.

Example of `sem-version` in your pipeline:

``` yaml
version: v1.0
name: Testing sem-version
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: sem-version
    task:
      jobs:
      - name: Using sem-version
        commands:
          - sem-version go 1.9
          - go version
```
