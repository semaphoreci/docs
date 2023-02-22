---
Description: Learn the basic concepts of Semaphore 2.0, such as Blocks & Tasks, Promotions, Secrets, Agents, Machines, and Containers.
---

# Concepts

Semaphore manages your build, test, and deployment workflows with _pipelines_,
_blocks_, and _promotions_:

- Workflows may contain multiple pipelines, e.g. one to run tests and
  another for deployment.
- _Blocks_ define what to do at each step in the pipeline.
- Blocks run in _agents_ that define the hardware and software environment.
- _Promotions_ connect different pipelines.

All configuration is specified in YAML files. The initial pipeline is always
sourced from `.semaphore/semaphore.yml`. Additional pipelines triggered via
promotions are defined in separate files.

![Semaphore 2.0 concepts diagram](https://storage.googleapis.com/semaphore-public-assets/public/images/semaphoreci2-concepts.png)

## Blocks & Tasks

Blocks are the building blocks of a pipeline. Each block has a _task_ defined by
one or more _jobs_. Jobs specify the _commands_ to execute.

If your task contains multiple jobs, Semaphore will execute them in parallel.
Each job runs in a separate, isolated machine that boots a clean environment.
For example, a `Tests` task may define jobs for running unit and integration
tests in parallel, making the task finish faster.

By default, blocks run sequentially, waiting for all tasks in the previous block
to complete before continuing.  However, you can also define your pipeline as a
dependency graph or run blocks in parallel by defining
[block dependencies](https://docs.semaphoreci.com/essentials/modeling-complex-workflows/).

Each task can configure its own environment (including machine type), set its own environment variables, and use any
predefined secrets.

For an introduction to creating blocks, tasks and jobs, refer to the [getting
started guide][getting-started]. You can
also refer to the [pipeline reference documentation](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/).

## Promotions

_Promotions_ are junction blocks in your workflow. Promotions are
commonly used for deployment and promoting builds to different environments.
A pipeline can have multiple promotions. Promoting loads an entirely new
pipeline, so you can build complex pipelines using only configuration files.

To see how to manage deployments using promotions, refer to the [promotions reference documentation](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions).

## Secrets

_Secrets_ are used to store and retrieve sensitive data, such as API keys,
which should never be committed to source control. Semaphore securely manages
sensitive data for use in blocks and tasks via encrypted environment variables
or files. You can create a secret using the `sem` CLI and reference it in
the pipeline YML definition.

To see how to define and use secrets, refer
to the [secrets documentation](https://docs.semaphoreci.com/essentials/using-secrets/).

## Agents, Machines, and Containers

Semaphore makes sure that there are always agents ready to run all your jobs.
When configuring an agent, you can select from a number of [memory/CPU
combinations][machine-types] and virtual machine (VM) operating system
environments.

The [Ubuntu Linux][ubuntu] and [MacOS][macos] VM environments have
common build tools and programming languages pre-installed, so you can
run your code without the overhead of installing numerous dependencies in
every workflow. Agents provide you with full `sudo` access, so you can install
additional software when needed.

Agents can also use [custom Docker containers][docker-containers] to run your
jobs. This is an alternative to using Semaphore VMs, which gives you complete
control over your CI/CD environment.

More reading:

[getting-started]: ../guided-tour/getting-started.md
[machine-types]: ../ci-cd-environment/machine-types.md
[ubuntu]: ../ci-cd-environment/ubuntu-20.04-image.md
[macos]: ../ci-cd-environment/macos-xcode-14-image.md
[docker-containers]: https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/
