
* [Overview](#overview-of-sem)
* [Syntax](#syntax)
* [Operations](#operations)
* [Resource types](#resource-types)
* [Working with organizations](#working-with-organizations)
* [Working with resources](#working-with-resources)
* [Project initialization](#project-initialization)
* [Help commands](#help-commands)
* [Flags](#flags)
* [Examples](#examples)
* [See also](#see-also)

## Overview of sem

`sem` is the command line interface to Semaphore 2.0. This reference page
covers the syntax and the commands of `sem` and presents examples of the `sem`
commands.

## Syntax

The general syntax of the `sem` utility is as follows:

    sem [COMMAND] [RESOURCE] [NAME] [flags]

where `[COMMAND]` is the name of the command as explained in this reference
page, `[RESOURCE]` is the resource type that interests us, `[NAME]` is the
actual name of the resource and `[flags]` are optional flags.

Not all `sem` commands require a `[RESOURCE]` value and most `sem` commands do
not have a `[flag]` part.

Some of the `[flags]` values need an additional argument, as it is the case
with the `-f` flag, which requires a valid path to a local file.

## Operations

The following list briefly describes the `sem` operations:

* *connect*: The `connect` command is used for connecting to an organization for the first time.
* *context*: The `context` command is used for switching organizations.
* *create*: The `create` command is used for creating new resources.
* *delete*: The `delete` command is used for deleting existing resources.
* *describe*: The `describe` command is used for getting information about existing resources.
* *get*: The `get` command is used for getting the list of an existing type of resource.
* *help*: The `help` command is used for getting help about `sem` or an existing `sem` command.
* *init*: The `init` command is used for adding an existing GitHub repository to Semaphore 2.0 for the first time.
* *version*: The `version` command is used for getting the version of the `sem` utility.

## Resource types

Semaphore 2.0 supports two types of resources: `secret` and `project`. Most
resource related operations also require a resource name.

### Secrets

You can consider a `secret` as a place where you can store your sensitive data.

Each `secret` is associated with a single organization. In other words, a
`secret` belongs to an organization. In order to use a specific `secret` you
should be connected to its organization.

### Projects

A project is the way Semaphore 2.0 organizes, stores and processes GitHub
repositories. As a result each Semaphore 2.0 project has a one-to-one
relationship with a GitHub repository.

However, the same GitHub repository can be assigned to multiple Semaphore 2.0
projects. Additionally, the same project can exist under multiple Semaphore 2.0
organizations and that deleting a Semaphore 2.0 project from an organization
will not automatically delete that project from the other organizations that
project exists in. Last, the related GitHub repository will remain intact after
deleting a project from Semaphore 2.0.

Last, you can use the same project name under multiple organizations but you
cannot use the same project name more than once under a single organization.

## Working with organizations

This group of `sem` commands for working with organizations contains the
`sem connect` and `sem context` commands.

### sem connect

The `sem connect` command allows you to connect to a Semaphore 2.0 organization
for the first time and requires two command line arguments. The first command
line argument is the organization domain and the second command line argument
is the user authentication token – the organization must already exist.
Organizations are created using the web interface of Semaphore 2.0. The
authentication token depends on the active user.

Once you connect to an organization, you do not need to execute `sem connect`
for connecting to that organization again – you can connect to any
organization that you are already a member of using the `sem context` command.

### sem context

The `sem context` command is used for listing the organizations the active
Semaphore 2.0 user belongs to and for changing between organizations.

The `sem context` command can be used with or without any command line
parameters. If `sem context` is used without any other command line parameters,
it returns the list of Semaphore 2.0 organizations the active has previously
connected to with the `sem` utility. When used with a command line argument,
which should be a valid organization the active user belongs to, `sem context`
will change the active organization to the given one.

## Working with resources

This group of `sem` commands includes the four most commonly and frequently
used commands: `sem create`, `sem delete`, `sem describe` and `sem get`. This
mainly happens because these are the commands that allow you to work with
resources.

### sem create

The `sem create` command is used for creating new resources and should always
be followed by the `-f` flag, which should be followed by a valid path to a
proper YAML file. Currently there exist two types of YAML configuration files
that can be handled by `sem create`: secrets and projects configuration files.

### sem delete

The `sem delete` command is used for deleting existing resources, which means
that is used for deleting Semaphore 2.0 projects and secrets.

Note that when you delete a secret, then that particular secret will disappear
from the active organization and all Semaphore 2.0 projects that are using it
will be affected.

When you use `sem delete` to delete a project then that particular project is
deleted from the active organization of the active user.

### sem describe

The `sem describe` command returns the description of an existing resource.
The resource type as well as the resource name should be given as command line
arguments, in that order.

### sem get

The `sem get` command returns the list of items for the given resource type
that can be found in the active organization and requires a command line
argument, which is the resource type.

## Project Initialization

This group only includes the `sem init` command.

### sem init

The `sem init` command adds a GitHub repository as a Semaphore 2.0 project to
the active organization.

The `sem init` command should be executed from within the root directory of a
GitHub repository that has been either created locally and pushed to GitHub or
cloned using the `git clone` command. The command is executed without any other
command line parameters or arguments.

## Help commands

The last group of `sem` commands includes the `sem help` and `sem version`
commands, which are help commands.

### sem help

The `sem help` command returns information about an existing command when
it is followed by a valid command name. If no command is given as a
command line argument to `sem help`, a help screen is printed.

### sem version

The `sem version` command requires no additional command line parameters and
returns the current version of the `sem` tool.

## Flags

### The --help flag

The `--help` flag, which can also be used as `-h`, is used for getting
information about a `sem` command or `sem`.

### The --verbose flag

The `--verbose` flag, which can also be used as `-v` displays verbose
output – you will see the interaction and the data exchanged between
`sem` and the Semaphore 2.0 servers.

The `-v` flag is useful for debugging.

### The -f flag

The `-f` flag allows you to specify the path to the desired YAML file that will
be used with the `sem create` command in order to create a new secret or a new
Semaphore 2.0 project.

## Examples

This section will present examples for all `sem` commands.

### sem version

The `sem version` command displays the used version of the `sem` tool. As an
example, if you are using `sem` version 0.4.1, the output of `sem version`
will be as follows:

    $ sem version
    v0.4.1

Your actual output might be different on your machine.

Additionally, the `sem version` command does not work with the `-f` flag and
does not create any additional output when used with the `-v` flag.

### sem help

The output of the `sem help` command is static and identical to the output of
the `sem` command when executed without any command line arguments.

Additionally, the `help` command can be also used as follows (the `connect`
command is used as an example here):

    sem connect help

In that case, `help` will generate information about the use of the
`sem connect` command.

### sem connect

The `sem connect` command should be executed as follows:

    sem connect tsoukalos.semaphoreci.com NeUFkim46BCdpqCAyWXN

### sem context

The next command will just list all the organizations the connected user
belongs to:

    sem context

In the output of `sem context`, the active organization will have a `*`
character in front of it.

If you use an argument with `sem context`, then that argument should be a valid
organization name as it appears in the output of `sem context`. So, in order to
change from the current organization to `tsoukalos_semaphoreci_com`, you should
execute the next command:

    sem context tsoukalos_semaphoreci_com

### sem create

The `sem create` command goes hand by hand with the `-f` flag because you
always need to provide a valid YAML file with the `sem create` command. So,
if you have a valid secret or project YAML file stored at `/tmp/valid.yaml`,
you should execute the next command in order to add that secret or
project under the current organization:

    sem create -f /tmp/valid.yaml

### sem delete project

In order to delete an existing project named `be-careful` from the current
organization, you should execute one of the next two commands:

    sem delete project be-careful

### sem delete secret

In order to delete an existing secret named `my-secrets` from the current
organization, you should execute the next command:

    sem delete secret my-secrets

### sem describe

The `sem describe` command requires a resource type and then a valid resource
name after the resource type.

In order to find out more information about a project named `docs`, you should
execute one of the next two commands:

    sem describe project docs

Similarly, in order to find out information about the contents of a `secret`
named `mySecrets`, you should execute one of the next two commands:

    sem describe secret mySecrets

### sem get

As the `sem get` command returns the list of available items that belong to the
specified resource type, you will need to specify the resource type that
interests you.

So, in order to get a list of the available projects for the current user
under the active organization, you should execute one of the following two
equivalent commands:

    sem get project

Similarly, the next command returns the list of available secrets for the
current user under the active organization:

	sem get secret

Each entry is printed on a separate line, which makes the generated output
suitable for being further processed by traditional UNIX command line tools.

### sem init

As `sem init` requires no command line arguments, you execute it as follows:

    sem init

If the `.semaphore/semaphore.yml` file is already present in the current
directory, `sem init` will fail.

## See also

* [Secrets YAML reference]  ()
* [Projects YAML reference]  ()

