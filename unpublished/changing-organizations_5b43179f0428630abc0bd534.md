## Introduction

In the document you will learn how to connect to an organization with
the  `sem` command line utility. The key point is that you need a file
named `.sem.yaml` that should be located in the home directory of the
active user. This file contains the necessary information for connecting
to one or more organizations. However, only one organization is active
at any given time.

## Connecting to an organization for the first time

If  `.sem.yaml` does not exist, `sem` will guide you through the process
and help you create the required YAML configuration file. So, imagine
that no YAML file for `sem` exists and that you try to issue
a `sem` command. The `sem` command will produce the following output:

``` bash
$ ls -l ~/.sem.*
ls: /Users/mtsouk/.sem.*: No such file or directory

$ sem get projects
Connection to Semaphore is not established.
Run the following command to connect to Semaphore:

sem connect [HOST] [TOKEN]

$ ls -l ~/.sem.*
-rw-r--r--  1 mtsouk  staff  0 Jul  2 15:25 /Users/mtsouk/.sem.yaml
```

So, you need to know your host and also get your authentication token
and put it in the YAML file for  `sem` to work. Please notice that the
authentication token is connected to the active Semaphore 2.0 user and
not the organization. At this point it does not matter where you can get
the authentication token – just assume that you have one which for the
current Semaphore 2.0 user is `DArXY1y3yar5jazmxE8U`. Additionally,
assume that your host is called `tsoukalos.semaphoreci.com`. After that,
you should execute the following command:

``` bash
$ sem connect tsoukalos.semaphoreci.com DAryy1y3yar5jazmxE8U
connected to tsoukalos.semaphoreci.com

$ ls -l ~/.sem.*
-rw-r--r--  1 mtsouk  staff  161 Jul  5 10:21 /Users/mtsouk/.sem.yaml
```

The  `sem get projects` command will now get executed without any
problems:

``` bash
$ sem get projects
NAME
S2
S1
```

You can get the authentication token as well as your host from the web
page of your organization, which is this case it will be
`https://tsoukalos.semaphoreci.com/`, when you press the `"Start a
project"` link. The authentication token will be the same for all the
organizations of the same Semaphore 2.0 user but the host name will be
different because in depends on the names of the organizations you are a
member of.

This means that if you ever need to connect to another organization, you
should click on the  `"Start a project"` link of that organization and
execute the presented `sem connect` command on your favourite UNIX
shell.

You are now good to go and start using the  `sem` utility to work with
your Semaphore 2.0 projects.

## Changing between the organizations of a Semaphore 2.0 user

Once you have added your organizations to `./sem.yaml` using `sem
connect`, you will not need to use `sem connect` to change organization,
although this will also work. The `sem` tool provides the `context`
command for switching between existing organizations. Executing `sem
context` without any other parameter will show you the organizations you
are a member of:

``` bash
$ sem context
* semaphore_semaphoreci_com
  tsoukalos_semaphoreci_com
```

The line with the `*` character shows the active Semaphore 2.0
organization. After that you can change to another organization as
follows:

``` bash
$ sem context tsoukalos_semaphoreci_com
switched to context "tsoukalos_semaphoreci_com"

$ sem context
  semaphore_semaphoreci_com
* tsoukalos_semaphoreci_com
```

## See also

- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
