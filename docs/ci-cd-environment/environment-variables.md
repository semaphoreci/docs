---
Description: Environment variables used in Semaphore projects can be pre-defined, git repository-related, cache-related, or private docker registry-related.
---

# Environment Variables

This document describes the environment variables used in Semaphore
projects.

Although some of the presented environment variables can be defined on a per-project or on a per-task basis, all the presented environment variables can be viewed on a per-job basis.

If you're looking to set custom environment variables yourself, refer to [this
guide instead][setting-env-vars].

## Pre-defined environment variables

Semaphore defines and uses its own environment variables.

### Semaphore-related

This group of environment variables includes the environment variables that
are related to Semaphore and hold information that is specific to Semaphore
2.0.

#### CI

The value of the `CI` environment variable specifies whether we are in a
Continuous Integration environment or not. The type of the `CI` variable is
boolean.

Example value: `true`

#### SEMAPHORE

The value of the `SEMAPHORE` environment variable says whether the job is
executed in the Semaphore environment or not and is a boolean variable.

Example value: `true`

#### SEMAPHORE\_PROJECT\_NAME

The value of the `SEMAPHORE_PROJECT_NAME` environment variable holds the name
of the project that a job belongs to.

Example value: `Documentation Project`

#### SEMAPHORE\_PROJECT\_ID

The value of the `SEMAPHORE_PROJECT_ID` environment variable holds the project
ID of the project that a job belongs to.

Example value: `0dd982e8-32f5-4037-983e-4de01ac7fb1e`

#### SEMAPHORE\_ORGANIZATION\_URL

The value of the `SEMAPHORE_ORGANIZATION_URL` environment variable holds the url
of the organization that owns a given project on Semaphore.

Example value: `https://example.semaphoreci.com`

#### SEMAPHORE\_JOB\_NAME

The value of the `SEMAPHORE_JOB_NAME` environment variable is a string that
holds the name of the job.

Example value: `Push image to Docker`

#### SEMAPHORE\_JOB\_ID

The `SEMAPHORE_JOB_ID` environment variable holds the Job ID of the job that is
being executed. It is the same value that is displayed in the output of the
`sem get jobs` or the `sem get jobs --all` commands and is assigned by
Semaphore.

Example value: `a26d42cf-89ac-4c3f-9e2d-51bb231897bf`

#### SEMAPHORE\_JOB\_CREATION_TIME

The `SEMAPHORE_JOB_CREATION_TIME` environment variable holds the UNIX epoch seconds for when the job was created.

Example value: `1632943641`.

#### SEMAPHORE\_JOB\_RESULT

The value of the `SEMAPHORE_JOB_RESULT` environment variable holds the result
of a job. The list of values includes `none`, `passed`, `failed`, and `stopped`.

Example value: `passed`

#### SEMAPHORE\_WORKFLOW\_ID

The value of the `SEMAPHORE_WORKFLOW_ID` environment variable is the workflow
ID that is used during the execution of an active job.

The `SEMAPHORE_WORKFLOW_ID` environment variable remains the same during
a pipeline run and is available in all the blocks of a pipeline as well as in
all promoted and auto-promoted pipelines.

#### SEMAPHORE\_WORKFLOW\_NUMBER

The value of the `SEMAPHORE_WORKFLOW_NUMBER` environment variable represents the
current count of workflows in each distinct branch, tag, or pull request.
The first workflow in each gets `1` for the value of
`SEMAPHORE_WORKFLOW_NUMBER`; each time a push or workflow is rerun, this
value is increased by one.

The `SEMAPHORE_WORKFLOW_NUMBER` environment variable remains the same during
a pipeline run and is available in all the blocks of a pipeline as well as in
all promoted and auto-promoted pipelines belonging to the same workflow.

Example value: `42`

#### SEMAPHORE\_WORKFLOW\_RERUN

The value of the `SEMAPHORE_WORKFLOW_RERUN` environment variable is `true` if
the workflow is a rerun of a previously-created workflow, otherwise it is `false`.

The `SEMAPHORE_WORKFLOW_RERUN` environment variable remains the same during
a pipeline run and is available in all the blocks of a pipeline as well as in
all promoted and auto-promoted pipelines of the same workflow.

Example value: `false`

#### SEMAPHORE\_WORKFLOW\_TRIGGERED\_BY\_HOOK

The value of the `SEMAPHORE_WORKFLOW_TRIGGERED_BY_HOOK` environment variable is
`true` if the workflow run was triggered via a hook from the git repository.

It has a `false` value in workflows which were triggered via the
[cron scheduler][scheduler] feature or through Semaphore's API.

