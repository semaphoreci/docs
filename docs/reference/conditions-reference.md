---
description: The Conditions DSL is a universal way of specifying conditional execution of CI/CD commands in Semaphore 2.0.
---

# Conditions Reference

The Conditions DSL is a universal way of specifying conditional execution of
CI/CD commands in Semaphore.

Using Conditions you can perform a full or regular expression matches and
combine them with boolean operations. For example:
```
branch = 'master' OR tag =~ '^v1\.'
```

Currently you can use Conditions DSL to configure following features:

- [Auto-cancel previous pipelines on a new push][auto_cancel]
- [Auto-promote next pipeline in the workflow][auto_promote]
- [Fail-fast - Stop everything as soon as a failure is detected][fail_fast]
- [Skip block execution][skip]
- [Conditionally run block][run]

## Formal language definition

Formal language definition in [extended Backus-Naur Form (EBNF)][ebnf] notation:

``` txt
expression = expression bool_operator term
           | term

term = "(" expression ")"
     | keyword operator string
     | string operator keyword
     | basic_val
     | fun
     | fun operator term

basic_val = string
          | boolean
          | integer
          | float
          | list
          | map

list = "[" "]"
     | "[" params "]"

params = basic_val
       | basic_val "," params

map = "{" "}"
    | "{" map_vals "}"

map_vals = key_val
         | key_val "," map_vals

key_val = map_key basic_val

fun = identifier "(" ")"
    | identifier "(" params ")"

bool_operator = "and" | "AND" | "or" | "OR"

keyword = "branch" | "BRANCH" | "tag" | "TAG" | "pull_request" | "PULL_REQUEST" |
          "result" | "RESULT" | "result_reason" | "RESULT_REASON"

operator = "=" | "!=" | "=~" | "!~"

boolean = "true" | "TRUE" | "false" | "FALSE"

string = ? all characters between two single quotes, e.g. 'master' ?

integer = ? any integer value, e. g. 123, -789, 42 etc. ?

float = ? any float value, e.g. 0.123, -78.9012, 42.0 etc. ?

map_key = ? string that matches [a-zA-Z][a-zA-Z0-9_\-]*: regex, e.g. first-name_1: ?

identifier = ? string that matches [a-zA-Z][a-zA-Z0-9_\-]* regex, e.g. foo-bar_1 ?
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

## Functions

The functions allow you to perform more complex checks that are not just direct
boolean or regex matches.

### change_in

The `change_in` function accepts one path or list of paths within the repository
as a first parameter. It checks if any of those paths matches or contains one
of the files that were changed in a particular range of commits.

``` txt
change_in(<file-pattern>, [configuration])

<file-pattern>  - Required. A pattern can be:

   - A file pattern relative to the root of the directory
     example: "/lib" matches every file recursively in the lib directory

   - A file pattern relative to the pipeline file
     example: "../lib" matches every file recursively in the lib directory

   - A glob pattern
     example: "/lib/**/*.js" matches every JS file in the lib directory

   - A list of multiple file patterns
     example: "['/lib', '/app', '/config/**/*.rb']" matches every file in the
     lib, app directories, and every Ruby file in the config directory

[configuration] - Optional, map containing the values for configurable parameters.
                  All parameters and their default values are stated below.
                  e.g. {on_tags: false, default_branch: 'master-new'}
