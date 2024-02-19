# Pipeline Initialization

Every Semaphore pipeline goes through an initialization process during
which Semaphore fetches, evaluates, and verifies the Pipeline YAML file.

For pipelines that need a full clone of the Git repository for evaluation
(ex. pipelines that use [change-in][change-in] expressions), Semaphore runs a
job that clones the Git repository and evaluates the pipeline files. 
Pipelines that use dedicated initialization jobs for evaluation have 
an "Initialization" step displayed on the Workflow Page.
Initialization jobs have a duration limit (set to 10 minutes).

As a default, initialization jobs use the machine and OS image assigned by the relevant internal strategy. However, you can customize agent specifications for initialization jobs across your organization. If you need to configure it at the project level, you might be interested in [project-level Pre-flight checks](/security/configuring-pre-flight-checks#project-pre-flight-checks).


## Configuring agents for intialization jobs

1. Open the **Settings** tab in the **Organization menu** on the right side of the page header.

2. Click **Initialization jobs** on the left side of the settings panel and go to the **Agent configuration** section.

3. Choose the preferred machine type:
    - **Linux Based Virtual Machines** - hosted by Semaphore
    - **Mac Based Virtual Machines** - hosted by Semaphore
    - **Self-Hosted Machines** - hosted by the customer (if applicable)

    For machines hosted by Semaphore, choose a proper **Machine type** and **OS image** for the agent. For self-hosted machines choose a **Machine type** that matches your self-hosted agent type.

4. Click the **Save changes** button.

[change-in]: https://docs.semaphoreci.com/reference/conditions-reference/#change_in
