---
description: To build, test and deploy your code on Semaphore 2.0, you'll need to create a project for it to live in. This guide will show you how to do that.
---

# Creating Your First Project

To build, test and deploy your code on Semaphore, you'll need to
create a project for it to live in.

## Creating a project in the web interface

Once you're inside an organization that you've created or were invited to,
you're ready to create a CI/CD project.

Click on the **+ Create new** button in the application header (next to the **Projects** button) and you will be able to choose between 2 options:

### Option 1 - Start a real project 

If you'd like to hook up your GitHub repository with Semaphore and start a real project, follow the steps described below:

1. Click on **Choose Repository**,
2. Add people to the project,
3. Choose a starter workflow - you can use one of the templates or customize it on 
your own.

### Option 2 - Fork & Run

If you'd like to try a quick experiment, Fork & Run will copy a working example to your GitHub, connect Semaphore, and trigger the first build. All you need to do is click on the **Fork and Run** button next to the programming language of your choice.

You are all set!

## Alternative: creating a project from command line

You can also create and manage projects using the Semaphore Command Line
Interface (CLI):

1. Visit `https://your-organization.semaphoreci.com/projects/scopes/github` and
authorize Semaphore to access your public and/or private GitHub repositories.
2. [Install sem CLI][install-cli] and connect it to your organization.
3. Run `sem init` in the root of your repository.
4. `git push` a new commit to run your first workflow.

`sem init` creates a deploy key and webhook on GitHub, so
that Semaphore can access your code as it changes. It also creates a pipeline
definition file `.semaphore/semaphore.yml` in the repository on your computer.
In case that file already exists, sem will not overwrite it.

After you commit `.semaphore/semaphore.yml` and run `git push`, you should see
the pipeline running in your browser. You can also see all running jobs in your
terminal via `sem get jobs`.

## Moving on

Congratulations! You've successfully created your first project,
and initialized it with a working pipeline.
Take some time to explore the Semaphore web interface, and compare what you
see with the generated YAML file.

[Let's move on to an overview of key Semaphore concepts][next] to learn what
each part means.

## Troubleshooting

In case running `sem init` throws an error:

``` txt
error: http status 422 with message
"{"message":"POST https://api.github.com/repos/orgname/projectname/keys: 404 - Not Found // See:
https://developer.github.com/v3/repos/keys/#add-a-new-deploy-key";}"
received from upstream
```

or

``` txt
"{"message":"admin permisssions are required on the repository in order to add the project to Semaphore"}"
```

or

``` txt
error: http status 422 with message "{"message":"Repository 'orgname/projectname' not found"}"
received from upstream
```

You can do the following:

- Check if the user who wants to add a project to Semaphore is a member of the
  given Semaphore organization, and has Admin-level permissions for the
  repository on GitHub.
- Check if the access for Semaphore 2.0 was granted within your GitHub
  organization. You can do that [here][github-connection].
- Request the GitHub organization owner to give access to Semaphore. [Here](https://help.github.com/en/articles/requesting-organization-approval-for-oauth-apps) you can find how.

[next]: https://docs.semaphoreci.com/guided-tour/concepts/
[install-cli]: https://docs.semaphoreci.com/reference/sem-command-line-tool/
[github-connection]: https://github.com/settings/connections/applications/328c742132e5407abd7d

## Renaming a project

If you want to rename your project, you can:

1. Choose the project whose name you want to change,
2. Go to **Settings** in the top right corner of the page,
3. Change the name in the **Name and Description** section and
4. Click on **Save Changes**.

This can also be performed from the CLI by using [`sem edit` command](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-edit-examples).

## Transferring project ownership

In order to transfer the project ownership to a different user, the following 
conditions need to be met:

1. New project owner needs to have Admin permission level for the repository on GitHub,
2. If you plan to build private projects, the new owner needs to grant access 
for Semaphore to all repositories. They can do that that under [Personal Settings -> GitHub repository access](https://me.semaphoreci.com/account).
3. If you plan to build only public projects, the new owner needs to grant access for 
Semaphore to public repositories. They can do that that under [Personal Settings -> GitHub repository access](https://me.semaphoreci.com/account). 

After that, please reach out to [support@semaphoreci.com](mailto:support@semaphoreci.com)
and include the name of the project and the GitHub username of the new owner in your message.

**Note:** After the project ownership is transferred, you need to push a new commit. 
Rerunning old builds will no longer work if the ownership of the project is changed.

## Deleting a project

In order to delete a project, you can:

1. Choose the project you want to delete,
2. Go to **Settings** in the top right corner of the page,
3. At the bottom of the page, click on the link in the **Delete project** section,
4. Leave your feedback,
5. Enter project name for final confirmation and
5. Click on **Delete project** button.

**Please note that this action cannot be reversed.**

If you prefer using CLI, you can delete a project by using [`sem delete` command](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-delete-example).
