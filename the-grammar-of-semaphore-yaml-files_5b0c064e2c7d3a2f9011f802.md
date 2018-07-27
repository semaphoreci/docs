## The Sections of a Semaphore 2.0 pipeline YAML file

YAML files have a structure and YAML files used for configuring
pipelines in Semaphore 2.0 projects are no exception.

Each Semaphore 2.0 pipeline configuration file has certain blocks, which
are defined by the use of properties. Some of the blocks and properties
can be repeated whereas others are unique in each pipeline YAML file.
The core properties of a Semaphore 2.0 pipeline configuration file are
`blocks`, which appear only once at the beginning of a YAML file,
`task`, which can appear multiple times and `jobs`, which can also be
repeated. Inside a `task` block you can also add other kinds of
properties that define environment variables and identify commands that
are executed before or after a job.

### The Preamble

Each Semaphore 2.0 pipeline configuration file has a preamble, which is
mandatory and should be present on every `.semaphore/semaphore.yml` file you create.
This preamble includes the following seven lines:

    version: "v1.0"
    name: "The name of the Semaphore 2.0 project"
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:

The `version` property is a string value that shows the version of the
pipeline YAML file that will be used. At the time of writing this, the
current version is 1.0 and therefore this is the value that should be
used.

The `name` property is a Unicode string that assigns a name to the
pipeline. You will see the `name` property again because it can also be
used for defining the name of a job inside a `jobs` block or the name of
a task section defined using `task`.

## About agent

You can think of the _three_ values under the `agent` property as the
environment (type of container) in which the jobs of the pipeline will
get executed. The `type` property is intended for selecting the machine
(hardware) you would like to use for your builds. The `os_image`
property specifies the operating system and the version of the operation systems that will be used.
Please notice that you cannot use arbitrary values for the `type` and `os_image` properties.

You will most likely need to use `e1-standard-2` as the value of the
`type` property and `ubuntu1804` as the value of the `os_image` property.

## About blocks

The `blocks` property is an array of items that hold the elements of
a `.semaphore/semaphore.yml` file.

Each item of the `blocks` property can have its own `name` property
associated with it. If there is no `name` value, Semaphore 2.0 will
assign a value to it. The important thing to remember is that the `name`
values of all the `blocks` items of a Semaphore 2.0 project, which
appear before the `task` property, must be unique.

If you accidentally name two or more `blocks` properties with the same
name, you will get an error message similar to the following:

    semaphore.yml ERROR:
    Error: "There are at least two blocks with same name: Build Go project"

## About task

The `task` keyword that comes after the `blocks` property divides a
YAML configuration file into major and distinct sections. Each `task`
section can have multiple `jobs` items, an optional `prologue` section,
an optional `epilogue` section as well as an optional `env_vars` block
for defining environment variables.

###  About Jobs

The core part of each `.semaphore/semaphore.yml` file is code blocks
that define one or more jobs because jobs define the commands that will
get executed on a given Semaphore 2.0 project. Therefore, `jobs`
properties are essential for each Semaphore 2.0 pipeline because they
allow you to define the commands that you want to execute.

###  Creating a new job

A job item can contain various sections including `name`, `commands` and
`cmd_file`, which can be considered as the parameters of a job.
The `commands` and `cmd_file` properties can help you define jobs either
inline or using an external plain text file, respectively.

The general structure of a job when using the `commands` property is as
follows:

    jobs:
       - name: A name for this job
          commands:
             - Command 1
             - Command 2

The list of the `commands` property can contain as many jobs as you
want.

The general structure of a job when using the `cmd_file` property is as
follows:

    jobs:    
      - name: A name for this job
         cmd_file: /path/to/file/plain_text_file

As you will learn in a while, the type of the value of the
`cmd_file` property is string, which means that you can only have a
single `cmd_file` value. Should you wish to call multiple UNIX scripts,
you can put all of them into a single file or call them directly from
the plain text file used as the value of `cmd_file`.

#### About name

The value of the `name` property, which has already been discussed at
the beginning of this document, is a Unicode string that provides a
description/name for a particular job. It is considered a good practice
to give descriptive names to the jobs and the blocks of a Semaphore 2.0
pipeline.

#### About commands

According to the grammar used for defining the configuration files of
Semaphore 2.0 pipelines, the `commands` property is an array of strings
that holds the UNIX commands that will be executed for a job. A job
example that uses the `commands` property is the following:

    commands:
      - checkout
      - echo $SEMAPHORE_PIPELINE_ID
      - go run hw.go

Notice that you cannot use both `commands` and `cmd_file` for defining a
single job. Additionally, notice that the `checkout` command is specific
to Semaphore 2.0 pipelines YAML files and is used for fetching the files
of the GitHub repository into the Linux virtual machine in order to be
able to use them.

