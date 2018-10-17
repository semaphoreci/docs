To build, test and deploy your code on Semaphore, you'll need to
create a project for it to live in.

All projects on Semaphore belong to an organization.
You'll be prompted to create your first organization after
you [sign up for Semaphore][app]. Once you're inside an organization
that you've created or were invited to, you're ready to start.

At this point Semaphore presents you with three commands to run in
your terminal.

The first command installs the `sem` CLI.
The [`sem` command line tool][sem] can create and configure projects.
To install it, copy and paste the installation command:

```
curl https://storage.googleapis.com/sem-cli-releases/get.sh | bash
```

Next, you'll need to connect `sem` to the organization.
The command includes the URL and access token. In your web browser
you'll see something similar to:

```
sem connect ORGANIZATION.semaphoreci.com ACCESS_TOKEN
```

Finally, run `sem init` inside the Git repository you'd like to connect
to Semaphore. The command creates a deploy key and webhook on GitHub, so
that Semaphore can access your code as it changes, and creates a pipeline
definition file `.semaphore/semaphore.yml` on your computer.

After you follow the last instruction to `git push` the file, you should
see the pipeline running in your browser. You can also see all running
jobs in your terminal via `sem get jobs`.

Congratulations! You've successfully created your first project,
and initialized it with a working pipeline.
Take some time to explore the Semaphore web interface, and compare what you
see with the generated YAML file.

Let's move on to [an overview of key Semaphore concepts][next] to learn what
each part means.

[app]: https://id.semaphoreci.com
[next]: https://docs.semaphoreci.com/article/62-concepts
[sem]: https://docs.semaphoreci.com/article/53-sem-reference