The `SEMAPHORE_WORKFLOW_TRIGGERED_BY_HOOK` environment variable remains the same
during a pipeline run and is available in all the blocks of a pipeline as well
as in all promoted and auto-promoted pipelines of the same workflow.

Example value: `true`

#### SEMAPHORE\_WORKFLOW\_TRIGGERED\_BY\_SCHEDULE

The value of the `SEMAPHORE_WORKFLOW_TRIGGERED_BY_SCHEDULE` environment variable
is `true` if the workflow run was triggered via the [cron scheduler][scheduler] feature.

It has a `false` value in workflows which were triggered via a hook from the git
repository or through Semaphore's API.

The `SEMAPHORE_WORKFLOW_TRIGGERED_BY_SCHEDULE` environment variable remains the same
during a pipeline run and is available in all the blocks of a pipeline as well
as in all promoted and auto-promoted pipelines in the same workflow.

Example value: `false`

#### SEMAPHORE\_WORKFLOW\_TRIGGERED\_BY\_MANUAL\_RUN

The value of the `SEMAPHORE_WORKFLOW_TRIGGERED_BY_MANUAL_RUN` environment variable
is `true` if the workflow run was triggered manually by user from Semaphore UI (for instance by running Task manually).

It has a `false` value in workflows which were triggered via a hook from the git
repository, API, or via [scheduled Task][tasks] feature.

The `SEMAPHORE_WORKFLOW_TRIGGERED_BY_MANUAL_RUN` environment variable remains the same
during a pipeline run and is available in all the blocks of a pipeline as well
as in all promoted and auto-promoted pipelines in the same workflow.

Example value: `false`


#### SEMAPHORE\_WORKFLOW\_TRIGGERED\_BY\_API

The value of the `SEMAPHORE_WORKFLOW_TRIGGERED_BY_API` environment variable
is `true` if the workflow run was triggered through Semaphore's API.

It has a `false` value in workflows which were triggered via a hook from the git
repository or via the [cron scheduler][scheduler] feature.

The `SEMAPHORE_WORKFLOW_TRIGGERED_BY_API` environment variable remains the same
during a pipeline run and is available in all the blocks of a pipeline as well
as in all promoted and auto-promoted pipelines in the same workflow.

Example value: `false`
_
#### SEMAPHORE\_WORKFLOW\_TRIGGERED\_BY

The value of the `SEMAPHORE_WORKFLOW_TRIGGERED_BY` environment variable is 
the GitHub/Bitbucket username of the person that initiated the workflow.

Example value: `torvalds`

#### SEMAPHORE\_PIPELINE\_ID

The value of the `SEMAPHORE_PIPELINE_ID` environment variable is the pipeline
ID that is used for the execution of the active job.

The `SEMAPHORE_PIPELINE_ID` environment variable remains the same throughout
all the blocks of a pipeline, which makes it the perfect candidate for sharing
data inside a pipeline.

Example value: `ea3e6bba-d19a-45d7-86a0-e78a2301b616`

#### SEMAPHORE\_PIPELINE\_PROMOTION

The value of the `SEMAPHORE_PIPELINE_PROMOTION` environment variable is `true`
if the pipeline was started by a promotion belonging to another pipeline.

It has a `false` value only in the initial pipeline that was created when
the workflow was created.

The `SEMAPHORE_PIPELINE_PROMOTION` environment variable remains the same
throughout all the blocks of a pipeline.

Example value: `false`

#### SEMAPHORE\_PIPELINE\_PROMOTED\_BY

The value of the `SEMAPHORE_PIPELINE_PROMOTED_BY` environment variable is `auto-promotion`,
if the pipeline is auto-promoted.

If the pipeline is manually-promoted, the value is the GitHub/Bitbucket username
of the person that promoted the pipeline.

However, if it is an initial pipeline, the value of the environment variable is an empty string.

Example value: `auto-promotion`

#### SEMAPHORE\_PIPELINE\_RERUN

The value of the `SEMAPHORE_PIPELINE_RERUN` environment variable is `true` if
the pipeline is a rerun of a failed pipeline, otherwise it is `false`.

*Note*: Pipeline reruns are in the alpha phase of development and only available
through CLI.

The `SEMAPHORE_PIPELINE_RERUN` environment variable remains the same throughout
all the blocks of a pipeline.

Example value: `false`

#### SEMAPHORE\_AGENT\_MACHINE\_TYPE

The value of the `SEMAPHORE_AGENT_MACHINE_TYPE` environment variable specifies
the type of agent used in the job that is being executed.

Example value: `e1-standard-4`

#### SEMAPHORE\_AGENT\_MACHINE\_OS\_IMAGE

