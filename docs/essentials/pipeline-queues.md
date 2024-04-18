---
Description: This document shows how to assign pipelines to execution queues and run them sequentially or in parallel.
---

# Pipeline Queues

Pipeline queues allow you to control which pipelines Semaphore runs
sequentially and/or in parallel. For example, you can configure
consecutive pipelines to run in parallel on the main branch, while allowing
only one deployment to production to be running at any given time.

You can configure this behaviour via the [queue][queue-reference] property in the
pipeline's YAML configuration file.

## Default behaviour

By default, Semaphore assigns pipelines to the same queue and runs them
sequentially if they are initiated from the same branch/tag/pull request with
the same configuration, e.g. multiple pushes or multiple promotions.

## Using queues for deployments

You can use queues to prevent parallel runs of
[deployment pipelines][deploying-with-promotions] that might cause issues in the
environment you are deploying to.

If you are deploying projects independently one from another, you can use
separate queues for each project by setting `scope: project` in the queue
configuration.

In the following example, we configure the deployment pipeline to run
sequentially in a queue called `Deployment queue`.

``` yaml
version: v1.0
name: Production deployment
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

queue:
  name: Deployment queue
  scope: project

blocks:
  - name: Deploy
    task:
      jobs:
      - commands:
          - make deploy
```

In cases where multiple projects are deployed to the same environment (e.g.
to the same Kubernetes cluster) you need the deployment pipelines of those projects to
queue together. To set that up, use queue configurations with equal values 
for `name` and `scope` set to **organization** in all related projects.

The following example illustrates a queue configuration that can be used for
projects that need to have a shared deployment queue.

``` yaml
version: v1.0
name: Project A deployment
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

queue:
  name: Shared deployment queue
  scope: organization

blocks:
  - name: Deploy
    task:
      jobs:
      - commands:
          - make deploy
```

## Running pipelines in parallel

In cases where pipeline runs are completely independent one from another, you
might want to run them in parallel to receive faster feedback.

You can configure this via the `processing` property of the queue configuration.

This is mostly useful for pipelines that are only running tests and when you want
to have results for each push to the repository, e.g. on the main branch.

In the event that you only need the result of the pipeline from the latest push, you might
want to consider the [auto-cancel][auto-cancel] feature.  

The following is an example of a queue configuration that allows parallel pipelines:

``` yaml
version: v1.0
name: Tests
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

queue:
  processing: parallel

blocks:
  - name: Unit Tests
    task:
      jobs:
      - commands:
          - make test
```

## Conditional queue configurations

In some cases, it is useful to have different queue behaviours for different branches of 
the same pipeline. Similarly, you might only need to assign tag-triggered pipelines 
to a separate queue and let the rest to behave normally.

The solution for such cases is to have multiple queue configurations
that are only applicable if certain conditions are met. Semaphore supports this
option via [conditional queue configurations][cond-queue-defs-reference].
Here's an example:

``` yaml
version: v1.0
name: Example project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

queue:
  - when: "branch = 'master'"
    name: Production
    scope: organization

  - when: "tag =~ '.*'"
    name: Image build queue

  - when: true
    processing: parallel

blocks:
  - name: Unit Tests
    task:
      jobs:
      - commands:
          - make test

  - name: Build and push image
    run:
      when: "branch = 'master' or tag =~ '.*'"
    task:
      jobs:
      - commands:
          - make image.build
          - make image.push

  - name: Deploy to production
    run:
      when: "branch = 'master'"
    task:
      jobs:
      - commands:
          - make deploy
```

In this example, if the pipeline is triggered by a push to the master branch, it
will be assigned to the queue called `Production`. This queue is defined within the
scope of the organization and can be shared with other projects.

With this queue configuration, only one production deployment
is possible at any given time for the whole organization.

If the pipeline is triggered by a git tag, however, it will be
assigned to the queue called `Image build queue`, which is specific to that project.

This should ensure that images are built and pushed in chronological order.

The third configuration has a "catch-all" condition that is applied if none of
the conditions from the previous configurations is true.

This is the case for all pipelines triggered by a push to any non-master branch
or any pull request, and it means that those pipelines will be run in parallel.

## See also

- [Deploying with promotions][deploying-with-promotions]
- [Auto-cancel previous pipelines in the queue][auto-cancel]
- [Defining 'when' conditions](https://docs.semaphoreci.com/reference/conditions-reference/)

[queue-reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#queue
[cond-queue-defs-reference]:https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#conditional-queue-configurations
[auto-cancel]: https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/
[deploying-with-promotions]: https://docs.semaphoreci.com/essentials/deploying-with-promotions/
