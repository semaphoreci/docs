# sem commad line tool Reference


## Overview of sem

`sem` is the command line interface to Semaphore 2.0.


## Syntax




## Operations


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

The `sem version` command

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


#### Secrets


#### Projects


## See also


