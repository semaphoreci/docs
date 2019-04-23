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

For example, to change Go version to 1.9, use:

``` bash
sem-version go 1.9
```