The following is an example of a working `.semaphore/semaphore.yml`
file that uses the `commands` property:

    version: "v1.0"
    name: Single Job YAML file.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
     - name: The name of the block
       task:
          jobs:
            - name: My Semaphore 2.0 job
              commands:
                - echo $SEMAPHORE_PIPELINE_ID
                - echo "Hello World!"

#### About cmd_file

Strictly speaking, the `cmd_file` is a string property that points to a
plain text file that can be found in the GitHub repository of your
Semaphore 2.0 project.

Some information about what happens behind the scenes: Semaphore 2.0
reads the plain text file and creates the equivalent job using a
`commands` block, which is what is finally executed. This means that
the `cmd_file` property is replaced before the job is started and a
machine begins its execution.

An example of a job defined using `cmd_file` is the following:

    jobs:    
      - name: A name for this job
         cmd_file: /path/to/GitHub/file/plain_text_file

Notice that you cannot use both `commands` and `cmd_file` for defining
a job. Moreover, you cannot have a job properly defined if both
the `commands` and `cmd_file` properties are missing.

The following is an example of a working `.semaphore/semaphore.yml` file
that uses the `cmd_file` property to execute the commands found
in `command_file`:

    version: "v1.0"
    name: Using cmd_file.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
     - name: Calling text file
       task:
          jobs:
            - name: Using command_file
              cmd_file: command_file
          prologue:
              commands:
                - checkout

You will learn more the `prologue` property at the section that follows.

### The prologue and epilogue properties

A `.semaphore/semaphore.yml` configuration file can have a single
`prologue` and a single `epilogue` property per `task` property. Both
`prologue` and `epilogue` properties are optional.

A `prologue` property is used when you want to execute some commands
prior to a job. This is usually the case with initialization commands
that install software, start or stop a service, etc.

An `epilogue` property should be used when you want to execute some
commands after a job has finished, either successfully or
unsuccessfully.

Apart from these details, the syntax of a `prologue` or an `epilogue`
block is similar to the syntax of a job without support for the `name`
property. Both the `commands` and `cmd_file` properties are supported by
`prologue` and `epilogue` blocks and their restrictions still apply.
Last, the indentation level of `prologue`, `epilogue` and `jobs`
properties should be the same.

An `epilogue` property definition can look as follows:

    epilogue:
      commands:
        - echo Epilogue command 1
        - echo Epilogue command 2

A `prologue` property definition can be defined as follows:

    prologue:
        cmd_file: /path/to/GitHub/file/plain_text_file

The following is an example of a working `.semaphore/semaphore.yml` file
that uses the `prologue` and `epilogue` properties:

    version: "v1.0"
    name: Pipeline epilogue and prologue YAML example.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
     - name: Inspect Linux environment
       task:
          jobs:
            - name: Execute hw.go 
              commands:
                - echo $SEMAPHORE_PIPELINE_ID
                - echo $HOME
                - echo $SEMAPHORE_GIT_DIR
                - pwd
          prologue:
              commands:
                - checkout
          epilogue:
              commands:
                - echo $SEMAPHORE_JOB_RESULT
                - echo $SEMAPHORE_PIPELINE_ID

### What if you need a global prologue or epilogue block?

Currently, there is no way to define a global `prologue` or `epilogue`
block, that is a `prologue` or `epilogue` definition that will be
defined outside a `block` item and would be applied to each `block` item
of the entire `.semaphore/semaphore.yml` file. However, you can put the
desired commands on an external file and define your `prologue` or
`epilogue` blocks using a `cmd_file` item.

###  What happens to prologue or epilogue blocks when a job fails?

As the `prologue` block is executed before a job, the result of the job
that follows that `prologue` block has no effect on the execution of the
`prologue` block. The same happens with `epilogue` blocks, which means
that `epilogue` blocks are executed even if the jobs that precedes them
have failed.

Imagine that you have the following `epilogue` definition:

    epilogue:   
      commands:
         - echo $SEMAPHORE_JOB_RESULT

The `$SEMAPHORE_JOB_RESULT` environment variable used here holds the
result (`passed` or `failed`) of a job.

Executing the previously defined `epilogue` on a successfully executed
job will generate the following kind of output:

    exit code: 0
    echo $SEMAPHORE_JOB_RESULT
    passed
    exit code: 0
    Job Finished

Executing the same `epilogue` block on a job that failed will generate
the following kind of output:

    ls /e/tc
    ls: cannot access /e/tc: No such file or directory
    exit code: 2
    echo $SEMAPHORE_JOB_RESULT
    failed
    exit code: 0
    Job Finished

### Defining Environment variables

