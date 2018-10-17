* [Overview](#overview)
* [Defining variables in pipeline files](#defining-variables-in-pipeline-files)
* [Defining variables in secrets](#defining-variables-in-secrets)
* [Predefined environment variables](#predefined-environment-variables)
   * [Semaphore related](#semaphore-related)
   * [Git repository related](#git-repository-related)
* [See also](#see-also)
   
## Overview

This document describes the environment variables used in Semaphore 2.0
projects.

Although some of the presented environment variables are defined on a per
project or on a per task basis, all the presented environment variables can be
seen on a per job basis.

## Defining variables in pipeline files

You can define your own environment variables in a pipeline file.

## Defining variables in secrets

All the environment variables that are defined in the `secrets` that are used
in the current `task` as exported as regular environment variables.

## Predefined environment variables

Semaphore defines and uses its own environment variables.

### Semaphore related

This group of environment variables includes the environment variables that
are related to Semaphore 2.0 and hold information that is specific to Semaphore
2.0.

#### CI

The value of the `CI` environment variable

Example value:

#### SEMAPHORE

The value of the `SEMAPHORE` environment variable

Example value:

#### SEMAPHORE\_PROJECT\_NAME

The value of the `SEMAPHORE_PROJECT_NAME` environment variable holds the name
of the project a job belongs to.

Example value:

#### SEMAPHORE\_PROJECT\_ID

The value of the `SEMAPHORE_PROJECT_ID` environment variable holds the project
ID of the project that a job belongs to.

Example value: `0dd982e8-32f5-4037-983e-4de01ac7fb1e`

#### SEMAPHORE\_JOB\_NAME

The value of the `SEMAPHORE_JOB_NAME` environment variable is a string that
holds the name of the job.

Example value: `Push image to Docker`

#### SEMAPHORE\_JOB\_ID

The `SEMAPHORE_JOB_ID` environment variable holds the Job ID of the job that is
being executed. It is the same value as is displayed in the output of the
`sem get jobs` or the `sem get jobs --all` commands and is assigned by
Semaphore 2.0.

Example value: `a26d42cf-89ac-4c3f-9e2d-51bb231897bf`

#### SEMAPHORE\_JOB\_RESULT

The value of the `SEMAPHORE_JOB_RESULT` environment variable holds the result
of a job. The list of values includes `none`, `passed`, `failed` and `stopped`.

Example value: `passed`

#### SEMAPHORE\_PIPELINE\_ID

The value of the `SEMAPHORE_PIPELINE_ID` environment variable is the pipeline
ID that is used for the active execution of a job.

Example value: `ea3e6bba-d19a-45d7-86a0-e78a2301b616`

### Git repository related

This group of environment variables includes environment variables that are
used by Semaphore 2.0 and are related to GitHub and the GitHub repository that
is used in the current Semaphore 2.0 project.

#### SEMAPHORE\_GIT\_SHA

The value of the `SEMAPHORE_GIT_SHA` environment variable

Example value: `5c84719708b9b649b9ef3b56af214f38cee6acde`

#### SEMAPHORE\_GIT\_URL

The value of the `SEMAPHORE_GIT_URL` environment variable is the URL of the
GitHub repository used in the current Semaphore 2.0 project.

Example value: `http://git@github.com:semaphoreci/toolbox.git`

#### SEMAPHORE\_GIT\_REPO_SLUG

The value of the `SEMAPHORE_GIT_REPO_SLUG` environment variable

Example value: `semaphoreci/toolbox`

#### SEMAPHORE\_GIT\_BRANCH

The value of the `SEMAPHORE_GIT_BRANCH` environment variable

Example value: `development`

#### SEMAPHORE\_GIT\_PR\_NUMBER

The value of the `SEMAPHORE_GIT_PR_NUMBER` environment variable

Example value: `1228`

#### SEMAPHORE\_GIT\_REPO_NAME

The value of the `SEMAPHORE_GIT_REPO_NAME` environment variable

Example value: `toolbox`

#### SEMAPHORE\_GIT\_DIR

The value of the `SEMAPHORE_GIT_DIR` environment variable

Example value: `/home/semaphore/foo`

## See Also

* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
