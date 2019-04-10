- [Overview](#overview)
- [Quick start](#quick-start)
- [How to use sem](#how-to-use-sem)
  - [A Quick example](#a-quick-example)
  - [A secrets example that uses files](#a-secrets-example-that-uses-files)
- [The process in more detail](#the-process-in-more-detail)
  - [A YAML file for creating secrets](#a-yaml-file-for-creating-secrets)
  - [How to tie an existing secret into a pipeline quickly](#how-to-tie-an-existing-secret-into-a-pipeline-quickly)
  - [Showing existing secrets](#showing-existing-secrets)
  - [Showing the contents of an existing secret](#showing-the-contents-of-an-existing-secret)
  - [Updating existing secrets](#updating-existing-secrets)
  - [Deleting a secret](#deleting-a-secret)
  - [What if you try to use a secret that does not exist](#what-if-you-try-to-use-a-secret-that-does-not-exist)
- [An example](#an-example)
- [Use cases](#use-cases)
  - [How to handle an SSH key file](#how-to-handle-an-ssh-key-file)
- [See also](#see-also)

## Overview

This documentation page will demonstrate the use of `secrets` in Semaphore 2.0
projects by describing the entire process from creating a `secret` up to using
that `secret` on a Semaphore 2.0 project.

A `secret` is a bucket for keeping sensitive information in the form of
environment variables and small files. Therefore, you can consider a `secret`
as a place where you can store small amounts of sensitive data such as
passwords, tokens or keys. Sharing sensitive data in a `secret` is both
safer and more flexible than storing it using plain text files or environment
variables that anyone can access.

## Quick start

In this section you will learn how to work with secrets on your Semaphore 2.0
projects with the help of the `sem` command line utility.

In order to follow this page you will need to have the `sem` utility already
installed on your machine. You can download `sem` by following these
[instructions](https://docs.semaphoreci.com/article/26-installing-cli).

## How to use sem

The `sem` utility related commands for working with secrets are the following:

- `sem create secrets <secret_name>`: for creating a new empty secret
- `sem create -f aFile.yml`: for creating a new secret based on an existing
    `secrets` YAML file
- `sem edit secrets <secret_name>`: for editing an existing secret
- `sem get secrets`: for listing existing secrets and for listing the contents
  of an existing secret
- `sem apply -f secret_file`: for updating an existing secret using a `secret`
    YAML file.
- `sem delete secrets <secret_name>`: for deleting an existing secret

You will see all these commands in action in a while.

### A quick example

This section will present some everyday `sem` commands that can help you work
with secrets as well as a Semaphore pipeline YAML file that uses an existing
secret.

The following `sem` command creates a new secret under the active organization
using a `secrets` YAML file:

``` bash
sem create -f add-secrets.yml
```

The contents of `add-secrets.yml` are as follows:

``` yaml
apiVersion: v1beta
kind: Secret
metadata:
  name: my-example-secret
data:
  env_vars:
    - name: ONE
      value: Secret ONE
    - name: TWO
      value: Secret TWO
```

The presented file creates a `secret` named `my-example-secret` with two
environment variables named `ONE` and `TWO` in it.

You can also execute the following command to create an empty `secret` named
`my-example-secret`:

``` bash
sem create secret my-example-secret
```

After that, you can edit the empty `my-example-secret` secret using the
`sem edit secrets my-example-secret` command and make its contents look like
the contents of the `add-secrets.yml` secrets YAML file.

An example pipeline YAML file that uses `my-example-secret` is the following:

``` yaml
$ cat .semaphore/semaphore.yml
version: v1.0
name: Using secrets in Semaphore projects
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - task:
      jobs:
        - name: My secrets
          commands:
            - echo $ONE
            - echo $TWO
      secrets:
        - name: my-example-secret
```

So, what is happening here? The `secrets` property of the pipeline YAML grammar
allows you to define a list of existing secrets that you want to import. In
this case the name of the secret is `my-example-secret` – all the contents of
`my-example-secret` will be automatically imported in the pipeline.

Please notice that if the names of the environment variables of two or more
`secrets` are the same, then the shared environment variables will have the
value that can be found in the `secret` that was imported last.

The following command prints all the secret names of the active organization:

``` yaml
sem get secrets
```

The `sem get secrets` also shows the age of each `secret`, that is the time
since the last change of any kind in that `secret`.

The following command prints the contents of the `my-example-secret` secret:

``` bash
sem get secrets my-example-secret
```

Last, the following example deletes `my-example-secret`:

``` bash
sem delete secrets my-example-secret
```

### A secrets example that uses files

In this section you will see how to add a file to an existing `secret`.

Imagine that you have a file that you need to use in a `secret` named
`my-example-secret`. The desired file is the following:

``` bash
$ ls -l file.txt
-rw-r--r--  1 mtsouk  wheel  21 Sep 25 08:40 file.txt
```

On a macOS machine, you will need to execute the following command:

``` bash
base64 file.txt
```

The output of that command will be the base64 encoding of `file.txt` that will
be used in the next step. At this point it is better to copy the generated text
in order to paste it in a while. Note that the bigger the size of the file the
bigger the output of `base64 file.txt` will be.

Notice that Linux machines require executing `base64 file.txt` as
`base64 -w 0 file.txt` to prevent line wrapping whereas macOS machines do not.

Execute the next command in order to edit the contents of the
`my-example-secret` secret using your favorite UNIX editor:

``` bash
sem edit secrets my-example-secret
```

Now, you can include that filename along with the output of `base64 file.txt`
in the `my-example-secret` secret by adding the following text in it:

``` yaml
apiVersion: v1beta
kind: Secret
metadata:
  name: my-example-secret
data:
  env_vars:
    - name: ONE
      value: Secret ONE
    - name: TWO
      value: Secret TWO
files:
- path: file.txt
  content: SGVsbG8gU2VtYXBob3JlIDIuMCEK
```

If the output already has a `files` block with a a `path` and `content` pair,
you will just need to add your own `path` and `content` pair. The value of
`content` should be the output of the `base64 file.txt` command.

If the output has a line that looks like `files: []`, then you should replace
that line with the presented text.

An example pipeline YAML file that uses the file that was created in the
previous `secret` is the following:

``` yaml
version: v1.0
name: Using files in secrets in Semaphore 2.0
agent:
   machine:
     type: e1-standard-2
     os_image: ubuntu1804

blocks:
- task:
      jobs:
        - name: Getting file.txt
          commands:
            - checkout
            - ls -l ~/file.txt
            - cd ..
            - cat file.txt
            - echo $SECRET_ONE
      secrets:
        - name: my-example-secret
        - name: ssh-keys
```

So, by default `file.txt` will be restored in the home directory of the user
of the Virtual Machine (VM) and it will be automatically *decoded* when its
`secret` is included in the `secrets` list of a pipeline YAML file.

## The process in more detail

The process of creating and using a secret involves the following steps:

- Creating a secrets YAML file and importing that secrets YAML file into
    Semaphore 2.0 using `sem` or creating an empty `secret` using
    `sem create secret` and editing the contents of that secret to match your
    needs
- Using the secret you have just created in a Semaphore 2.0 project

### A YAML file for creating secrets

Everything that is related to secrets starts with a YAML file that is
specific to secrets and allows you to create new secrets under the current
organization. You can either create that file yourself or let `sem` create an
empty one for you in order to start putting data in it. This section will
present the former method whereas the next section will present the latter
method.

For the purposes of this documentation page, the YAML file that
is going to be used is named `createSecret.yml` and has the following content:

``` yaml
$ cat createSecret.yml
apiVersion: v1beta
kind: Secret
metadata:
  name: my-secrets
data:
  env_vars:
    - name: SECRET_ONE
      value: "Ca c'est un petite secret"
    - name: SECRET_TWO
      value: "Secret deux"
```

Each secret YAML file creates a new `secret`, which is a place for
storing secrets, that can contain one or more secrets. You recall an existing
`secret` on your Semaphore projects by its name.

Have in mind that each `secret` is stored under a Semaphore organization and
that in order to use a particular `secret` you should be connected to its
related organization.

You can now import that secret YAML file into Semaphore by executing the
following command:

``` bash
sem create -f createSecret.yml
```

### Another way of creating secrets

The method that is going to be described in this section will create the exact
same `secret` as the previous section with the exact same content but using a
slightly different method.

First, you can create an empty `secret` named `my-secrets` as follows:

``` bash
sem create secret my-secrets
```

You can verify that `my-secrets` is created by looking at the output of the
`sem get secrets` command – `my-secrets` should be included in the output.

Then, you will have to populate that `secret` with data by editing its contents
with the help of the next command:

``` bash
sem edit secrets my-secrets
```

The previous command allows you to edit the contents of `my-secrets` using
your favorite text editor. You will have to add the name and value pairs you
want. Later in in this document you will learn more ways of editing the
contents of an existing `secret`.

Although you can create a `secret` any way you want, there is only one way you
can use the contents of a `secret`, which will be described in the next
section.

### How to tie an existing secret into a pipeline quickly

Imagine that you have the following `.semaphore/semaphore.yml` file that does
not uses any `secrets`:

``` yaml
# .semaphore/semaphore.yml

version: v1.0
name: Using secrets in Semaphore
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - task:
      jobs:
        - name: Using Secrets
          commands:
            - checkout
```

If you know the names of one or more secrets, which for the purposes of this
section will be `aws-secrets`, `docker-secrets` and `ssh-keys`, you can quickly
add them to a Semaphore task by including the following lines into the desired
task block of the pipeline YAML file:

``` yaml
secrets:
  - name: aws-secrets
  - name: docker-secrets
  - name: ssh-keys
```

This will make the contents of `aws-secrets`, `docker-secrets` and `ssh-keys`
available to all the jobs of that particular task.

After that, the original `.semaphore/semaphore.yml` file will look as follows:

``` yaml
# .semaphore/semaphore.yml

version: v1.0
name: Using secrets in Semaphore
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - task:
      jobs:
        - name: Using Secrets
          commands:
            - checkout
            - echo $TWO
            - echo $ONE
            - echo $SECRET_ONE
      secrets:
        - name: aws-secrets
        - name: docker-secrets
        - name: ssh-keys
```

### Showing existing secrets

Getting a list of the secrets that exist under the active organization requires
the execution of the next command:

``` bash
sem get secrets
```

### Showing the contents of an existing secret

You can see the contents of an existing secret as follows:

``` bash
sem get secrets my-secrets
```

The following command can help you get the contents of all the secrets in the
current organization:

``` bash
sem get secrets | grep -v NAME | awk '{print $1}' | xargs -n1 sem get secrets
```

### Updating existing secrets

Updating existing secrets can be also done with the `sem` utility. Imagine that
you have `createSecret.yml` that was defined earlier in this page and you want
to update the value of `SECRET_ONE` into `This is a little secret`. All you
have to do is edit `createSecret.yml` and make it looks as follows:

``` yaml
# createSecret.yml

apiVersion: v1beta
kind: Secret
metadata:
  name: my-secrets
data:
  env_vars:
    - name: SECRET_ONE
      value: "This is a little secret"
    - name: SECRET_TWO
      value: "Secret deux"
```

After that you will need to execute the following command:

``` bash
sem apply -f createSecret.yml
```

Alternatively, you can edit the contents of a `secret` directly using your
favorite text editor:

``` bash
sem edit secrets my-secrets
```

There is another technique that can be applied when you do not have the
original YAML file and requires the execution of the following three commands:

``` bash
sem get secrets my-secrets > /tmp/aFile
vi /tmp/aFile
sem apply -f /tmp/aFile
```

The first command dumps the contents of an existing `secret` into a file, the
second command edits these contents and the third command updates them.

There is nothing unique with this technique - the good thing is that it saves
you from having to remember the YAML file that created the `secret` in case you
want to keep it somewhere, send it to another Semaphore 2.0 user or use it in a
different Semaphore 2.0 project.

### Deleting a secret

Deleting an existing secret along with its contents is as simple as executing
the following command:

``` bash
sem delete secrets my-secrets
```

The only way to recreate a secret that you deleted is to find the secret YAML
file of that secret and execute `sem create` again.

### What if you try to use a secret that does not exist

In that case the pipeline will fail to execute.

## An example

The following `secret` defines two environment variables and one file in a
`secret` named `ssh-keys`:

``` yaml
apiVersion: v1beta
kind: Secret
metadata:
  name: ssh-keys
data:
  env_vars:
    - name: SSH_KEY_1
      value: SSH Secret key
    - name: SSH_KEY_2
      value: Secret SSH key TWO
  files:
  - path: file.txt
    content: SGVsbG8gU2VtYXBob3JlIDIuMCEK
```

## Use cases

This section will present a real world scenario that uses Semaphore 2.0 and
utilize secrets to connect to a server machine using SSH.

### How to handle an SSH key file

In this section you will learn how to store and retrieve ssh keys as files in
`secrets` in order to connect to a remote SSH server without needing a password.

First, you will have to take a base64 representation of your file and put it
in your `secret`. On a macOS machine, you will need to execute
the following command:

``` bash
base64 .ssh/server_key
```

Please note that the `base64` encoding of the file should be pasted into the
`secret` as a single line. The macOS version of `base64` generates the output
in a single line by default.

However, the Linux version of `base64` does not do that by default. Therefore,
on a Linux machine you will need to execute the `base64` command with the
`-w 0` options to prevent line wrapping from happening:

``` bash
base64 -w 0 .ssh/server_key
```

The `secrets` YAML file will be as follows:

``` yaml
apiVersion: v1beta
kind: Secret
metadata:
  name: ssh-keys
data:
  env_vars: []
  files:
  - path: .ssh/server_key
    content: SGVsbG8gU2VtYXBob3JlIDIuMCEK
```

The pipeline YAML file will be as follows:

``` yaml
version: v1.0
name: Using a secret file with a SSH key
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Using SSH key files
    task:
      jobs:
      - name: Using server_key
        commands:
          - ls -l ~/.ssh
      - chmod 600 ~/.ssh/server_key
      - ssh -i ~/.ssh/server_key username@server_name
      secrets:
      - name: ssh-keys
```

## See also

- [Installing sem](https://docs.semaphoreci.com/article/26-installing-cli)
- [Secrets YAML reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)
- [sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
- [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
- [Changing Organizations](https://docs.semaphoreci.com/article/29-changing-organizations)
