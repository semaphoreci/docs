---
Description: This is the reference for the YAML grammar used for creating secrets in Semaphore. A secret is a bucket that stores environment variables and files.
---

# Secrets YAML Reference

This document is the reference for the YAML grammar used for creating Semaphore secrets.

A `secret` is a bucket that stores environment variables and files.

A secret (along with its contents) is created for the current organization and
is available to this organization only, unless you add it to other
organizations. Additionally, a secret is visible to all the users of an
organization.

## Properties

### apiVersion

The `apiVersion` property defines the version of the YAML grammar that will be
used in the current YAML file. Different versions might have different
features.

The list of values for `apiVersion` can be obtained by entering: `v1beta`.

### kind

The `kind` property defines the purpose of the YAML file. For a YAML file that
will be used for defining secrets, the value of the `kind` property should
be `Secret` or `ProjectSecret` if you are defining project-level secret. 

The list of values for `kind` can be obtained by entering: `Secret`.

### metadata

The `metadata` property defines the metadata of the Secrets YAML file.
Currently, only the `name` property is allowed for organization-level secrets, but this might change
in future versions.
For project-level secrets you also have to provide project id or project name in `project_id_or_name` field.

#### name in metadata

The value of the `name` property, which is a string, defines the name of the secret in the `metadata` context. 
This `name` value will be used in the Pipeline YAML file for importing a specific secret or as an
argument for the `sem delete secret` command.

The value of each `name` property should be unique for all secrets
that exist under the same organization and must only contain [a-z], [A-Z], or
[0-9] characters, dashes, and underscores – spaces are not allowed.

#### project_id_or_name in metadata

This is a required field for project-level secrets. It must contain either the project name
or project id of the project the secret is scoped to.

### org_config

The `org_config` property holds organization access policy fields, which are enabled
for organizations on [Startup plan](/account-management/startup-plan/) or higher. 
Policy fields control contain things like `projects_access`, `projects_ids`, `debug_access` and `attach_access`.

#### projects_access

This field can be set to one of three values: `ALL`, `ALLOWED` or `NONE`. If a secret 
is set to `ALL`, then all projects in the organizations can use this secret in jobs,
`NONE` does the opposite and does not allow use of the secret by any project.
When the value is set to `ALLOWED`, the secret is available to projects that are whitelisted 
in the `projects_ids` field.

#### projects_ids

This field is a list of project ids to be whitelisted to use a secret when `projects_access` is 
set to `ALLOWED`. If `projects_access` is set to `ALL` or `NONE` this whitelist is ignored.

#### debug_access

This field controls whether jobs containing the secret can be started for debugging with `sem debug`.
It can be set to either `JOB_DEBUG_YES` or `JOB_DEBUG_NO`.

#### attach_access

This field controls if a job containing the secret can be attached to with `sem attach`.
It can be set to either `JOB_ATTACH_YES` or `JOB_ATTACH_NO`.

### data

The `data` property, which is compulsory, holds a
single `env_vars` property and/or a single `files` property.

### env_vars

The `env_vars` property is a list of `name` and `value` pairs that allows you
to define the names and the values of the environment variables that will be
inserted into a secret.

#### name in env_vars

The value of the `name` property under the `env_vars` property defines the
name of an environment variable.

The name of an environment variable should follow
[these guidelines](http://pubs.opengroup.org/onlinepubs/000095399/basedefs/xbd_chap08.html).

#### value

The value of the `value` property defines the value of an environment variable
that was previously defined using the `name` property.

### files

The `files` property holds a list of items with `path` and `content` pairs and
is used for storing files in `secrets`.

#### path

The `path` property holds the name of the file that will be stored – this
value defines the way the file is going to be referenced and restored in the
future and should not exist in the repository.

#### content

The `content` property holds the contents of the file that will be referenced
by the value of the `path` property. The data of the `content` field is in
-Base64 representation-.

## Example

``` yaml
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
```

The previous example defines a secret named `a-secrets-name`,
which contains two environment variables named `SECRET_ONE` and
`SECRET_TWO`, which have the values `This is the value of SECRET_ONE` and
`This is the value of SECRET_TWO`, respectively.

The following example is equivalent to the previous example:

``` yaml
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
```

## Example with files

``` yaml
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
```

The data in the `content` field is the output of the `base64 file.txt` command,
because the contents of the file are in Base64 representation.

## Example with an empty secret

If you want to create an `empty` secret, you can define the `data` block as
follows:

``` yaml
apiVersion: v1beta
kind: Secret
metadata:
  name: empty-secret
data:
  env_vars: []
  files: []
```

## See also

- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Projects YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/)
- [Pipeline YAML Reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
