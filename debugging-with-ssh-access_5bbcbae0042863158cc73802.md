Often the best way to troubleshoot failures in your pipelines is to SSH into a
job and inspect log files, running processes, and directory paths. Semaphore 2.0
gives you the option to access all running jobs via SSH, to restart your jobs
in debug mode, or to start on-demand virtual machines to explore the build
environment.

* [Setting Your SSH Key](#Setting Your SSH Key)
* [Exploring the build environment](#exploring-the-build-environment)
* [Inspecting the state of a running job](#inspecting-the-state-of-a-running-job)
* [Restarting a job in debug mode](#restarting-a-job-in-debug-mode)
* [Port forwarding your web server and debug UI issues](#port-forwarding-your-web-server-and-debug-ui-issues)
* [See also](#see-also)

## Setting Your SSH Key

You'll need to set your debug SSH key before continuing. You can use
the same key you use for Github. Here's an example:

``` bash
sem config set debug.PublicSshKey $(curl https://github.com/YOUR_USERNAME.keys)
```

Replace `YOUR_USERNAME` with your Github username.

Or you can use the first key in your SSH agent:

``` bash
sem config set debug.PublicSshKey $(ssh-add -L | head -n 1)
```

## Exploring the build environment

Setting up a pipeline can be challenging if you are not familiar with the
software stack installed in Semaphore's virtual machines. Starting a debug
session for your project is a great place to start exploring.

To start a debug session for your project, run:

``` bash
sem debug project [name-of-your-project]
```

The above command will start a virtual machine connected with your git
repository and attach you to it via an SSH session.

## Inspecting the state of a running job

Often the best way to inspect failures is to SSH into a running job, explore the
running processes, inspect the environment variables, and take a peek at the
log files.

Semaphore allows you to SSH into any running job with:

``` bash
sem attach [job-id]
```

Use `sem get jobs` to list running jobs.

Access to the job's virtual machine is managed by the public SSH keys in the
`.ssh/authorized_keys` file. To add your public key to the machine add the
following command to your pipeline definition:

``` bash
echo '[your-public-key]' >> .ssh/authorized_keys
```

To manage multiple public keys for SSH access
[store your public keys in a
secret](https://docs.semaphoreci.com/article/66-environment-variables-and-secrets).

## Restarting a job in debug mode

To find the root cause of a failed job, Semaphore allows you to restart your job
in debug mode with:

``` bash
sem debug job [job-id]
```

This will start a new interactive job based on the specification of the old one,
export the same environment variables, inject the same secrets, and connect to
the same git commit.

Commands in the debug mode are not executed automatically, instead they are
stored in `/home/semaphore/commands.sh`. This allows you to execute them
step-by-step, and inspect the changes in the environment.

## Port forwarding your web server and debug UI issues

Sometimes SSH access to your build environment is not enough to fully explore
the problem. For example, Selenium based tests will fail if the html elements
are not visible on the screen when you are running the tests.

Semaphore allows you to forward ports to your local machine and explore the UI
of your application from your browser. If your application is running on port
`3000`, you can port forward to your local port `6000` with:

``` bash
sem port-forward [job-id] 6000 3000
```

The `http://localhost:6000` should now be accessible in your browser.

## See also

- [Sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Secrets YAML
  Reference](https://docs.semaphoreci.com/article/51-secrets-yaml-reference)
