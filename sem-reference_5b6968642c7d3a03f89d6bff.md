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

The `sem version` command displays the version of the `sem` tool:

    $ sem version
    v0.4.1

The actual output might be different on your machine.

### sem help

The output of the `sem help` command is static and is as follows:

    $ sem help
    Semaphore 2.0 command line interface

    Usage:
      sem [command]

    Available Commands:
      config      Get and set configuration options.
      connect     Connect to a Semaphore endpoint
      context     Manage contexts for connecting to Semaphore
      create      Create a resource from a file.
      delete      Delete a resource.
      describe    Describe a resource
      get         List of resources.
      help        Help about any command
      init        Initialize a project
      version     Display the version

    Flags:
      -h, --help      help for sem
      -v, --verbose   verbose output

    Use "sem [command] --help" for more information about a command.

### Resources

There exist two kinds of resources: `secrets` buckets and projects.

#### Secrets

`secrets`

#### Projects

A project is

## See also


