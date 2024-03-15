# Pipeline Initialization

Every Semaphore pipeline goes through an initialization process during
which Semaphore fetches, evaluates, and verifies the Pipeline YAML file.

For pipelines that need a full clone of the Git repository for evaluation
(ex. pipelines that use [change-in][change-in] expressions), Semaphore runs a
job that clones the Git repository and evaluates the pipeline files. 
Pipelines that use dedicated initialization jobs for evaluation have 
an "Initialization" step displayed on the Workflow Page.
Initialization jobs have a duration limit set to 10 minutes.

As a default, initialization jobs use machine and OS image assigned by internal strategy. However, you can customize agent specification for initialization jobs across your organization. If you need to configure it at a project level, you might be interested in [project-level Pre-flight checks](/security/configuring-pre-flight-checks#project-pre-flight-checks).


## Configuring agents for intialization job

1. Open the **Settings** from the **Organization menu** in the right side of the page header.

2. Click **Initialization jobs** on the left side of the settings view and go to **Agent configuration** section.

3. Choose between different machine types:
    - **Linux Based Virtual Machines** - hosted by Semaphore
    - **Mac Based Virtual Machines** - hosted by Semaphore
    - **Self-Hosted Machines** - hosted by the customer (if applicable)

    For machines hosted by Semaphore, choose a proper **Machine type** and **OS image** of the agent. For self-hosted machines choose a **Machine type** that matches your self-hosted agent type.

4. Click **Save changes** button.

[change-in]: https://docs.semaphoreci.com/reference/conditions-reference/#change_in
