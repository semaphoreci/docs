On Semaphore, you can choose which GitHub events should trigger the workflow. In project settings, you can choose one or more triggers.

There are four triggers to choose between: *branches*, *tags*, *pull requests*, and *forked pull requests*.

There is also an option to pause a project.

- [Pause project](#pause-project)
- [Build branches](#build-branches)
- [Build tags](#build-tags)
- [Build pull requests](#build-pull-requests)
- [Build forked pull requests](#build-forked-pull-requests)
  - [Expose secrets in forked pull requests](#expose-secrets-in-forked-pull-requests)
- [Build default branch](#build-default-branch)
- [See also](#see-also)

## Pause project

Semaphore will create a workflow after any trigger from GitHub. You can still restart a Workflow, run a Debug Session and use Scheduler.

## Build branches

When you choose this option Semaphore will create a workflow for every push to the repo.

In every job from this workflow, we are injecting `SEMAPHORE_GIT_REF_TYPE` with value `branch`.

## Build tags

When you choose this option Semaphore will create a workflow for every tag you create on the repository.

In every job from this workflow, we are injecting `SEMAPHORE_GIT_REF_TYPE` with value `tag`.

## Build pull requests

When you choose this option Semaphore will create a workflow for every push to the pull request on a repo.

In every job from this workflow, we are injecting `SEMAPHORE_GIT_REF_TYPE` with value `pull-request`.

## Build forked pull requests

When you choose this option Semaphore will create a workflow for every push to the pull request that came from a forked repository.

In every job from this workflow, we are injecting `SEMAPHORE_GIT_REF_TYPE` with value `pull-request`.

To distinguish workflows from the forked repository you need to compare `SEMAPHORE_GIT_PR_SLUG` and `SEMAPHORE_GIT_REPO_SLUG`.

### Expose secrets in forked pull requests

By default Semaphore want inject any secrets to jobs from the forked pull request. You can whitelist the secrets you want to expose specifying their names.

There is no option to expose all the secrets.

## Build default branch

When the project is not on pause Semaphore will always create a workflow for pushes to master branch.

In every job from this workflow, we are injecting `SEMAPHORE_GIT_REF_TYPE` with value `branch`.

# See also

- [Environment Variables](https://docs.semaphoreci.com/article/12-environment-variables)
- [Projects YAML reference](https://docs.semaphoreci.com/article/52-projects-yaml-reference)
