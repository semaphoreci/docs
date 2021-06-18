---
description: This document is the reference of the YAML grammar used for describing the pipelines of Semaphore 2.0 projects.
---

# Pipeline YAML Reference

This document is the reference of the YAML grammar used for describing the
pipelines of Semaphore 2.0 projects.

The core properties of a Semaphore pipeline configuration file are
`blocks`, which appear only once at the beginning of a YAML file, `task`,
which can appear multiple times, `jobs`, which can also be repeated, and
`promotions` that is optional and can appear only once.

Each Semaphore pipeline configuration file has a mandatory preface,
which consists of properties `version`, `name` and `agent`.

## Properties

## version

The `version` property is a string value that shows the version of the
pipeline YAML file that will be used.

The list of valid values for `version`: `v1.0`.

Example of `version` usage:

``` yaml
version: v1.0
```

## name in preface

The `name` property is a Unicode string that assigns a name to a Semaphore
pipeline and is optional. However, you should always give descriptive names
to your Semaphore pipelines.

*Note*: The `name` property can be found in other sections such as defining the
name of a job inside a `jobs` block.

Example of `name` usage:

``` yaml
name: The name of the Semaphore 2.0 project
```

## agent

The `agent` property defines the hardware and software environment of the
virtual machine that runs your jobs.

Example of `agent` usage:

``` yaml
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
```

