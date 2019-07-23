# Fail-Fast: Stop running tests on first failure

There are two strategies for running CI tests. A developer either wants to get
a comprehensive report on all failures in a test suite, or to get an fast
feedback from the system and fail everything immediately on first failure.

Semaphore by default runs all the jobs and prepares a comprehensive report for
your pipeline. By setting a Fail-Fast strategy in your pipelines you can control
this policy and get a fast response from the system.

Two Fail-Fast strategies can be defined:

- A 'stop' strategy that stops everything in your pipeline as soon as a failure
  is detected.

- A 'cancel' strategy that stops only the jobs and blocks in your pipeline that
  haven't yet started. This option is ideal if you don't want to stop an already
  started test execution.

[Stopping all jobs in a pipeline on first failure]()
[Stopping all jobs in a pipeline on first failure only on the master branch]()
[Stop vs. Cancel strategies]()
[See also](#see-also)

## Stopping all jobs in a pipeline on first failure

To stop all the jobs in a pipeline on first failure, define the fail-fast stop
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
    when: "branch =~ '.*'"

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

If 'Unit Test 1/2' fail in the above pipeline, the 'Unit Test 2/2' will be
immediately stopped.

## Stopping all jobs in a pipeline on first failure only on the master branch

Often the fail-fast behavior is ideal for feature branches during development,
but it is not ideal for the master branch of your project where you want to
get a comprehensive report on all the issues.

By changing the `when` condition to `branch != 'master'` in the above pipeline,
we can activate the fail-fast policy only for non-master branches.

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

## Stop vs. Cancel Fail-Fast strategies

Sometimes it is not desirable to stop everything in a pipeline. Instead, we
would like to allow already running jobs and blocks to finish, but prevent new
ones from starting.

In these scenarios, the 'cancel' strategy can be configured for your pipelines.

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

In the above scenario, if linting fails but the unit tests have already started,
we will not break them in the middle of the execution and instead wait for the
full report.

The Security Scan and Integration Tests will not be started.

# See also

- [Fail-Fast pipeline YAML property]()
- [Defining 'when' conditions]()