The syntax of `.semaphore/semaphore.yml` file allows you to define your
own environment variables with the help of the `env_vars` property that
is an array. The elements of such an array are name and value pairs that
hold the name of the environment variable and the value of the
environment variable, respectively.

The following code exempt shows the use of the `env_vars` property:

          env_vars:
               - name: VAR1
                 value: Environment Variable 1
               - name: PI
                 value: "3.14159"

The preceding YAML code exempt defines two environment variables named
`VAR1` and `PI`. Both environment variables have string values, which
means that numeric values that are not natural numbers need to be
included in double quotes.

The following code presents a complete `.semaphore/semaphore.yml` file
that defines and uses two environment variables:

    version: "v1.0"
    name: Using Environment Variable.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
     - name: Environment variables
       task:
          jobs:
            - name: Inspect Environment variables
              commands:
                - echo $SEMAPHORE_PIPELINE_ID
                - echo $VAR1
                - echo $PI
          env_vars:
               - name: VAR1
                 value: Environment Variable 1
               - name: PI
                 value: "3.14159"

### Comments

Lines that begin with `#` are considered comments and are being ignored
by the YALM parser:

    # This is a comment
    #

Please notice that this capability is not defined in the grammar of the
Semaphore 2.0 YAML configuration files – it is just the way YAML files
work. Additionally, you can have empty lines in your YAML files.

### Steps for creating a Semaphore 2.0 pipeline configuration file

A good practice would be to begin with the definitions of the jobs that
you will need for your pipeline using simple *echo* commands before
writing the actual commands for each one of them. Once you have
a `.semaphore/semaphore.yml` file without syntactical errors, you can
start putting the commands for each job.

The following `.semaphore/semaphore.yml` configuration file defines a
minimalistic pipeline configuration file with a single job:

    version: "v1.0"
    name: Basic pipeline YAML configuration file example.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
     - name: The name of the block
       task:
          jobs:
            - name: My Semaphore 2.0 job
              commands:
                - echo $SEMAPHORE_PIPELINE_ID
                - echo "Hello World!"

You can always begin with such simple `.semaphore/semaphore.yml` files
and build on these or use any one of your existing `.semaphore/semaphore.yml` files.

### The order of execution

You cannot and you should not make any assumptions about the order the
various jobs of a block are going to be executed. This means that the
jobs of each block might not start in the order of definition.

However, the blocks of a `.semaphore/semaphore.yml` file are executed
sequentially. This means that if you have two blocks on
a `.semaphore/semaphore.yml` file file, the second one will begin only
when the first one has finished.

Last, the jobs of a block will run in parallel provided that you have
the required capacity (boxes) available.

###  A complete .semaphore/semaphore.yml example

The following code presents a complete `.semaphore/semaphore.yml` file:

    version: "v1.0"
    name: YAML file example for Go project.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
     - name: Inspect Linux environment
       task:
          jobs:
            - name: Execute hw.go 
              commands:
                - echo $SEMAPHORE_PIPELINE_ID
                - echo $HOME
                - echo $SEMAPHORE_GIT_DIR
                - pwd
                - ls -al
                - cat hw.go
                - echo $VAR1
                - echo $PI
          prologue:
              commands:
                - checkout
          env_vars:
               - name: VAR1
                 value: Environment Variable 1
               - name: PI
                 value: "3.14159"
    
     - name: Calling text file
       task:
          jobs:
            - name: Using command_file
              cmd_file: command_file
          prologue:
              commands:
                - checkout
    
     - name: Build Go project
       task:
          jobs:
            - name: Build hw.go 
              commands:
                - checkout
                - sudo apt-get -y install golang-go
                - go build hw.go
                - ls -l ./hw
                - file ./hw
                - ./hw
            - name: PATH variable
              commands:
                - echo $PATH
          epilogue:
              commands:
                - echo $SEMAPHORE_JOB_RESULT
                - echo $SEMAPHORE_PIPELINE_ID

### A .semaphore/semaphore.yml file without name properties

Although it is allowed to have `.semaphore/semaphore.yml` files without
name properties, it is considered a very bad practice and should be
avoided.

However, the following sample `.semaphore/semaphore.yml` file proves
that it can be done:

    version: "v1.0"
    name: Basic YAML configuration file example.
    semaphore_image: standard
    blocks:
      - task:
          jobs:
              - commands:
                 - echo $SEMAPHORE_PIPELINE_ID
                 - echo "Hello World!"

### Summary

At this moment the best thing you can do is to start creating Semaphore
2.0 pipelines and projects in order to try things and understand
how `.semaphore/semaphore.yml` files work. You will most likely make
mistakes in the process but this is part of the learning process!



[1]: https://docs.semaphoreci.com/article/15-secrets
[2]: https://www.python.org/
