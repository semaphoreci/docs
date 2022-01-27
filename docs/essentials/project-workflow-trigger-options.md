---
Description: You can choose which GitHub events trigger new workflows for your Semaphore 2.0 project by selecting one of the available triggers.
---

# Workflow Triggers

You can choose which GitHub events trigger new workflows for your Semaphore project.

In your project's settings, you can select one of the following triggers:

- Branches
- Tags
- Pull requests
- Forked pull requests

There is also an option to pause a project.

## Pausing a project

Projects can be paused. Selecting the "pause" setting for a project will result in Semaphore not creating new workflows for any trigger from GitHub.
You can, however, still restart a past workflow, run a debug session, and configure a scheduler.

## Building branches

Semaphore will create a workflow for every push to your repository.

In every job from this workflow, Semaphore will export a
`SEMAPHORE_GIT_REF_TYPE` environment variable with `branch` as a value.

## Whitelisting branches

By default, Semaphore will create a workflow for every branch. You can limit
the branches that you want to run by following these steps:

1. Go to your project and click **Settings** in the top right corner.
2. Under *Branches*, click **Run only from whitelist**.
3. Enter the names of branches you want to whitelist into the text box.
4. Click **Save changes**.

Branch names can be separated by commas. Regular expressions enclosed with `/` are also allowed,
for example: `/feature-.*/`.

**Note:** Whitelisting works only for newly-created branches, Semaphore will always create
workflows for existing branches.

## Building tags

Semaphore will create a workflow for every tag you create in a Git repository.

In every job from this workflow, Semaphore will export a
`SEMAPHORE_GIT_REF_TYPE` environment variable with `tag` as a value.

## Whitelisting tags

By default, Semaphore will create a workflow for every tag. You can limit
the tags that you want to run by following these steps:

1. Go to your project and click **Settings** in the top right corner.
2. Under *Tags*, click **Run only from whitelist**.
3. Enter tags you want to whitelist into the text box.
4. Click **Save changes**.

Tags can be separated by commas in the text box. Regular expressions enclosed
with `/` are also allowed, for example: `/^v\d+\.\d+\.\d+$/`.

## Building pull requests

When you choose this option Semaphore will create a workflow for every push to a pull request in a repo.

In every job from this workflow, Semaphore will export a
`SEMAPHORE_GIT_REF_TYPE` environment variable with `pull-request` as a value.

Semaphore uses a MERGE commit to run a workflow. The SHA of the HEAD commit
of the Pull Request is stored in the `SEMAPHORE_GIT_PR_SHA` environment variable.

## Building pull requests from forks

Semaphore will create a workflow for every push to a pull request
originating from a forked repository.

In every job from this workflow, Semaphore will export a
`SEMAPHORE_GIT_REF_TYPE` environment variable with `pull-request` as a value.

To distinguish workflows from main and forked repositories, you can compare
`SEMAPHORE_GIT_PR_SLUG` and `SEMAPHORE_GIT_REPO_SLUG` environment variables.

Semaphore uses the MERGE commit to run a workflow. The SHA of the HEAD commit
of the Pull Request is stored in `SEMAPHORE_GIT_PR_SHA` environment variable.

### Exposing secrets in forked pull requests

By default, Semaphore will not inject any secrets into jobs for pull requests from forks.
You can whitelist the secrets you want to expose specifying their names.

### Filtering contributors in forked pull requests

By default, Semaphore will allow all contributors to create workflows for pull requests
from forks. You can limit these contributors by following these steps:

1. Go to your project and click **Settings** in the top right corner.
2. In the *What to build?* section, select the **Forked pull requests** checkbox.
3. In the *How to handle fork contributors?* section, click **Run workflows only for trusted**.
4. Enter the GitHub usernames of the users you'd like to be able to create workflows for
pull requests from forks.
5. Click **Save changes**.

### Approving forked pull requests

If you are using a filter for contributors, you can still review and approve blocked
pull requests by commenting with a `/sem-approve` message.

Anyone who can run a forked pull request can also approve one.

Approving forked pull requests is limited to new comments only and is not possible for comment edits.
Due to security concerns, `/sem-approve` will work only once. Subsequent pushes to the forked
pull request must to be approved again.

## Building the default branch

When the project is not paused, Semaphore will always create new workflows
for pushes to the master branch.

In every job from this workflow, Semaphore will export a
`SEMAPHORE_GIT_REF_TYPE` environment variable with `branch` as a value.

## See also

- [Environment Variables](https://docs.semaphoreci.com/ci-cd-environment/environment-variables/)
- [Projects YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/)
