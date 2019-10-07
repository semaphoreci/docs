# Artifacts

__Note__: *Using Artifacts during the beta period is free. Once the artifacts
system is in the general availability, additional charges will apply based on
the usage.*

Artifacts are used to persist files that are either final deliverables or
intermediary/debugging files.

Semaphore has three levels of artifact store: job, workflow and project.

Each job and workflow gets its own namespaced artifact store,
which is handy for storing debugging data or
build artifacts that need to be promoted through the pipeline.

On the project level there is a single artifact store
that usually stores final deliverables of CI/CD pipelines.

## Job Artifacts

Each job has an artifact store. You can view stored files from job page.
Look for "Job Artifacts" button.
The main use-case for job level artifacts is storing logs,
screenshots and other types of files that make debugging easier.

To upload files to job level artifacts store use built-in artifact CLI.

`artifact push job <my_file_or_dir>`

If you want to upload artifacts only in the case of failed job
using
[epilogue](https://docs.semaphoreci.com/article/50-pipeline-yaml#the-epilogue-property) in combination with `on_fail` condition is a usual pattern.

``` yaml
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

Since job level debugging artifacts are relevant in a week or two after job has
finished you can set artifacts to expire with `--expire-in` flag.

`artifact push job --expire-in 2w logs/test.log`

For more details about uploading artifacts check
the [artifact CLI reference][artifact-cli-reference].

## Workflow Artifacts

As in case of jobs, each workflow also gets its own artifact store.
On the workflow page look for "Workflow Artifacts" button.

Workflow artifacts can be used for storing various build and test reports and
build artifacts. Promoting build artifacts through blocks and pipelines of a
workflow is another common use-case.

The following example illustrates how executable `app`, available in the
workflow level artifact store, can be downloaded in the downstream blocks of
the pipeline.  In the same way artifacts can be downloaded from any other
pipeline of the same workflow.

``` yaml
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

For more details about uploading and downloading artifacts see
[artifact CLI reference][artifact-cli-reference].

## Project Artifacts

Project level artifacts are great for storing final deliverables of the
CI/CD process. To access them in the UI look for "Project Artifacts"
button on the job page.

To upload artifacts from any job of any workflow you need to use:

`artifact push project myapp-v1.25.tar.gz`

Similarly, if you want to download file from the project level artifact store
use the `pull` command.

`artifact pull project myapp-v1.25.tar.gz`

[artifact-cli-reference]: https://docs.semaphoreci.com/article/154-artifact-cli-reference
