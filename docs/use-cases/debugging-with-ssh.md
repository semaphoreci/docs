Often the best way to troubleshoot failures and bugs in your pipelines is to
SSH into a job and inspect log files, running processes, and directory paths.
Semaphore gives you the option to access all running jobs via SSH, to
restart your jobs in debug mode, or to start on-demand virtual machines to
explore the CI/CD environment.

Before you begin, you'll need to [install the Semaphore CLI][install-cli].

## Restarting a job in debug mode

Setting up a pipeline can be challenging if you are not familiar with the
software stack installed in Semaphore virtual machines. Starting a debug
session for your job is a great place to start exploring.

To start a debug session for your job, run:

``` bash
sem debug job [job-id]
```

This will start a new interactive job based on the specification of the old one,
export the same environment variables, inject the same secrets, and connect to
the same git commit.

Commands in the debug mode are not executed automatically, instead they are
stored in `~/commands.sh`. This allows you to execute them step-by-step, and
inspect the changes in the environment.

By default, the duration of the SSH session is limited to one hour. To run
longer debug sessions, pass the `duration` flag to the above command:

``` bash
sem debug job [job-id] --duration 3h
```

By default, a debug session does not include the contents of the GitHub
repository related to your Semaphore project. Run `checkout` in the debug
session to clone your repository.

### Error: project or job not found

If you get this error and you're part of multiple organizations, check if
you're currently in the right one by running `sem context`. If not, change
context to the organization of desired project or job by running
`sem context <id>`.

## Inspecting the state of a running job

Often the best way to inspect failures is to SSH into a running job, explore the
running processes, inspect the environment variables, and take a peek at the
log files.

Semaphore allows you to SSH into any running job with:

``` bash
sem attach [job-id]
```

Use `sem get jobs` to list running jobs.


To find the root cause of a failed job, Semaphore allows you to restart your job
in debug mode with the following command:

``` bash
sem debug job [job-id]
```

## Port forwarding your web server and debug UI issues

Sometimes SSH access to your CI/CD environment is not enough to fully explore
the problem. For example, Selenium based tests will fail if the html elements
are not visible on the screen when you are running the tests.

Semaphore allows you to forward ports to your local machine and explore the UI
of your application from your browser. If your application is running on port
`3000`, you can port forward it to your local port `6000` with:

``` bash
sem port-forward [job-id] 6000 3000
```

The `http://localhost:6000` should now be accessible in your browser.

Note: Port-Forwarding works only for Virtual Machine based CI/CD environments.

## Stopping a debug session

The debug session will *automatically* end once you exit the SSH session. To
manually stop a debug session execute `sem stop job [job-id]` from your local
machine. You can find the Job ID of your debug job using the `sem get jobs`
command.

## See also

- [Sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Secrets YAML Reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)

[install-cli]: https://docs.semaphoreci.com/article/53-sem-reference
