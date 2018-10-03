
* [Overview](#overview-of-sem)
* [Syntax](#syntax)
* [Operations](#operations)
* [Resource types](#resource-types)
* [Working with organizations](#working-with-organizations)
* [Working with resources](#working-with-resources)
* [Project initialization](#project-initialization)
* [Working with jobs](#working-with-jobs)
* [Help commands](#help-commands)
* [Flags](#flags)
* [Examples](#examples)
* [Command aliases](#command-aliases)
* [See also](#see-also)

## Overview of sem

`sem` is the command line interface to Semaphore 2.0. This reference page
covers the syntax and the commands of `sem` and presents examples of the
various `sem` commands.

## Syntax

The general syntax of the `sem` utility is as follows:

    sem [COMMAND] [RESOURCE] [NAME] [flags]

where `[COMMAND]` is the name of the command as explained in this reference
page, `[RESOURCE]` is the resource type that interests us, `[NAME]` is the
actual name of the resource and `[flags]` are optional command line flags.

Not all `sem` commands require a `[RESOURCE]` value and most `sem` commands do
not have a `[flag]` part.

Some of the `[flags]` values need an additional argument, as it is the case
with the `-f` flag, which requires a valid path to a local file.

## Operations

The following list briefly describes all `sem` operations:

* *connect*: The `connect` command is used for connecting to an organization for the first time.
* *context*: The `context` command is used for switching organizations.
* *create*: The `create` command is used for creating new resources.
* *delete*: The `delete` command is used for deleting existing resources.
* *get*: The `get` command is used for getting a list of items for an existing
    type of resource as well as getting analytic information about specific
    resources.
* *edit*: The `edit` command is used for editing existing `secrets` and
    `dashboards` using your favorite text editor.
* *apply*: The `apply` command is used for updating existing `secrets` and
    `dashborads` using a `secret` or a `dashaboard` YAML file and requires
    the use of the `-f` flag.
* *attach*: The `attach` command is used for attaching to a running `job`.
* *logs*: The `logs` command is used for getting the logs of a `job`.
* *port-forward*: The `port-forward` command is used for redirecting the
    network traffic from a running job to the local machine and for specifying
	the remote port number, which is used in the Virtual Machine (VM), and the
	local port number, which is used by the local machine.
* *help*: The `help` command is used for getting help about `sem` or an existing `sem` command.
* *init*: The `init` command is used for adding an existing GitHub repository
    to Semaphore 2.0 for the first time and creating a new project.
* *version*: The `version` command is used for getting the version of the `sem` utility.

## Resource types

Semaphore 2.0 supports four types of resources: `secret`, `project`, `job` and
`dashboard`. Most resource related operations require a resource name.

### Secrets

A `secret` is a bucket for keeping sensitive information in the form of
environment variables and small files. Therefore, you can consider a `secret`
as a place where you can store small amounts of sensitive data such as
passwords, tokens or keys. Sharing sensitive data in a `secret` is both
safer and more flexible than storing it using plain text files or environment
variables that anyone can access.

Each `secret` is associated with a single organization. In other words, a
`secret` belongs to an organization. In order to use a specific `secret` you
should be connected to the organization that owns it.

### Projects

A project is the way Semaphore 2.0 organizes, stores and processes GitHub
repositories. As a result each Semaphore 2.0 project has a relationship with
a single GitHub repository.

However, the same GitHub repository can be assigned to multiple Semaphore 2.0
projects. Additionally, the same project can exist under multiple Semaphore 2.0
organizations and deleting a Semaphore 2.0 project from an organization
will not automatically delete that project from the other organizations that
project exists in. Last, the related GitHub repository will remain intact after
deleting a project from Semaphore 2.0.

You can use the same project name in multiple organizations but you cannot
use the same project name more than once under the same organization.

### Dashboards

A Semaphore 2.0 `dashboard` is a place when you can keep the `widgets` that you
define in order to overview the operations of your current Semaphore 2.0
organization.

A `widget` is used for following the activity of pipelines and workflows
according to certain criteria that are defined using filters that help you
narrow down the displayed information.

As it happens with `secrets`, each `dashboard` is associated with a given
organization. Therefore, in order to view a specific `dashboard` you should be
connected to the organization the `dashboard` belongs to.

### Jobs

A Semaphore 2.0 `job` is

## Working with organizations

This group of `sem` commands for working with organizations contains the
`sem connect` and `sem context` commands.

### sem connect

The `sem connect` command allows you to connect to a Semaphore 2.0 organization
for the first time and requires two command line arguments. The first command
line argument is the organization domain and the second command line argument
is the user authentication token – the organization must already exist.

Organizations are created using the web interface of Semaphore 2.0.

The authentication token depends on the active user.

Once you connect to an organization, you do not need to execute `sem connect`
for connecting to that organization again – you can connect to any
organization that you are already a member of using the `sem context` command.

### sem context

The `sem context` command is used for listing the organizations the active
Semaphore 2.0 user belongs to and for changing between organizations.

The `sem context` command can be used with or without any command line
parameters. If `sem context` is used without any other command line parameters,
it returns the list of Semaphore 2.0 organizations the active user has previously
connected to with the `sem` utility. When used with a command line argument,
which should be a valid organization name the active user belongs to,
`sem context` will change the active organization to the given one.

## Working with resources

This group of `sem` commands includes the five most commonly and frequently
used commands: `sem create`, `sem delete`, `sem edit`, `sem apply -f` and
`sem get`. This mainly happens because these are the commands that allow you to
work with resources.

### sem create

The `sem create` command is used for creating new resources and can be followed
by the `-f` flag, which should be followed by a valid path to a proper YAML
file. Currently there exist three types of YAML configuration files that can be
handled by `sem create`: secrets, dashboards and projects configuration files.

However, for `secrets` and `dashboards` only, you can use `sem create` to
create an *empty* `secret` or `dashbord` without the need for a YAML file as
follows:

    sem create secret [name]
    sem create dashbord [name]

Should you wish to learn more about creating new resources, you can visit
the [Secrets YAML reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference),
the [Dashboard YAML reference]()
and the [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
pages of the Semaphore 2.0 documentation.

The `sem create` command does not support the `job` resource type.

### sem edit

The `sem edit` command works for `secrets` and `dashboards` only and allows
you to edit the YAML representation of a `secret` or a `dashboard` using your
favorite text editor.

The `sem edit` command does not support the `job` resource type.

### sem get

The `sem get` command can do two things. First, it can return a list of items
for the given resource type that can be found in the active organization. This
option requires a command line argument, which is the resource type. Second, it
can return analytical information for an existing resource. In this case you
should provide `sem get` with the type of the resource and the name of the
resource that interests you, in that exact order.

In the first case, `sem get` can be used as follows:

    sem get [RESOURCE]

In the second case, `sem get` should be used as follows:

    sem get [RESOURCE] [name]

In the case of a `job` resource, you should give the Job ID of the job that
interests you and not its name.

### sem apply

The `sem apply` command works for `secrets` and `dashboards` and allows you to
update the contents of an existing `secret` or `dashboard` using an external
`secrets` or `dashboards` YAML file. `sem apply` is used with the `-f` command
line option followed by a valid path to a proper YAML file.

### sem delete

The `sem delete` command is used for deleting existing resources, which means
that is used for deleting Semaphore 2.0 projects, dashboards and secrets.

When you delete a secret, then that particular secret will disappear from the
active organization, which will affect all the Semaphore 2.0 projects that are
using it.

When you use `sem delete` to delete a project then that particular project is
deleted from the active organization of the active user.

Deleting a `dashboard` does not affect any Semaphore 2.0 projects.

## Project Initialization

This group only includes the `sem init` command.

### sem init

The `sem init` command adds a GitHub repository as a Semaphore 2.0 project to
the active organization.

The `sem init` command should be executed from within the root directory of the
GitHub repository that has been either created locally and pushed to GitHub or
cloned using the `git clone` command. Although the command can be executed
without any other command line parameters or arguments, it also supports the
`--project-name` and `--repo-url` options.

#### --project-name

The `--project-name` command line option is used for manually setting the name
of the Semaphore 2.0 project.

#### --repo-url

The `--repo-url` command line option allows you to manually specify the URL of
the GitHub repository in case `sem init` has difficulties finding that out.

## Working with jobs

Apart from the `sem get` command that can be used for all kinds of resources,
the commands for working with `jobs` cannot be used with other kinds of
resources. The list of commands for working with `jobs` includes the
`sem attach`, `sem logs` and `sem port-forward` commands.

### sem attach

The `sem attach` command allows you to connect to the Virtual Machine (VM) of a
running job using SSH. However, as soon as the job ends, the SSH session will
automatically finish and the SSH connection will be closed.

The `sem attach` command works with running jobs only and is helpful for
debugging purposes.

### sem logs

The `sem logs` command allows you to see the log entries of a job, which is
specified by its Job ID.

The `sem logs` command works with both finished and running jobs.

### sem port-forward

The general form of the `sem port-forward` command is the following:

    sem port-forward [JOB ID of running job] [REMOVE TCP PORT] [LOCAL TCP PORT]

The `sem port-forward` command works with running jobs only.

## Help commands

The last group of `sem` commands includes the `sem help` and `sem version`
commands, which are help commands.

### sem help

The `sem help` command returns information about an existing command when it is
followed by a valid command name. If no command is given as a command line
argument to `sem help`, a help screen is printed.

### sem version

The `sem version` command requires no additional command line parameters and
returns the current version of the `sem` tool.

## Flags

### The --help flag

The `--help` flag, which can also be used as `-h`, is used for getting
information about a `sem` command or `sem` itself.

### The --verbose flag

The `--verbose` flag, which can also be used as `-v`, displays verbose
output – you will see the interaction and the data exchanged between
`sem` and the Semaphore 2.0 API.

This flag is useful for debugging.

### The -f flag

The `-f` flag allows you to specify the path to the desired YAML file that will
be used with the `sem create` or `sem apply` commands.

### The --all flag

The `--all` flag can only be used with the `sem get jobs` command in order to
display the most recent jobs of the current organization, both running and
finished.

## Examples

This section will present examples for all the `sem` commands.

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

If you have a valid secret, dashboard or project YAML file stored at
`/tmp/valid.yaml`, you should execute the next command in order to add that
secret, dashboard or project under the current organization:

    sem create -f /tmp/valid.yaml

Additionally, the following command will create a new and empty `secret` that
will be called `my-new-secret`:

    sem create secret my-new-secret

Last, the following command will create a new and empty `dashboard` that will
be called `my-dashboard`:

    sem create dashboard my-dashboard

You cannot execute `sem create project <name>` in order to create an empty
Semaphore 2.0 project.

### sem delete

In order to delete an existing project named `be-careful` from the current
organization, you should execute the next command:

    sem delete project be-careful

Similarly, you can delete an existing dashboard named `my-dashboard` as
follows:

    sem delete dashboard my-dashboard

Last, you can delete an existing secret named `my-secret` as follows:

    sem delete secret my-secret

### sem get

As the `sem get` command works with resources, you will need to specify a
resource type when issuing a `sem get` command all the time.

So, in order to get the list of the available projects for the current user
under the active organization, you should execute the following command:

    sem get project

Similarly, the next command returns the list of the names of the available
secrets for the current user under the active organization:

    sem get secret

Each entry is printed on a separate line, which makes the generated output
suitable for being further processed by traditional UNIX command line tools.

Additionally, you can use `sem get` to display all running jobs:

    sem get jobs

Last, you can use `sem get jobs` with `--all` to display the more recent jobs
of the current organization, both running and finished:

    sem get jobs --all

In order to find out more information about a specific project named `docs`,
you should execute the next command:

    sem get project docs

Similarly, in order to find out the contents of a `secret` named `mySecrets`,
you should execute the next command:

    sem get secret mySecrets

You can also use `sem get` for displaying information about a `dashboard`:

    sem get dashboard my-dashboard

In order to find more information about a specific job, either running or
finished, you should execute the next command:

    sem get job 5c011197-2bd2-4c82-bf4d-f0edd9e69f40

### sem edit

The following command will edit an existing `secret` that is named `my-secret`
and will automatically run your favorite text editor:

    sem edit secret my-secret

What you are going to see on your screen is the YAML representation of the
`my-secret` secret.

Similarly, the next command will edit a `dashboard` named `my-activity`:

    sem edit dashboard my-activity

`sem edit` cannot be used for editing projects.

### sem apply

The following command will update the `my-secret` secret according to the
contents of the `aFile`, which should be a valid `secrets` YAML file:

    sem apply -f aFile

If everything is OK with `aFile`, the output of the previous command will be as
follows:

    Secret 'my-secrets' updated.

This means that the `secret` was updated successfully.

You can also use `sem apply -f` in a similar way to update an existing dashboard.

### sem init

As `sem init` can be used without any command line arguments, you can execute
it as follows from the root directory of a GitHub repository that resides on
your local machine:

    sem init

If a `.semaphore/semaphore.yml` file already exists in the root directory of a
GitHub repository, `sem init` will keep that `.semaphore/semaphore.yml` file
and continue its operation.

If you decide to use `--project-name`, then you can call `sem init` as follows:

    sem init --project-name my-own-name

The previous command creates a new Semaphore 2.0 project that will be called
`my-own-name`.

Using `--repo-url` with `sem init` is much trickier because you should know
what you are doing.

### sem attach

The `sem attach` command requires the *Job ID* of a running job as its
parameter. So, The following command attaches to job with Job ID 
`6ed18e81-0541-4873-93e3-61025af0363b`:

    sem attach 6ed18e81-0541-4873-93e3-61025af0363b

The job with the given Job ID must be in running state at the time of
execution of `sem attach`.

### sem logs

The `sem logs` command requires the *Job ID* of a job as its parameter:

    sem logs 6ed18e81-0541-4873-93e3-61025af0363b

The last lines of the output of the previous command of a PASSED job should be
similar to the following output:

```
✻ export SEMAPHORE_JOB_RESULT=passed
exit status: 0
Job passed.
````

### sem port-forward

The `sem port-forward` command is executed as follows:

    sem port-forward 6ed18e81-0541-4873-93e3-61025af0363b 8000 80

The previous command tells `sem` to forward the network traffic of the TCP port
8000 of the job with job ID `6ed18e81-0541-4873-93e3-61025af0363b` to the TCP
port 80 of the current machine.

### sem version

The `sem version` command displays the used version of the `sem` tool. As an
example, if you are using `sem` version 0.4.1, the output of `sem version`
will be as follows:

    $ sem version
    v0.7.0

Your output might be different.

Additionally, the `sem version` command cannot be used with the `-f` flag and
does not create any additional output when used with the `-v` flag.

### sem help

The output of the `sem help` command is static and identical to the output of
the `sem` command when executed without any command line arguments.

Additionally, the `help` command can be also used as follows (the `connect`
command is used as an example here):

    sem connect help

In that case, `help` will generate information about the use of the
`sem connect` command.

## Command aliases

The words of each line that follows, which represent resource types, are
equivalent:

* `project`, `projects` and `prj`
* `dashboard`, `dashboards` and `dash`
* `secret` and `secrets`
* `job` and `jobs`

As an example, the following three commands are equivalent and will return the
same output:

    sem get project
	sem get prj
	sem get projects

## See also

* [Installing sem](https://docs.semaphoreci.com/article/26-installing-cli)
* [Secrets YAML reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)
* [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
* [Changing Organizations](https://docs.semaphoreci.com/article/29-changing-organizations)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Dashboard YAML reference](https://docs.semaphoreci.com/article/60-dashboards-yaml-reference)
