# Project workflow trigger options

You can choose which GitHub events should trigger new workflows for your Semaphore project.

In project settings, you can select one of the following triggers:

- Branches
- Tags
- Pull requests
- Forked pull requests

There is also an option to pause a project.

## Pause project

Semaphore will not create new workflows on any trigger from GitHub.
You can still restart a past workflow, run a debug session and configure a scheduler.

## Build branches

Semaphore will create a workflow for every push to your repository.

In every job from this workflow, Semaphore will export
`SEMAPHORE_GIT_REF_TYPE` environment variable with value `branch`.

## Whitelist branches

By default, Semaphore will create a workflow for every branch. You can whitelist
the branches that you want to run by specifying their names separated by commas.
Regular expressions enclosed with `/` are also allowed,
for example: `/feature-.*/`.

Whitelisting works only for newly created branches, Semaphore will always create
workflows for existing branches.

## Build tags

Semaphore will create a workflow for every tag you create on the Git repository.

In every job from this workflow, Semaphore will export
`SEMAPHORE_GIT_REF_TYPE` environment variable with value `tag`.

## Whitelist tags

By default, Semaphore will create a workflow for every tag. You can whitelist
the tags that you want to run by specifying their names separated by commas.
Regular expressions enclosed with `/` are also allowed,
for example: `/^v\d+\.\d+\.\d+$/`.

## Build pull requests

When you choose this option Semaphore will create a workflow for every push to the pull request on a repo.

In every job from this workflow, Semaphore will export
`SEMAPHORE_GIT_REF_TYPE` environment variable with value `pull-request`.

Semaphore uses the MERGE commit to run a workflow. The SHA of the HEAD commit
of the Pull Request is stored in `SEMAPHORE_GIT_PR_SHA` environment variable.

## Build pull requests from forks

Semaphore will create a workflow for every push to a pull request
originating from a forked repository.

In every job from this workflow, Semaphore will export
`SEMAPHORE_GIT_REF_TYPE` environment variable with value `pull-request`.

To distinguish workflows from main and forked repositories, you can compare
`SEMAPHORE_GIT_PR_SLUG` and `SEMAPHORE_GIT_REPO_SLUG` environment variables.

Semaphore uses the MERGE commit to run a workflow. The SHA of the HEAD commit
of the Pull Request is stored in `SEMAPHORE_GIT_PR_SHA` environment variable.

### Expose secrets in forked pull requests

By default, Semaphore will not inject any secrets into jobs for pull requests from forks.
You can whitelist the secrets you want to expose specifying their names.

### Filter contributors in forked pull requests

By default, Semaphore will allow all contributors to create workflows for pull requests from forks.
You can filter the contributors you want to allow to do run workflows specifying their GitHub logins.

## Build default branch

When the project is not on pause, Semaphore will always create new workflows
for pushes to master branch.

In every job from this workflow, Semaphore will export
`SEMAPHORE_GIT_REF_TYPE` with value `branch`.

## See also

- [Environment Variables](https://docs.semaphoreci.com/article/12-environment-variables)
- [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