```

The `change_in` function calculates the commit range that should be examined in
different ways depending on whether the workflow was initiated from the master
branch or some other branch, or if it is a tag or a pull request.

The default behavior is the following:

- On `master` branch the examined commit range is all the commits within the push
that initiated the workflow.
The same range is available in a job environment as an environment variable called
`SEMAPHORE_GIT_COMMIT_RANGE`.
The changes that are compared to the paths given as parameters in this case are
equivalent to the result of `git diff <sha 1>^ <sha N>` command where `sha 1` is
the first commit of the push and the `sha N` is the last.

- On `other (non-master)` branches the examined commit range is wider and all
the commits between the head of the current branch and the common ancestor for
that branch and the master branch are taken into account.
The changes collected from this range are equivalent to the result of `git diff
master...<current branch>` command and are later compared to the paths passed as
parameters.

- For `pull requests` the commit range of interest is from the head of the
current branch until the commit that is the common ancestor for it and the branch
that is the target of the pull request.
The changes gathered in this way are equivalent to the result of  `git diff
<pull request target branch>...<current branch>` command and are later compared
with given paths.

- For `tags` the change_in always returns true if not configured otherwise.

The behavior of `change_in` is configurable via a map of parameters that can be
given as a second parameter, as was stated above.

The supported map parameters are:

<table style="background-color: rgb(255, 255, 255);">
  <thead>
    <tr>
      <td> PARAMETER </td>
      <td> DESCRIPTION AND VALUES </td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td> on_tags </td>
      <td>
        The value of change_in function in workflows initiated by tags.
        Default value is <b>true</b>.
      </td>
    </tr>
    <tr>
      <td> default_branch </td>
      <td>
        The default value is <b>master</b>. If changed to another branch,
        change_in will behave on that branch as it behaves by default on the
        master, and all other branches will be compared to it instead of to master.
      </td>
    </tr>
    <tr>
      <td> pipeline_file </td>
      <td>
        Possible values are <b>track</b> and <b>ignore</b>, default is
        <b>track</b>. Only if track is chosen, the path to the give pipeline file
        will be automatically added to the paths that are given as a parameters
        of the change_in function.
      </td>
    </tr>
    <tr>
      <td> branch_range </td>
      <td>
        Configures the commit range that is examined on all branches except the
        default one. The default value is
        <b>$SEMAPHORE_MERGE_BASE...$SEMAPHORE_GIT_SHA </b>, where
        <b>$SEMAPHORE_MERGE_BASE</b> is default branch in workflows initiated
        from branches or targeted branch in workflows initiated from a pull
        request, and the <b>$SEMAPHORE_GIT_SHA</b> is the sha of the commit
        for which the workflow was initiated. You can use here this predefined
        values or any literal values to create ranges in double-dot or
        triple-dot syntax as described
        <a href="https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection">
        here </a> in <b>Commit ranges</b> section.
      </td>
    </tr>
    <tr>
      <td> default_range </td>
      <td>
        Configures the commit range that is examined on the default branch. The
        default value is <b>$SEMAPHORE_GIT_COMMIT_RANGE</b> which behavior is
        described above. It accepts any commit range specified in double-dot or
        triple-dot syntax and same predefined values are available as stated
        above in the description of <b>branch_range</b> property.
      </td>
    </tr>
    <tr>
      <td> exclude </td>
      <td>
        List of file patterns to exclude from the change-in pattern match.
        For example, `change_in('/', {exclude: ['/docs']})` will evaluate to true
        for any change in the repository, except if the change happens in the
        "docs" directory.
      </td>
    </tr>
  </tbody>
</table>

The `change_in` function is ideal for modeling [Monorepo CI/CD][monorepo].

Pipelines that use `change_in` expressions need the full Git history and are
[evaluated in dedicated Semaphore Jobs](pipeline-initialization).

## Usage examples for change_in

### When a directory changes

```yaml
blocks:
  - name: Test WEB server
    run:
      when: "change_in('/web-app/')"
```

### When a file changes

```yaml
blocks:
  - name: Unit tests
    run:
      when: "change_in('../Gemfile.lock')"
```

### When any file changes, except in the docs directory

```yaml
blocks:
  - name: Unit tests
    run:
      when: "change_in('/', {exclude: ['/docs']})"
```

### Changing the default branch from master to main

```yaml
blocks:
  - name: Test WEB server
    run:
      when: "change_in('/web-app/', {default_branch: 'main'})"
```

### Exclude changes in the pipeline file

**Note:** If you change the pipeline file, Semaphore will consider `change_in` as true.
The following illustrates how to disable this behaviour.

```yaml
blocks:
  - name: Test WEB server
    run:
      when: "change_in('/web-app/', {pipeline_file: 'ignore'})"
```

## Usage examples for skip

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
      when: "branch =~ '^df/'"
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
      when: "branch !~ '^dev/'"
```

[ebnf]: https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form
[skip]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#skip-in-blocks
[run]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#run-in-blocks
[fail_fast]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#fail_fast
[auto_cancel]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#auto_cancel
[auto_promote]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#auto_promote
[monorepo]: https://docs.semaphoreci.com/essentials/building-monorepo-projects
[pipeline-initialization]: https://docs.semaphoreci.com/reference/pipeline-initialization
