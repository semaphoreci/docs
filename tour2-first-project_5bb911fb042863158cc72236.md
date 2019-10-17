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

1. [Install sem CLI][install-cli];
2. Run `sem init` in the root of your repository;
3. `git push` a new commit to run your first workflow.

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

### Troubleshooting

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

[next]: https://docs.semaphoreci.com/article/62-concepts
[install-cli]: https://docs.semaphoreci.com/article/53-sem-reference
[github-connection]: https://github.com/settings/connections/applications/328c742132e5407abd7d

### Renaming a project

If you want to rename your project, you can:

1. Choose the project whose name you want to change,
2. Go to **Settings**,
3. Change the name in the **Name of the Project** field and
4. Click on **Save Changes**.

This can also be performed from the CLI by using [`sem edit` command](https://docs.semaphoreci.com/article/53-sem-reference#sem-edit-examples).

### Deleting a project

In order to delete a project, you can:

1. Choose the project you want to delete,
2. Go to **Settings**,
3. At the bottom of the page, click on **Delete project…**,
4. Re-enter the name of the project and
5. Click on **Delete project** button.

If you prefer using CLI, you can delete a project by using [`sem delete` command](https://docs.semaphoreci.com/article/53-sem-reference#sem-delete-example).
