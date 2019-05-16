- [Overview](#overview)
- [Properties](#properties)
- [apiVersion](#apiversion)
- [kind](#kind)
- [metadata](#metadata)
  - [name](#name)
- [spec](#spec)
  - [repository](#repository)
    - [url](#url)
  - [schedulers](#schedulers)
- [Examples](#examples)
- [See also](#see-also)

## Overview

This document is the YAML grammar reference used for adding and editing
Semaphore 2.0 projects using the `sem` command line utility.

Projects can also be added to Semaphore 2.0 with the `sem init` command. In
that case, you will not need to create a YAML file on your own. However,
`sem init` requires a local copy of the GitHub repository, even if that
repository is not up to date, that does not contain a
`.semaphore/semaphore.yml` file. Put simply, `sem init` is simpler but less
flexible than the `sem create` command.

To learn more about the `sem` commands for project manipulation, you can visit the
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

The `spec` property is currently used for holding the required `repository` and
optional `schedulers` properties.

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

#### schedulers

The schedulers property can contain a list of schedulers defined on the
project.

A scheduler in Semaphore 2.0 is a way to run a pre-defined pipeline on a project
at the pre-defined time.

A scheduler has a few properties: `name`, `branch`, `at` and
`pipeline_file`.

##### name

The `name` property uniquely identifies the scheduler inside an organization.

##### branch

The `branch` property specifies which currently existing branch will be used in
running the pipeline.

The chosen branch must have at least one workflow initiated by a push in order
for the scheduler to be valid.

##### at

The `at` property defines the schedule at which the pipeline will be ran.

Semaphore expects this property to be the [standard cron syntax](https://en.wikipedia.org/wiki/Cron).
For a simple way to define your cron syntax, visit [crontab.guru](https://crontab.guru/).

##### pipeline_file

The `pipeline_file` property contains the relative path to the pipeline
definition file from the root of the project.

For more information on defining a valid pipeline file, visit the
[Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml).

## Examples

A simple project:

``` yaml
apiVersion: v1alpha
kind: Project
metadata:
  name: goDemo
spec:
  repository:
    url: "git@github.com:renderedtext/goDemo.git"
```

A project with schedulers:

``` yaml
apiVersion: v1alpha
kind: Project
metadata:
  name: goDemo
spec:
  repository:
    url: "git@github.com:renderedtext/goDemo.git"
  schedulers:
    - name: first-scheduler
      branch: master
      at: "5 4 * * *"
      pipeline_file: ".semaphore/cron.yml"
    - name: second-scheduler
      branch: master
      at: "5 3 * * *"
      pipeline_file: ".semaphore/semaphore.yml"
```

## See Also

- [Secrets YAML Reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)
- [Changing organizations](https://docs.semaphoreci.com/article/29-changing-organizations)
- [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
