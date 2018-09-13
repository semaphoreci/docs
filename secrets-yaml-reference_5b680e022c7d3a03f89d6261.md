* [Overview](#overview)
* [Properties](#properties)
   * [apiVersion](#apiversion)
   * [kind](#kind)
   * [metadata](#metadata)
      * [name](#name-in-metadata)
   * [data](#data)
   * [env_vars](#env_vars)
      * [name](#name-in-env_vars)
      * [value](#value)
    * [files](#files)
	  * [path](#path)
	  * [content](#content)
* [Example](#example)
* [Example with files](#example-with-files)
* [See also](#see-also)

## Overview

This document is the reference for the YAML grammar used for creating secrets.

A secret along with its contents is created under the current
organization and is available in this organization only unless you add it to
other organizations. Additionally, a secret is visible to all the
users of an organization.

## Properties


### apiVersion

The `apiVersion` property defines the version of the YAML grammar that will be
used in the current YAML file. Different versions might have different
features.

The list of values for `apiVersion`: `v1beta`.

### kind

The `kind` property defines the purpose of the YAML file. For a YAML file that
will be used for defining secrets, the value of the `kind` property should
be `Secret`.

The list of values for `kind`: `Secret`.

### metadata

The `metadata` property defines the metadata of the Secrets YAML file.
Currently, only the `name` property is allowed but this might change
in future versions.

#### name in metadata

The value of the `name` property, which is a string, in the `metadata` context
defines the name of the secret. This `name` value will be used in
the Pipeline YAML file for importing a specific secret or as an
argument to the `sem delete secret` command for deleting a specific secret.

The value of each `name` property should be unique among all secrets
that exist under the same organization and must only contain [a-z], [A-Z] or [0-9] characters,
dashes and underscores – space characters are not allowed.

### data

The `data` property, which is compulsory, currently holds a single `env_vars`
property.

### env_vars

The `env_vars` property, which is compulsory, is a list of `name` and `value`
pairs that allows you to define the names and the values of the environment
variables that will be inserted in the current secret.

#### name in env_vars

The value of the `name` property under the `env_vars` property defines the
name of an environment variable.

The name of an environment variable should follow
[these guidelines](http://pubs.opengroup.org/onlinepubs/000095399/basedefs/xbd_chap08.html).

#### value

The value of the `value` property defines the value of the environment variable
that was previously defined using a `name` property.

### files

The `files` property holds a list of items with `path` and `content` pairs and
is used for storing files in `secrets`.

#### path

The `path` property holds the name of the file that will be stored – this
value is related to the way the file is going to be referenced and restored in
the future and should not exist in the GitHub repository.

#### content

The `content` property holds the contents of the file that is defined in the
`path` property. The data of the `content` field is in Base64 representation.

## Example

    apiVersion: v1beta
    kind: Secret
    metadata:
      name: a-secret-name
    data:
      env_vars:
        - name: SECRET_ONE
          value: "This is the value of SECRET_ONE"
        - name: SECRET_TWO
          value: "This is the value of SECRET_TWO"

The previous example defines a secret named `a-secrets-name`
that contains two environment variables named `SECRET_ONE` and
`SECRET_TWO` with values `This is the value of SECRET_ONE` and
`This is the value of SECRET_TWO`, respectively.

The next file is equivalent to the previous one:

    apiVersion: v1beta
    kind: Secret
    metadata:
      name: a-secret-name
    data:
      env_vars:
        - name: SECRET_ONE
          value: "This is the value of SECRET_ONE"
        - name: SECRET_TWO
          value: "This is the value of SECRET_TWO"
	  files: []

## Example with files

	apiVersion: v1beta
	kind: Secret
	metadata:
	  name: my-secrets
	data:
	  env_vars:
	  - name: SECRET_ONE
	    value: This is a little secret
	  files:
	  - path: file.txt
	    content: SGVsbG8gU2VtYXBob3JlIDIuMAo=

The data in the `content` field is the output of the `base64 file.txt` command
because the file is stored using Base64 representation.

## See also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Changing Organizations](https://docs.semaphoreci.com/article/29-changing-organizations)