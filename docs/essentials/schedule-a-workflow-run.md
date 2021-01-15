---
description: Scheduling workflow runs daily, hourly or even every other minute. Workflow scheduler/cron can be set up via GUI or CLI.
---

# Workflow scheduler/cron

Scheduling workflow runs daily, hourly or even every other minute can be useful
in many use cases, such as:

- Periodically performing long-running or resource-intensive tests that should
not be triggered on every push.
- If your application delivery process requires periodical builds.
- When you have an inactive project but would like to be sure that the code still
works with its dependencies.
- An easy way to periodically execute arbitrary code, track results and receive
notifications.

## Set up a scheduled workflow run

To set up a scheduled workflow run for your project, you need to specify three
things:

- a git branch that should be used for workflow runs
- the path within the repository to a file with YAML definition of the
initial pipeline for the scheduled workflows
- an expression in standard **Crontab** syntax that defines the UTC times at
which the workflow should run

This can be done through both Web UI and CLI.

### Web UI

1. Open project page.

2. Click on **Manage Schedulers** on the top right side

3. Click on **New Scheduler** button.

5. Fill out the form with necessary data:

    - Enter a descriptive **name** for the schedule, e.g. `nightly-deploys`
    - Enter the **branch name**, e.g. `master`
    - Enter a path to **pipeline file**, e.g. `.semaphore/nightly-deploys.yml`
    - Enter a **Crontab expression** defining the times for workflow runs, e.g. `15 12 * * *` - every day at 12:15 UTC

6. Click **Create** button.

### CLI

*Note*: Be sure to use the [latest version][update-cli] of Semaphore CLI

Use the [sem edit project][cli-edit-project] command to open project YAML
definition in your preferred editor, it should look similar to this:

```yaml
apiVersion: v1alpha
kind: Project
metadata:
  name: Your project
  id: abcd-12345
  description: Description of your project
spec:
  visibility: private
  repository:
    ...
  schedulers: []
```

Here you can add the definition of a new scheduler that will run workflows
periodically, like in example:

```yaml
apiVersion: v1alpha
kind: Project
metadata:
  name: Your project
  id: abcd-12345
  description: Description of your project
spec:
  visibility: private
  repository:
    ...
  schedulers:
  - name: nightly-deploys
    branch: master
    at: "15 12 * * *"
    pipeline_file: .semaphore/nightly-deploys.yml
```
 More details about the fields within the scheduler definition can be found
 [here][scheduler-yml-spec].

Save the changes and close the editor and scheduled workflow runs will be set up.

## Limitations

- In order to disperse the load, the workflows will be run at the random second
of the wanted minute. This means that even though some versions of Crontab
format support seconds in expression, the Semaphore 2.0 will ignore them.

- When the scheduled workflow is triggered, the Semaphore 2.0 uses the latest
webhook received from GitHub for the given branch to determine the exact commit
for which the workflow should be run.
This can be problematic in two cases:

    1. When the project is new and there were no pushes to the given branch since
    project creation - in this case, the creation of schedule described above will
    fail
    2. In rare cases when there is an issue with GitHub webhook delivery, you can
    either redeliver them from GitHub or contact us at support@semaphoreci.com.

- The scheduled workflow runs will not be started in the first 60 seconds (this
can span across two differently numbered minutes) after the schedule is created,
to avoid inconsistencies due to minute precision of the Crontab expressions.

## See also

- [Semaphore guided tour][guided-tour]
- [Project workflow trigger options][wf-trigger-options]
- [Pipelines reference][pipelines-ref]

[update-cli]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#download-and-install
[cli-edit-project]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-edit_1
[scheduler-yml-spec]: https://docs.semaphoreci.com/reference/projects-yaml-reference/#schedulers
[guided-tour]: https://docs.semaphoreci.com/guided-tour/getting-started/
[wf-trigger-options]: https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/
[pipelines-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
