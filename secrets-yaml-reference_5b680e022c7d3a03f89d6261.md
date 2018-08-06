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


### kind


The list of valid values for the `kind` property includes `Secret` and
`Project`.

### metadata


#### name in metadata

### data:



### env_vars


#### name in env_vars


#### value


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


## See also

* [sem Utility Reference]
* [Projects YAML Reference]
* [Pipeline YAML Reference]