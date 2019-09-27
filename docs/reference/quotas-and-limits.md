# Quotas and Limits

Semaphore 2.0 enforces usage quotas and limits to protect customers and the
platform from unforeseen spikes in usage. As your use of Semaphore expands over
time, your quotas may increase accordingly.

- [Quotas for Maximum Parallel Running Jobs in an Organization](#quotas-for-maximum-parallel-running-jobs-in-an-organization)
- [Pipeline and Block Execution Time Limit](#pipeline-execution-time-limit)
- [Job Log Size Limit](#job-log-size-limit)

## Quotas for Maximum Parallel Running Jobs in an Organization

Every organization has a set of quotas that define the maximum number of
parallel running jobs.

Default quotas per machine type for an organization on a [**free plan**](https://docs.semaphoreci.com/article/104-billing#plans):

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
  <td>0</td>
</tr>
</tbody>
</table>

Default quotas per machine type for an organization in a [**trial**](https://docs.semaphoreci.com/article/104-billing#trial-period) or on 
a [**paid plan**](https://docs.semaphoreci.com/article/104-billing#plans):

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
  <td>8</td>
</tr>
<tr>
  <td>e1-standard-4</td>
  <td>4</td>
</tr>
<tr>
  <td>e1-standard-8</td>
  <td>1</td>
</tr>
<tr>
  <td>a1-standard-4</td>
  <td>2</td>
</tr>
</tbody>
</table>

If your organization needs are bigger than what is provided with the default
machine quotas, you can request an increase by sending a request to
<customersuccess@semaphoreci.com> (please include which type of machine you 
prefer) or through the UI (Billing > See detailed insights… > Quota > Request 
upgrade…).

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

[execution-time-limit-reference]: https://docs.semaphoreci.com/article/50-pipeline-yaml#execution_time_limit
