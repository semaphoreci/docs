---
description: The job priority allows you to manage the order in which the enqueued jobs are starting to run when the quota of maximum parallel jobs is reached.
---

# Prioritizing jobs

The job `priority`  allows you to manage the order in which the enqueued jobs are
starting to run when the [quota][quota-link] of maximum parallel jobs for your
organization is reached.

Each new job is assigned a priority between a `0` and a `100` and the jobs with
higher priority are run first.

These priorities are assigned automatically as it is described below, but you
can also override those default values and configure the job priorities directly
in your YAML configuration files.

## Default job priorities

The priorities are assigned to jobs automatically in the following way:

- the highest default priority of `65` is assigned to jobs in `the promotions on the master branch` since those are usually deployments
- the priority is `60` for all jobs in `the initial pipelines on the master branch`
- the priority is `55` for all jobs in `the promotions on other branches, tags or pull requests`
- the priority is `50` for all jobs in `the initial pipelines on other branches, tags or pull requests`
- the priority is `45` for all jobs in `after_pipeline` jobs
- the lowest default priority of `40` is assigned to jobs in `the workflows initiated by scheduler`

## Configure job priority

The job priority can be configured in YAML configuration file for each job
[separately][job-priority-yml-spec] or for [all the jobs][global-priority-yml-spec]
in the pipeline.

If these configurations are not present or if none of the conditions is evaluated
as true the default job priorities will be used.


[quota-link]: https://docs.semaphoreci.com/reference/quotas-and-limits/
[job-priority-yml-spec]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#priority
[global-priority-yml-spec]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#global_job_config
