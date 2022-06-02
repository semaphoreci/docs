---
Description: Artifacts are used to persist files that are final deliverables or debugging files.
---

# Artifacts

Semaphore provides a persistent artifact store for all projects. Artifacts are ideal for:

- Collecting debug data from your jobs (ex. screenshots, screencasts, build logs)
- Passing data and executables between jobs in a single workflow (ex. building the executable in the first job and passing it to upstream jobs for testing)
- Long-term storage of final deliverables (ex. storing release v1.0.12 of a CLI application)

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/artifacts/top.png" alt="Example artifact usage on Semaphore 2.0">

## Types of artifacts

Semaphore has three levels of artifact stores: job, workflow, and project.

Each job and workflow has its own namespaced artifact store, while on the project
level there is a single artifact store for the whole project.

Each artifact type has its primary use case: 

- Job artifacts are suitable for collecting debug data
- Workflow artifacts are ideal for passing data from one job to another
- Project artifacts are ideal for storing final deliverables.

### Job Artifacts

The primary use case for job artifacts is storing logs, screenshots, and other
files that make debugging easier.

To upload files to the job artifacts store, use the built-in artifact CLI.

``` bash
artifact push job <my_file_or_dir>
```

Here is a complete example that uploads test logs and screenshots produced by your tests.

``` yaml
blocks:
 - name: Build app
   task:
      jobs:
        - name: Tests
          commands:
            - make test

      epilogue:
        always:
          commands:
            - artifact push job logs/test.log
            - artifact push job screenshots
```

In the above example, we use [epilogue always][epilogue-always] commands to ensure that 
artifacts are uploaded for both passed and failed jobs.

You can view the stored files from a job's page. Go to the job page and click on the "Artifacts"
tab to see artifacts uploaded by this job.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/artifacts/job-artifacts.png" alt="Viewing job artifacts">

### Workflow Artifacts

The primary use case for workflow artifacts is storing various build and test reports
and passing data and executables between jobs in a single workflow.

To upload files to the workflow artifacts store, use the built-in artifact CLI:

``` bash
artifact push workflow <my_file_or_dir>
```

To download files from the workflow artifacts store:

``` bash
artifact pull workflow <my_file_or_dir>
```

Here is a complete example that shows how to build a release in the first block and
use it in the upstream blocks of the workflow.

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

In the above example, we build the application in the "Build app" block and 
then pull that application in the "Test" block for unit and integration tests.

You can view the stored files from a workflow page. Go to the workflow page and 
click on the "Artifacts" tab to see artifacts uploaded in this workflow.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/artifacts/workflow-artifacts.png" alt="Viewing workflow artifacts">

### Project Artifacts

The primary use case for project artifacts is storing the final 
deliverables of the CI/CD process.

To upload project artifacts from any job of any workflow use:

``` bash
artifact push project myapp-v1.25.tar.gz
```

Similarly, use the `pull` command if you want to download a file from 
the project-level artifact store.

``` bash
artifact pull project myapp-v1.25.tar.gz
```

To access them in the UI, click the "Artifacts" button on the project page.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/artifacts/project-artifacts.png" alt="Viewing project artifacts">

## Artifact retention policies 

By default, artifacts are persisted and never automatically deleted. If you want to limit the
lifetime of the artifacts in your project, you can set up artifact retention policies in your 
project.

For example, if you want to delete every job and workflow artifact after a week, go to your project
settings and set up retention policies for job and workflow artifacts.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/artifacts/simple-retention-policy.png" alt="Simple retention policies">

### Applying different retention policies to different folders

Some artifacts have higher values, and you might want to extend their lifetime. 

For example, test screenshots saved on the job level typically lose their value 
after a couple of days, while the test logs can offer a high value for several months.

We can set up a retention policy that matches that matches our previous needs. One
week for screenshots and three months for test logs. We will also set one months for
any other file:

To do this, we will use the following configuration for job level artifacts:

```
/screenshots/**/*.png         1 week
/logs/**/*.txt              3 months
/**/*                        1 month
```

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/artifacts/artifact-retention-custom.png" alt="Simple retention policies">

The format of the selector patterns and the available options are further described 
in the [Artifact Retention Policy Reference][artifact-retention-policy-ref].

[artifact-cli-reference]: /reference/artifact-cli-reference/
[epilogue-always]: /reference/pipeline-yaml-reference/#the-epilogue-property
[artifact-retention-policy-ref]: /reference/artifact-retention-policies
