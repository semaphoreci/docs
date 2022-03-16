---
Description: Job priority allows you to manage the order in which the queued jobs run when the quota of maximum parallel jobs has been reached.
---

# Prioritizing jobs

The job `priority` property allows you to manage the order in which the queued jobs 
run when the [quota][quota-link] of maximum parallel jobs for your
organization has been reached.

Each new job is assigned a priority between `0` and `100` and the jobs with
higher priority are run first.

These priorities are assigned automatically as described below, but you
can also override the default values and configure job priorities directly
in your YAML configuration files.

## Default job priorities

Priorities are assigned to jobs automatically in the following way:

- The highest default priority -- `65` -- is assigned to jobs in `the promotions on the master branch`, as those are usually deployments.
- The default priority for all jobs in `the initial pipelines on the master branch` is `60`.
- The default priority for all jobs in `the promotions on other branches, tags or pull requests` is `55`.
- The default priority for all jobs in `the initial pipelines on other branches, tags or pull requests` is `50`.
- The default priority for all jobs in `after_pipeline` jobs is `45`.
- The lowest default priority -- `40` -- is assigned to jobs in `the workflows initiated by scheduler`.

## Configuring job priority

Job priority can be configured in the YAML configuration file for each job
[separately][job-priority-yml-spec] or for [all the jobs][global-priority-yml-spec]
in the pipeline.

If these configurations are not present or if none of the conditions are evaluated
as true, the default job priorities will be applied.


[quota-link]: https://docs.semaphoreci.com/reference/quotas-and-limits/
[job-priority-yml-spec]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#priority
[global-priority-yml-spec]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#global_job_config
