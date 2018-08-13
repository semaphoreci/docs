# sem commad line tool Reference

* [Overview](#overview-of-sem)
* [Syntax](#syntax)
* [Operations](#operations)
* [Resource types](#resource-types)
* [Working with organizations](#working-with-organizations)
* [Working with resources](#working-with-resources)
* [Project Initialization](#project-initialization)
* [Help functions](#help-functions)
* [Examples](#examples)
* [Flags](#flags)
* [See also](#see-also)


## Overview of sem

`sem` is the command line interface to Semaphore 2.0. This reference covers
the syntax and the commands of `sem` and provides examples of the `sem`
commands.

## Syntax

The general syntax of `sem` is as follows:

    sem [COMMAND] [RESOURCE] [NAME] [flags]

where `[COMMAND]` is the name of the command as explained in this reference
page, `[RESOURCE]` is the type of the resource that interests us, `[NAME]` is
the actual name of the resource and `[flags]` are optional flags. Some of the
`[flags]` might need an additional argument, as it is the case with the `-f`
flag, which requires a path to a local file.

Not all `sem` commands require a `[RESOURCE]`


## Operations

The following list briefly describes the `sem` operations:

* *config*: The `config` command is used for 
* *connect*: The `connect` command is used for connecting to organizations.
* *context*: The `context` command is used for adding an organization to your existing ones for the first time.
* *create*: The `create` command is used for creating new resources.
* *delete*: The `delete` command is used for deleting existing resources.
* *describe*: The `describe` command is used for getting information about existing resources.
* *get*: The `get` command is used for getting the list of an existing type of resource.
* *help*: The `help` command is used for getting help about `sem` or an existing `sem` command.
* *init*: The `init` command is used for adding an existing GitHub repository to Semaphore 2.0 for the first time.
* *version*: The `version` command is used for getting the used version of the `sem` command.

## Resource types

Semaphore 2.0 has various types of resources that can be handled by `sem`. This
list includes

## Working with organizations

This group of `sem` commands for working with organizations includes the
`sem config`, `sem connect` and `sem context` commands.


### sem config

The `sem config` command allows you to set, change and view individual key and
value pairs related to organizations.

### sem connect

The `sem connect` command allows you to connect to a Semaphore 2.0 organization
for the first time and requires two command line arguments. The first command
line argument is the organization name and the second command line argument is
the authentication token for that organization.

Once you connect to an organization, you do not need to execute `sem connect`
for connecting to that organization again – you can connect to any
organization that you are already a member of using the `sem context` command.


### sem context

The `sem context` command is used for listing the organizations the active
Semaphore 2.0 user belong to and changing from one organization to another.

The `sem context` command can be used with or without any command line
parameters.


## Working with resources

This group of `sem` commands includes the most commonly and frequently used
`sem create`, `sem delete`, `sem describe` and `sem get` commands because
these are the commands that allow you to work with existing resources.


### sem create

The `sem create` command is used for creating new resources and should always
be followed by the `-f` flag, which should be followed by a valid path to a
YAML file


### sem delete

The `sem delete` command is used for deleting existing resources, which means
that is used for deleting entire `secrets` buckets and Semaphore 2.0 projects.

Note that when you delete a `secrets` bucket, then that particular `secrets`
bucket disappears from the active organization and there is no way to get it
back unless you recreate that `secrets` buckets using `sem create`. However,
when you use `sem delete` to delete a project, what happens is that that
particular project is deleted from the active organization but all of its files
along with the related GitHub repository remain intact.


### sem describe

The `sem describe` command


### sem get

The `sem get` command


## Project Initialization

This group includes the `sem init` command only.

### sem init

The `sem init` command should be executed from within the root directory of a
GitHub repository that has been either created locally or cloned using the
`git clone` command. The command is executed without any other command line
parameters or arguments.

## Help functions

The last group of `sem` commands includes the `sem help` and `sem version`
commands.

### sem help

The `sem help` command


### sem version

The `sem version` command requires no additional command line parameters and
returns the current version of the `sem` tool.


## Examples


### sem version

The `sem version` command displays the used version of the `sem` tool. As an
example, if you are using `sem` version 0.4.1, the output of `sem version`
will be as follows:

    $ sem version
    v0.4.1

The actual output might be different on your machine.

### sem help

The output of the `sem help` command is static and identical to the output of
executing the `sem` command without any command line arguments.


### sem config

The `sem config`


### sem connect

The `sem connect` command allows you to connect to a Semaphore 2.0 organization
for the first time.

### sem context

The `sem context` can be used with or without any command line parameters. The
next command will just list all the organizations the connected user belongs
to:

    sem context

The active organization will have a `*` character in front of it.

If you use an argument with `sem context`, then that argument should be a valid
organization name as it appears in the output of `sem context`. So, in order to
change from the current organization to `tsoukalos_semaphoreci_com`, you should
execute the next command:

    sem context tsoukalos_semaphoreci_com

### sem create

The `sem create` command goes hand by hand with the `-f` flag because you
always need to provide a file with the `sem create` command. So, if you have
a valid secret or project YAML file stored at `/tmp/valid.yaml`, you should
execute the next command in order to add that `secrets` bucket or project under
the current organization:

    sem create -f /tmp/valid.yaml

### sem delete [project | projects]

In order to delete an existing project named `be-careful` from the current
organization, you should execute one of the next two commands:

    sem delete project be-careful
    sem delete projects be-careful

Both `project` and `projects` resource values will work with `sem delete`.

### sem delete [secret | secrets]

In order to delete an existing `secrets` bucket named `my-secrets` from the
current organization, you should execute one of the next two commands:

    sem delete secret my-secrets
    sem delete secrets my-secrets

Both `secret` and `secrets` resource values will work with `sem delete`.

### sem describe

The `sem describe` command required a resource type and then a valid resource
name after the resource type.

In order to find out more information about a project named `docs`, you should
execute one of the next two commands:

    sem describe project docs
    sem describe projects docs

Similarly, in order to find out information about the contents of a `secrets`
bucket named `mySecrets`, you should execute one of the next two commands:

    sem describe secrets mySecrets
    sem describe secret mySecrets

### sem get

The `sem get`

### sem init

    sem init

### Resources

There exist two kinds of resources: `secrets` buckets and projects.

#### Secrets

You can consider a `secrets` bucket as a place where you can store your
sensitive data.

Each `secrets` bucket is associated with a single organization. In other words,
a `secrets` bucket belongs to an organization. In order to use a specific
`secrets` bucket you should be connected to its organization.

Currently, there is no way to use two or more `secrets` buckets that belong in
different organizations in the same Semaphore 2.0 project. You should import
the desired `secrets` buckets in a single organization and used them from
there.

#### Projects

A project is the way Semaphore 2.0 organizes, stores and processes GitHub
repositories. As a result each Semaphore 2.0 project has a one-to-one
relationship with a GitHub repository.

Note that the same project can exist under multiple Semaphore 2.0 organizations
and that deleting a Semaphore 2.0 project from a organization will not
automatically delete that project from the other organizations that project
exists in.


## Flags

### The --help flag

The `--help` flag, which can also be used as `-h`

### The --verbose flag

The `--verbose` flag, which can also be used as `-v`


### The -f flag

The `-f` flag allows you to specify the path to the desired YAML file that will
be used with the `sem create` command in order to create a new `secrets` bucket
or a new Semaphore 2.0 project.


## See also

* [Secrets YAML reference]()
* [Projects YAML reference]()

