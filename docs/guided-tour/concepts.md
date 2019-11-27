# Concepts

Semaphore manages your build, test and deployment workflows with _pipelines_,
_blocks_, and _promotions_. Workflows may contain multiple pipelines, for
example one for tests and another for deployment. _Blocks_ define what to do
at each step in the pipeline. _Promotions_ connect different pipelines.
Semaphore schedules and runs the blocks on agents. Each agent manages the
environment the blocks run in. All configuration is written in YAML files.
The initial pipeline is always kept in `.semaphore/semaphore.yml`. Promoted
pipelines have different filenames.

![Semaphore 2.0 concepts diagram](https://storage.googleapis.com/semaphore-public-assets/public/images/semaphoreci2-concepts.png)

## Blocks & Tasks

_Blocks_ are the heart of a pipeline. Each block has a _task_ that
defines one or more _jobs_. Jobs define the commands to execute.

If your task contains multiple jobs, they are executed in parallel.
So, a "test" task could define jobs for "linting", "unit tests", and
"integration tests" that run in parallel, making the task finish faster.

Blocks are executed sequentially, waiting for all tasks in the previous block
to complete before continuing. Each task can configure its own environment,
including machine type, set its own environment variables and use any
predefined secret.

We will see how to define blocks, tasks and jobs later in this guide. You can
also refer to the [pipeline reference docs](https://docs.semaphoreci.com/article/50-pipeline-yaml)
for complete information.

## Promotions

_Promotions_ are junctions blocks in your larger workflow. Promotions are
commonly used for deployment and promoting builds to different environments.
A pipeline can have multiple promotions. Promoting loads an entirely new
pipeline, so you can build up complex pipelines using only configuration files.

We will see how we can manage deployment using promotions later in this guide.
You can also refer to the [promotions reference docs](https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions)
for complete information.

## Secrets

_Secrets_ are used to store and retrieve sensitive data such as API keys,
which should never be committed to source control. Semaphore securely manages
sensitive data for use in blocks and tasks via encrypted environment variables
or files. You can create a secret using the `sem` CLI and reference it in
the pipeline YML definition.

We will see how to define and use secrets later in this guide. You can refer
to the [secrets reference docs](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)
for more information.

## Agents, Machines, and Containers

Semaphore makes sure that there are always agents ready to run all your jobs.
When configuring an agent, you can select from a number of [memory/CPU
combinations][machine-types] and virtual machine (VM) operating system
environments.

The [Ubuntu Linux][ubuntu] and [MacOS Mojave][macos] VM environments have
common build tools and programming languages preinstalled, so you can
run your code without an overhead of installing many dependencies in
every workflow. Agents provide full `sudo` access to you so you can install
additional software when needed.

Agents can also use [custom Docker containers][docker-containers] to run your
jobs. This is an alternative to using Semaphore VMs which gives you complete
control over your CI/CD environment.

## Next steps

[Let's learn how to customize your pipeline][next] so that it runs the way
you want it.

[next]: https://docs.semaphoreci.com/article/64-customizing-your-pipeline
[machine-types]: https://docs.semaphoreci.com/article/20-machine-types
[ubuntu]: https://docs.semaphoreci.com/article/32-ubuntu-1804-image
[macos]: https://docs.semaphoreci.com/article/120-macos-mojave-image
[docker-containers]: https://docs.semaphoreci.com/article/127-custom-ci-cd-environment-with-docker