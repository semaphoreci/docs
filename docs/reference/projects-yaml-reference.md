---
Description: This is the YAML grammar reference used for adding and editing Semaphore 2.0 projects via the sem command line utility.
---

# Projects YAML Reference

This document is the YAML grammar reference used for adding and editing
Semaphore 2.0 projects via the `sem` command line utility.

Projects can also be added to Semaphore 2.0 with the `sem init` command. In
such a case, you will not need to create a YAML file. However,
`sem init` requires a local copy of the GitHub repository (even if that
repository is not up to date) that does not contain a
`.semaphore/semaphore.yml` file. Essentially, `sem init` is simpler but less
flexible than the `sem create` command.

To learn more about the `sem` commands for project manipulation, you can visit the
[sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/).

## Properties

### apiVersion

The `apiVersion` property defines the version of the YAML grammar that will be
used to define the YAML file. Different YAML versions might have
different features.

Here is a list of values for `apiVersion`: `v1alpha`.

### kind

The value of the `kind` property is a string that specifies the type of the
YAML file, i.e. whether it is for creating new projects or new secrets.
For projects, the value of the `kind` property should be `Project`.

Here is a list of values for `kind`: `Project`.

### metadata

The `metadata` property is for grouping other properties. Currently, the only
supported property is `name`.

#### name

The `name` property defines the name of a Semaphore 2.0 project as it will
be displayed in the Semaphore 2.0 user interface, and is the output of the
`sem get project` command.

The value of the `name` property should be unique among all Semaphore 2.0
projects belonging to the same organization and must only contain [a-z], [A-Z] or [0-9]
characters, dashes, and underscores – spaces are not allowed.

Using the same YAML file with different `name` values will create
multiple Semaphore 2.0 projects connected to the same GitHub repository.

### spec

The `spec` property is currently used for holding the required `repository` and
optional `schedulers` properties.

#### repository

The `repository` property is used for holding the `url`, `run_on`, and,
`forked_pull_requests` properties.

##### url

The `url` property is a string that specifies the URL of the GitHub repository
you want to add to Semaphore 2.0. The format of the `url` value should be as
follows:

``` txt
git@github.com:github_username/github_repository.git
```

If the value of `url` is erroneous, you will get various types of error
messages, as detailed below.

1. If the GitHub repository cannot be found, `sem create` will reply with the
following error message:

``` bash
$ sem create -f goDemo.yaml

error: http status 422 with message "{"message":"repository \"text/goDemo\" not found"}" received from upstream
```

2. If the Semaphore 2.0 project's name is already taken, `sem` will reply with
the following error message:

``` bash
$ sem create -f goDemo.yaml

error: http status 422 with message "{"message":"project name \"goDemo2.1\" is already taken"}" received from upstream
```

3. If the `url` value does not have the correct format, `sem` will print
the following error message:

``` bash
$ sem create -f goDemo.yaml

error: http status 422 with message "{"message":"repository url must be an SSH url"}" received from upstream
```

##### run_on

The value of the `run_on` property is an array of repository events which should trigger
new workflows for your Semaphore project.

Here is a list of values for `run_on`: `branches`, `tags`, `pull_requests`, and `forked_pull_requests`

For more information about workflow triggers, visit the
[project workflow tigger options](https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/).

##### forked\_pull\_requests

The `forked_pull_requests` property is used for holding the `allowed_secrets`
and `allowed_contributors` properties.

###### allowed\_secrets

The `allowed_secrets` property specifies the array of secrets' names that are allowed
to be exported into jobs triggered by `forked-pull-requests`. If the array is empty,
no secret will be exported.

###### allowed\_contributors

The `allowed_secrets` property specifies an array of secrets names that are allowed
to be exported into jobs triggered by `forked-pull-requests`. If the array is empty,
no secret will be exported.

##### pipeline\_file

The `pipeline_file` property is used for setting the initial pipeline file
that is executed when a post-commit hook is received by Semaphore.

The default value is `.semaphore/semaphore.yml`.

*Note*: When modifying the initial pipeline file it is necessary to also update 
the corresponding [GitHub status check](https://docs.semaphoreci.com/essentials/configuring-github-status-checks/).

##### status

The `status` property is used to specify which Semaphore pipeline(s) will
submit a status check on GitHub pull requests.

A pipeline can create a single status check as a result of the whole pipeline.
Or each block in a pipeline can create its own status check.

##### pipeline\_files

The `pipeline_files` property is a list of pipeline files for which Semaphore
will submit a status check.

Each value has two properties: `path` and `level`.

When you create a project, the default value is
`path: .semaphore/semaphore.yml, level: pipeline`.

##### path

The `path` property specifies a pipeline.

##### level

The `level` property specifies the granularity of status checks.

Here is a list of values for `level`: `block`, `pipeline`

#### schedulers

The schedulers property can contain a list of schedulers defined in the
project.

A scheduler is a way to run a pre-defined pipeline on a project
at the pre-defined time. All times are interpreted as UTC.

A scheduler has several properties: `name`, `branch`, `at`, and
`pipeline_file`.

##### name

The `name` property uniquely identifies each scheduler within an organization.

##### branch

The `branch` property specifies which branch will be used for
running the pipeline.

The chosen branch must have at least one workflow initiated by a push in order
for the scheduler to be valid.

##### at

The `at` property defines the schedule under which the pipeline will be run.

Semaphore expects this property to be in the [standard cron syntax](https://en.wikipedia.org/wiki/Cron).
For a simple way to define your cron syntax, visit [crontab.guru](https://crontab.guru/).

##### pipeline_file

The `pipeline_file` property contains the relative path to the pipeline
definition file from the root of the project.

For more information on defining a valid pipeline file, visit the
[Pipeline YAML Reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/) documentation.

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
    run_on:
      - branches
      - tags
    pipeline_file: ".semaphore/semaphore.yml"
    status:
      pipeline_files:
        - path: ".semaphore/semaphore.yml"
          level: "pipeline"
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
    run_on:
      - branches
      - tags
    pipeline_file: ".semaphore/semaphore.yml"
    status:
      pipeline_files:
        - path: ".semaphore/semaphore.yml"
          level: "pipeline"
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

- [Secrets YAML Reference](https://docs.semaphoreci.com/reference/secrets-yaml-reference/)
- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Pipeline YAML Reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [Project workflow tigger options](https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/)
