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

This document is the reference for the YAML grammar used for adding projects
to Semaphore 2.0 using the `sem` command line utility.

Projects can also be added to Semaphore 2.0 with the `sem init` command.

## Properties


## apiVersion

The `apiVersion` property

List of value for `apiVersion`: `v1alpha`.

## kind

The `kind` property

List of values for `kind`: `Project`, `Secret`.

## metadata

The `metadata` property

### name

The `name` property

## spec

The `spec` property

### repository

The `repository` property

#### url

The `url` property is a string that specifies the URL of the GitHub repository
you want to add in Semaphore 2.0.

If the value of `url` is erroneous, you will get various types of error messages.

First, if the GitHub repository cannot be found, `sem create` will reply with the
next error message:

> $ sem create -f goDemo.yaml

> error: http status 422 with message "{"message":"repository \"text/goDemo\" not found"}" received from upstream

Next, if the Semaphore 2.0 project name is already taken, `sem` will reply with
the following error message:

> $ sem create -f goDemo.yaml

> error: http status 422 with message "{"message":"project name \"goDemo2.1\" is already taken"}" received from upstream


Last, if the `url` value does not have the correct format, `sem` will print
the next kind of error message:

> $ sem create -f goDemo.yaml

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

   * [Secrets YAML reference]
   * [Changing organizations]
   * [sem utility reference]
