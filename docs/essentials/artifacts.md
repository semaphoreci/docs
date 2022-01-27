---
Description: There are three levels of artifact stores - job, workflow, and project. Artifacts are used to persist files that are final deliverables or debugging files.
---

# Artifacts

__Note__: *Using Artifacts during the beta period is free. Once the artifacts
system is generally available to all users, additional charges will apply based on
usage.*

Artifacts are used to persist files that are either final deliverables or
intermediary/debugging files.

Semaphore has three levels of artifact stores: job, workflow, and project.

Each job and workflow gets its own namespaced artifact store,
which is handy for storing debugging data or
build artifacts that need to be promoted through the pipeline.

On the project level there is a single artifact store
that usually stores the final deliverables of CI/CD pipelines.

## Job Artifacts

Each job has an artifact store. You can view the stored files from a job's page.
To do so, click the "Job Artifacts" button.
The main use-case for job level artifacts is storing logs,
screenshots, and other types of files that make debugging easier.

To upload files to the job level artifacts store, use the built-in artifact CLI.

`artifact push job <my_file_or_dir>`

If you want to upload artifacts only in the event of failed job, the preferred method is to use
[epilogue](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-epilogue-property) in combination with the `on_fail` condition.

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

Because job level debugging artifacts become irrelevant shortly after a job has
finished, you can set artifacts to expire with the `--expire-in` flag.

`artifact push job --expire-in 2w logs/test.log`

For more details about uploading artifacts, check
the [artifact CLI documentation][artifact-cli-reference].

## Workflow Artifacts

Similar to the case with jobs, each workflow also gets its own artifact store.
To access these, click the "Workflow Artifacts" button.

Workflow artifacts can be used for storing various build and test reports and
build artifacts. Promoting build artifacts through blocks and pipelines of a
workflow is another common use-case.

The following example illustrates how an executable `app`, available in the
workflow level artifact store, can be downloaded into the downstream blocks of
the pipeline. In the same way, artifacts can be downloaded from any other
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

For more details about uploading and downloading artifacts see the
[artifact CLI documentation][artifact-cli-reference].

## Project Artifacts

Project level artifacts are great for storing final deliverables of the
CI/CD process. To access them in the UI, click the "Project Artifacts"
button on the project page.

To upload project artifacts from any job of any workflow you need to use:

`artifact push project myapp-v1.25.tar.gz`

Similarly, if you want to download a file from the project level artifact store,
use the `pull` command.

`artifact pull project myapp-v1.25.tar.gz`

[artifact-cli-reference]: https://docs.semaphoreci.com/reference/artifact-cli-reference/
