---
Description: This is the reference for the YAML grammar used for creating schedulers in Semaphore. A scheduler is basically a cron that can run a specified pipeline on a specified branch.
---

# Scheduler YAML Reference

This document is the reference for the YAML grammar used for creating Semaphore schedulers.

A `scheduler` is a cron that can run a specified pipeline on a specified branch.

A scheduler (along with its contents) is created per project and specifies the branch and pipeline along with the cron expression that will be used to run the pipeline.

## Properties

### apiVersion

The `apiVersion` property defines the version of the YAML grammar that will be used in the current YAML file. This documentation refers to the v1alpha version of the YAML grammar.

### kind

The `kind` property defines the purpose of the YAML file. For a YAML file that will be used for defining schedulers, the value of the `kind` property should be `Schedule`.

### metadata

The `metadata` property defines the metadata of the Scheduler YAML file. Currently, only the `name` and `id` propertys are allowed. `name` field contains name of the scheduler and `id` field contains UUID of the scheduler.
The `name` can not contain spaces and must be unique for all schedulers that exist under the same project.

### spec

The `spec` property defines the specification of the Scheduler. It contains the following fields:
- `project` - name of the project the scheduler is scoped to
- `branch` - name of the branch the scheduler will run the pipeline on
- `at` - cron expression that defines the times at which the pipeline will run
- `pipeline_file` - path to the pipeline file that will be used for runing the workflow

## Example

```yaml
apiVersion: v1.0
kind: Schedule
metadata:
  name: foo_name
  id: some-uuid
spec:
  project: my first
  branch: master
  at: "* * * "
  pipeline_file: .semaphore/cron.yml
```
