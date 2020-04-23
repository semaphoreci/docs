# Workflow Triggers

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

By default, Semaphore will create a workflow for every branch. You can limit
the branches that you want to run by following these steps:

1. Go to your project and click on **Settings** in the top right corner,
2. Under *Branches*, click on **Run only from whitelist**,
3. Enter the names of branches you want to whitelist in the text box,
4. Click on **Save changes**.

Branch names can be separated by commas. Regular expressions enclosed with `/` are also allowed,
for example: `/feature-.*/`.

**Note:** Whitelisting works only for newly created branches, Semaphore will always create
workflows for existing branches.

## Build tags

Semaphore will create a workflow for every tag you create on the Git repository.

In every job from this workflow, Semaphore will export
`SEMAPHORE_GIT_REF_TYPE` environment variable with value `tag`.

## Whitelist tags

By default, Semaphore will create a workflow for every tag. You can limit
the tags that you want to run by following these steps:

1. Go to your project and click on **Settings** in the top right corner,
2. Under *Tags*, click on the **Run only from whitelist**,
3. Enter tags you want to whitelist in the text box,
4. Click on **Save changes**.

Tags can be separated by commas in the text box. Regular expressions enclosed 
with `/` are also allowed, for example: `/^v\d+\.\d+\.\d+$/`.

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

By default, Semaphore will allow all contributors to create workflows for pull requests 
from forks. You can limit these contributors by following these steps:

1. Go to your project and click on **Settings** in the top right corner,
2. In *What to build?* section click on the **Forked pull requests** checkbox,
3. In *How to handle fork contributors?* section click on **Run workflows only for trusted**,
4. Enter GitHub usernames of the users you'd like to be able to create workflows for 
pull requests from forks,
5. Click on **Save changes**.

## Build default branch

When the project is not on pause, Semaphore will always create new workflows
for pushes to master branch.

In every job from this workflow, Semaphore will export
`SEMAPHORE_GIT_REF_TYPE` with value `branch`.

## See also

- [Environment Variables](https://docs.semaphoreci.com/ci-cd-environment/environment-variables/)
- [Projects YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/)