The value of the `SEMAPHORE_AGENT_MACHINE_OS_IMAGE` environment variable represents
the operating system image that is being used.

Example value: `ubuntu1804`

#### SEMAPHORE\_AGENT\_MACHINE\_ENVIRONMENT\_TYPE

The value of the `SEMAPHORE_AGENT_MACHINE_ENVIRONMENT_TYPE` environment variable
specifies the type of environment in which the job is being executed:
inside a `container` or a `VM`.

Example value: `container`

### Git repository related

This group of environment variables includes environment variables that are
used by Semaphore, which are related to Git and the Git repository used in the current Semaphore project.

#### SEMAPHORE\_GIT\_PROVIDER

The value of the `SEMAPHORE_GIT_PROVIDER` environment variable holds the information of which git provider is repository hosted on.

Example values: `bitbucket`, `github`

#### SEMAPHORE\_GIT\_SHA

The value of the `SEMAPHORE_GIT_SHA` environment variable holds the current
revision of code that the pipeline is using.

Example values: `5c84719708b9b649b9ef3b56af214f38cee6acde`, `HEAD`

#### SEMAPHORE\_GIT\_URL

The value of the `SEMAPHORE_GIT_URL` environment variable is the URL of the
 repository used in the current Semaphore project.

Example value: `http://git@github.com:semaphoreci/toolbox.git`

#### SEMAPHORE\_GIT\_BRANCH

The value of the `SEMAPHORE_GIT_BRANCH` environment variable is the name of
the git branch used in the current job.

In builds triggered by a Pull Request, the value of the `SEMAPHORE_GIT_BRANCH`
is the name of the git branch targeted by the Pull Request.

Example value: `development`

#### SEMAPHORE\_GIT\_WORKING\_BRANCH

The value of the `SEMAPHORE_GIT_WORKING_BRANCH` environment variable is the name of
the repository branch used in the current job.

In builds triggered by a Pull Request, the value of the `SEMAPHORE_GIT_WORKING_BRANCH`
is the name of the head repository branch.

In builds triggered by a Tag, the variable is missing.

Example value: `development`

#### SEMAPHORE\_GIT\_DIR

The value of the `SEMAPHORE_GIT_DIR` environment variable is the name of the
directory that contains the files of the repository linked to the current
Semaphore project.

Example value: `foo`

#### SEMAPHORE\_GIT\_REPO\_SLUG

The value of the `SEMAPHORE_GIT_REPO_SLUG` environment variable is the
name (owner_name/repo_name) of the repository of the current
Semaphore project.

Example value: `semaphoreci/docs`

#### SEMAPHORE\_GIT\_REF\_TYPE

The value of the `SEMAPHORE_GIT_REF_TYPE` environment variable indicates
the git reference type.

Example value: `branch`, `tag`, or `pull-request`

#### SEMAPHORE\_GIT\_REF

The value of the `SEMAPHORE_GIT_REF` environment variable holds the name of
git reference to the commit that the pipeline is using.

Example value: `refs/heads/master`

#### SEMAPHORE\_GIT\_COMMIT\_RANGE

The value of the `SEMAPHORE_GIT_COMMIT_RANGE` environment variable holds
the range of commits that were included in a push or pull request.

This is empty for builds triggered by the initial commit of a new branch or tag.

Example value: `5c84719708b9b649b9ef3b56af214f38cee6acde...92d87d5c0dd2dbb7a68ecb27df43d1b164fd3e30`

#### SEMAPHORE\_GIT\_TAG\_NAME

The value of the `SEMAPHORE_GIT_TAG_NAME` environment variable is the name of
the git tag used in the current job.

Example value: `v1.0.0`

#### SEMAPHORE\_GIT\_PR\_BRANCH

The value of the `SEMAPHORE_GIT_PR_BRANCH` environment variable is the name of
the git branch from which the Pull Request originated.

#### SEMAPHORE\_GIT\_PR\_SLUG

The value of the `SEMAPHORE_GIT_PR_SLUG` environment variable is the
name (owner_name/repo_name) of the repository from which
the Pull Request originated.

Example value: `renderedtext/docs`

#### SEMAPHORE\_GIT\_PR\_SHA

The value of the `SEMAPHORE_GIT_PR_SHA` environment variable holds the
commit SHA of the HEAD commit of the Pull Request.

Example values: `5c84719708b9b649b9ef3b56af214f38cee6acd3`

#### SEMAPHORE\_GIT\_PR\_NUMBER

The value of the `SEMAPHORE_GIT_PR_NUMBER` environment variable holds the
number of the Pull Request.

Example values: `1`

#### SEMAPHORE\_GIT\_PR\_NAME

