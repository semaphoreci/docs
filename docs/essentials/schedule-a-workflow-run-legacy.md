---
Description: You can schedule workflow runs daily, hourly, or even every other minute using the workflow scheduler/cron. The workflow scheduler/cron can be set up via the GUI or CLI.
---

!!! warning "Scheduler/cron has been deprecated in favor of Tasks"
    Please note that Tasks has replaced Schedulers and this documention is outdated.
    Formerly configured schedulers have been automatically migrated and they should work as usual without any additional action.
    Please check out [Tasks documentation](/essentials/schedule-a-workflow-run) to learn more about the differences and new capabilities coming with the change.

# Workflow scheduler/cron

Scheduling workflow runs daily, hourly, or even every other minute can be useful
in many use cases, such as:

- Periodically performing long or resource-intensive tests that should
not be triggered on every push.
- If your application delivery process requires periodical builds.
- When you have an inactive project but would like to be sure that the code still
works with its dependencies.
- An easy way to periodically execute arbitrary code, track results, and receive
notifications.

## Setting up a scheduled workflow run

To set up a scheduled workflow run for your project, you need to specify three
things:

- the git branch that should be used for workflow runs
- the path within the repository to a file with the YAML definition of the
initial pipeline for the scheduled workflows
- an expression in standard **Crontab** syntax that defines the UTC times at
which the workflow should run

This can be done via both the Web UI and CLI.

### Web UI

1. Open the project page.

2. Click **Manage Schedulers** on the top right side

3. Click the **New Scheduler** button.

5. Fill out the form with necessary data:

    - Enter a descriptive **name** for the schedule, e.g. `nightly-deploys`
    - Enter the **branch name**, e.g. `master`
    - Enter a path to **pipeline file**, e.g. `.semaphore/nightly-deploys.yml`
    - Enter a **Crontab expression** defining the times for workflow runs, e.g. `15 12 * * *` - every day at 12:15 UTC

6. Click the **Create** button.

### CLI

*Note*: Be sure to use the [latest version][update-cli] of Semaphore CLI

Use the [sem edit project][cli-edit-project] command to open the project YAML
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

Here you can add the definition for a new scheduler that will run workflows
periodically, as shown below:

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
 More details about the fields within the scheduler can be found
 [here][scheduler-yml-spec].

Save the changes and close the editor, and your scheduled workflow runs will be set up.

## Delete the workflow scheduler

If you no longer need to run specific scheduled workflows you can delete
any given scheduler, either via the Web UI or CLI.

### Deleting a scheduler in the Web UI

1. Open the project page.

2. Switch to the **Schedulers** tab.

3. Find the desired scheduler and click the **Delete** button.

4. Confirm the action in the message dialog.

### Deleting a scheduler with the CLI

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
  schedulers:
  - name: nightly-deploys
    branch: master
    at: "15 12 * * *"
    pipeline_file: .semaphore/nightly-deploys.yml
```

Simply remove the `scheduler` definition of the desired scheduler from `schedulers`
list, save the changes, and close the editor.

## Temporary deactivate a workflow scheduler

If you want to stop a scheduler from triggering workflows only temporary, you
can deactivate it in the Web UI with the following steps:

1. Open the project page.

2. Switch to the **Schedulers** tab.

3. Find the desired scheduler and click the **Deactivate** button.

4. Confirm this action in the message dialog.

This will disable workflow scheduling, but it will allow you to easily
resume its use if needed by clicking the **Activate** button in the same place.

Additionally, it is also possible to manually run workflows based on
deactivated schedulers.

## Manually run a workflow based on scheduler definition

You can manually trigger a workflow in the Web UI with the following steps:

1. Open the project page.

2. Switch to the **Schedulers** tab.

3. Find the desired scheduler and click the **Run Now** button.

4. Confirm this action in the message dialog.

This will trigger a new workflow based on the configuration from the file configured
in the scheduler definition. The workflow will use code revision of the latest
commit from the branch that is configured in the scheduler definition.

## Limitations

- In order to disperse the load, the workflows will be run at a random second
of the selected minute. This means that even though some versions of Crontab
format support seconds in expressions, Semaphore 2.0 will ignore them.

- When the scheduled workflow is triggered, Semaphore 2.0 uses the latest
webhook received from GitHub/Bitbucket for the given branch to determine the exact commit
for which the workflow should be run. 

If a project is new and there have been no pushes to the selected branch since project creation, **the creation of a schedule as described above will fail**.

- Scheduled workflow runs will not be started in the first 60 seconds (this
can span across two differently numbered minutes) after the schedule is created,
to avoid inconsistencies due to minute precision of Crontab expressions.

- In rare cases when there is an issue with scheduling workflows the Semaphore
will retry to initiate the workflow every ten seconds for the following 15 minutes.

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
