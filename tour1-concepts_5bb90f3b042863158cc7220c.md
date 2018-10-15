You can use Semaphore to automate all kinds of tasks related to building,
testing, and delivering or deploying software. If you're new to Semaphore,
specifically to the product version 2.0, this page is a great starting point.

Semaphore manages your build, test and deployment workflows with _pipelines_,
_blocks_, and _promotions_. Workflows may be separated with different
pipelines, for example one for tests and another for deployment. _Blocks_
define what to do at each step in the pipeline. _Promotions_ connect
different pipelines. Semaphore schedules and runs the blocks on
agents. The agent manages the environment the blocks run in. All
configuration is written in YAML and kept in `.semaphore/semaphore.yml`.

## Blocks & Tasks

_Blocks_ are the heart of a pipeline. Each block has a _task_ that
defines _jobs_. Jobs define the commands to run. If your task contains multiple
jobs, they are executed in parallel. So, a "test" task could define jobs
for "linting", "unit tests", and "integration tests" that run in parallel,
making the task finish faster.

Blocks are executed sequentially, waiting for all tasks in the previous block
to complete before continuing. Each task can configure its' own environment,
including machine type, setting environment variables, and using predefined
secrets.

We will see how to define blocks, tasks and jobs later in this guide. You can
also refer to the [pipeline reference docs](https://docs.semaphoreci.com/article/50-pipeline-yaml) for
complete information.

## Promotions

_Promotions_ are junctions blocks in your larger workflow.
Promotions are commonly used for deployment and promoting builds to different
environments. A pipeline can have multiple promotions, and they are always
defined at the end of a pipeline. Promoting loads an entirely new
pipeline, so you can build up complex pipelines using only
configuration files.

We will see how we can manage deployment using promotions later in this guide.
You can also refer to the [promotions reference docs](https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions)
for complete information.

## Secrets

_Secrets_ are used to store and retrieve sensitive data such as API keys,
which should never be committed to source control. Semaphore securely manages
sensitive data for use in blocks and tasks via environment variables.
You can create a secret using the `sem` CLI and reference it in the pipeline
YML definition.

We will see how to define and use secrets later in this guide. You can refer
to the [secrets reference docs](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)
for more information.

## Agents and Machine

Semaphore makes sure that there are always agents ready to run all your tasks.
When specifying agent type, you can select from a number of memory/CPU
combinations and operating system environments.

The standard Ubuntu Linux environment has all the common build tools and
programming languages preinstalled, so you can run your code without overhead.
Agents also provide full `sudo` access so you can install additional
software when needed.

## Organization and Projects

Everything in Semaphore is part of an _Organization_. The organization
connects team members with their _Projects_. You'll have a project
for each code repository connected to Semaphore.

## Next steps

[Let's create your first project](https://docs.semaphoreci.com/article/63-your-first-project)
and see how this works in practice.
