# Concepts

Semaphore manages your test and deployment workflows with _pipelines_,
_blocks_, and _promotions_. Workflows may be separated with different
pipelines, say one for tests and another for deployment. _Blocks_
define what to do at each step in the pipeline. _Promotions_ connect
different pipelines. Semaphore schedules and runs the blocks on
agents. The agent manages the environment the blocks run in. All
configuration is written in YAML and kept in `.semaphore/config.yml`.

## Blocks & Tasks

_Blocks_ are the heart of a pipeline. Each block has a _task_ that
defines _jobs_. Jobs define the commands to run. Tasks with multiple
jobs are executed in parallel. So, the "test" block could define tasks
for "linting", "unit", and "integration" for faster parallel
execution. _Blocks_ execute in sequence, waiting for all tasks in
previous block to complete before continuing. _Tasks_ can be
configured to run a list of commands, set environment variables, and
manage secrets. Refer to the [reference docs][pipeline_reference] for
complete information.

## Promotions

_Promotions_ are junctions blocks in your larger workflow.
_Promotions_ are commonly used for promoting builds to different
environments. Pipelines may have multiple switches, but they must
come at the end of a pipeline. Promoting loads an entirely new
pipeline, so you can build up complex pipelines with only
configuration files. Refer to the [reference docs][switch_reference]
for complete information.

## Secrets

A _secrets_ is sensitive data such as API keys. They **should not** be
committed to source control. Instead they should be read from
environments variables. Semaphore securely manages sensitive data for
use in _blocks_ and _tasks_ via environment variables. Secretes are
created with the `sem` CLI and configured in the YML pipeline. Refer
to the [reference docs][secrets] for more information.

## Agents and Machine

Semaphore maintains a pool of agents to run tasks. You can select from
memory/CPU combinations and OS image. The standard OS image has all
the common tools and full `sudo` access so you can install extra
software.

## Organization and Projects

Everything in Semaphore is part of an _Organization_. The organization
connects team members with their _Projects_. You'll have a _Project_
for each code repository connected to Semaphore.
