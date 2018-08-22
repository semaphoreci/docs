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
* [Example](#example)
* [See also](#see-also)

# Overview

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

The list of values for `apiVersion`: `v1alpha`.

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

## Example

    apiVersion: v1alpha
    kind: Secret
    metadata:
      name: a-secrets-name
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

## See also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Projects YAML Reference]
* [Pipeline YAML Reference]
