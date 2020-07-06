# Prioritizing jobs

At the end of the day when everyone is committing their work or in cases when there
is a sudden burst of activity like when you start to roll out deployments for
multiple services, the [quota][quota-link] of maximum parallel jobs for your
organization could easily be reached.

In these situations, it is important to know which job will be run next and to be
able to configure it if needed.

The feature that enables this is called the job `priority`.

Each new job is assigned a priority between a `0` and a `100` and the jobs with
higher priority are run first.

## Default job priorities

The priorities are assigned to jobs automatically in the following way:

- the highest default priority of `65` is assigned to jobs in `the promotions on the master branch` since those are usually deployments
- the priority is `60` for all jobs in `the initial pipelines on the master branch`
- the priority is `55` for all jobs in `the promotions on other branches, tags or pull requests`
- the priority is `50` for all jobs in `the initial pipelines on other branches, tags or pull requests`
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
