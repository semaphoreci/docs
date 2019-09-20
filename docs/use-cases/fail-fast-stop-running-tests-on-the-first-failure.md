On Semaphore, a fail-fast strategy means that you get instant feedback when a
job fails. All the running jobs of a pipeline are stopped as soon as one of
the jobs fails. You don't need to wait for all the other jobs to get feedback.

There are two fail-fast strategies: *stop* and *cancel*.

The *stop* strategy stops everything in your pipeline as soon as a failure
is detected.

The *cancel* strategy stops only the jobs and blocks in your pipeline that
haven't yet started. This option is ideal if you don't want to stop an already
started test execution.

- [Stopping all jobs on the first failure](#stopping-all-jobs-on-the-first-failure)
- [Stopping all jobs on the first failure on non-master branches](#stopping-all-jobs-on-the-first-failure-on-non-master-branches)
- [Canceling all jobs on the first failure](#canceling-all-jobs-on-the-first-failure)
- [See also](#see-also)

## Stopping all jobs on the first failure

To stop all the jobs in a pipeline on the first failure, set a fail-fast stop
policy in your pipeline YAML files.

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

If 'Unit Test 1/2' fails in the above pipeline, the 'Unit Test 2/2' is stopped.

## Stopping all jobs on the first failure on non-master branches

Often the fail-fast strategy is ideal for feature branches during development.
However, it isn't suitable for the master branch of your project, where a full
report is better suited.

By changing the `when` condition to `branch != 'master'` we can set a policy
that activates fail-fast only for non-master branches.

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

Sometimes it is not desirable to stop everything in a pipeline. Instead, we
would like to allow already running jobs and blocks to finish, but prevent new
ones from starting.

For these scenarios, configure the 'cancel' strategy for your pipelines.

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
we will not break them in the middle of the execution.

The Security Scan and Integration Tests are canceled.

# See also

- [Fail-Fast pipeline YAML property](https://docs.semaphoreci.com/article/50-pipeline-yaml#fail\_fast)
- [Defining 'when' conditions](https://docs.semaphoreci.com/article/142-conditions-reference)
