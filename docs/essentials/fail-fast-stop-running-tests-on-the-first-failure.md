---
Description: The two fail-fast strategies -- stop and cancel -- help you get instant feedback when a job fails. This guide shows you how they work.
---

# Fail-Fast: Stop running tests on the first failure

On Semaphore, a fail-fast strategy means that you get instant feedback when a
job fails. All the jobs running in a pipeline can be stopped (and subsequent jobs canceled) when a job fails. You don't need to wait for all the other jobs to complete to get feedback.

There are two fail-fast strategies: *stop* and *cancel*.

The *stop* strategy stops everything in your pipeline as soon as a failure
is detected.

The *cancel* strategy only stops the jobs and blocks in your pipeline that
haven't yet started. This option is ideal if you don't want to stop a
test that is underway.

## Stopping all jobs on the first failure

To stop all the jobs in a pipeline on the first failure, set a fail-fast 'stop'
strategy in your pipeline YAML files, as shown below:

``` yaml
version: v1.0
name: Tests
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

fail_fast:
  stop:
    when: "true"  # enable strategy for branches, tags, and pull-requests

blocks:
  - name: Unit Tests
    task:
      jobs:
      - name: "Unit Tests 1/2"
        commands:
          - make test PARTITION=1

      - name: "Unit Tests 2/2"
        commands:
          - make test PARTITION=2
```

If 'Unit Test 1/2' fails in the above pipeline, 'Unit Test 2/2' is stopped immediately.

## Stopping all jobs on the first failure on non-master branches

Often, a fail-fast strategy is ideal for feature branches during development.
However, it isn't suitable for the master branch of your project, where a full
report would be more useful.

By changing the `when` condition to `branch != 'master'`, we can set a strategy
that activates fail-fast only for non-master branches, as shown below:

``` yaml
version: v1.0
name: Tests
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

fail_fast:
  stop:
    when: "branch != 'master'"

blocks:
  - name: Unit Tests
    task:
      jobs:
      - name: "Unit Tests 1/2"
        commands:
          - make test PARTITION=1

      - name: "Unit Tests 2/2"
        commands:
          - make test PARTITION=2
```

## Canceling all jobs on the first failure

Sometimes you don't want to stop everything in a pipeline when a job fails. You can allow running jobs and blocks to finish and prevent new ones from starting (if/when a job fails) using the 'cancel' strategy.

For such scenarios, configure the 'cancel' strategy for your pipelines, as shown below:

``` yaml
version: v1.0
name: Tests
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

fail_fast:
  cancel:
    when: "branch != 'master'"

blocks:
  - name: Linter
    dependencies: []
    task:
      jobs:
      - name: "Linter"
        commands:
          - make lint

  - name: Security Scan
    dependencies: ["Linter"]
    task:
      jobs:
      - name: "Security"
        commands:
          - make scan-for-vulnerabilities

  - name: Unit Tests
    dependencies: []
    task:
      jobs:
      - name: "Unit Tests 1"
        commands:
          - make test

  - name: Integration Tests
    dependencies: ["Unit Tests"]
    task:
      jobs:
      - name: "Unit Tests 1"
        commands:
          - make test
```

In the above scenario, if linting fails, but the unit tests have already started,
they will not be stopped in the middle of execution.

The Security Scan and Integration Tests, however, would be canceled.

## See also

- [Fail-Fast pipeline YAML property](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#fail\_fast)
- [Defining 'when' conditions](https://docs.semaphoreci.com/reference/conditions-reference/)