*Note*: `agent` can also be defined on a [per `task` basis](#agent-in-task).

### machine

The `machine` property, which can only be defined under `agent`, requires two
properties named `type` and `os_image`.

Example of `machine` usage:

``` yaml
machine:
  type: e1-standard-2
  os_image: ubuntu1804
```

### type

The `type` property is intended for selecting the hardware you would
like to use for the Virtual Machine of your jobs.

A complete list of valid values for the `type` is available on the
[Machine Types](https://docs.semaphoreci.com/ci-cd-environment/machine-types/) page.

Example of `type` usage:

``` yaml
type: e1-standard-4
```

### os_image

The `os_image` is an optional property that specifies the operating system image
to be used in the virtual machine. If the value is not provided the default for
the machine type is used.

These are valid values for `os_image`:

- `ubuntu1804` ([reference][ubuntu1804])
- `macos-xcode11` ([reference][macos-xcode11])
- `macos-xcode12` ([reference][macos-xcode12])

The default operating system depends on the type of the machine:

- For the `e1-standard-*` machine types the default image is `ubuntu1804`
- For the `a1-standard-*` machine types the default image is `macos-xcode11`

Example of `os_image` usage:

``` yaml
os_image: ubuntu1804
```

### containers

The `containers` property, which can only be defined under `agent`, is an array
of docker images that will run the jobs in the pipeline.

Example of `containers` usage:

``` yaml
agent:
  machine:
    type: e1-standard-2
  containers:
    - name: main
      image: 'registry.semaphoreci.com/ruby:2.6'
    - name: db
      image: 'registry.semaphoreci.com/postgres:9.6'
      user: postgres
      env_vars:
        - name: POSTGRES_PASSOWRD
          value: keyboard-cat
```
!!! info "Semaphore convenience images redirection"
	Due to the introduction of [Docker Hub rate limits](/ci-cd-environment/docker-authentication/), if you are using a [Docker-based CI/CD environment](/ci-cd-environment/custom-ci-cd-environment-with-docker/) in combination with convenience images Semaphore will **automatically redirect** any pulls from the `semaphoreci` Docker Hub repository to the [Semaphore Container Registry](/ci-cd-environment/semaphore-registry-images/).	
    
Each container entry must define the `name` and `image` property. The name of
the container is used when linking the containers together, and for defining
hostnames in the first container.

The first container runs the jobs' commands, while the rest of the containers
are linked via DNS records. The container with name `db` is registered with a
hostname `db` in the first container.

Other optional parameters of each container definition can be divided into two groups:

1. Docker related parameters that are passed to docker run command that starts the container. More information about them can be found in [docker run][docker-run] docs.

    - `user` - The user that will be used within the container
    - `command` - The first command to execute within the container. It overrides the command defined in Dockerfile.
    - `entrypoint` - This specifies what executable to run when the container starts

2. The data that needs to be injected into containers that is either defined directly there in YAML file or is stored in Semaphore secrets

    - `env_vars` - Environment variables that are injected into the the container. They are defined in the same way as in [task definition][env-var-in-task].
    - `secrets` - Secrets which hold the data the should be injected into the container. They are defined in the same way as in [task definition][secrets-in-task]. *Note*: currently, only environment variables defined in a secret will be injected into container, the files within the secret will be ignored.

!!! warning "Docker Hub rate limits"
    Please note that due to the introduction of the [rate limits](https://docs.docker.com/docker-hub/download-rate-limit/) on Docker Hub, all pulls have to be authenticated. 
    If you are pulling any images from Docker Hub public repository please make sure you are logged in to avoid any failiures. You can find more information on how to authenticate in our [Docker authentication](https://docs.semaphoreci.com/ci-cd-environment/docker-authentication/) guide.

### A Preface example

``` yaml
version: v1.0
name: The name of the Semaphore 2.0 project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
 - name: Inspect Linux environment
   task:
      jobs:
        - name: Print Envrinment variable
          commands:
            - echo $SEMAPHORE_PIPELINE_ID
```

## execution\_time\_limit

The concept behind the `execution_time_limit` property is simple: you do not
want your jobs to be executed forever and you need to be able to set a time
limit for the entire pipeline as well as for individual blocks and jobs.

The `execution_time_limit` property can be used at the `pipeline`, `block`
or `job` scope. In the latter two cases you can use the propery for multiple
blocks or jobs.

*Note*: In the `pipeline` and `block` scopes `execution_time_limit`  will 
sum the  runtime of all underlying elements, this also includes the time 
jobs are waiting for quota. Please keep this in mind when using the property.

The `execution_time_limit` property can hold two other properties, which are
named `hours` and `minutes`, for specifying the execution time limit in hours,
and minutes, respectively. You should only use one of these two properties and
not both of them at the same time.

The types of the values for both the `hours` and `minutes` properties are
integers and their values should be greater than or equal to 1.

If the `execution_time_limit` property is not used at all, the default global
value of the `execution_time_limit` property is **1 hour**. Additionally, if
a pipeline has only local `execution_time_limit` properties, the global value
of `execution_time_limit` will still be **1 hour**.

### An example with a single execution\_time\_limit

The following pipeline YAML file uses an `execution_time_limit` property
with a `pipeline` scope:

``` yaml
version: v1.0
name: Using execution_time_limit
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
execution_time_limit:
  hours: 3

blocks:
  - name: Creating Docker Image
    task:
      jobs:
      - name: Docker build
        commands:
          - checkout
          - sleep 120

  - name: Building executable
    task:
      jobs:
      - name: Building job
        commands:
          - echo 360
          - echo "Building executable"
```

### An example with an execution\_time\_limit in a block

The following pipeline YAML file uses two `execution_time_limit` properties in
a `block`:

``` yaml
version: v1.0
name: Using execution_time_limit
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Creating Docker Image
    execution_time_limit:
      minutes: 15
    task:
      jobs:
      - name: Docker build
        commands:
          - checkout
          - sleep 120

  - name: Building executable
    execution_time_limit:
      minutes: 10
    task:
      jobs:
      - name: Building job
        commands:
          - echo 360
          - echo "Building executable"
```

### An example with an execution\_time\_limit at the job level

The following pipeline YAML file uses the `execution_time_limit` property with
 a `job` scope:

``` yaml
version: v1.0
name: Using execution_time_limit on a job
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Tests
    task:
      jobs:

      - name: Lint
        commands:
          - checkout
          - make lint

      - name:  Tests
        execution_time_limit:
          minutes: 30
        commands:
          - checkout
          - make test
```

### An example with multiple execution\_time\_limit

The following pipeline YAML file uses a combination of an `execution_time_limit`
property with a `pipeline` scope and a single `execution_time_limit` property
with a `block` scope:

``` yaml
version: v1.0
name: Using execution_time_limit
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
execution_time_limit:
  hours: 5

blocks:
  - name: Creating Docker Image
    execution_time_limit:
      minutes: 15
    task:
      jobs:
      - name: Docker build
        commands:
          - checkout
          - sleep 120

  - name: Building executable
    task:
      jobs:
      - name: Building job
        commands:
          - checkout
          - echo "Building executable"
```

In this case the `Creating Docker Image` block should finish in less than 15
minutes whereas the `Building executable` block should finish in less than 5
hours, which is the value of the `pipeline` scope `execution_time_limit` property.

However, as blocks are currently executed sequentially, the
`Building executable` block should finish in 5 hours minus the time it took the
`Creating Docker Image` block to finish.

## fail_fast

The `fail_fast` property enables you to set a policy for a pipeline when one of
its jobs fail.

It can have two sub-properties, `stop` and `cancel`.

At least one of them is required. If both are set, `stop` will be evaluated first.

Both `stop` and `cancel` properties require a condition defined with a `when`,
following the [Conditions DSL][conditions-reference].

If this condition is fulfilled for a given pipeline execution, the appropriate
fail-fast policy is activated.

If a `stop` policy is set, all running jobs will be stopped and all pending
ones will be canceled as soon as possible when one job fails.

If a `cancel` policy is set, when one job fails, the blocks and jobs which have
not yet started executing will be canceled, but already running ones will be
allowed to finish executing. This will provide you with more data for debugging
without using additional resources.

### An example of setting fail-fast stop policy

In the following configuration, blocks A and B run in parallel. Block C runs
after block B is finished.

When Block A fails, if the workflow was initiated from a non-master branch, the
fail fast `stop` policy will be applied to:

- Stop block B
- Cancel (ie. not run) block C

``` yaml
version: v1.0
name: Setting fail fast stop policy
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

fail_fast:
  stop:
    when: "branch != 'master'"

blocks:
  - name: Block A
    dependencies: []
    task:
      jobs:
      - name: Job A
        commands:
          - sleep 10
          - failing command
  - name: Block B
    dependencies: []
    task:
      jobs:
      - name: Job B
        commands:
          - sleep 60
  - name: Block C
    dependencies: ["Block B"]
    task:
      jobs:
      - name: Job C
        commands:
          - sleep 60
```

### An example of setting fail-fast cancel policy

In the following configuration, blocks A and B run in parallel. Block C runs
after block B is finished.

When Block A fails, if the workflow was initiated from a non-master branch, the
fail fast `cancel` policy will be applied to:

- Let block B finish
- Cancel (ie. not run) block C

``` yaml
version: v1.0
name: Setting fail fast cancel policy
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

fail_fast:
  cancel:
    when: "branch != 'master'"

blocks:
  - name: Block A
    dependencies: []
    task:
      jobs:
      - name: Job A
        commands:
          - sleep 10
          - failing command
  - name: Block B
    dependencies: []
    task:
      jobs:
      - name: Job B
        commands:
          - sleep 60
  - name: Block C
    dependencies: ["Block B"]
    task:
      jobs:
      - name: Job C
        commands:
          - sleep 60
```

## queue

The optional `queue` property enables you to assign the pipeline to the custom
execution queues and/or to configure the way the pipelines are processed when
queuing is about to happen.

There are two ways you can define a `queue` behaviour.

The first one is with `direct queue configuration` that will be applied to all
pipelines initiated with a given YAML configuration file.

The second approach is `conditional queue configurations` that allows you to
define an array of queue definitions and conditions under which those definitions
should be applied.

All the sub-properties with their possible values for both approaches are listed
below and you can find more examples and use cases for different queue
configurations on the [Pipeline Queues][pipeline-queues] page

### direct queue configuration

When using this approach, you can use the `name`, `scope` and `processing`
properties as a direct sub-properties of a `queue` property.

The `name` property should hold the string that uniquely identifies wanted queue
within the configured scope.

If it is omitted, it will be auto-generated based on the git branch/tag name or
pull request number and the YAML configuration file name for the given pipeline.

The `scope` property can have one of two values, **project** or **organization**.

If the `scope` is set to **organization** the pipelines from the queue will be
queued together with pipelines from other projects within the organization that
have the queue configuration with same `name` and `scope` values.

On the other hand, the queues with the same values for `name` property in different
projects that have `scope` set to **project** are mutually independent and their
pipelines will not be queued together.

If `scope` property is omitted, its value will be automatically set to **project**.

The `processing` property configures the way pipelines are processed in the queue
and it can have one of two values, **serialized** or **parallel**.

If the `processing` is set to **serialized** the pipelines in the queue will be
queued and executed one by one in the ascending order by creation time.

If the `processing` is set to **parallel** all pipelines in the queue will be
executed as soon as they are created and there will be no queuing at all.

If `processing` property is omitted, its value will be automatically set to
**serialized**.

Either `name` or `processing` property are required for queue definitions to be
valid and `scope` property can only be configured if the `name` property is also
configured.

### conditional queue configurations

In this approach, you should define an array of items with queue configurations
as a sub-property of the `queue` property.

Each array item can have the same properties, `name`, `scope` and `processing`,
as in [direct queue configuration](#direct-queue-configuration).

Besides those, one additional property is required in each array item and that is
a `when` property that should hold the condition written in [Conditions DSL][conditions-reference].

When the `queue` configuration is evaluated in this approach, the `when` conditions
from the items in the array are evaluated one by one starting with the first item
in the array.

The evaluation is stopped as soon as one of the `when` conditions are evaluated
as `true` and the rest of the properties from the same array item are used
to configure the queue for the given pipeline.

This means that the `order of the items` in the array is important and that the
items should be ordered so the ones with most specific conditions are defined
first followed by the ones with the more generalized conditions (e.g. the one with
`branch = 'develop'` before the one with `branch != 'master'`).

If none of the conditions is evaluated as true, the
[default queue behaviour][default-queue-config] will be used.

## auto_cancel

The `auto_cancel` property enables you to set a strategy for auto-canceling other
pipelines in a queue when a new one appears.

It can have two sub-properties, `running` and `queued`.

At least one of them is required. If both are set, `running` will be evaluated
first.

Both `running` and `queued` properties require a condition defined with a `when`,
following the [Conditions DSL][conditions-reference].

If this condition is fulfilled for a given pipeline execution, the appropriate
auto-cancel strategy will be implemented.

If a `running` auto-cancel strategy is set, the newest pipeline in a queue will:

- cancel all queued pipelines in a queue before self
- stop any running pipeline in a queue before self

This will make new pipelines start running as soon as possible while still making
sure that pipelines from the same queue are not run in parallel.

If a `queued` auto-cancel strategy is set, the newest pipeline in a queue will:

- cancel all queued pipelines in a queue before self
- wait for any running pipeline in a queue before self to finish

This way you will always get results for anything that was already using resources
but the new pipelines will be delayed a bit more in a queue.

### An example of setting auto-cancel running strategy

In the following configuration, all pipelines initiated from a non-master branch
will run immediately after auto stopping everything else in front of them in the
queue.

``` yaml
version: v1.0
name: Setting auto-cancel running strategy
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

auto_cancel:
  running:
    when: "branch != 'master'"

blocks:
  - name: Unit tests
    task:
      jobs:
      - name: Unit tests job
        commands:
          - echo Running unit test
```

### An example of setting auto-cancel queued strategy

In the following configuration, all pipelines initiated from a non-master branch
will cancel any queued pipelines and wait for running one to finish before starting
to run.

``` yaml
version: v1.0
name: Setting auto-cancel queued strategy
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

auto_cancel:
  queued:
    when: "branch != 'master'"

blocks:
  - name: Unit tests
    task:
      jobs:
      - name: Unit tests job
        commands:
          - echo Running unit test
```

## global\_job\_config

The `global_job_config` property enables you to choose a set of configuration
that is shared across the whole pipeline and define it in one place instead of
having to repeat it in every task separately.

It can contain any of these properties:

- [prologue](#prologue)
- [epilogue](#epilogue)
- [secrets](#secrets)
- [env_vars](#env_vars)
- [priority](#priority)

The defined configuration values have completely the same syntax as the ones
defined on a task or a job level and are applied to all the tasks and jobs in a
pipeline.

In the case of `prologue` and `env_vars` the global values, ones from
`global_job_config`, are exported first, and after them, the ones defined on a
task level.
This allows overriding global values for the specific task if there is a need for
that.

In the case of `epilogue`, the order of exporting is reversed, so, for example,
one can firstly perform specific cleanup commands before the global ones.

The `secrets` are just merged since ordering plays no role there.

In the case of the `priority`, the global values are added at the end of the list
of the priorities and their conditions defined on a job level.
This allows for job-specific priorities to be evaluated first, and only if none
of them matches will the global ones be evaluated and used.

### An example of using global\_job\_config property

``` yaml
version: "v1.0"
name: An example of using global_job_config
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
global_job_config:
  prologue:
    commands:
      - checkout
  env_vars:
    - name: TEST_ENV_VAR
      value: test_value
blocks:
  - name: Linter
    task:
      jobs:
        - name: Linter
          commands:
            - echo $TEST_ENV_VAR
  - name: Unit tests
    task:
      jobs:
        - name: Unit testing
          commands:
            - echo $TEST_ENV_VAR
  - name: Integration Tests
    task:
      jobs:
        - name: Integration testing
          commands:
            - echo $TEST_ENV_VAR
```

## Blocks

The `blocks` property defines an array of items that hold the elements of a
pipeline. Each element of that array is called a *block* and can have two
properties: `name`, which is optional and `task`, which is compulsory.

### name in blocks

The `name` property is a Unicode string that assigns a name to a block and is
optional.

If you accidentally name two or more `blocks` items with the same name value,
you will get an error message similar to the following:

``` txt
semaphore.yml ERROR:

Error: "There are at least two blocks with same name: Build Go project"
```

Semaphore assigns its own unique names to nameless `blocks` items, which are
displayed in the Semaphore 2.0 UI.

### dependencies in blocks

When your pipeline is running blocks in parallel,
you can use the `dependencies` property to define the flow of execution for subsequent blocks.

The following example runs `Block A` and `Block B` in parallel at the
very beginning of a pipeline.

``` yaml
version: "v1.0"
name: Pipeline with dependencies
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Block A"
    dependencies: []
    task:
      jobs:
      - name: "Job A"
        commands:
          - echo "output"
  - name: "Block B"
    dependencies: []
    task:
      jobs:
      - name: "Job B"
        commands:
          - echo "output"
  - name: "Block C"
    dependencies: ["Block A", "Block B"]
    task:
      jobs:
      - name: "Job C"
        commands:
          - echo "output"
```

The `dependencies` property of `Block C` makes `Block A` and `Block B` run in
parallel. Once both are finished `Block C` will run.

If you use `dependencies` property in some block, you have to specify dependencies for other blocks as well.
Otherwise the YAML validation error will be thrown. The following specification
is invalid, because dependencies are missing for `Block A` and `Block B`.

``` yaml
version: "v1.0"
name: Invalid pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Block A"
    task:
      jobs:
      - name: "Job A"
        commands:
          - echo "output"
  - name: "Block B"
    task:
      jobs:
      - name: "Job B"
        commands:
          - echo "output"
  - name: "Block C"
    dependencies: ["Block A", "Block B"]
    task:
      jobs:
      - name: "Job C"
        commands:
          - echo "output"
```

For more examples of common complex CI/CD workflows, see the
[semaphore-demo-workflows](https://github.com/semaphoreci-demos/semaphore-demo-workflows)
repository on GitHub. You will find specifications for fan-in/fan-out,
monorepo and multi-platform pipelines.

### task in blocks

All the items of a `blocks` list have a `task` property which is required.

You will learn about the properties of a `task` item in a while.

### skip in blocks

The `skip` property is optional and it allows you to define conditions, written
in [Conditions DSL][conditions-reference], which are based on branch name or tag
name of current push which initiated whole pipeline.

If condition defined in this way is evaluated to be true, the block will be
skipped.

When block is skipped, it means that it will immediately finish with result
`passed` without actually running any of its jobs.

Its result_reason will be set to `skipped` and other blocks which depend on it
passing will be started and executed as if this block executed regularly and all
of its jobs passed.

*Note*: It is not possible to have both `skip` and [run](#run-in-blocks)
properties defined for the same block since both of them configure the same
behavior, but in opposite ways.

Example of a block that is skipped on all branches except on master:

``` yaml
version: v1.0
name: The name of the Semaphore 2.0 project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
 - name: Inspect Linux environment
   skip:
     when: "branch != 'master'"
   task:
      jobs:
        - name: Print Environment variables
          commands:
            - echo $SEMAPHORE_PIPELINE_ID
            - echo $HOME
```

### run in blocks

The `run` property is optional and it allows you to define a condition, written
in [Conditions DSL][conditions-reference], that is based on properties of the push
which initiated the whole workflow.

Only if the run condition is evaluated to be true will the block and
all of its jobs be run, otherwise the block will be skipped.

When a block is skipped, it means that it will immediately finish with the result
`passed` and the result_reason `skipped` without actually running any of its jobs.

*Note*: It is not possible to have both `run` and [skip](#skip-in-blocks)
properties defined for the same block since both of them configure the same
behavior, but in opposite ways.

Example of a block that is run only on the master branch:

``` yaml
version: v1.0
name: The name of the Semaphore 2.0 project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
 - name: Inspect Linux environment
   run:
     when: "branch = 'master'"
   task:
      jobs:
        - name: Print Environment variables
          commands:
            - echo $SEMAPHORE_PIPELINE_ID
            - echo $HOME
```

## Task

The `task` property that is a compulsory part of each block of a `blocks`
property divides a YAML configuration file into major and distinct sections.
Each `task` item can have multiple `jobs` items, an optional `agent` section,
an optional `prologue` section, an optional `epilogue` section as well as an
optional `env_vars` block for defining environment variables and an optional
`secrets` block for using predefined environment variables from predefined
secrets.

### jobs

A `jobs` item is a property of `task` that allows you to define the commands
that you want to execute.

### agent in task

The `agent` section under a `task` section is optional and can coexist with the
global `agent` definition at the beginning of a Pipeline YAML file. The
properties and the possible values of the `agent` section can be found in the
[agent reference](#agent).

An `agent` block under a `task` block overrides the global `agent` definition.

### secrets

The `secrets` property is used for using existing environment variables from
a secret. This is described in the [The secrets property](#the-secrets-property)
section.

### prologue

A `prologue` block is executed before the commands of each job of a `task`
item.

You can consider the `prologue` commands as a part of each one of the `jobs` of
the same `task` item.

### epilogue

An `epilogue` block is executed after the commands of each `jobs` item of a
`task`.

### env_vars

The elements of an `env_vars` array are name and value pairs that hold the name
of the environment variable and the value of the environment variable,
respectively.

#### Example of env_vars

``` yaml
version: v1.0
name: A Semaphore 2.0 project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
   task:
      jobs:
        - name: Check environment variables
          commands:
            - echo $HOME
            - echo $PI
            - echo $VAR1
      env_vars:
           - name: PI
             value: "3.14159"
           - name: VAR1
             value: This is Var 1
```

The preceding pipeline YAML file defines two environment variables named `VAR1`
and `PI`. Both environment variables have string values, which means that
numeric values need to be included in double quotes.

### Example of task

``` yaml
version: v1.0
name: The name of the Semaphore 2.0 project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
   task:
      jobs:
        - name: Check environment variables
          commands:
            - echo $SEMAPHORE_PIPELINE_ID
            - echo $HOME
            - echo $PI
            - pwd

      prologue:
        commands:
          - checkout

      env_vars:
        - name: PI
          value: "3.14159"
```

*Caution*: The indentation level of `prologue`, `epilogue`, `env_vars` and
`jobs` properties should be the same.

### Example of a task block with agent

``` yaml
version: v1.0
name: YAML file example with task and agent.
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
 - name: Run in Linux environment
   task:
      jobs:
        - name: Learn about SEMAPHORE_GIT_DIR
          commands:
            - echo $SEMAPHORE_GIT_DIR

 - name: Run in macOS environment
   task:
      agent:
          machine:
            type: a1-standard-4
            os_image: macos-xcode12
      jobs:
        - name: Using agent job
          commands:
            - echo $PATH
```

## Jobs

The `jobs` items are essential for each pipeline because they allow you to
define the actual commands that you want to execute.

### name in jobs

The value of the optional `name` property is a Unicode string that provides a
name to a job.

Semaphore assigns its own names to nameless `jobs` items, which is what is
displayed in the UI.

*Tip*: It is considered a good practice to give descriptive names to all the
`jobs` and the `blocks` items of a Semaphore pipeline.

### commands

The `commands` property is an array of strings that holds the commands that
will be executed for a job.

#### Example of commands

The general structure of a job when using the `commands` property is as follows:

``` yaml
version: v1.0
name: The name of the Semaphore 2.0 project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
   task:
      jobs:
        - name: Check environment variables
          commands:
            - echo $SEMAPHORE_PIPELINE_ID
            - pwd
```

### commands_file

The `commands_file` file property allows you to define the path of a plain text
file that contains the commands of a job that is an item in a `jobs` list, a
`prologue` or an `epilogue` block instead of listing them in a `commands` list.

You cannot use both `commands_file` and `commands` when defining a job, a
`prologue` or an `epilogue` item. Moreover, you cannot have a job, a `prologue`
or an `epilogue` properly defined if both the `commands` and `commands_file`
properties are missing.

#### Example of commands_file

The contents of the YAML file that defines the pipeline are as follows:

``` yaml
version: v1.0
name: Using commands_file
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
 - name: Calling text file
   task:
      jobs:
        - name: Using command_file
          commands_file: file_with_commands
      prologue:
          commands:
            - checkout
```

The contents of `file_with_commands` are as follows:

``` bash
echo "Command File"
echo "Exit command_file"
```

Some information about what happens behind the scenes: Semaphore 2.0
reads the plain text file and creates the equivalent job using a
`commands` block, which is what is finally executed. This means that
the `commands_file` property is replaced before the job is started and a
machine begins its execution.

### env_vars in jobs

An `env_vars` block can also be defined within a `jobs` block having a local
scope in addition to an `env_vars` block that is defined on a `task` level
where its scope is the entire `task` block. In that case the environment
variables of that local `env_vars` block will be only visible to the `jobs`
block it belongs to.

If one or more environment variables are defined on both a `jobs` level and a
`task` level, the values of the environment variables that are defined on the
`jobs` level take precedence over the values of the environment variables that
were also defined on the `task` level.

#### Example of env_vars in jobs

``` yaml
version: v1.0
name: Using env_vars per jobs
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Using Local Environment variables only
    task:
      jobs:
      - name: Job that uses local env_vars
        commands:
          - echo $APP_ENV
        env_vars:
          - name: APP_ENV
            value: This is APP_ENV
          - name: VAR_2
            value: This is VAR_2 from First Job

  - name: Both local and global env_vars
    task:
      env_vars:
        - name: APP_ENV
          value: prod
        - name: VAR_1
          value: VAR_1 from outer env_vars
      jobs:
      - name: Using both global and local env_vars
        commands:
          - echo $VAR_1
          - echo $VAR_2
          - echo $APP_ENV
        env_vars:
          - name: VAR_1
            value: This is VAR_1
          - name: VAR_2
            value: This is VAR_2
      - name: Second job - no local env_vars
        commands:
          - echo $VAR_1
          - echo $APP_ENV
```

### priority

The `priority` property allows you to configure a job priority that affects the
order in which jobs are started when the parallel jobs quota for the organization
is reached.

It holds a list of items where each item has a `value` property that represents
the numerical value for the job priority in range from a 0 to a 100, and a `when`
condition property written in [Conditions DSL][conditions-reference].

The items are evaluated from the top of the list and the value of the first item
which `when` condition is evaluated as true will be set as the priority for the
given job.

If non of the conditions is evaluated as true, the
[default job priority][default-priorities] will be set.

#### Example of priority

The following pipeline illustrates the use of the `priority` property:

``` yaml
version: v1.0
name: Job priorities
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Tests
    task:
      jobs:
      - name: Unit tests
        priority:
        - value: 70
          when: "branch = 'master'"
        - value: 45
          when: true
        commands:
          - make unit-test
      - name: Integration tests
        priority:
        - value: 58
          when: "branch = 'master'"
        - value: 42
          when: true
        commands:
          - make integration-test
```

### matrix

The `matrix` property allows you to define one or more environment variable
sets with multiple values. In such a setup, `n` parallel jobs are created,
where `n` equals the cardinality of the Cartesian product of all environment
variable sets.

So, the final outcome of the `matrix` property is the creation of multiple
parallel jobs with exactly the same commands that are defined in the respective
`commands` property. Each generated job is assigned with the environment
variables from corresponding element of Cartesian product.

#### Example of matrix

The following pipeline illustrates the use of the `matrix` property:

``` yaml
version: v1.0
name: Using the matrix property
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Elixir + Erlang
    task:
        jobs:
        - name: Elixir + Erlang matrix
          commands:
            - echo $ELIXIR
            - echo $ERLANG
          matrix:
            - env_var: ELIXIR
              values: ["1.3", "1.4"]
            - env_var: ERLANG
              values: ["19", "20", "21"]
```

In this example, the job specification named `Elixir + Erlang matrix` expands
to 6 parallel jobs as there are 2 x 3 = 6 combinations of the provided
environment variables:

- `Elixir + Erlang matrix - ELIXIR=1.4, ERLANG=21`
- `Elixir + Erlang matrix - ELIXIR=1.4, ERLANG=20`
- `Elixir + Erlang matrix - ELIXIR=1.4, ERLANG=19`
- `Elixir + Erlang matrix - ELIXIR=1.3, ERLANG=21`
- `Elixir + Erlang matrix - ELIXIR=1.3, ERLANG=20`
- `Elixir + Erlang matrix - ELIXIR=1.3, ERLANG=19`

## parallelism

The `parallelism` property can be used to easily generate a set of jobs with same
commands that can be parameterized.
Each of those jobs will have the environment variables with the total number of
jobs and the index of a particular job that can be used as parameters.

The `parallelism` property expects integer value larger than `1`.

The following environment variables are added in each generated job:

- `SEMAPHORE_JOB_COUNT` - total number of jobs generated via parallelism property
- `SEMAPHORE_JOB_INDEX` - value in the range from `1` to `SEMAPHORE_JOB_COUNT` which represents the index of a particular job in the list of generated jobs.

*Note*: It is not possible to have both `parallelism` and [matrix](#matrix)
properties defined for the same job since `parallelism` functionality is a subset
of `matrix` functionality.

### Example of using parallelism

When the following configuration is used:

``` yaml
version: v1.0
name: Using the parallelism property
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Example for parallelism
    task:
        jobs:
        - name: Parallel job
          parallelism: 4
          commands:
            - echo Job $SEMAPHORE_JOB_INDEX out of $SEMAPHORE_JOB_COUNT
            - make test PARTITION=$SEMAPHORE_JOB_INDEX
```
It will automatically create 4 jobs with the following names:

- `Parallel job - 1/4`
- `Parallel job - 2/4`
- `Parallel job - 3/4`
- `Parallel job - 4/4`

## Prologue and Epilogue

Each `task` element can have a single `prologue` and a single `epilogue`
element. Both `prologue` and `epilogue` properties are optional.

### The prologue property

A `prologue` block in a `task` block is used when you want to execute certain
commands prior to the commands of each job of that `task`. This is usually the
case with initialization commands that install software, start or stop
services, etc.

Please notice that a pipeline *will fail* if a command in a `prologue` block
fails to execute for some reason.

### Example of prologue

``` yaml
version: v1.0
name: YAML file illustrating the prologue property
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
 - name: Display a file
   task:
      jobs:
        - name: Display hw.go
          commands:
            - ls -al
            - cat hw.go
      prologue:
          commands:
            - checkout
```

### The Epilogue property

An `epilogue` block should be used when you want to execute some commands after
a job has finished, either successfully or unsuccessfully.

Please notice that a pipeline *will not fail* if one or more commands in the
`epilogue` fail to execute for some reason.

There are three types of epilogue commands:

1. Epilogue commands that are always executed. Defined with `always` in the
   epilogue section.

2. Epilogue commands that are executed when the job passes. Defined with
  `on_pass` in the epilogue section.

3. Epilogue commands that are executed when the job fails. Defined with
   `on_fail` in the epilogue sections.

The order of command execution is the following:

- First, the `always` commands are executed
- Then the `on_pass` or `on_fail` commands are executed

Example of epilogue:

``` yaml
version: v1.0
name: YAML file illustrating the epilogue property
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
 - name: Linux version
   task:
      jobs:
        - name: Execute uname
          commands:
            - uname -a
      epilogue:
        always:
          commands:
            - echo "this command is executed for both passed and failed jobs"
        on_pass:
          commands:
            - echo "This command runs if job has passed"
        on_fail:
          commands:
            - echo "This command runs if job has failed"
```

Commands can be defined as a list directly in the YAML file, as in the above
example, or via a `commands_file` property:

``` yaml
version: v1.0
name: YAML file illustrating the epilogue property
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
 - name: Linux version
   task:
      jobs:
        - name: Execute uname
          commands:
            - uname -a
      epilogue:
        always:
          commands_file: file_with_epilogue_always_commands.sh
        on_pass:
          commands_file: file_with_epilogue_on_pass_commands.sh
        on_fail:
          commands_file: file_with_epilogue_on_fail_commands.sh
```

Where the content of the files is a list of commands, like in the following
example:

``` bash
echo "hello from command file"
echo "hello from $SEMAPHORE_GIT_BRANCH/$SEMAPHORE_GIT_SHA"
```

The location of the file is relative to the pipeline file. For example, if your
pipeline file is located in `.semaphore/semaphore.yml`, the
`file_with_epilogue_always_commands.sh` in the above example is assumed to live
in `.semaphore/file_with_epilogue_always_commands.sh`.

## The secrets property

A secret is a place for keeping sensitive information in the form of
environment variables and small files. Sharing sensitive data in a secret is
both safer and more flexible than storing it using plain text files or
environment variables that anyone can access. A secret is defined using a specific
[YAML grammar](https://docs.semaphoreci.com/reference/secrets-yaml-reference/)
and processed using the `sem` command line tool.

The `secrets` property is used for importing all the environment variables
and files from an existing secret into a Semaphore 2.0 organization.

If one or more names of the environment variables from two or more imported
secrets are the same, then the shared environment variables will have the value
that was found in the secret that was imported last. The same rule applies to
the files in secrets.

Additionally, if you try to use a `name` value that does not exist, the
pipeline will fail to execute.

### name in secrets

The `name` property is compulsory is a `secrets` block because it specifies the
secret that you want to import. Please note that the specified secret or
secrets should exist under the active organization.

### files in secrets

You can store one or more files in a `secret`.

You do not need any extra work for using a file that you stored in a `secret`
apart from including the name of the secret that holds the file in the
`secrets` list of the pipeline YAML file. After that the only other requirement is
remembering the name of the file, which is the value you put in the `path`
property when creating the `secret`.

All files in secrets are restored in the home directory of the user of the
Virtual Machine (VM), which is `/home/semaphore`.

### Example of secrets with environment variables

``` yaml
version: v1.0
name: Pipeline configuration with secrets
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - task:
      jobs:
        - name: Using secrets
          commands:
            - echo $USERNAME
            - echo $PASSWORD
      secrets:
        - name: mysql-secrets
```

Environment variables imported from a `secrets` property are used like regular
environment variables defined in a `env_vars` block.

### Example of secrets with files

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
        - name: file.txt
          commands:
            - checkout
            - ls -l ~/file.txt
            - cd ..
            - cat file.txt
            - echo $SECRET_ONE
      secrets:
        - name: more-secrets
        - name: my-secrets
```

In this case the name of the file that was saved in a `secret` is `file.txt`
and is located at the home directory of the VM.

## promotions

The `promotions` property is used for *promoting* (manually or automatically
triggering) one or more pipelines using one or more pipeline YAML files,
respectively. A pipeline YAML file can have a single `promotions` block or
no `promotions` block at all.

The items of a `promotions` block are called *targets* and are implemented using
pairs of `name` and `pipeline_file` properties. A `promotions` block can have
multiple targets.

You can promote a target from the UI at any point, even while the pipeline that
owns that target is still running.

### name in promotions

The `name` property in a `promotions` block is compulsory, defines the name of a
target and is a Unicode string.

### pipeline_file

The `pipeline_file` property of the `promotions` block, which is compulsory,
is a path to another pipeline YAML file within the GitHub repository of the
Semaphore project.

If the `pipeline_file` value is just a plain filename without any directories,
then `pipeline_file` will look for it inside the `.semaphore` directory.
Otherwise, it will follow the given path beginning from the `.semaphore`
directory.

Each `pipeline_file` value must be a valid and syntactically correct pipeline
YAML file as defined in this document. However, the potential errors of a
pipeline YAML file that is given as a value to the `pipeline_file` property
will be revealed when the relevant target is promoted.

The same will happen if the file given as a `pipeline_file` value does not
exist – the error will be revealed at the time of promotion.

### Example of promotions

The contents of the `.semaphore/semaphore.yml` are as follows:

``` yaml
version: v1.0
name: Using promotions
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: ls
    task:
      jobs:
      - name: List contents
        commands:
          - ls -al
          - echo $SEMAPHORE_PIPELINE_ID

promotions:
  - name: Pipeline 1
    pipeline_file: p1.yml
  - name: Pipeline 2
    pipeline_file: p2.yml
```

The `promotions` block in the aforementioned `.semaphore/semaphore.yml` file
will allow you to promote two other YAML files named `p1.yml` and
`p2.yml`.

The contents of the `.semaphore/p1.yml` are as follows:

``` yaml
version: v1.0
name: This is Pipeline 1
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Environment variable
    task:
      jobs:
      - name: SEMAPHORE_PIPELINE_ID
        commands:
          - echo $SEMAPHORE_PIPELINE_ID
```

Last, the contents of the `.semaphore/p2.yml` are as follows:

``` yaml
version: v1.0
name: This is Pipeline 2
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: List VM Linux version
    task:
      jobs:
      - name: uname
        commands:
          - echo $SEMAPHORE_PIPELINE_ID
          - uname -a
```

### auto\_promote

The `auto_promote` property is optional and it allows you to specify a set of
conditions under which the pipeline will be promoted automatically.

It requires conditions to be defined in a `when` sub-property, following the
[Conditions DSL][conditions-reference].

If these conditions are fulfilled for a given pipeline execution, the appropriate
promotion will be triggered automatically.

You can define conditions based on values for the following properties of original
pipeline:

- `branch` - the name of the branch for which pipeline is initiated (empty if it is a tag or pull request)
- `tag` - the name of the tag for which pipeline is initiated (empty if it is a branch or pull-requests)
- `pull request` - the number of pull request for which pipeline is initiated (empty if it is a branch or tag)
- `change_in` - the fact that at least one file has changed in a given path. Used for [monorepo workflows][monorepo-workflows].
- `result` - the result of pipeline's execution, see possible values below
- `result_reason` - the reason for specific pipeline execution result, see possible values for each result type below

The valid values for `result` are:

- `passed`: all the blocks in the pipeline ended successfully
- `stopped`: the pipeline was stopped either by the user or by the system
- `canceled`: the pipeline was canceled either by the user or by the system.
    The difference between `canceled` and `stopped` is that if the result is
    `canceled` it means that pipeline was terminated before any block or job
    has started to execute.
- `failed`: the pipeline failed either due to a pipeline YAML syntax error or
    because at least one of the blocks of the pipeline failed due to a command
    not being successfully executed.

The valid values for `result_reason` are:

- `test`: one or more of user tests failed
- `malformed`: the pipeline YAML file is not correct
- `stuck`: the pipeline was stuck for some internal reason and then aborted
- `internal`: the pipeline was terminated for internal reasons
- `user`: the pipeline was stopped on user request
- `strategy`: the pipeline was terminated due to auto-cancel strategy
- `timeout`: the pipeline exceeded the execution time limit

Not all `result` and `result_reason` combinations make sense. For example, you
cannot have `passed` as the value of `result` and `malformed` as the value of
`result_reason`. On the other hand, you can have `failed` as the value of
`result` and `malformed` as the value of `result_reason`.

For a `result` value of `failed`, the valid values of `result_reason` are
`test`, `malformed` and `stuck`. When the `result` value is `stopped` or
`canceled`, the list of valid values for `result_reason` are `internal`,
`user`, `strategy` and `timeout`.

### Example of auto\_promote

The following pipeline YAML file presents two examples using `auto_promote` and
depends on three other pipeline YAML files named `p1.yml`, `p2.yml`, and `p3.yml`:

``` yaml
version: v1.0
name: Testing Auto Promoting
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

promotions:
- name: Staging
  pipeline_file: p1.yml
  auto_promote:
    when: "result = 'passed' and (branch = 'master' or tag =~ '^v1\.')"
- name: Documentation
  pipeline_file: p2.yml
  auto_promote:
    when: "branch = 'master' and change_in('/docs/')"
- name: Production
  pipeline_file: p3.yml


blocks:
  - name: Block 1
    task:
      jobs:
        - name: Job 1 - Block 1
          commands:
            - echo $SEMAPHORE_GIT_BRANCH

  - name: Block 2
    task:
      jobs:
        - name: Job 1 - Block 2
          commands:
            - echo Job 1 - Block 2
            - echo $SEMAPHORE_GIT_BRANCH
        - name: Job 2 - Block 2
          commands:
            - echo Job 2 - Block 2
```

According to the specified rules, only the `Staging` and `Documentation` promotions
can be auto-promoted – when the conditions specified in `when` sub-property of
`auto_promote` property are fulfilled. However, the `Production` promotion has no
`auto_promote` property so there is no way it can be auto-promoted.

So, if the pipeline finishes with result `passed` and it was initiated from the
`master` branch then the `p1.yml` pipeline file will be auto-promoted.

The same will happen if the pipeline was initiated from the tag that has a name
which matches the expression given in PCRE (*Perl Compatible Regular Expression*)
syntax, which is, in this case, any string that starts with `v1.`.

As for the `Documentation` promotion, it will be auto-promoted when initiated from
the `master` branch and there is at least one changed file in the `docs` folder
(relative to the root of the repository). Check the 
[change_in reference][change-in-ref] for additional usage details.

The content of `p1.yml` is as follows:

``` yaml
version: v1.0
name: Pipeline 1
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Environment variable
    task:
      jobs:
      - name: SEMAPHORE_PIPELINE_ID
        commands:
          - echo $SEMAPHORE_PIPELINE_ID
```

The content of `p2.yml` is the following:

```yaml
version: v1.0
name: Pipeline 2
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Update docs
    task:
      jobs:
      - name: make docs
        commands:
          - make docs
```

Finally, the contents of `p3.yml` are:

``` yaml
version: v1.0
name: This is Pipeline 3
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: List VM Linux version
    task:
      jobs:
      - name: uname
        commands:
          - echo $SEMAPHORE_PIPELINE_ID
          - uname -a
```

All the shown files are perfectly correct pipeline YAML files that could
have been used as `semaphore.yml` files.

### auto\_promote\_on - DEPRECATED

*Note*: The `auto_promote_on` property is deprecated in favor of [auto_promote](#auto_promote) property

The `auto_promote_on` property is used for automatically promoting one or more
branches of `promotions` blocks according to user specified rules.

The `auto_promote_on` property is a list of items and supports three
properties: `result`, which is mandatory, `branch`, which is optional, and
`result_reason`, which is also optional.

For a `auto_promote_on` branch to execute, the return values of all the used
properties of that branch must be `true`.

#### result

The value of the `result` property is a string that is used for matching the
status of a pipeline.

The list of valid values for `result`: `passed`, `stopped`, `canceled` and
`failed`.

- `passed`: all the blocks in the pipeline ended successfully
- `stopped`: the pipeline was stopped either by the user or by the system
- `canceled`: the pipeline was cancelled either by the user or by the system.
    The difference between `canceled` and `stopped` is that a pipeline that is
    not running can be cancelled but cannot be stopped.
- `failed`: the pipeline failed either due to a pipeline YAML syntax error or
    because at least one of the blocks of the pipeline failed due to a command
    not being successfully executed.

#### branch

The `branch` property is a list of items. Its items are regular expressions
that Semaphore 2.0 tries to match against the name of the GitHub branch that
is used with the pipeline that is being executed. If any of them is a match,
then the return value of the `branch` is `true`.

The `branch` property uses Perl Compatible Regular Expressions.

In order for a `branch` value to match the `master` branch only and not match
names such as `this-is-not-master` or `a-master-alternative`, you should use
`^master$` as the value of the `branch` property. The same rule applies for
matching words or strings.

In order for a `branch` value to match branches that begin with `dev` you
should try something like `^dev`.

#### result_reason

The value of the `result_reason` property is a string that signifies the reason
that the value of the `result` property happened.

The list of valid values for `result_reason`: `test`, `malformed`, `stuck`,
`deleted`, `internal` and `user`.

- `test`: one or more of user tests failed
- `malformed`: the pipeline YAML file is not correct
- `stuck`: the pipeline was stuck for some internal reason and then aborted
- `deleted`: the pipeline was terminated because the GitHub branch was deleted
    while the pipeline was running
- `internal`: the pipeline was terminated for internal reasons
- `user`: the pipeline was stopped on user request

Not all `result` and `result_reason` combinations make sense. For example, you
cannot have `passed` as the value of `result` and `malformed` as the value of
`result_reason`. On the other hand, you can have `failed` as the value of
`result` and `malformed` as the value of `result_reason`.

For a `result` value of `failed`, the valid values of `result_reason` are
`test`, `malformed` and `stuck`. When the `result` value is `stopped` or
`canceled`, the list of valid values for `result_reason` are `deleted`,
`internal` and `user`.

### Example of auto\_promote\_on - DEPRECATED

*Note*: The `auto_promote_on` property is deprecated in favor of [auto_promote](#auto_promote) property

The following pipeline YAML file presents an example use of `auto_promote_on`
and depends on two other pipeline YAML files named `p1.yml` and `p2.yml`:

``` yaml
version: v1.0
name: Testing Auto Promoting
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

promotions:
- name: Staging
  pipeline_file: p1.yml
  auto_promote_on:
    - result: passed
      branch:
        - "master"
        - ^refs/tags/v1.*
    - result: failed
      branch:
        - "v2."
      result_reason: malformed

- name: prod
  pipeline_file: p2.yml

blocks:
  - name: Block 1
    task:
      jobs:
        - name: Job 1 - Block 1
          commands:
            - echo $SEMAPHORE_GIT_BRANCH
        - name: Job 2 - Block 1
          commands:
            - echo Job 2 - Block 1

  - name: Block 2
    task:
      jobs:
        - name: Job 1 - Block 2
          commands:
            - echo Job 1 - Block 2
            - echo $SEMAPHORE_GIT_BRANCH
        - name: Job 2 - Block 2
          commands:
            - echo Job 2 - Block 2
```

According to the specified rules only the `Staging` promotion of the `promotions`
list can be auto promoted – this depends on the rules of the two items of
the `auto_promote_on` list. However, the `prod` promotion of the `promotions`
list has no `auto_promote_on` property so there is no way it can be auto
promoted.

So, if the pipeline finishes with result `passed` and the GitHub branch name
contains the word `master` in its name then the `p1.yml` pipeline file will be
auto promoted. The same will happen if the the pipeline finishes with result
`failed`, the `result_reason` is `malformed` and the GitHub branch name
contains the `v2` sequence of characters followed by at least one more
character because a `.` character in a Perl Compatible Regular Expression means
one or more characters.

The contents of `p1.yml` are as follows:

``` yaml
version: v1.0
name: Pipeline 1
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Environment variable
    task:
      jobs:
      - name: SEMAPHORE_PIPELINE_ID
        commands:
          - echo $SEMAPHORE_PIPELINE_ID
```

The contents of `p2.yml` are the following:

``` yaml
version: v1.0
name: This is Pipeline 2
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: List VM Linux version
    task:
      jobs:
      - name: uname
        commands:
          - echo $SEMAPHORE_PIPELINE_ID
          - uname -a
```

Both `p1.yml` and `p2.yml` are perfectly correct pipeline YAML files that could
have been used as `semaphore.yml` files.

## Complete Configuration examples

### A complete .semaphore/semaphore.yml example

The following code presents a complete `.semaphore/semaphore.yml` file:

``` yaml
version: v1.0
name: YAML file example for Go project
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
            - echo $PI
      prologue:
          commands:
            - checkout
      env_vars:
           - name: PI
             value: "3.14159"

 - name: Build Go project
   task:
      jobs:
        - name: Build hw.go
          commands:
            - checkout
            - change-go-version 1.10
            - go build hw.go
            - ./hw
        - name: PATH variable
          commands:
            - echo $PATH
      epilogue:
        always:
          commands:
            - echo "The job finished with $SEMAPHORE_JOB_RESULT"
        on_pass:
          commands:
            - echo "Executed when the SEMAPHORE_JOB_RESULT is passed"
        on_fail:
          commands:
            - echo "Executed when the SEMAPHORE_JOB_RESULT is failed"
```

### A .semaphore/semaphore.yml file that uses secrets

``` yaml
version: v1.0
name: Pipeline configuration with secrets
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - task:
      jobs:
        - name: Using secrets
          commands:
            - checkout
            - ls -l .semaphore
            - echo $SEMAPHORE_PIPELINE_ID
            - echo $SECRET_ONE
            - echo $SECRET_TWO
        - name: Using SECRET_TWO
          commands:
            - checkout
            - echo $SECRET_TWO
            - ls -l .semaphore

      secrets:
        - name: mySecrets
        - name: more-mihalis-secrets
```

### A .semaphore/semaphore.yml file without name properties

Although it is allowed to have `.semaphore/semaphore.yml` files without
name properties, it is considered a very bad practice and should be
avoided.

However, the following sample `.semaphore/semaphore.yml` file proves
that it can be done:

``` yaml
version: v1.0
name: Basic YAML configuration file example.
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - task:
      jobs:
          - commands:
             - echo $SEMAPHORE_PIPELINE_ID
             - echo "Hello World!"
```

## The order of execution

You cannot and you should not make any assumptions about the order the various
`jobs` items of a `task` are going to be executed. This means that the jobs of
a `task` item might not start in the order of definition.

However, the `blocks` items of a `.semaphore/semaphore.yml` file, which are
`task` items, are executed sequentially. This means that if you have two `task`
items on a `.semaphore/semaphore.yml` file, the second one will begin only
when the first one has finished.

Last, the jobs of a block will run in parallel provided that you have the
required capacity (boxes) available.

### Comments

Lines that begin with `#` are considered comments and are being ignored by the
YAML parser, which is not a Semaphore 2.0 feature but the way YAML files work.

### See also

- [Secrets YAML reference](https://docs.semaphoreci.com/reference/secrets-yaml-reference/)
- [Projects YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/)
- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Machine Types](https://docs.semaphoreci.com/ci-cd-environment/machine-types/)

[ubuntu1804]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/
[macos-xcode12]: https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/
[conditions-reference]: https://docs.semaphoreci.com/reference/conditions-reference/
[when-repo-skip-exemples]: https://github.com/renderedtext/when#skip-block-exection
[docker-run]: https://docs.docker.com/engine/reference/run/#overriding-dockerfile-image-defaults
[env-var-in-task]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#env_vars
[secrets-in-task]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#secrets
[default-priorities]: https://docs.semaphoreci.com/essentials/prioritization/#default-job-priorities
[pipeline-queues]: https://docs.semaphoreci.com/essentials/pipeline-queues/
[default-queue-config]: https://docs.semaphoreci.com/essentials/pipeline-queues#default-behaviour
[monorepo-workflows]: https://docs.semaphoreci.com/essentials/building-monorepo-projects/
[change-in-ref]: https://docs.semaphoreci.com/reference/conditions-reference/#change_in
