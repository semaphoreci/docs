# Concepts

The new version of Semaphore uses an entirely different model than the
previous version. The new version supports complex deployment
pipelines through _blocks_ and _switches_. Blocks represent steps in a
pipelinel. Blocks are the real unit work representing what to do.
Switches support conditional loading new pipelines, for example taking
a manual approval to deploy to production. Semaphore schedules and
runs the blocks on agents. The agent manages the environment the
blocks run in.

The new version is also more focused on configuration files and CLI,
then working in GUIs. The pipeline is defined in
`.semaphore/config.yml` and the `sem` CLI bootstraps new projects.

## Blocks & Tasks

_Blocks_ are the heart of pipeline. Blocks may define multiple
_tasks_.  Here's an example. Consider an application that runs
multiple kinds of tests. The test could run in parallel or in a
series. Blocks are flexible enough to support that. Of course
pipelines may have multiple blocks, so your pipeline may be as long or
short as needed. _Tasks_ can be configured to run a list of commands,
set environment variables, and manage secrets. Refer to the [reference
docs][pipeline_reference] for complete information.

## Switches

_Switches_ are like railroad switches in the pipeline because they force
the pipeline to move in a different direction. _Switches_ are commonly
used for promoting builds to different environments. Pipelines may
have multiple switches, but they must come at the end of a pipeline.
Switching loads an entirely new pipeline, so you can build up complex
pipelines with only configuration files. Refer to the [reference
docs][switch_reference] for complete information.

## Secrets

A _secrets_ is sensitive data such as API keys. They **shoult not** be
commited to source control. Instead they should be read from
environments variables. Semaphore securely manages sensitive data for
use in _blocks_ and _tasks_ via environment variables. Secretes are
created with the `sem` CLI and configured in the YML pipeline. Refer
to the [reference docs][secrets] for more information.

## Agents and Machine

Semaphore maintains a pool of agents to run tasks. You can select from
memory/CPU combinations and OS image. The standard OS image has all
the common tools and full `sudo` access so you can install extra
software.
