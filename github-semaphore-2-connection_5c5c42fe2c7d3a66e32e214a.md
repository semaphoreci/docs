To check the status of a connection between Semaphore 2.0 and GitHub please visit
[this](https://github.com/settings/connections/applications/328c742132e5407abd7d) web page.

**If the page is not showing Semaphore 2.0 application on GitHub, and you previously
login to Semaphore 2.0 with this GitHub account, please contact our support.**

This web page shows permissions you have granted to Semaphore 2.0, as well as the
organizations you are a member of and the access level that Semaphore 2.0 has
to these organizations.

## Grant additional permissions

During the registration, we are asking only for your email. If you want to grant
additional permissions for Semaphore 2.0 to access public and/or private
repositories that you have access to, please visit:

```
https://{ORGANIZATION_NAME}.semaphoreci.com/projects/scopes/github
```

## Grant access to organization repositories

On application page you can also request an organization admin on GitHub to grant
access for Semaphore 2.0 for repositories from his organization.

## Knows issues after a connection between GitHub and Semaphore 2.0 is lost

You might see the following error message when trying to execute a Semaphore 2.0
project:

``` yaml
semaphore.yml ERROR:
Error: {"File '.semaphore/semaphore.yml' is not available", "Not Found"}
```
