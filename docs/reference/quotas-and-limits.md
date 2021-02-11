---
description: Semaphore 2.0 enforces usage quotas and limits to protect customers and the platform from unforeseen spikes in usage. This page provides more information on it.
---

# Quotas and Limits

Semaphore 2.0 enforces usage quotas and limits to protect customers and the
platform from unforeseen spikes in usage. As your use of Semaphore expands over
time, your quotas may increase accordingly.

## Quotas for Maximum Parallel Running Jobs in an Organization

Every organization has a set of quotas that define the maximum number of
parallel running jobs.

Default quotas per [machine type](https://docs.semaphoreci.com/ci-cd-environment/machine-types/) for an organization in a verified **[trial](https://docs.semaphoreci.com/account-management/plans/#trial-period)** or on
a **[paid plan](https://docs.semaphoreci.com/account-management/plans/#paid-plan)**:

<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>Machine Type</td>
  <td>Default Quota</td>
</tr>
</thead>
<tbody>
<tr>
  <td>e1-standard-2</td>
  <td>50</td>
</tr>
<tr>
  <td>e1-standard-4</td>
  <td>25</td>
</tr>
<tr>
  <td>e1-standard-8</td>
  <td>10</td>
</tr>
<tr>
  <td>a1-standard-4</td>
  <td>2</td>
</tr>
</tbody>
</table>


!!! info "Verified vs Unverified Trials"
	
    **Verified trials** are the ones initiated by users with a work email address provided upon the registration
    and the above described quotas and parallelism apply. Alternatively, to verify your trial account 
    with a non-work email address, contact us at [support@semaphoreci.com](mailto:support@semaphoreci.com). 
  
    **Unverfified trials** are trials initiated by users with non-work email address provided upon the registration.
    Such trials can run a maximum of 5 parallel jobs.
  

If your organization needs are bigger than what is provided with the default
machine quotas, you can request an increase by sending a request to
<customersuccess@semaphoreci.com> (please include which type of machine you
prefer) or through the UI (Billing > See detailed insights… > Quota > Request
upgrade…).

Default quotas per [machine type](https://docs.semaphoreci.com/ci-cd-environment/machine-types/) for an organization on an **[open source plan](https://docs.semaphoreci.com/account-management/plans/#open-source-plan)**:

<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>Machine Type</td>
  <td>Default Quota</td>
</tr>
</thead>
<tbody>
<tr>
  <td>e1-standard-2</td>
  <td>4</td>
</tr>
<tr>
  <td>e1-standard-4</td>
  <td>0</td>
</tr>
<tr>
  <td>e1-standard-8</td>
  <td>0</td>
</tr>
<tr>
  <td>a1-standard-4</td>
  <td>1</td>
</tr>
</tbody>
</table>

Default quotas per [machine type](https://docs.semaphoreci.com/ci-cd-environment/machine-types/) for an organization on a **[free plan](https://docs.semaphoreci.com/account-management/plans/#free-plan)**:

<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>Machine Type</td>
  <td>Default Quota</td>
</tr>
</thead>
<tbody>
<tr>
  <td>e1-standard-2</td>
  <td>1</td>
</tr>
<tr>
  <td>e1-standard-4</td>
  <td>0</td>
</tr>
<tr>
  <td>e1-standard-8</td>
  <td>0</td>
</tr>
<tr>
  <td>a1-standard-4</td>
  <td>1</td>
</tr>
</tbody>
</table>

## Pipeline and Block Execution Time Limit

By default, every pipeline and block is limited to an hour of execution time.
This mechanism protects your project from undesired expenses in case of jobs
that are running longer than anticipated. A good example is an accidentally
committed debug statement that is waiting for user input.

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

For detailed explanation, see the [execution time limit section in the
Pipeline YAML reference][execution-time-limit-reference].

The maximum value of the `execution_time_limit` is 24 hours.

## Limit on the number of pipelines in the queue

Each pipeline is assigned to execution queue before running any jobs to prevent
parallel execution of consecutive pushes or deployment promotions.

By default, separate queues are created for each branch, tag or pull request and
YAML configuration file combination. You can also define your own queues via
[queue property][yml-reference-queue] in pipeline's YAML configuration.

Semaphore imposes a limit on queue size of **30 active pipelines** at any moment
to prevent system abuse and performance degradation.

This limit is not adjustable.

If you have a use case where this limit is too constraining, please contact us
on <support@semaphoreci.com> so we can work on the solution to that problem.

## Limit on the number of blocks in the pipeline

Semaphore imposes a limit on the number of blocks defined in one pipeline and
that limit is  **100 blocks per pipeline**.

This limit is not adjustable.

If you have a use case where this limit is too constraining, please contact us
on <support@semaphoreci.com> so we can work on the solution to that problem.

## Limit on the number of jobs in the block

Semaphore imposes a limit on the  number of jobs defined in one block and that
limit is  **50 jobs per block** .

This limit is not adjustable.

If you need more jobs to be executed in parallel, you can split them into
multiple blocks that are run in parallel. This can be achieved by configuring
the [dependency][dependency-reference] property of the blocks.

## Job Log Size Limit

Semaphore collects up to 16 megabytes of raw log data from every job in a
pipeline, which in practice roughly equals 100,000 lines of output.

Logs longer than 16 megabytes are trimmed with the following message on the
bottom:

``` txt
Content of the log is bigger than 16MB. Log is trimmed.
```

This limit is not adjustable.

For collecting longer textual files, or output from long and verbose process,
we recommend using a blob store like AWS S3 or Google Cloud Storage.

[execution-time-limit-reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#execution_time_limit
[yml-reference-queue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#queue
[dependency-reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#dependencies-in-blocks
