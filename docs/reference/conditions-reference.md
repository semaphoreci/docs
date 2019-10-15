# Conditions Reference

## Overview

The Conditions DSL is a universal way of specifying conditional execution of
CI/CD commands in Semaphore.

Using Conditions you can perform a full or regular expression matches and
combine them with boolean operations. For example:
```
branch == 'master' OR tag =~ '^v1\.'
```

Currently you can use Conditions DSL to configure following features:

- [Auto-cancel previous pipelines on a new push][auto_cancel]
- [Auto-promote next pipeline in the workflow][auto_promote]
- [Fail-fast - Stop everything as soon as a failure is detected][fail_fast]
- [Skip block execution][skip]

## Formal language definition

Formal language definition in [extended Backus-Naur Form (EBNF)][ebnf] notation:

``` txt
expression = expression bool_operator term
           | term

term = "(" expression ")"
     | keyword operator string
     | string operator keyword
     | string
     | boolean

bool_operator = "and" | "AND" | "or" | "OR"

keyword = "branch" | "BRANCH" | "tag" | "TAG" | "pull_request" | "PULL_REQUEST" |
          "result" | "RESULT" | "result_reason" | "RESULT_REASON"

operator = "=" | "!=" | "=~" | "!~"

boolean = "true" | "TRUE" | "false" | "FALSE"

string = ? all characters between two single quotes, e.g. 'master' ?
```

Each `keyword` in passed expression is replaced with actual value of that
attribute for current pipeline when expression is evaluated, and then operations
identified with one of the `operators` from above are executed with those values.

<table style="background-color: rgb(255, 255, 255);">
  <thead>
    <tr>
      <td>KEYWORD</td>
      <td>ATTRIBUTE IT REPRESENTS</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>branch</td>
      <td>Name of the Git branch from which originated the pipeline that is
      being executed.</td>
    </tr>
    <tr>
      <td>tag</td>
      <td>Name of the Git tag from which originated the pipeline that is being
      executed.</td>
    </tr>
    <tr>
      <td>pull_request</td>
      <td>The number of GitHub pull request from which originated the pipeline
      that is being executed.</td>
    </tr>
    <tr>
      <td>result</td>
      <td> Execution result of pipeline, block, or job. Possible values are: passed, stopped, canceled and failed.</td>
    </tr>
    <tr>
      <td>result_reason</td>
      <td> The reason for given result of execution. Possible values are: test, malformed, stuck, internal, user, strategy and timeout.</td>
    </tr>
  </tbody>
</table>

<table style="background-color: rgb(255, 255, 255);">
  <thead>
    <tr>
      <td>OPERATOR</td>
      <td>OPERATION RESULT</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>=</td>
      <td>True if keyword value and given string are equal</td>
    </tr>
    <tr>
      <td>!=</td>
      <td>True if keyword value and given string are not equal</td>
    </tr>
    <tr>
      <td>=~</td>
      <td>True if keyword value and given PCRE* string match</td>
    </tr>
    <tr>
      <td>!~</td>
      <td>True if keyword value and given PCRE* string do not match</td>
    </tr>
    <tr>
      <td>and</td>
      <td>True if expressions on both sides are true</td>
    </tr>
    <tr>
      <td>or</td>
      <td>True if at least one of two expressions is true</td>
    </tr>
  </tbody>
</table>

\* PCRE = Perl Compatible Regular Expression


## Usage examples

### Always true

``` yaml
blocks:
  - name: Unit tests
    skip:
      when: "true"
```

### On any branch

``` yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch =~ '.*'"
```

### When branch is master

``` yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch = 'master'"
```

### When branch starts with “df/”

``` yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch =~ '^df\/'"
```

### When branch is staging or master

``` yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch = 'staging' OR branch = 'master'"
```

### On any tag

``` yaml
blocks:
  - name: Unit tests
    skip:
      when: "tag =~ '.*'"
```

### When tag start with “v1.”

``` yaml
blocks:
  - name: Unit tests
    skip:
      when: "tag =~ '^v1\.'"
```

### When branch is master or if it is a tag

``` yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch = 'master' OR tag =~ '.*'"
```

### When branch does not start with "dev/"

``` yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch !~ '^dev\/'"
```


[ebnf]: https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form
[skip]: https://docs.semaphoreci.com/article/50-pipeline-yaml#skip-in-blocks
[fail_fast]: https://docs.semaphoreci.com/article/50-pipeline-yaml#fail_fast
[auto_cancel]: https://docs.semaphoreci.com/article/50-pipeline-yaml#auto_cancel
[auto_promote]: https://docs.semaphoreci.com/article/50-pipeline-yaml#auto_promote
