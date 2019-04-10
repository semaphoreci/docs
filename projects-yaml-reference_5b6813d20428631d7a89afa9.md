- [Overview](#overview)
- [Properties](#properties)
- [apiVersion](#apiversion)
- [kind](#kind)
- [metadata](#metadata)
  - [name](#name)
- [spec](#spec)
  - [repository](#repository)
    - [url](#url)
- [Example](#example)
- [See also](#see-also)

## Overview

This document is the reference for the YAML grammar used for adding Semaphore
2.0 projects to the active Semaphore 2.0 organization using the `create`
command of the `sem` command line utility.

Projects can also be added to Semaphore 2.0 with the `sem init` command. In
that case, you will not need to create a YAML file on your own. However,
`sem init` requires a local copy of the GitHub repository, even if that
repository is not up to date, that does not contain a
`.semaphore/semaphore.yml` file. Put simply, `sem init` is simpler but less
flexible than the `sem create` command. To learn more about the `sem init`
command you can visit the
[sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference).

## Properties

### apiVersion

The `apiVersion` property defines the version of the YAML grammar that will be
used for the definition of the YAML file. Different YAML versions might have
different features.

List of value for `apiVersion`: `v1alpha`.

### kind

The value of the `kind` property is a string that specifies the type of the
YAML file, that is whether it is for creating new projects or new secrets.
For projects the value of the `kind` property should be `Project`.

The list of values for `kind`: `Project`.

### metadata

The `metadata` property is for grouping other properties. Currently, the only
supported property is `name`.

#### name

The `name` property defines the name of the Semaphore 2.0 project as it will
be displayed in the Semaphore 2.0 user interface and the output of the
`sem get project` command.

The value of the `name` property should be unique among all Semaphore 2.0
projects of the same organization and must only contain [a-z], [A-Z] or [0-9]
characters, dashes and underscores – space characters are not allowed.

Using the same YAML file with different `name` values, will create
multiple Semaphore 2.0 projects connected to the same GitHub repository.

### spec

The `spec` property is currently used for holding the `repository` property.

#### repository

The `repository` property is used for holding the `url` property.

##### url

The `url` property is a string that specifies the URL of the GitHub repository
you want to add in Semaphore 2.0. The format of the `url` value should be as
follows:

``` txt
git@github.com:github_username/github_repository.git
```

If the value of `url` is erroneous, you will get various types of error
messages.

First, if the GitHub repository cannot be found, `sem create` will reply with the
next error message:

``` bash
$ sem create -f goDemo.yaml

error: http status 422 with message "{"message":"repository \"text/goDemo\" not found"}" received from upstream
```

Next, if the Semaphore 2.0 project name is already taken, `sem` will reply with
the following error message:

``` bash
$ sem create -f goDemo.yaml

error: http status 422 with message "{"message":"project name \"goDemo2.1\" is already taken"}" received from upstream
```

Last, if the `url` value does not have the correct format, `sem` will print
the next kind of error message:

``` bash
$ sem create -f goDemo.yaml

error: http status 422 with message "{"message":"repository url must be an SSH url"}" received from upstream
```

## Example

``` yaml
apiVersion: v1alpha
kind: Project
metadata:
  name: goDemo
spec:
  repository:
    url: "git@github.com:renderedtext/goDemo.git"
```

## See Also

- [Secrets YAML Reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)
- [Changing organizations](https://docs.semaphoreci.com/article/29-changing-organizations)
- [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
