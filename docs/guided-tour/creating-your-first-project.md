# Creating Your First Project

To build, test and deploy your code on Semaphore, you'll need to
create a project for it to live in.

## Creating a project in the web interface

Once you're inside an organization that you've created or were invited to,
you're ready to create a CI/CD project.

Follow the `Projects > Create new project (+ sign)` link in the sidebar of Semaphore web interface.
You'll go through a simple two-step process:

1. Find the wanted repository and click on `Add Repository`;
2. In the Workflow Builder, edit your Semaphore pipeline and commit it to start your first workflow.

<iframe width="560" height="315" src="https://www.youtube.com/embed/5u3NDj0xBm0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

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

Here are some useful tips on what to do if you find yourself in one of the
situations described below.

### "Fetching repositories..." message showing continuously

In the situation where Semaphore is showing "Fetching repositories..." message
longer than expected, please do the following:

1. Check if you have an Admin permission level for the repository on GitHub.
2. Check if the access has been granted for Semaphore 2.0 within your GitHub 
organization. You can use [this link](https://github.com/settings/connections/applications/328c742132e5407abd7d) for that. There should be a green checkmark next to the name of your organization.
3. If the access hasn't been granted, you can request the GitHub organization owner 
to give access to Semaphore. [Here](https://help.github.com/en/github/setting-up-and-managing-your-github-user-account/requesting-organization-approval-for-oauth-apps) you can find how.

If all of the above mentioned is met and you are still experiencing issues,
please reach out to [support@semaphoreci.com](mailto:support@semaphoreci.com).

### Running `sem init` returns an error


If you see one of the following error messages while running `sem init`:

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
2. Go to **Settings**,
3. Change the name in the **Name of the Project** field and
4. Click on **Save Changes**.

This can also be performed from the CLI by using [`sem edit` command](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-edit-examples).

## Transferring project ownership

If you need to transfer ownership of any project in your organization,
please reach out to [support@semaphoreci.com](mailto:support@semaphoreci.com). In this email please include 
the name of the project and the GitHub username of the new owner.

**Note:** After the project ownership transfer, you need to push a new commit. 
Rerunning old builds will no longer work if the ownership of a project is changed.

## Deleting a project

In order to delete a project, you can:

1. Choose the project you want to delete,
2. Go to **Settings**,
3. At the bottom of the page, click on **Delete project…**,
4. Re-enter the name of the project and
5. Click on **Delete project** button.

If you prefer using CLI, you can delete a project by using [`sem delete` command](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-delete-example).
