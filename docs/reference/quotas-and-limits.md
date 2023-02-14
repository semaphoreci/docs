---
Description: Semaphore 2.0 enforces usage quotas and limits to protect customers and the platform from unforeseen spikes in traffic. 
---

# Quotas and Limits

Semaphore 2.0 enforces usage quotas and limits to protect customers and the
platform from unforeseen spikes in traffic. As a given customer's use of Semaphore increases, 
quota typically size increases correspondingly.

## Pipeline and Block Execution Time Limit

By default, each pipeline and block has a maximum execution time of **one hour**.
This mechanism protects your project from undesired expenses in the event that jobs
run longer than anticipated, e.g. an accidentally-committed debug 
statement waiting for user input.

This limit is adjustable in the Pipeline YAML.

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
  - name: Limited to 3 hours by pipeline level configuration
    commands:
      - sudo apt-get install piglet

  - name: Limited to 15 minutes
    execution_time_limit:
      minutes: 15
    commands:
      - sudo apt-get install vim
```

For a detailed explanation, see the [execution time limit section in the
Pipeline YAML reference][execution-time-limit-reference] documentation.

The maximum value for `execution_time_limit` is 24 hours.

## Limit on the number of pipelines in a queue

Each pipeline is assigned to an execution queue before running any jobs to prevent
parallel execution of consecutive pushes or deployment promotions.

By default, separate queues are created for each branch, tag, or pull request and
YAML configuration file combination. You can also define your own queues via
[queue property][yml-reference-queue] in a pipeline's YAML configuration.

Semaphore imposes a limit on each queue of **30 active pipelines** at any given moment,
to prevent system abuse and performance degradation.

This limit is not adjustable.

If you have a use case in which this limit is too constraining, please contact us
at <support@semaphoreci.com> and we will try to work out a solution.

## Limit on the number of blocks in a pipeline

Semaphore limits blocks to **100 per pipeline**.

This limit is not adjustable.

If you have a use case in which this limit is too constraining, please contact us
at <support@semaphoreci.com> and we will try to work out a solution.

## Limit on the number of jobs in a block

Semaphore limits jobs to **50 per block**.

This limit is not adjustable.

If you need more jobs to be executed in parallel, you can split them into
multiple blocks that run in parallel. This can be achieved by configuring
the [dependency][dependency-reference] property of the blocks.

## Job Log Size Limit

Semaphore collects up to 16 megabytes of raw log data from every job in a
pipeline, which is roughly 100,000 lines of output.

Logs longer than 16 megabytes are trimmed with the following message at the
bottom:

``` txt
Content of the log is bigger than 16MB. Log is trimmed.
```

This limit is not adjustable.

For collecting longer textual files, or output from long and verbose processes,
we recommend using a blob store like AWS S3 or Google Cloud Storage.

[execution-time-limit-reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#execution_time_limit
[yml-reference-queue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#queue
[dependency-reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#dependencies-in-blocks
