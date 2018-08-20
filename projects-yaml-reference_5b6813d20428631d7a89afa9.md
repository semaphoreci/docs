  * [About Projects YAML](#projects-yaml-reference)
  * [Properties](#properties)
  * [apiVersion](#apiversion)
  * [kind](#kind)
  * [metadata](#metadata)
    * [name](#name)
  * [spec](#spec)
    * [repository](#repository)
      * [url](#url)
  * [Example](#example)
  * [See also](#see-also)
 
# Projects YAML Reference

This document is the reference for the YAML grammar used for adding Semaphore
2.0 projects to the active Semaphore 2.0 organization using the `create`
command of the `sem` command line utility.

Projects can also be added to Semaphore 2.0 with the `sem init` command. In
that case, you will not need to create a YAML file on your own. However,
`sem init` requires a local copy of the GitHub repository, even if that
repository is not up to date, that does not contain a
`.semaphore/semaphore.yml` file. Put simply, `sem init` is simpler but less
flexible than the `sem create` command.

Note that all branches of a GitHub repository that is added to Semaphore
2.0 will be visible in Semaphore 2.0 automatically.

## Properties


## apiVersion

The `apiVersion` property defines the version of the YAML grammar that will be
used for the definition of the YAML file. Different YAML versions have
different features.

List of value for `apiVersion`: `v1alpha`.

## kind

The value of the `kind` property is a string that specifies the type of the
YAML file, that is whether it is for creating new projects or new `secrets`
buckets. For projects the value of the `kind` property should be `Project`.

List of values for `kind`: `Project`, `Secret`.

## metadata

The `metadata` property is for grouping other properties. Currently, the only
supported property is `name`.

### name

The `name` property defines the name of the Semaphore 2.0 project, as it will
be displayed in the Semaphore 2.0 user interface and the output of the
`sem get projects` command.

The value of the `name` property should be unique among the Semaphore 2.0
projects of the same organization.

Using the same YAML file with different `name` values, will create
multiple copies of the same GitHub repository in Semaphore 2.0.

## spec

The `spec` property is currently used for holding the `repository` property.

### repository

The `repository` property is used for holding the `url` property.

#### url

The `url` property is a string that specifies the URL of the GitHub repository
you want to add in Semaphore 2.0.

If the value of `url` is erroneous, you will get various types of error
messages.

First, if the GitHub repository cannot be found, `sem create` will reply with the
next error message:

> $ sem create -f goDemo.yaml
>
> error: http status 422 with message "{"message":"repository \"text/goDemo\" not found"}" received from upstream

Next, if the Semaphore 2.0 project name is already taken, `sem` will reply with
the following error message:

> $ sem create -f goDemo.yaml
>
> error: http status 422 with message "{"message":"project name \"goDemo2.1\" is already taken"}" received from upstream

Last, if the `url` value does not have the correct format, `sem` will print
the next kind of error message:

> $ sem create -f goDemo.yaml
>
> error: http status 422 with message "{"message":"repository url must be an SSH url"}" received from upstream

## Example

    apiVersion: v1alpha
    kind: Project
    metadata:
      name: goDemo
    spec:
      repository:
        url: "git@github.com:renderedtext/goDemo.git"


## See Also

   * [Secrets YAML Reference] ()
   * [Changing organizations] ()
   * [sem utility Reference] ()
