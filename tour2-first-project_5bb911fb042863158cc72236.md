# Your First Project

All projects should be part of an organization. You're prompted to create
your first organization when you first login. Open the [website](https://id.semaphoreci.com)
and follow a long. Or, go directly the [new organization](https://me.semaphoreci.com/organizations/new) page.
Afterwards you're given three commands to run.

The first command installs the `sem` CLI. The `sem` command can create
and configure projects. Copy and paste the install command.

```
curl https://storage.googleapis.com/sem-cli-releases/get.sh | bash
```

Next, you'll need to connect `sem` to the organization. That command
should be displayed as well. The command includes the URL and access
token. It's similar to:

```
sem connect ORGANIZATION.semaphoreci.com ACCESS_TOKEN
```

Last, run `sem init` inside the git repository you'd like to connect
to Semaphore. The command creates the pipeline file
`./semaphore/semaphore.yml`, if it does not already exist, and shows
you how to trigger your first build. If everything worked, you'll see
the build running in your browser or using `sem get jobs`.

Now you're ready to [customize your pipeline](https://docs.semaphoreci.com/article/50-pipeline-yaml).
