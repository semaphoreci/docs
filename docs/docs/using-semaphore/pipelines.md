---
description: Orchestrate jobs, configure global settings, and launch deployments.
---

# Pipelines

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Overview

The pipeline is the configuration unit. Each pipeline is encoded as a YAML file. By default, Semaphore will look for the first pipeline in the path `.semaphore/semaphore.yml` relative to the root of your repository. 

For reference, here is an example pipeline with its respective YAML.

<Tabs groupId="jobs">
  <TabItem value="editor" label="Pipeline">
  ![Example job with a single test](./img/example-pipeline.jpg)
  </TabItem>
  <TabItem value="yaml" label="YAML">
  ```yaml title=".semaphore/semaphore.yml"
  version: v1.0
  name: Initial pipeline
  agent:
    machine:
      type: e1-standard-2
      os_image: ubuntu2004
  blocks:
    - name: Build
      task:
        jobs:
          - name: Build
            commands:
              - checkout
              - npm install
              - npm run build
              - artifact push workflow dist
    - name: Test
      dependencies:
        - Build
      task:
        jobs:
          - name: Unit tests
            commands:
              - checkout
              - artifact pull workflow dist
              - 'npm run test:unit'
          - name: Integration
            commands:
              - checkout
              - artifact pull workflow dist
              - 'npm run test:integration'
    - name: UI Tests
      dependencies:
        - Test
      task:
        jobs:
          - name: UI tests
            commands:
              - checkout
              - artifact pull workflow dist
              - npm run serve &
              - 'npm run test:ui'
  ```
  </TabItem>
</Tabs>

## Job execution order {#dependencies}

A pipeline is a group of [blocks](./jobs#blocks) connected by dependencies. Semaphore will automatically compute the execution graph based on the declared block dependencies.

In the following example:

- Block B and C depend on Block A. So, Block B and C won't start until all Block A is done. 
- Block D only starts when Block B AND Block C have finished.

![Pipeline execution order](./img/pipeline-execution-order.jpg)

<details>
  <summary>What if we removed all dependencies?</summary>
  <div>If we removed dependencies between blocks then all of them would run in parallel. 
  Functionally, it would be the same as having all jobs in one big block</div>
</details>

## Pipeline settings {#settings}

Pipeline settings will be applied to all jobs contained. You can change pipeline settings with the editor or directly in the YAML.

<Tabs groupId="jobs">
  <TabItem value="editor" label="Editor">
  ![Pipelines settings screeen](./img/pipeline-settings.jpg)
  </TabItem>
  <TabItem value="yaml" label="YAML">
  ```yaml title=".semaphore/semaphore.yml"
  version: v1.0
  name: Initial pipeline
  # highlight-next-line
  agent:
    machine:
      type: e1-standard-2
      os_image: ubuntu2004
  # highlight-next-line
  execution_time_limit:
    hours: 2
  # highlight-next-line
  fail_fast:
    stop:
      when: 'true'
  # highlight-next-line
  auto_cancel:
    running:
      when: 'true'
  global_job_config:
    # highlight-next-line
    prologue:
      commands:
        - echo "this is the prologue"
    # highlight-next-line
    epilogue:
      always:
        commands:
          - 'echo "epilogue: is always executed"'
      on_pass:
        commands:
          - 'echo "epilogue: executed only if job passes"'
      on_fail:
        commands:
          - 'echo "epilogue: executed only if job fails"'
  blocks:
    - name: Build
      task:
        jobs:
          - name: Build
            commands:
              - checkout
              - npm install
              - npm run build
  ```
  </TabItem>
</Tabs>


The pipeline settings are:

1. **Agent**: the *agent environment* where the jobs in the pipeline will run — [unless overriden](./jobs#agent-agent-override).
2. **Machine Type**: the hardware where the jobs run. Semaphore Cloud provides several *machine types* out of the box. You can add more types using *self-hosted agents*.
3. **Prologue**: similar to the [block prologue](./jobs#prologue), these commands will be prepended to the job commands in the pipeline.
4. **Epilogue**: like the [block epilogue](./jobs#epilogue), these commands will be appended to the job commands in the pipeline. You add commands that are executed when the job passes, fails, or to run always.
5. **Execution time limit**: time limit for job execution. Defaults to 1 hour. Any jobs running longer than this limit will be forcibly stopped.
6. **Fail-fast**: defines what to do when a job fails. Here you can configure the Semaphore to stop all running jobs as soon as one fails or set custom behaviors.
7. **Auto-cancel**: define what happens if changes are pushed to the repository while a pipeline is running. By default, Semaphore will queue these runs. You can, for example, stop the current pipeline and run the newer commits instead.
8. **YAML file path**: you can override where the pipeline config file is located in your repository.

### After-pipeline jobs

TODO

## Connecting pipelines {#promotions}

Your repository can contain more than one pipeline. To tie pipelines together, we use *promotions*. A promotion defines what pipeline or pipelines should run next.

![How jobs are organized into blocks which are organized into pipelines. Pipelines can trigger other pipelines using promotions](./img/pipeline-blocks-promotions.jpg)

Promotions are commonly used for deployment and promoting builds to different environments. For example, you can branch the main pipeline into separate development and production deployment pipelines, each with their own jobs, machine types, environment variables and secrets.

![A workflow with 3 pipelines](./img/workflows.jpg)

### How to add promotions

TODO


