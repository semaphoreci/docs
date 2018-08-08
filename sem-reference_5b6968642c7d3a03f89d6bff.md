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
the syntax and the commands of `sem` and provides examples of the commands with
output.


## Syntax

The general syntax of `sem` is as follows:

    sem [COMMAND] [RESOURCE] [NAME] [flags]

where `[COMMAND]` is the name of the command as explained in this reference
page, `[RESOURCE]` is the type of the resource that interests us, `[NAME]` is
the actual name of the resource and `[flags]` are optional flags. Some of the
`[flags]` might need an additional argument, as it is the case with the `-f`
flag, which requires a path to a local file.


## Operations

The following list briefly describes the `sem` operations:

* *config*: The `config` command is
* *connect*: The `connect` command is
* *context*: The `context` command is
* *create*: The `create` command is
* *delete*: The `delete` command is
* *describe*: The `describe` command is
* *get*: The `get` command is
* *help*: The `help` command is
* *init*: The `init` command is
* *version*: The `version` command is


## Resource types

Semaphore 2.0 has various types of resources that can be handled by `sem`. This
list includes

## Working with organizations

This group of `sem` commands includes the `sem config`, `sem connect` and `sem context` commands.


### sem config

The `sem config` command

### sem connect

The `sem connect` command

### sem context

The `sem context` command


## Working with resources

This group of `sem` commands includes the most commonly and frequently used
`sem create`, `sem delete`, `sem describe` and `sem get` commands.


### sem create

The `sem create` command


### sem delete

The `sem delete` command


### sem describe

The `sem describe` command


### sem get

The `sem get` command


## Project Initialization

This group includes the `sem init` command only.

### sem init

The `sem init` command


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

The `sem version` command displays the version of the `sem` tool. As an
example, if you are using `sem` version 0.4.1, the output of `sem version`
will be as follows:

    $ sem version
    v0.4.1

The actual output might be different on your machine.

### sem help

The output of the `sem help` command is static and identical to the output of
executing the `sem` command without any command line arguments.


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


