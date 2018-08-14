* [About Secrets YAML reference](#secrets-yaml-reference)
* [Properties](#properties)
   * [apiVersion](#apiversion)
   * [kind](#kind)
   * [metadata](#metadata)
      * [name](#name-in-metadata)
   * [data](#data)
   * [env_vars](#env_vars)
      * [name](#name-in-env_vars)
      * [value](#value)
* [Secrets example](#secrets-example)
* [See also](#see-also)

# Secrets YAML Reference

This document is the reference for the YAML grammar used for creating `secrets`
buckets for Semaphore 2.0 projects.

A `secrets` bucket along with its contents is created under the current
organization and is available in this organization only unless you add it to
other organizations.

## Properties


### apiVersion

The `apiVersion` property defines the version of the YAML grammar that will be
used in current YAML file. Different versions have different features.

The list of values for `apiVersion`: `v1alpha`.

### kind

The `kind` property defines the purpose of the YAML file. For a YAML file that
will be used for defining `secrets`, the value of the `kind` property should
be `Secret`.

The list of values for `kind`: `Secret`, `Project`.

### metadata

The `metadata` property defines the metadata of the Secrets YAML file.
Currently, only the `name` property is allowed but this might change
in future versions.

#### name in metadata

The value of the `name` property, which is a string, in the `metadata` context
defines the name of the `secrets` bucket. This `name` value will be used in
the Pipeline YAML file for importing a specific `secrets` bucket or as an
argument to the `sem delete secrets` command for deleting a specific `secrets`
bucket.

### data:

The `data` property, which is compulsory, currently holds a single `env_vars`
property.

### env_vars

The `env_vars` property, which is compulsory, is a list of `name` and `value`
pairs that allows you to define the names and the values of the environment
variables that will be inserted in the current `secrets` bucket.

#### name in env_vars

The value of the `name` property under the `env_vars` property defines the
name of an environment variable.

#### value

The value of the `value` property defines the value of the environment variable
that was previously defined using a `name` property.

## Secrets example

    apiVersion: v1alpha
    kind: Secret
    metadata:
      name: a-secrets-bucket-name
    data:
      env_vars:
        - name: SECRET_ONE
          value: "This is the value of SECRET_ONE"
        - name: SECRET_TWO
          value: "This is the value of SECRET_TWO"

The previous example defines a `secrets` bucket named `a-secrets-bucket-name`
that contains two secret environment variables named `SECRET_ONE` and
`SECRET_TWO` with values `This is the value of SECRET_ONE` and
`This is the value of SECRET_TWO`, respectively.

## See also

* [sem utility Reference]
* [Projects YAML Reference]
* [Pipeline YAML Reference]
