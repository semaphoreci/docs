sem, the Semaphore Command Line Interface (CLI), makes it easy to create and
manage your Semaphore projects and resources directly from the terminal. It’s an
essential part of using Semaphore.

#### Table of contents

- [Download and install](#download-and-install)
- [Overview](#overview)
  - [Syntax](#syntax)
  - [Operations](#operations)
  - [Resource types](#resource-types)
    - [Dashboards](#dashboards)
    - [Jobs](#jobs)
    - [Notifications](#notifications)
    - [Projects](#projects)
    - [Secrets](#secrets)
- [Working with organizations](#working-with-organizations)
  - [sem connect](#sem-connect)
  - [sem context](#sem-context)
- [Working with resources](#working-with-resources)
  - [sem create](#sem-create)
  - [sem edit](#sem-edit)
  - [sem get](#sem-get)
  - [sem apply](#sem-apply)
  - [sem delete](#sem-delete)
- [Working with jobs](#working-with-jobs)
  - [Creating one-off jobs](#creating-one-off-jobs)
  - [sem attach](#sem-attach)
  - [sem logs](#sem-logs)
  - [sem port-forward](#sem-port-forward)
  - [sem debug for jobs](#sem-debug-for-jobs)
  - [sem stop](#sem-stop)
- [Working with projects](#working-with-projects)
  - [sem init](#sem-init)
  - [sem debug for projects](#sem-debug-for-projects)
- [Working with notifications](#working-with-notifications)
  - [Create a notification](#creating-a-notification)
  - [List notifications](#list-notifications)
  - [Describe a notification](#describe-a-notification)
  - [Edit a notification](#edit-a-notification)
  - [Delete a notification](#delete-a-notification)
- [Working with pipelines](#working-with-pipelines)
- [Working with workflows](#working-with-workflows)
- [Help commands](#help-commands)
- [Flags](#flags)
- [Defining an editor](#defining-an-editor)
- [Command aliases](#command-aliases)
- [See also](#see-also)

## Download and install

To download and install sem, copy and paste the installation command:

``` bash
curl https://storage.googleapis.com/sem-cli-releases/get.sh | bash
```

Next, you'll need to connect `sem` to an organization.
The command includes the URL and access token. In your web browser
you'll see something similar to:

``` bash
sem connect ORGANIZATION.semaphoreci.com ACCESS_TOKEN
```

You can find the exact `sem connect` command, which includes your current
organization name and access token, by invoking the CLI widget in the top-right
corner of any screen on Semaphore.

Your access token is also always available, and revokable, on your [account
page](https://me.semaphoreci.com/account).

## Overview

### Syntax

The general syntax of the `sem` utility is as follows:

``` bash
sem [COMMAND] [RESOURCE] [NAME] [flags]
```

where `[COMMAND]` is the name of the command as explained in this reference
page, `[RESOURCE]` is the resource type that interests us, `[NAME]` is the
actual name of the resource and `[flags]` are optional command line flags.

Not all `sem` commands require a `[RESOURCE]` value and most `sem` commands do
not have a `[flag]` part.

Some of the `[flags]` values need an additional argument, as it is the case
with the `-f` flag, which requires a valid path to a local file.

### Operations

The following list briefly describes all `sem` operations:

- *connect*: The `connect` command is used for connecting to an organization
    for the first time.
- *context*: The `context` command is used for switching organizations.
- *create*: The `create` command is used for creating new resources.
- *delete*: The `delete` command is used for deleting existing resources.
- *get*: The `get` command is used for getting a list of items for an existing
    type of resource as well as getting analytic information about specific
    resources.
- *edit*: The `edit` command is used for editing existing `projects`, `secrets`,
    `notifications` and `dashboards` using your configured text editor.
- *apply*: The `apply` command is used for updating existing `secrets` and
    `dashborads` using a `secret` or a `dashaboard` YAML file and requires
    the use of the `-f` flag.
- *attach*: The `attach` command is used for attaching to a running `job`.
- *debug*: the `debug` command is used for debugging `jobs` and `projects`.
- *logs*: The `logs` command is used for getting the logs of a `job`.
- *stop*: The *stop* command is used for stopping `pipelines`, `workflows` and
    `jobs` from running.
- *rebuild*: The *rebuild* command is used for rebuilding `workflows` and
    `pipelines`
- *port-forward*: The `port-forward` command is used for redirecting the
    network traffic from a job that is running in the VM to your local machine.
- *help*: The `help` command is used for getting help about `sem` or an
    existing `sem` command.
- *init*: The `init` command is used for adding an existing GitHub repository
    to Semaphore 2.0 for the first time and creating a new project.
- *version*: The `version` command is used for getting the version of the `sem`
    utility.

### Resource types

You can use sem to manipulate five types of Semaphore resources: dashboards,
jobs, notifications, projects, pipelines, workflows and secrets. Most resource
related operations require either a valid resource name or an ID.

#### Dashboards

A Semaphore 2.0 `dashboard` is a place when you can keep the `widgets` that you
define in order to overview the operations of your current Semaphore 2.0
organization.

A `widget` is used for following the activity of pipelines and workflows
according to certain criteria that are defined using filters that help you
narrow down the displayed information.

As it happens with `secrets`, each `dashboard` is associated with a given
organization. Therefore, in order to view a specific `dashboard` you should be
connected to the organization the `dashboard` belongs to.

#### Jobs

A `job` is the only Semaphore 2.0 entity that can be executed in a Virtual
Machine (VM). You cannot have a pipeline without at least one `job`.

The `jobs` of a Semaphore 2.0 pipelines are independent from each other as they
are running in completely different Virtual Machines.

#### Notifications

A notification offers a way for sending messages to one or more Slack
channels or users. Notifications are delivered on the success or failure of a
pipeline. Notification rules contain user-defined criteria and filters.

A notification can contain multiple rules that are being evaluated each time
a pipeline ends, either successfully or unsuccessfully.

#### Projects

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

#### Pipelines

The smallest unit of scheduling and execution in Semaphore 2.0 is the **Job**.
A `pipeline` is the Semaphore 2.0 entity where jobs are defined in order to get
executed in a Virtual Machine.

Each `pipeline` is defined using a YAML file. The YAML file of the initial
pipeline is always `.semaphore/semaphore.yml`.

#### Workflows

Put simply, a `workflow` is the execution of a Semaphore 2.0 project. Each
workflow has its own Workflow ID that uniquely differentiates each workflow
execution from the other workflow executions.

A `workflow` is composed of one or more `pipelines` depending on whether there
exist promotions or auto promotions in the `workflow`. Therefore, a workflow
should be viewed of as *a group of pipelines* or, if you like strict
definitions, as a dynamically configurable, n-ary tree of pipelines.

#### Secrets

A `secret` is a bucket for keeping sensitive information in the form of
environment variables and small files. Therefore, you can consider a `secret`
as a place where you can store small amounts of sensitive data such as
passwords, tokens or keys. Sharing sensitive data in a `secret` is both
safer and more flexible than storing it using plain text files or environment
variables that anyone can access.

Each `secret` is associated with a single organization. In other words, a
`secret` belongs to an organization. In order to use a specific `secret` you
should be connected to the organization that owns it.

## Working with organizations

This group of `sem` commands for working with organizations contains the
`sem connect` and `sem context` commands.

### sem connect

The `sem connect` command allows you to connect to a Semaphore 2.0 organization
for the first time and requires two command line arguments. The first command
line argument is the organization domain and the second command line argument
is the user authentication token – the organization must already exist.

The `sem connect` command checks whether the user entered the correct
authentication token or not. If the authentication token is correct, it is
stored on the current computer. If the authentication token is incorrect, then
it is not stored on the current computer.

Organizations are created using the web interface of Semaphore 2.0.

The authentication token depends on the active user.

Once you connect to an organization, you do not need to execute `sem connect`
for connecting to that organization again – you can connect to any
organization that you are already a member of using the `sem context` command.

#### sem connect example

The `sem connect` command should be executed as follows:

``` bash
sem connect tsoukalos.semaphoreci.com NeUFkim46BCdpqCAyWXN
```

### sem context

The `sem context` command is used for listing the organizations the active
Semaphore 2.0 user belongs to and for changing between organizations.

The `sem context` command can be used with or without any command line
parameters. If `sem context` is used without any other command line parameters,
it returns the list of Semaphore 2.0 organizations the active user has previously
connected to with the `sem` utility. When used with a command line argument,
which should be a valid organization name the active user belongs to,
`sem context` will change the active organization to the given one.

#### sem context example

The next command will just list all the organizations the connected user
belongs to:

``` bash
sem context
```

In the output of `sem context`, the active organization will have a `-`
character in front of it.

If you use an argument with `sem context`, then that argument should be a valid
organization name as it appears in the output of `sem context`. So, in order to
change from the current organization to `tsoukalos_semaphoreci_com`, you should
execute the next command:

``` bash
sem context tsoukalos_semaphoreci_com
```

## Working with resources

This group of `sem` commands includes the five most commonly and frequently
used commands: `sem create`, `sem delete`, `sem edit`, `sem apply` and
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

``` bash
sem create secret [name]
sem create dashbord [name]
```

Should you wish to learn more about creating new resources, you can visit
the [Secrets YAML reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference),
the [Dashboard YAML reference](https://docs.semaphoreci.com/article/60-dashboards-yaml-reference),
the [Jobs YAML reference](https://docs.semaphoreci.com/article/74-jobs-yaml-reference)
and the [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
pages of the Semaphore 2.0 documentation.

#### sem create examples

If you have a valid secret, dashboard or project YAML file stored at
`/tmp/valid.yaml`, you should execute the next command in order to add that
secret, dashboard or project under the current organization:

``` bash
sem create -f /tmp/valid.yaml
```

Additionally, the following command will create a new and empty `secret` that
will be called `my-new-secret`:

``` bash
sem create secret my-new-secret
```

Last, the following command will create a new and empty `dashboard` that will
be called `my-dashboard`:

``` bash
sem create dashboard my-dashboard
```

You cannot execute `sem create project [name]` in order to create an empty
Semaphore 2.0 project.

#### sem create secret with environment variables and files

To create a secret with a list of environment variables and files, you can pass
them during creation.

For example to create a secret `example-secret` with two environment variables
and a file, use:

``` bash
sem create secret example-secret \
  -e FOO=BAR \
  -e "MESSAGE=Hello World" \
  -f /Users/John/hello.txt:/home/semaphore/hello.txt
```

Use the `-f` or `--file` flag to specify one or more files. The format of the
parameter is `<local-path>:<path-on-sempahore>`. If the `<path-on-semaphore>` is
an absolute path, for example `/etc/hosts` it will be mounted to `/etc/hosts`.
If the `<path-on-semaphore>` is a relative path, for example `.ssh/id_rsa_test`
it will be mounted relative to the home directory, in this example
`/home/semaphore/.ssh/id_rsa_test`.

Use the `-e` or `--env` flag to specify one or more environment variables. The
format of the parameter is `<NAME>=<VALUE>`.

### sem edit

The `sem edit` command works for `projects`, `secrets`, `notifications` and
`dashboards` and allows you to edit the YAML representation of these resources
using your configured text editor.

The `sem edit` command does not support the `job` resource type.

#### sem edit examples

The following command will edit an existing `secret` that is named `my-secret`
and will automatically run your configured text editor:

``` bash
sem edit secret my-secret
```

What you are going to see on your screen is the YAML representation of the
`my-secret` secret.

Similarly, the next command will edit a `dashboard` named `my-activity`:

``` bash
sem edit dashboard my-activity
```

To edit a `project` with the name `my-project`, use the following command:

``` bash
sem edit project my-project
```

### sem get

The `sem get` command can do two things. First, it can return a list of items
for the given resource type that can be found in the active organization. This
option requires a command line argument, which is the resource type. Second, it
can return analytical information for an existing resource. In this case you
should provide `sem get` with the type of the resource and the name of the
resource that interests you, in that exact order.

In the first case, `sem get` can be used as follows:

``` bash
sem get [RESOURCE]
```

In the second case, `sem get` should be used as follows:

``` bash
sem get [RESOURCE] [name]
```

In the case of a `job` resource, you should give the Job ID of the job that
interests you and not its name.

#### sem get examples

As the `sem get` command works with resources, you will need to specify a
resource type when issuing a `sem get` command all the time.

So, in order to get the list of the available projects for the current user
under the active organization, you should execute the following command:

``` bash
sem get project
```

Similarly, the next command returns the list of the names of the available
secrets for the current user under the active organization:

``` bash
sem get secret
```

Each entry is printed on a separate line, which makes the generated output
suitable for being further processed by traditional UNIX command line tools.

Additionally, you can use `sem get` to display all running jobs:

``` bash
sem get jobs
```

Last, you can use `sem get jobs` with `--all` to display the more recent jobs
of the current organization, both running and finished:

``` bash
sem get jobs --all
```

In order to find out more information about a specific project named `docs`,
you should execute the next command:

``` bash
sem get project docs
```

Similarly, in order to find out the contents of a `secret` named `mySecrets`,
you should execute the next command:

``` bash
sem get secret mySecrets
```

You can also use `sem get` for displaying information about a `dashboard`:

``` bash
sem get dashboard my-dashboard
```

In order to find more information about a specific job, given its Job ID,
either running or finished, you should execute the next command:

``` bash
sem get job 5c011197-2bd2-4c82-bf4d-f0edd9e69f40
```

### sem apply

The `sem apply` command works for `secrets` and `dashboards` and allows you to
update the contents of an existing `secret` or `dashboard` using an external
`secrets` or `dashboards` YAML file. `sem apply` is used with the `-f` command
line option followed by a valid path to a proper YAML file.

#### sem apply example

The following command will update the `my-secret` secret according to the
contents of the `aFile`, which should be a valid `secrets` YAML file:

``` bash
sem apply -f aFile
```

If everything is OK with `aFile`, the output of the previous command will be as
follows:

``` bash
Secret 'my-secrets' updated.
```

This means that the `my-secrets` secret was updated successfully.

You can also use `sem apply -f` in a similar way to update an existing dashboard.

### sem delete

The `sem delete` command is used for deleting existing resources, which means
that is used for deleting Semaphore 2.0 projects, dashboards and secrets.

When you delete a secret, then that particular secret will disappear from the
active organization, which will affect all the Semaphore 2.0 projects that are
using it.

When you use `sem delete` to delete a project then that particular project is
deleted from the active organization of the active user.

Deleting a `dashboard` does not affect any Semaphore 2.0 projects.

#### sem delete example

In order to delete an existing project named `be-careful` from the current
organization, you should execute the next command:

``` bash
sem delete project be-careful
```

Similarly, you can delete an existing dashboard named `my-dashboard` as
follows:

``` bash
sem delete dashboard my-dashboard
```

Last, you can delete an existing secret named `my-secret` as follows:

``` bash
sem delete secret my-secret
```

The `sem delete` command does not work with `jobs`.

## Working with jobs

The list of commands for working with `jobs` includes the `sem attach`,
`sem logs`, `sem port-forward` and `sem debug` commands. You can also
use `sem create -f` to create a one-off job that is not part of a pipeline.

Additionally, you can use the the `sem get` command for getting a list of all
jobs or getting a description for a particular job.

The `sem get jobs` command returns the list of all running jobs.

The `sem get jobs --all` command returns the list of all recent jobs of the
current organization, both running and finished.

The `sem stop` command allows you to stop a running job or entire pipeline.

### Creating one-off jobs

You can use `sem create -f` to create a one-off job that runs without being
part of an existing pipeline. You will need to provide `sem create -f` a valid
YAML file as described in the
[Jobs YAML Reference page](https://docs.semaphoreci.com/article/74-jobs-yaml-reference).

This can be very useful for checking out things like compiler versions and
package availability before adding a command into a bigger and slower pipeline.

When a job is created this way, it cannot be viewed in the UI of Semaphore 2.0.
The only way to see the results of such a job is with the `sem logs` command.

#### One-off job creation example

``` bash
sem create -f /tmp/aJob.yml
```

The aforementioned command creates a new job based on the contents of
`/tmp/aJob.yml`, which are as follows:

``` yaml
apiVersion: v1alpha
kind: Job
metadata:
  name: A new job
spec:
  files: []
  envvars: []
  secrets: []
  commands:
    - go version
  project_id: 7384612f-e22f-4710-9f0f-5dcce85ba44b
```

The value of `project_id` must be valid or the `sem create -f` command will
fail.

The output of the `sem create -f` command looks as follows:

``` bash
Job '686b3ed4-be56-4e95-beee-b3bbcc3981b3' created.
```

### sem attach

The `sem attach` allows you to connect to running jobs with an interactive SSH
session. This allows you to explore and inspect the state of jobs.

When the job ends, the SSH session will automatically end and the SSH
connection will be closed.

If you want to debug finished jobs, use `sem debug jobs [job-id]` instead.

#### sem attach example

The `sem attach` command requires the *Job ID* of a **running** job as its single
parameter. So, the following command will connect to the environment of the
job with Job ID `6ed18e81-0541-4873-93e3-61025af0363b` using SSH:

``` bash
sem attach 6ed18e81-0541-4873-93e3-61025af0363b
```

The job with the given Job ID must be in running state at the time of
execution of `sem attach`.

### sem logs

The `sem logs` command allows you to see the log entries of a job, which is
specified by its Job ID.

The `sem logs` command works with both finished and running jobs.

#### sem logs example

The `sem logs` command requires the *Job ID* of a job as its parameter:

``` bash
sem logs 6ed18e81-0541-4873-93e3-61025af0363b
```

The last lines of the output of the previous command of a PASSED job should be
similar to the following output:

``` bash
✻ export SEMAPHORE_JOB_RESULT=passed
exit status: 0
Job passed.
````

### sem port-forward

The general form of the `sem port-forward` command is the following:

``` bash
sem port-forward [JOB ID of running job] [LOCAL TCP PORT] [REMOTE TCP PORT]
```

So, the `sem port-forward` command needs three command line arguments: the Job
ID, the local TCP port number that will be used in the local machine, and
the remote TCP port number, which is defined in the Virtual Machine (VM).

The `sem port-forward` command works with running jobs only.

#### sem port-forward example

The `sem port-forward` command is executed as follows:

``` bash
sem port-forward 6ed18e81-0541-4873-93e3-61025af0363b 8000 8080
```

The previous command tells `sem` to forward the network traffic from the TCP
port 8000 of the job with job ID `6ed18e81-0541-4873-93e3-61025af0363b` that is
running in a VM to TCP port 8080 of your local machine.

All traffic of `sem port-forward` is transferred over an encrypted SSH channel.

Note: Port-Forwarding works only for Virtual Machine based CI/CD environments.

### sem debug for jobs

The general form of the `sem debug` command for jobs is the following:

``` bash
sem debug job [Job ID]
```

This will start a new interactive job based on the specification of the old one,
export the same environment variables, inject the same secrets, and connect to
the same git commit.

Commands in the debug mode are not executed automatically, instead they are
stored in `~/commands.sh`. This allows you to execute them step-by-step, and
inspect the changes in the environment.

By default, the duration of the SSH session is limited to one hour. To run
longer debug sessions, pass the `duration` flag to the above command:

``` bash
sem debug job [job-id] --duration 3h
```

A debug session does not include the contents of the GitHub repository related
to your Semaphore 2.0 project. Run `checkout` in the debug session to clone
your repository.

#### The --duration flag

By default the SSH session of a `sem debug` command is limited to **one hour**.
In order to change that, you can pass the `--duration` flag to the `sem debug`
command.

You can define the time duration using numeric values in the `XXhYYmZZs` format
using any valid combination. One hour can be defined as `1h0m0s` or just `1h`
or even as `60m`.

### sem stop

You can stop a running job or pipeline with `sem stop`:

``` bash
sem stop job|pipeline [ID]
```

If you are executing `sem stop job`, you will need to provide an `ID` of a
running job. If you are executing `sem stop pipeline`, you will need
to provide an `ID` of a running pipeline.

#### sem stop example

The following command will stop the `job` with a Job ID of
`0ae14ece-17b1-428d-99bd-5ec6b04494e9`:

``` bash
sem stop job 0ae14ece-17b1-428d-99bd-5ec6b04494e9
```

The following command will stop the `pipeline` with a Pipeline ID of
`ea3e6bba-d19a-45d7-86a0-e78a2301b616`:

``` bash
sem stop pipeline ea3e6bba-d19a-45d7-86a0-e78a2301b616
```

## Working with projects

This group includes the `sem init`, `sem edit` and `sem debug` commands.

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

#### sem init example

As `sem init` can be used without any command line arguments, you can execute
it as follows from the root directory of a GitHub repository that resides on
your local machine:

``` bash
sem init
```

If a `.semaphore/semaphore.yml` file already exists in the root directory of a
GitHub repository, `sem init` will keep that `.semaphore/semaphore.yml` file
and continue its operation. If there is no `.semaphore/semaphore.yml` file,
`sem init` will create one.

If you decide to use `--project-name`, then you can call `sem init` as follows:

``` bash
sem init --project-name my-own-name
```

The previous command creates a new Semaphore 2.0 project that will be called
`my-own-name`.

Using `--repo-url` with `sem init` is much trickier because you should know
what you are doing.

### sem edit

You can edit a project by using the `sem edit project` command, followed by the
`name` of an existing project.

``` bash
sem edit project [name]
```

The `sem edit project` command will start your configured text editor. In order
for the changes to take effect, you will have to save the changes and exit your
text editor.

To learn more about the configuration options for projects, visit the
[Projects YAML Reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference).

### sem debug for projects

You can use the `sem debug` command to debug an existing Semaphore 2.0 project.

The `sem debug` command can help you specify the commands of a job before
adding and executing it in a pipeline. This can be particularly helpful when
you do not know whether the Virtual Machine you are using has the latest
version of a programming language or a package and when you want to know what
you need to download in order to perform the task you want.

The general form of the `sem debug project` command is the following:

``` bash
sem debug project [Project NAME]
```

After that you are going to get automatically connected to the VM of the
project using SSH. The value of `SEMAPHORE_GIT_BRANCH` will be `master`
whereas the value of `SEMAPHORE_GIT_SHA` will be `HEAD`, which means that
you will be using the latest version of the `master` branch available on the
GitHub repository of the Semaphore 2.0 project.

The projects that are created using the `sem debug project` command support the
`--duration` parameter for specifying the timeout period of the project.

#### sem debug project example

You can debug a project named `docker-push` by executing the following command:

``` bash
sem debug project docker-push
```

You will need to execute either `sudo poweroff` or `sudo shutdown -r now` to
**manually terminate** the VM. Otherwise, you can wait for the timeout period
to pass.

By default the SSH session of a `sem debug` command is limited to **one hour**.
In order to change that, you can pass the `--duration` flag to the `sem debug`
command.

You can define the time duration using numeric values in the `XXhYYmZZs` format
using any valid combination. One hour can be defined as `1h0m0s` or just `1h`
or even as `60m`.

The next command specifies that the SSH session for the `deployment` project
will time out in 2 minutes:

``` bash
sem debug project deployment --duration 2m
```

The next command specifies that the SSH session for the `job` with JOB ID
`d7caf99e-de65-4dbb-ad63-91829bc8a693` will time out in 2 hours:

``` bash
sem debug job d7caf99e-de65-4dbb-ad63-91829bc8a693 --duration 2h
```

Last, the following command specifies that the SSH session of the `deployment`
project will time out in 20 minutes and 10 seconds:

``` bash
sem debug project deployment --duration 20m10s
```

## Working with notifications

In this section you will learn how to work with notifications with the `sem`
utility starting with how to create a new notification with a single rule.

### Create a notification

The first thing that you will need to do is to create one or more notifications
with the help of the `sem` utility.

The general form of the `sem create notification` command is as follows:

``` bash
sem create notification [name] \
  --projects [list of projects] \
  --branches [list of branches] \
  --slack-endpoint [slack-webhook-endpoint] \
  --slack-channels [list of slack channels] \
  --pipelines [list of pipelines]
```

Please refer to the [Examples](#examples) section to learn more about the use
of the `sem create notification` command.

You do not need to use all the command line options of the `sem create notification`
command when creating a new notification. However, the `--projects` as well as the
`--slack-endpoint` options are mandatory. The former specifies the list of
Semaphore 2.0 projects that will be included in that notification rule and the
latter specifies the URL for the Incoming WebHook that will be associated with
this particular notification rule. All `--branches`, `--pipelines` and
`--slack-channels` are optional.

If the `--slack-channels` option is not set, the default Slack channel that is
associated with the specified Incoming WebHook will be used. If you want to
test your notifications, you might need to create a dedicated Slack channel for
that purpose.

Additionally, the values of `--branches`, `--projects` and `--pipelines` can
contain regular expressions. Regex matches must be wrapped in forward slashes
(`/.-/`). Specifying a branch name without slashes (example: `.-`) would
execute a direct equality match.

Therefore, the minimum valid `sem create notification` command that can be
executed will have the following form:

``` bash
sem create notification [name] \
  --projects [list of projects] \
  --slack-endpoint [slack-webhook-endpoint]
```

The `sem create notification` command can only create a single rule under the
newly created notification. However, you can now use the `sem edit notification`
command to add as many rules as you like to the specified notification.

Tip: you can use just a single Incoming WebHook from Slack for all your
notifications as this Incoming WebHook has access to all the channels of a
Slack Workspace.

### List notifications

You can list all the available notifications under the current organization
with the `sem get notifications` command.

``` bash
sem get notifications
```

### Describe a notification

You can describe a notification using the `sem get notifications` command
followed by the `name` of the desired notification.

``` bash
sem get notifications [name]
```

The output of the previous command will be a YAML file – you can learn more
about the Notifications YAML grammar by visiting the
[Notifications YAML reference](https://docs.semaphoreci.com/article/89-notifications-yaml-reference).

### Edit a notification

You can edit a notification using the `sem edit notification` command followed
by the `name` of the existing notification.

``` bash
sem edit notification [name]
```

The `sem edit notification` command will start your configured text editor.
In order for the changes to take effect, you will have to save the changes and
exit your text editor.

### Delete a notification

You can delete an existing notification using the `sem delete notification`
command followed by the `name` of the notification you want to delete.

``` bash
sem delete notifications [name]
```

#### Working with notifications examples

In this subsection you will find `sem` examples related to notifications.

You can create a new notification named `documents` as follows:

``` bash
sem create notifications documents \
  --projects "/.*-api$/" \
  --branches "master" \
  --pipelines "semaphore.yml" \
  --slack-endpoint https://hooks.slack.com/services/XXTXXSSA/ABCDDAS/XZYZWAFDFD \
  --slack-channels "#dev-team,@mtsoukalos"
```

You can list all existing notifications under the current organization as
follows:

``` bash
sem get notifications
```

The output that you will get from the previous command will look similar to the
following:

``` bash
$ sem get notifications
NAME        AGE
documents   18h
master      17h
```

The `AGE` column shows the time since the last change.

You can find more information about a notification called `documents` as
follows:

``` bash
sem get notifications documents
```

You can edit that notification as follows:

``` bash
sem edit notifications documents
```

The aforementioned command will take you to your configured text editor. If your
changes are syntactically correct, you will get an output similar to the next:

``` bash
$ sem edit notifications documents
Notification 'documents' updated.
```

If there is a syntactical error in the new file, the `sem` reply will tell you
more information about the error but any changes you made to the notification
will be lost.

Last, you can delete an existing notification named `documents` as follows:

``` bash
sem delete notification documents
```

The output of the `sem delete notification documents` command is as follows:

``` bash
$ sem delete notification documents
Notification 'documents' deleted.
```

## Working with pipelines

### Listing pipelines

The `sem get pipelines` command returns the list of pipeline for a Semaphore
2.0 project. If you are inside the directory of a Semaphore project, then you
will not need to provide `sem` the name of the project as this will be
discovered automatically.

However, if you want list of pipelines for some project other than the one you
are currently in you can use the `-p` flag to declare the Semaphore project
that interests you.

So, the `sem get pipelines` command can have the following two formats:

``` bash
sem get pipelines
sem get pipelines -p [PROJECT NAME]
```

#### Listing pipelines example

The following command will return the last 30 pipelines of the S1 project:

``` bash
sem get pipelines -p S1
```

### Describing a pipeline

The `sem get pipeline` command followed by a valid Pipeline ID will return
a description of the specified pipeline.

### Describing a pipeline example

You can find more information about the pipeline with the Pipeline ID of
`c2016294-d5ac-4af3-9a3d-1212e6652cd8` as follows:

``` bash
sem get pipeline c2016294-d5ac-4af3-9a3d-1212e6652cd8
```

### Rebuilding a pipeline

You can rebuild an existing pipeline with the help of the
`sem rebuild pipeline` command, that has the following format:

``` bash
sem rebuild pipeline [Pipeline ID]
```

Note that `sem rebuild pipeline` will perform a partial rebuild of the pipeline
as **only the blocks that failed** will be rerun.

#### Rebuilding a pipeline example

Rebuilding the pipeline with a Pipeline ID of
`b83bce61-fdb8-4ace-b8bc-18be471aa96e` will return the next output:

``` bash
$ sem rebuild pipeline b83bce61-fdb8-4ace-b8bc-18be471aa96e
{"pipeline_id":"a1e45038-a689-460b-b3bb-ba1605104c08","message":""}
```

### The --follow flag

The general form of the `sem get pipeline` command when used with the
`--follow` flag is as follows:

``` bash
sem get pipeline [RUNNING Pipeline ID] --follow
```

The `--follow` flag makes the `sem get pipeline [RUNNING Pipeline ID]` command
to be repeatedly called until the pipeline reaches terminal state.

The `--follow` flag is particularly useful in the following two cases:

- If you want to look at how a build is advancing without using the Semaphore
    Web Interface (e.g. when you are prototyping something).
- If you want to be notified when pipeline is done (e.g. in shell scripts).

### The --follow flag example

The `--follow flag` can be used on a running pipeline with a Pipeline ID of
`9bfaf8d6-05c8-4397-b764-5f0f574c8e64` as follows:

``` bash
sem get pipeline 9bfaf8d6-05c8-4397-b764-5f0f574c8e64 --follow
```

## Working with workflows

### Listing workflows

The `sem get workflows` command returns the list of workflows for a Semaphore
2.0 project. If you are inside the directory of a Semaphore project, then you
will not need to provide `sem` the name of the project as this will be
discovered automatically.

However, if you want the list of workflows for some project other than the one
you are currently in, you can use the `-p` flag to directly specify the
Semaphore project that interests you.

So the `sem get workflows` has the following two formats:

``` bash
sem get workflows
sem get workflows -p [Project Name]
```

### Listing workflows examples

Finding the last 30 workflows for the `S1` Semaphore project is as simple as
executing the following commands:

``` bash
sem get workflows -p S1
```

If the project name does not exist, you will get an error message.

If you are inside the root directory of the `S1` Semaphore project, then you
can also execute the next command to get the same output:

``` bash
sem get workflows
```

### Describing a workflow

Each workflow has its own unique Workflow ID. Using that unique Workflow ID you
can find more information about that particular workflow using the next command:

``` bash
sem get workflow [WORKFLOW ID]
```

The output of the previous command is a list of pipelines that includes
promoted and auto promoted pipelines.

#### Describing a workflow example

Finding more information about the Workflow with ID
`5bca6294-29d5-4fd3-891b-8ac3179ba196` is as easy as follows:

``` bash
$ sem get workflow 5bca6294-29d5-4fd3-891b-8ac3179ba196
Label: master

PIPELINE ID                            PIPELINE NAME            CREATION TIME         STATE
9d5f9986-2694-43b9-bc85-6fee47440ba7   Pipeline 1 - p1.yml      2018-10-03 09:37:59   DONE
55e94adb-7aa8-4b1e-b60d-d9a1cb0a443a   Testing Auto Promoting   2018-10-03 09:31:35   DONE
```

Please note that you should have the required permissions in order to find
information about a Workflow.

### Rebuilding a workflow

You can rebuild an existing workflow using the following command:

``` bash
sem rebuild workflow [WORKFLOW ID]
```

Note that `sem rebuild workflow` will perform a full rebuild of the specified
workflow. A new workflow will be created as if a new commit was pushed to
GitHub.

#### Rebuilding a workflow example

You can rebuild a workflow with a Workflow ID of
`99737bcd-a295-4278-8804-fff651fb6a8c` as follows:

``` bash
$ sem rebuild wf 99737bcd-a295-4278-8804-fff651fb6a8c
{"wf_id":"8480a83c-2d90-4dd3-8e8d-5fb899a58bc0","ppl_id":"c2016294-d5ac-4af3-9a3d-1212e6652cd8"}
```

The output of `sem rebuild wf` command is a new Workflow ID and a new pipeline
ID as the `sem rebuild workflow` command creates a new workflow based on an
existing one.

## Help commands

The last group of `sem` commands includes the `sem help` and `sem version`
commands, which are help commands.

### sem help

The `sem help` command returns information about an existing command when it is
followed by a valid command name. If no command is given as a command line
argument to `sem help`, a help screen is printed.

#### sem help example

The output of the `sem help` command is static and identical to the output of
the `sem` command when executed without any command line arguments.

Additionally, the `help` command can be also used as follows (the `connect`
command is used as an example here):

``` bash
sem connect help
```

In that case, `help` will generate information about the use of the
`sem connect` command.

### sem version

The `sem version` command requires no additional command line parameters and
returns the current version of the `sem` tool.

#### sem version example

The `sem version` command displays the used version of the `sem` tool. As an
example, if you are using `sem` version 0.4.1, the output of `sem version`
will be as follows:

``` bash
$ sem version
v0.8.17
```

Your output might be different.

Additionally, the `sem version` command cannot be used with the `-f` flag and
does not create any additional output when used with the `-v` flag.

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

### Defining an editor

The `sem` utility chooses which editor to use by following the next process:

- Using the value of the `editor` property. This value can be set using the
    `sem config set editor` command
- From the value of the `EDITOR` environment variable, if it is set
- If none of the above exists, `sem` will try to use the `vim` editor

#### The `sem config set editor` command

You can define that you want to use the `nano` editor for editing Semaphore
resources by executing the following command:

``` bash
sem config set editor nano
```

#### The EDITOR environment variable

The `EDITOR` environment variable offers a way of defining the editor that
will be used with the session of the `sem edit` command.

You can check whether the `EDITOR` environment variable is set on your UNIX
machine by executing the following command:

``` bash
echo $EDITOR
```

If the output is an empty line, then then `EDITOR` environment variable is not
set. You can set it to the `nano` editor as follows:

``` bash
$ export EDITOR=nano
$ echo $EDITOR
nano
```

The `sem` utility also supports custom flags in the `EDITOR` environment
variable, like `EDITOR="subl --wait"`.

## Command aliases

The words of each line that follows, which represent resource types, are
equivalent:

- `project`, `projects` and `prj`
- `dashboard`, `dashboards` and `dash`
- `secret` and `secrets`
- `job` and `jobs`
- `notifications`, `notification`, `notifs` and `notif`
- `pipelines`, `pipeline` and `ppl`
- `workflows`, `workflow` and `wf`

As an example, the following three commands are equivalent and will return the
same output:

``` bash
sem get project
sem get prj
sem get projects
```

## See also

- [Installing sem](https://docs.semaphoreci.com/article/63-your-first-project)
- [Secrets YAML reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)
- [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
- [Changing Organizations](https://docs.semaphoreci.com/article/29-changing-organizations)
- [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
- [Dashboard YAML reference](https://docs.semaphoreci.com/article/60-dashboards-yaml-reference)
- [Jobs YAML reference](https://docs.semaphoreci.com/article/74-jobs-yaml-reference)
- [Notifications YAML reference](https://docs.semaphoreci.com/article/89-notifications-yaml-reference)