The value of the `SEMAPHORE_GIT_PR_NAME` environment variable holds the
name of the Pull Request.

Example values: `Update Readme.md`

#### SEMAPHORE\_GIT\_COMMITTER

The value of the `SEMAPHORE_GIT_COMMITTER` environment variable holds the
GitHub/Bitbucket username of the person that committed the revision.

Example values: `torvalds`

#### SEMAPHORE\_GIT\_COMMIT\_AUTHOR

The value of the `SEMAPHORE_GIT_COMMIT_AUTHOR` environment variable holds the
GitHub/Bitbucket username of the person that authored the revision.

Example values: `torvalds`

### Environment Variables injected into after_pipeline jobs

The following environment variables are injected only in
[after pipeline jobs][after-pipeline-ref]{target="_blank"}.

#### SEMAPHORE\_PIPELINE\_RESULT

The value of `SEMAPHORE_PIPELINE_RESULT` contains the result of the pipeline.

Values: `failed`, `passed`, `canceled`, and `stopped`.

#### SEMAPHORE\_PIPELINE\_RESULT\_REASON

The value of `SEMAPHORE_PIPELINE_RESULT_REASON` contains the reason for
the pipeline result.

Values: `test`, `malformed`, `stuck`, `internal`, `user`, `strategy`, and `timeout`.

#### SEMAPHORE\_PIPELINE\_TOTAL\_DURATION

The value of `SEMAPHORE_PIPELINE_TOTAL_DURATION` contains the duration of
the pipeline including queuing time.

The value is expressed in seconds. 

Example value: `10`.

#### SEMAPHORE\_PIPELINE\_INIT\_DURATION

The value of `SEMAPHORE_PIPELINE_INIT_DURATION` contains the duration of pipeline initialization.

The value is expressed in seconds. 

Example value: `1`.

#### SEMAPHORE\_PIPELINE\_QUEUEING\_DURATION

The value of `SEMAPHORE_PIPELINE_QUEUEING_DURATION` contains the time that
the pipeline spent in the queue.

The value is expressed in seconds. 

Example value: `1`.

#### SEMAPHORE\_PIPELINE\_RUNNING\_DURATION

The value of `SEMAPHORE_PIPELINE_RUNNING_DURATION` contains the pipeline
execution time while jobs were running.

The value is expressed in seconds. 

Example value: `12`.

#### SEMAPHORE\_PIPELINE\_CREATED\_AT

The value of `SEMAPHORE_PIPELINE_CREATED_AT` is the UNIX epoch timestamp when
the pipeline was created.

Example value: `1632943641`.

#### SEMAPHORE\_PIPELINE\_STARTED\_AT

The value of `SEMAPHORE_PIPELINE_STARTED_AT` is the UNIX epoch timestamp when
the pipeline started running jobs.

Example value: `1632943642`.

#### SEMAPHORE\_PIPELINE\_DONE\_AT

The value of `SEMAPHORE_PIPELINE_DONE_AT` is the UNIX epoch timestamp when
when the pipeline was finished.

Example value: `1632943650`.

### Cache related

The following environment variables are related to the `cache` utility. You can
find more information about the `cache` utility in the
[Toolbox reference documentation](https://docs.semaphoreci.com/reference/toolbox-reference/).

#### SEMAPHORE\_CACHE\_USERNAME

The value of the `SEMAPHORE_CACHE_USERNAME` environment variable is the
username used for connecting to the cache server.

Example value: `0614ef08af7a408d8aae45b029ba3bb8`

#### SEMAPHORE\_CACHE\_URL

The value of the `SEMAPHORE_CACHE_URL` environment variable is the IP address
and the port number of the cache server.

Example value: `94.130.158.146:29920`

#### SEMAPHORE\_CACHE\_PRIVATE\_KEY\_PATH

The value of the `SEMAPHORE_CACHE_PRIVATE_KEY_PATH` environment variable is the
path to the file that contains the SSH key to the cache server.

Example value: `/home/semaphore/.ssh/semaphore_cache_key`

### Private Docker Registry-related variables

Private Docker registry is a beta feature that is available on a request.

This feature adds the following environment variables to every job of a given project:

- `SEMAPHORE_REGISTRY_USERNAME` - Semaphore private Docker Registry username
- `SEMAPHORE_REGISTRY_PASSWORD` - Semaphore private Docker Registry password
- `SEMAPHORE_REGISTRY_URL` - Semaphore private Docker Registry url

## See Also

- [Pipeline YAML Reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)


[scheduler]: ../essentials/schedule-a-workflow-run.md
[setting-env-vars]: ../essentials/environment-variables.md
[after-pipeline-ref]: /reference/pipeline-yaml-reference/#after_pipeline
