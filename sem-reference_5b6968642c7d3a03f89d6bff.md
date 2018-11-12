
* [Overview](#overview-of-sem)
* [Syntax](#syntax)
* [Operations](#operations)
* [Resource types](#resource-types)
* [Working with organizations](#working-with-organizations)
* [Working with resources](#working-with-resources)
* [Adding one or more files in a new secret](#adding-one-or-more-files-in-a-new-secret)
* [Working with jobs](#working-with-jobs)
* [Working with projects](#working-with-projects)
* [Working with Pipelines](#working-with-pipelines)
* [Working with Workflows](#working-with-workflows)
* [Working with Notifications](#working-with-notifications)
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
* *debug*: the `debug` command is used for debugging `jobs` and `projects`.
* *logs*: The `logs` command is used for getting the logs of a `job`.
* *port-forward*: The `port-forward` command is used for redirecting the
    network traffic from a job that is running in the VM to your local machine.
* *help*: The `help` command is used for getting help about `sem` or an existing `sem` command.
* *init*: The `init` command is used for adding an existing GitHub repository
    to Semaphore 2.0 for the first time and creating a new project.
* *version*: The `version` command is used for getting the version of the `sem` utility.

## Resource types

Semaphore 2.0 supports seven types of resources: `secret`, `project`, `job`,
`dashboard`, `pipeline`, `workflow` and `notification`. Most resource related
operations require a resource name or ID.

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
repositories. As a result each Semaphore 2.0 project has a direct relationship
with a single GitHub repository.

However, the same GitHub repository can be assigned to multiple Semaphore 2.0
projects under different names. Additionally, the same project name can exist
under multiple Semaphore 2.0 organizations and deleting a Semaphore 2.0 project
from an organization will not automatically delete that project from the other
organizations that project exists in. Last, the related GitHub repository will
remain intact after deleting a project from Semaphore 2.0.

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

A `job` is the only Semaphore 2.0 entity that can be executed in a Virtual
Machine (VM). You cannot have a pipeline without at least one `job`.

The `jobs` of a Semaphore 2.0 pipelines are independent from each other as they
are running in completely different Virtual Machines.


### Pipelines

A `Pipeline` is


### Workflows

A `Workflow` is


### Notifications

A `Notification` is


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
file. Currently there exist four types of YAML resource files that can be
handled by `sem create`: secrets, dashboards, jobs and projects resource files.

However, for `secrets` and `dashboards` only, you can use `sem create` to
create an *empty* `secret` or `dashbord` without the need for a YAML file as
follows:

    sem create secret [name]
    sem create dashbord [name]

Should you wish to learn more about creating new resources, you can visit
the [Secrets YAML reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference),
the [Dashboard YAML reference](https://docs.semaphoreci.com/article/60-dashboards-yaml-reference),
the [Jobs YAML reference](https://docs.semaphoreci.com/article/74-jobs-yaml-reference)
and the [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
pages of the Semaphore 2.0 documentation.

#### Adding one or more files in a new secret

There exists a unique way for adding one or more files and creating a new
`secret` with them that uses the `sem create` command. The general form of the
command is the following:

    sem create secret [NAME] -f local1:secret1 [-f local2:secret2]

Each entry has two parts, which are the path to the local file and the path to
the file as it will appear in the `secret`. This is very convenient as you do
not have to rename the local files before inserting them to the `secret`.

After that you can edit, delete or use that new `secret` as usual.

The only downside of this method is that after creating a `secret` you can only
add more environment variables and files by editing the `secret`.

### sem edit

The `sem edit` command works for `secrets` and `dashboards` only and allows
you to edit the YAML representation of a `secret` or a `dashboard` using your
favorite text editor.

The `sem edit` command does not support the `job` and `project` resource types.

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

## Working with jobs

The list of commands for working with `jobs` includes the `sem attach`,
`sem logs`, `sem port-forward` and `sem debug` commands. Additionally, you can
use `sem create -f` to create a new job that is different from the usual jobs
of a pipeline.

Additionally, you can use the the `sem get` command for getting a list of all
jobs or getting a description for a particular job.

The `sem get jobs` command returns the list of all running jobs.

The `sem get jobs --all` command returns the list of all recent jobs of the
current organization, both running and finished.

### sem create -f

You can use `sem create -f` to create a new job that will be running without
being added to an existing Pipeline. This means that it will run much faster
than the same Pipeline with that job but it will not be attached to any
pipeline.

This can be very useful for checking things out like compiler versions and
package availability before adding a command into a pipeline.

When a job is created this way, it cannot be viewed in the UI of Semaphore 2.0.

### sem attach

The `sem attach` command works with running jobs only and is helpful for
debugging the operations of a `job`.

The `sem attach` command allows you to connect to the Virtual Machine (VM) of a
running job using SSH and execute any commands you want. However, as soon as
the job ends, the SSH session will automatically end and the SSH connection
will be closed.

In order to be able to connect to the VM of the `job` that interests you, you
will need to include the following command in the relevant `job` block of the
Pipeline YAML file:

    - curl https://github.com/mactsouk.keys >> ~/.ssh/authorized_keys

Replace `mactsouk` with the GitHub username that *you* are using.

If you need to include the `curl` command on every `job`, you can include it in
the `prologue` block of the `task`. An alternative way is to create a `secret`
and put you public SSH keys there.

The `sem attach` command might be a better choice than `sem debug job` while a
job is running because you can see what is happening in real time.
`sem debug job` is better when a job has finished.

### sem logs

The `sem logs` command allows you to see the log entries of a job, which is
specified by its Job ID.

The `sem logs` command works with both finished and running jobs.

### sem port-forward

The general form of the `sem port-forward` command is the following:

    sem port-forward [JOB ID of running job] [LOCAL TCP PORT] [REMOTE TCP PORT]

So, the `sem port-forward` command needs three command line arguments: the Job
ID, the local TCP port number that will be used in the local machine, and
the remote TCP port number, which is defined in the Virtual Machine (VM).

The `sem port-forward` command works with running jobs only.

### sem debug for jobs

The `sem debug` command can help you troubleshoot all types of jobs (*running*,
*stopped* and *finished*) that are not working as you might have expected.

The general form of the `sem debug` command for jobs is the following:

    sem debug job [Job ID]

What the command does is reading the specification of a job, using that
specification to build a Virtual Machine (VM) and connecting you to that VM
using SSH in order to be able to execute all the commands manually.
Additionally, there is a file in the home directory named `commands.sh` that
contains all the commands of that job, including the commands in `prologue` and
`epilogue` blocks.

The VM that is used with `sem debug job` is on the *task level*, which means
that it will be the real VM with the real environment that is used for the job
when that job is executed in a pipeline – this includes all `secrets` and
environment variables. This also means that you will be working on the actual
GitHub repository with the actual branch.

The `sem debug job` command is ideal for debugging jobs that are finished.

### On demand job creation

There is a quick way to create a job and executing it right way:

    sem create job [name] --project [existing project name] --command "[Valid command]"

You will need to provide the name of an existing project as well as a valid
command that can be executed in the Virtual Machine. The output of the
aforementioned command is a Job ID.

The only way to see the results of such a job is with the `sem logs` command.

## Working with projects

This group only includes the `sem init` and `sem debug` commands.

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

### sem debug for projects

You can use the `sem debug` command to debug an existing Semaphore 2.0 project.

The `sem debug` command can help you specify the commands of a job before
adding and executing it in a pipeline. This can be particularly helpful when
you do not know whether the Virtual Machine you are using has the latest
version of a programming language or a package and when you want to know what
you need to download in order to perform the task you want.

The general form of the `sem debug project` command is the following:

    sem debug project [Project NAME]

After that you are going to get automatically connected to the VM of the
project using SSH. The value of `SEMAPHORE_GIT_BRANCH` will be `master`
whereas the value of `SEMAPHORE_GIT_SHA` will be `HEAD`, which means that
you will be using the latest version of the `master` branch available on the
GitHub repository of the Semaphore 2.0 project.


## Working with Pipelines

There are many interesting and unique things that you can do with pipelines.


## Working with Workflows


## Working with Notifications

### List all notifications

You can list all the available notifications under the current orginization
with the `sem get notifications` command.

    sem get notifications

### Describe a notification

You can describe a notification using the `sem get notifications` command
followed by the `name` of the desired notification.

    sem get notifications [name]

### Edit a notification

You can edit a notification using the `sem edit notification` command
followed by the `name` of the desired notification.

    sem edit notification [name]

### Delete a notification

You can delete an existing notification using the `sem delete notification`
command followed by the `name` of the notification you want to delete.

    sem delete notifications [name]

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

Additionally, `-f` can be used for creating new `secrets` with multiple files.

Last, the `-f` flag can be used as `--file`.

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

You cannot execute `sem create project [name]` in order to create an empty
Semaphore 2.0 project.

### On demand job creation

    sem create job "On Demand Job" --project S2 --command "go version"

The aforementioned command creates a job named `On Demand Job` that will be
added to the `S2` Semaphore 2.0 project. The command that will be executed by 
this job is `go version`.

### sem create secret with files

Imagine that you have two files that are located at `/etc/hosts` and
`/home/rtext/docker-secrets` that you want to add to a secret. Although you
can manually add them to an existing secret, you can also use `sem create` with
the following syntax:

    sem create secret newSecret -f /etc/hosts:/var/hosts -f /home/rtext/docker-secrets:docker-secrets

After the execution of the aforementioned command, there will be a new secret
named `newSecret` with two files in it. The path of the first file will be
`/var/hosts` and the path of the second file will be `docker-secrets`.

You can verify the results of the command as follows:

    sem get secrets newSecret

The output you will get from the previous command will be similar to the
following:

```
apiVersion: v1beta
kind: Secret
metadata:
  name: newSecret
  id: 9851fa6a-681e-439c-b366-2c7283c6b363
  create_time: "1539247272"
  update_time: "1539247272"
data:
  env_vars: []
  files:
  - path: /var/log/hosts
    content: IyMKMTI3LjAuMC4xCWxvY2FsaG9zdAoyNTUuMjU1LjI1NS4yNTUJYnJvYWR
  - path: docker-secrets
    content: ICAtIG5hbWdWU6IG1hY3Rzb3Vcwo=
```

### sem delete

In order to delete an existing project named `be-careful` from the current
organization, you should execute the next command:

    sem delete project be-careful

Similarly, you can delete an existing dashboard named `my-dashboard` as
follows:

    sem delete dashboard my-dashboard

Last, you can delete an existing secret named `my-secret` as follows:

    sem delete secret my-secret

The `sem delete` command does not work with `jobs`.

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

In order to find more information about a specific job, given its Job ID,
either running or finished, you should execute the next command:

    sem get job 5c011197-2bd2-4c82-bf4d-f0edd9e69f40

### sem edit

The following command will edit an existing `secret` that is named `my-secret`
and will automatically run your favorite text editor:

    sem edit secret my-secret

What you are going to see on your screen is the YAML representation of the
`my-secret` secret.

Similarly, the next command will edit a `dashboard` named `my-activity`:

    sem edit dashboard my-activity

### sem apply

The following command will update the `my-secret` secret according to the
contents of the `aFile`, which should be a valid `secrets` YAML file:

    sem apply -f aFile

If everything is OK with `aFile`, the output of the previous command will be as
follows:

    Secret 'my-secrets' updated.

This means that the `my-secrets` secret was updated successfully.

You can also use `sem apply -f` in a similar way to update an existing dashboard.

### sem init

As `sem init` can be used without any command line arguments, you can execute
it as follows from the root directory of a GitHub repository that resides on
your local machine:

    sem init

If a `.semaphore/semaphore.yml` file already exists in the root directory of a
GitHub repository, `sem init` will keep that `.semaphore/semaphore.yml` file
and continue its operation. If there is no `.semaphore/semaphore.yml` file,
`sem init` will create one.

If you decide to use `--project-name`, then you can call `sem init` as follows:

    sem init --project-name my-own-name

The previous command creates a new Semaphore 2.0 project that will be called
`my-own-name`.

Using `--repo-url` with `sem init` is much trickier because you should know
what you are doing.

### sem attach

The `sem attach` command requires the *Job ID* of a **running** job as its single
parameter. So, the following command will connect to the VM of the job with Job
ID `6ed18e81-0541-4873-93e3-61025af0363b` using SSH:

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

    sem port-forward 6ed18e81-0541-4873-93e3-61025af0363b 8000 8080

The previous command tells `sem` to forward the network traffic from the TCP
port 8000 of the job with job ID `6ed18e81-0541-4873-93e3-61025af0363b` that is
running in a VM to TCP port 8080 of your local machine.

All traffic of `sem port-forward` is transferred over an encrypted SSH channel.

### sem debug job

The first time you execute `sem debug job`, you are going to get an output
similar to the following:

```
$ sem debug job 415b252c-b2b2-4ced-96ea-f8268d365d96
error: Public SSH key for debugging is not configured.

Before creating a debug session job, configure the debug.PublicSshKey value.

Examples:

  # Configuring public ssh key with a literal
  sem config set debug.PublicSshKey "ssh-rsa AX3....DD"

  # Configuring public ssh key with a file
  sem config set debug.PublicSshKey "$(cat ~/.ssh/id_rsa.pub)"

  # Configuring public ssh key with your GitHub keys
  sem config set debug.PublicSshKey "$(curl -s https://github.com/<username>.keys)"
```

What this output tells us is that we need to configure our Public SSH key
before using `sem debug job` for the first time – you can choose any one of
the three proposed ways.

Note that you will need to **manually terminate** the VM using either `sudo poweroff`
or `sudo shutdown -r now`.

### sem debug project

You can debug a project named `docker-push` by executing the following command:

    sem debug project docker-push

You will need to **manually terminate** the VM using either `sudo poweroff` or
`sudo shutdown -r now`.


### sem and pipelines

In this subsection you will find `sem` examples related to pipelines.


### sem and workflows

In this subsection you will find `sem` examples related to workflows.


### sem and notifications

In this subsection you will find `sem` examples related to notifications.

You can list all existing notifications under the current organization as
follows:

    sem get notifications

You can find more information about a specific notification as follows:

    sem get notifications [name]

You can edit an existing notification as follows:

    sem edit notifications [name]

Last, you can delete an existing notification as follows:

    sem delete notifications [name]

### sem version

The `sem version` command displays the used version of the `sem` tool. As an
example, if you are using `sem` version 0.4.1, the output of `sem version`
will be as follows:

    $ sem version
    mt/sem-0.8.0
    v0.8.2

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
* `pipelines`, `pipeline` and `ppl`
* `workflows`, `workflow` and `wf`
* `notifications`, `notification`, `notifs` and `notif`

As an example, the following three commands are equivalent and will return the
same output:

    sem get project
	sem get prj
	sem get projects

## See also

* [Installing sem](https://docs.semaphoreci.com/article/63-your-first-project)
* [Secrets YAML reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)
* [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
* [Changing Organizations](https://docs.semaphoreci.com/article/29-changing-organizations)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Dashboard YAML reference](https://docs.semaphoreci.com/article/60-dashboards-yaml-reference)
* [Jobs YAML reference](https://docs.semaphoreci.com/article/74-jobs-yaml-reference)
