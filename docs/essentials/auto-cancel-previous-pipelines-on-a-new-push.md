---
Description: The auto-cancel strategy defines the behavior of pipelines when an execution queue forms. There are two auto-cancel strategies - running and queued.
---

# Auto-cancel previous pipelines on a new push

The *auto-cancel* strategy defines the behavior of pipelines when an execution queue forms.

By default, all pipelines will enter a First-In-First-Out (FIFO) queue and be executed in turn.

In some cases, this is not the optimal solution, especially if you consider the
following scenario:

We have all had situations where you push new changes, only to realize that you
missed something small, so you push a new revision immediately and then find
**another** mistake...

Without *auto-cancel* strategies, the only way to get immediate feedback on the
latest revision is to manually stop all pipelines from obsolete commits.

If you set up an auto-cancel strategy, however, this will be done automatically.
This means that you will get faster feedback on the revisions that matter.

There are two auto-cancel strategies: *running* and *queued*.

The *running* strategy stops all pipelines in the queue as soon as a new one appears.

The *queued* strategy will only cancel pipelines that are waiting in the queue, i.e. pipelines in the queue that are **not running**.
This option is ideal if you don't want to stop an execution that is underway.


## Auto-cancel queued pipelines on a new push

If your Git commit log looks like this:

``` txt
- commit C <- queued
- commit B <- queued
- commit A <- a workflow / pipeline is currently running for this revision
```
then when you push new commit 'D' with `.semaphore/semaphore.yml` updated as shown below:

``` yaml
version: "v1.0"
name: Build and test pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

auto_cancel:
  queued:
    when: "true" # enable auto-cancel for branches, tags and pull-requests

blocks:
  - name: Unit Tests
    task:
      jobs:
      - name: "Unit Tests"
        commands:
          - echo Testing...
```

the following will happen:

``` txt
- commit D <- queued, waiting for the pipeline from commit A to finish
- commit C <- canceled
- commit B <- canceled
- commit A <- pipeline running for this revision
```

The pipeline from the newest commit (D) will arrive at the top of the queue, canceling
all other pipelines that have yet to be run. In this case, pipelines from commits B and C.

The running pipeline, from commit A, will not be affected and will be
allowed to finish.
This will make sure that no execution time is wasted without providing feedback.

## Auto-cancel both running and queued pipelines on a new push

Let's say your Git commit log looks like this:

``` txt
- commit C <- queued
- commit B <- queued
- commit A <- a workflow / pipeline is currently running for this revision
```
If you push new commit 'D' with `.semaphore/semaphore.yml` updated as shown below:

``` yaml
version: "v1.0"
name: Build and test pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

auto_cancel:
  running:
    when: "true"

blocks:
  - name: Unit Tests
    task:
      jobs:
      - name: "Unit Tests"
        commands:
          - echo Testing...
```

the following will happen:

``` txt
- commit D <- pipeline running for newest revision
- commit C <- canceled
- commit B <- canceled
- commit A <- pipeline stopped
```

The execution of the pipeline from commit A will be stopped and the pipelines initiated
by commits B and C that were waiting in the queue will be canceled.

This will allow pipeline from newest commit (D) to start executing and provide you
with feedback as soon as possible after a push.

## Auto-cancel all pipelines on a new push to a non-master branch

The auto-cancel strategy is ideal for feature branches during development.
However, it isn't suitable for the master branch of your project, where there are
potentially further steps in a workflow that should not be missed for any commit.

By changing the `when` condition to `branch != 'master'`, we can set a policy
that activates auto-canceling only for pipelines from non-master branches.

``` yaml
version: "v1.0"
name: Build and test pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

auto_cancel:
  running:
    when: "branch != 'master'"

blocks:
  - name: Unit Tests
    task:
      jobs:
      - name: "Unit Tests"
        commands:
          - echo Testing...
```

## See also

- [Auto-cancel pipeline YAML property](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#auto\_cancel)
- [Defining 'when' conditions](https://docs.semaphoreci.com/reference/conditions-reference/)
