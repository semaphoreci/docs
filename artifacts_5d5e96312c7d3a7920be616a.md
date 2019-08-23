# Artifacts

Artifacts are used to persist and share files accross workflows for a project.
They are typically the result of a CI/CD process such as final deliverables
or inermediary/debugging files (e.g. log error files, screenshots, code coverage results...).

Semaphore has three levels of artifact store: job, workflow and project.

Each job and workflow gets its own namespaced artifact store,
which is handy for storing debugging data or
build artifacts that need to be promoted through the pipeline.

On the project level there is a single artifact store
that usually stores final deliverables of CI/CD pipelines.

__Note__: Artifacts are a *beta feature* and Artifacts web interface is available on request.
Using Artifacts during the beta period is free.
Once the artifacts system is in the general availability,
additional charges will apply based on the usage.

Although we make the best effort to maintain the uptime for the Artifacts system,
we cannot guarantee the 100% uptime during the beta period.

If you'd like to share a feedback or if you run into any challenges,
please reach out to support@semaphoreci.com.

- [Job Artifacts](#job-artifacts)
- [Workflow Artifacts](#workflow-artifacts)
- [Project Artifacts](#project-artifacts)


## Job Artifacts

Each job has an artifact store that you can access from the job page by clicking
Look for “Job Artifacts” button.
The main use-case for job level artifacts is storing of logs,
screenshots and other types of files that make debugging easier.

To upload files to job level artifacts store use built-in artifact CLI.

`artifact push job <my_file_or_dir>`

If you want to upload artifacts only in the case of failed job
using epilogue in combination with `on_fail` condition is a usual pattern.

```yml
blocks:
 - name: Build app
   task:
      jobs:
        - name: Job 1
          commands:
            - make test
      epilogue:
        on_fail:
          commands:
            - artifact push job logs/test.log
            - artifact push job screenshots
```

Since job level debugging artifacts are relevant in a week or two after job has finished
you can set artifacts to expire with `--expire-in` flag.

`artifact push job --expire-in 2w logs/test.log`

For more details about uploading artifacts check
the [artifact CLI reference][artifact-cli-reference].

## Workflow Artifacts

As in case of jobs, each workflow also get's its own artifact store.
On the workflow page look for "Workflow Artifacts" button.

Workflow artifacts can be used for storing various build and test reports and build artifacts.
Promoting build artifacts though blocks and pipelines of a workflow is another use-case.

The following example illustrates how executable `app`, stored in the workflow level artifacts,
can be downloaded in the downstream blocks of the pipeline.
In the same way artifacts can be downloaded from any other pipeline of the same workflow.

```yml
blocks:
 - name: Build app
   task:
      jobs:
        - name: Make
          commands:
            - make
            - artifact push workflow app
 - name: Test
   task:
      jobs:
        - name: Unit tests
          commands:
            - artifact pull workflow app
            - make test
        - name: Integration tests
          commands:
            - artifact pull workflow app
            - make integration-tests

```

For more details about uploading and downloading artifacts see artifact CLI reference.

## Project Artifacts

Project level artifacts are great for storing final of deliverables of CI/CD process.
To access them trought the UI look for "Project Artifacts" button on the job page.

To upload artifacts from any job of any workflow you need to use:

`artifact push project myapp-v1.25.tar.gz`

In the same way if you want to download file from project level artifact store with the `pull` command.

`artifact pull project myapp-v1.25.tar.gz`



[artifact-cli-reference]: https://docs.semaphoreci.com/article/154-artifact-cli-reference
