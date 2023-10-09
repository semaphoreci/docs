---
Description: Start your CI/CD workflows on a regular basis or on demand using Tasks.
---

!!! warning "Scheduler/cron is deprecated in favor of Tasks"
    Formerly configured schedulers have been automatically migrated to Tasks and they should work as usual without any additional action.

    Continue reading to learn about the differences and new possibilities that Tasks offer. If you need, you can still refer to [the old documention](/essentials/schedule-a-workflow-run-legacy) of Schedulers.

# Tasks

Tasks are a continuation of Schedulers/cron feature, offering a wider range of possible use.
They act as an entrypoint for workflows that were not initiated by git provider automation.
These are the key differences between Schedulers and Tasks:

- Schedulers needed you to provide a cron-based schedule. Tasks have two modes: 
**scheduled** (which overlaps Schedulers) and **unscheduled** (periodic execution is disabled). 
- Due to technical limitation, Schedulers required customers to run at least one workflow before its use. 
Tasks use new data flow to overcome that difficulty, so you can **run them on any branch** (as long as it exists at repository).
- Schedulers allowed you to run the workflow on demand (by clicking the button) with set branch and pipeline file. 
Tasks allow **overriding branch and pipeline file** before each execution.
- Schedulers did not accept parameters to the workflow. Tasks allow you to **pass arguments as environment variables** to both scheduled (as default values) and manual (provided by hand) runs.

## Use cases

Scheduling workflow runs daily, hourly, or even every other minute might be handful
in many use cases, such as:

- Periodically performing long or resource-intensive tests that should
not be triggered on every push.
- If your application delivery process requires periodical builds.
- When you have an inactive project but would like to be sure that the code still
works with its dependencies.
- An easy way to periodically execute arbitrary code, track results, and receive
notifications.

Manually triggered workflow runs complement the mentioned range to give a full control
over the execution of CI/CD workflow, for example in case of:

- repeated jobs performed under specific circumstances (for instance, database maintenance),
- quality control of your CI/CD environment performed on demand,
- provisioning and setting up resources at your cloud provider,
- exceptional corrective actions (e.g. pruning cache). 

## Setting up a new task

### Web UI

1. Open the project page.

2. Select **Tasks** tab on the top menu pane.

3. Click the **New Task** button. <img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/schedule-a-workflow-run/new_task_button.png" alt="New Task button in the project tasks page">

4. Task creation wizard page will open and prompt you to enter the task details. <img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/schedule-a-workflow-run/create_task.png" alt="Task creation wizard">

    1. Enter the name and optionally a description for the task. The name needs to be unique within the project. 

    2. Choose branch name and pipeline file that will be used to checkout the repository and run the CI/CD workflow. Those values will be used as defaults for scheduled and manual runs. Before creating the task, please ensure that the branch exists in the repository.
  
    3. Configure parameters passed to the workflow as environment variables. Apart from name and description, you can  possible options to suggest, set default value, or mark it as required. Parameter names must comply with the bash environment variable naming convention.

    4. Optionally, you can configure the task to be scheduled. To do so, select the **Scheduled** option and provide the crontab that will describe when to trigger the workflow. Otherwise, choose **Unscheduled** option. 

9. Click the **Create** button to confirm your changes.

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
  tasks: []
```

Here you can add the definition of tasks that will be configured on the project, as shown below:

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
  tasks:
  - name: nightly-deploys
    branch: master
    scheduled: true
    at: "15 12 * * *"
    pipeline_file: .semaphore/nightly-deploys.yml
  - name: canary-setup
    branch: develop
    scheduled: false
    pipeline_file: .semaphore/nightly-deploys.yml
    parameters:
    - name: CANARY_VERSION
      required: true
      default_value: "1.0.0"
```

More details about the fields within the tasks can be found [here][tasks-yml-spec].

Save the changes and close the editor. Your tasks will be set up.

## Editing and deleting tasks

### Web UI

1. Open the project page.

2. Select **Tasks** tab on the top menu pane. You will see a list of Tasks for the project.

3. Click on the **Edit** button on the task you want to edit. You will be moved to the Task edit page resembling the [Task creation wizard](#setting-up-a-new-task). Make appropriate changes and click the **Confirm** button.

4. If you want to remove the task, click on the **Delete** button. Confirm this action in the dialog.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/schedule-a-workflow-run/edit_task.png" alt="Edit and Delete buttons in the project tasks page">

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
  tasks:
  - name: nightly-deploys
    scheduled: true
    branch: master
    at: "15 12 * * *"
    pipeline_file: .semaphore/nightly-deploys.yml
```

If you want to edit the task, simply change the values of the fields you want to
modify to the desired ones. Make sure the changes you enter are valid.

If you want to remove the task, simply remove the definition of that particular task from `tasks`,
save the changes and close the editor.

## Deactivating scheduled tasks

If you want temporarily stop scheduled task from triggering periodic workflows, 
you can deactivate it in the Web UI by clicking on the **Deactivate** button 
or putting `status: INACTIVE` attribute in the CLI definition.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/schedule-a-workflow-run/deactivate_task.png" alt="Deactivate button in the project tasks page">

To resume the scheduler for the task, simply click on the **Activate** button 
that will appear in the same place or put `status: ACTIVE` attribute in the CLI definition.

Deactivating the task will not affect the possibility to manually run the workflow via task,
regardless from the fact whether the task is scheduled or not.

## Running the workflow manually

You can trigger the workflow in the Web UI with the following steps:


1. Open the project page.

2. Select **Tasks** tab on the top menu pane.

3. Find the wanted task and click on the **Run Now** button. <img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/schedule-a-workflow-run/run_task.png" alt="Deactivate button in the project tasks page">

4. You will be moved to the workflow run page. Before triggering the workflow, you can override
branch and pipeline file used to run the workflow. You can also modify parameter values passed to the workflow. <img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/schedule-a-workflow-run/just_run_form.png" alt="Task execution form example">

5. Click the **Run** button.


This will trigger a new workflow based on the configuration from the file configured
in the task definition. The workflow will use code revision of the latest commit 
from the branch that is configured in the definition. Additionally, parameters passed
to the workflow are accessible as environment variables in every job of the initial pipeline.

## Limitations

- In order to disperse the load, the workflows will be run at a random second
of the selected minute. This means that even though some versions of Crontab
format support seconds in expressions, Semaphore 2.0 will ignore them.

- Scheduled workflow runs will not be started in the first 60 seconds (this
can span across two differently numbered minutes) after the task is created,
to avoid inconsistencies due to minute precision of Crontab expressions.

- In rare cases when there is an issue with scheduling workflows the Semaphore
will retry to initiate the workflow every ten seconds for the following 15 minutes.

## See also

- [Semaphore guided tour][guided-tour]
- [Project workflow trigger options][wf-trigger-options]
- [Pipelines reference][pipelines-ref]

[update-cli]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#download-and-install
[cli-edit-project]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-edit_1
[tasks-yml-spec]: https://docs.semaphoreci.com/reference/projects-yaml-reference/#tasks
[guided-tour]: https://docs.semaphoreci.com/guided-tour/getting-started/
[wf-trigger-options]: https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/
[pipelines-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
