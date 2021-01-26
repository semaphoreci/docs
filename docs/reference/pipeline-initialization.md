# Pipeline Initialization

Every Semaphore pipeline goes through an initialization process during
which Semaphore fetches, evaluated, and verifies the Pipeline YAML file.

For pipelines that need a full clone of the Git repository for evaluation
(ex. pipelines that use [change-in][change-in] expressions), Semaphore runs a
job that clones the Git repository and evaluates the pipeline files. This job
has the following specification:

- It uses an e1-standard-2 / ubuntu1804 agent.
- Its duration is limited to 10 minutes.

Pipelines that use dedicated initialization jobs for evaluation have an
"Initialization" step displayed on the Workflow Page.

[change-in]: https://docs.semaphoreci.com/reference/conditions-reference/#change_in
