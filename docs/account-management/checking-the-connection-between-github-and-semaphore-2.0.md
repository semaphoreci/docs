# Checking the connection between GitHub and Semaphore 2.0

To check the status of the connection between Semaphore 2.0 and GitHub, please visit
the [Semaphore 2.0 application page on GitHub](https://github.com/settings/connections/applications/328c742132e5407abd7d).

This web page shows you:

- Account permissions you have granted to Semaphore 2.0
- Organizations that you are a member of, and the level of access that Semaphore
  2.0 has to these organizations.

**If the page is not showing Semaphore 2.0 application on GitHub, and you
previously logged in to Semaphore 2.0 with the GitHub account that you are
currently using, then please contact Semaphore support.**


## Grant additional permissions

When you sign up with your GitHub account, Semaphore is asking only for your
email. If you want to grant additional permissions, that is to let Semaphore
2.0 access public and/or private repositories that you have access to, please
visit:

```
https://{ORGANIZATION_NAME}.semaphoreci.com/projects/scopes/github
```

## Grant access to organization repositories

On the Semaphore 2.0 application page you can also request from a GitHub organization admin
to grant Semaphore 2.0 access to its repositories. If you are an admin, then you can do
that yourself.

## Knows issues after a connection between GitHub and Semaphore 2.0 is lost

You might see the following error message when trying to run workflows on Semaphore:

``` yaml
semaphore.yml ERROR:
Error: {"File '.semaphore/semaphore.yml' is not available", "Not Found"}
```

This means that Semaphore can't fetch `.semaphore/semaphore.yml` file from the
repository. To do that, Semaphore is using GitHub credentials of the person who added
the project to Semaphore. If this person no longer has access to the repository
on GitHub, please contact Semaphore support, with information who should be the
new owner of the project.
