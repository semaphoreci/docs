---
description: Semaphore supports setting environment variables on per-job and per-block level.
---

# Setting Environment Variables

Semaphore supports setting environment variables on a [global_job_config][global_job_config],
[per-block][envvars-perblock] and [per-job][envvars-perjob] level.

If you're looking for a list of environment variables which Semaphore sets in
every job, refer to [CI/CD Environment guide][semaphore-env-vars].

## Using Workflow Builder

To set a new environment variable:

1. Open Workflow Builder.
2. Select a block or job where you would like to export environment variables.
3. Click **Environment variables**.
4. Click **Add env vars**.
5. Fill in the variable's key and value.
6. Optionally, add more variables.
7. Click **Run the workflow** to save your configuration and run a new workflow.

## YAML example

Here's an example which applies one to all jobs in the block:

``` yaml
# .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      env_vars:
        - name: GUIDED_TOUR
          value: "TRUE"
      jobs:
        - name: Lint
          commands:
            - echo "${GUIDED_TOUR}"
            - echo 'Linting code'
        - name: Unit
          commands:
            - echo "${GUIDED_TOUR}"
            - echo 'Unit tests'
```

[envvars-perblock]: ../reference/pipeline-yaml-reference.md#env_vars
[envvars-perjob]: ../reference/pipeline-yaml-reference.md#env_vars-in-jobs
[semaphore-env-vars]: ../ci-cd-environment/environment-variables.md
[global_job_config]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#global_job_config
