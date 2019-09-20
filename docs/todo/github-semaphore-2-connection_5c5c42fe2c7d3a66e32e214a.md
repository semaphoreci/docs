## Checking the connection between GitHub and Semaphore 2.0

If for some reason GitHub loses access to Semaphore 2.0 then you might see
the following error message when trying to execute a Semaphore 2.0 project:

``` yaml
semaphore.yml ERROR:
Error: {"File '.semaphore/semaphore.yml' is not available", "Not Found"}
```

The first thing to do is visiting [this](https://github.com/settings/connections/applications/328c742132e5407abd7d)
web page and grant access to Semaphore 2.0 again.

This web page shows the organizations you are a member of and the access level
that Semaphore 2.0 has to these organizations.
