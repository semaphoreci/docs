---
description: See how to assign pipelines to execution queues and run them sequentially or how to run them in parallel to save time.
---

# Pipeline Queues

Pipeline queues allow you to control which pipelines Semaphore must run
sequentially and which may run in parallel. For example, you may configure
consecutive pipelines to run in parallel on the main branch, while allowing
only one deployment to production to be running at any given time.

You can configure this behaviour via [queue][queue-reference] property in the
pipeline's YAML configuration file.

## Default behaviour

By default, Semaphore assigns pipelines to the same queue and runs them
sequentially if they are initiated from the same branch/tag/pull request with
the same configuration, e.g. multiple pushes or multiple promotions.

## Using queues for deployments

You can use queues to prevent parallel runs of
[deployment pipelines][deploying-with-promotions] that might cause issues in the
environment you deploy to.

If you are deploying projects independently one from another, you can use the
separate queues for each project by setting `scope: project` in the queue
configuration.

In the following example, we are configuring the deployment pipeline to run
sequentially in a queue called `Deployment queue`.

``` yaml
version: v1.0
name: Production deployment
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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
same Kubernetes cluster) you need the deployment pipelines from those projects to
queue together. To set that up, you should use the queue configurations with the
equal values for `name` and `scope` set to **organization** in all related projects.

The following example illustrates the queue configuration that can be used in all
projects that need to have a shared deployment queue.

``` yaml
version: v1.0
name: Project A deployment
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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

You can configure this via `processing` property of the queue configuration.

It is mostly useful for pipelines that are only running tests and when you want
to have results for each push to GitHub, e.g. on the main branch.

In case you only need the result of the pipeline from the latest push you might
want to consider the [auto-cancel][auto-cancel] feature.  

The following is the example of queue configuration that allows parallel pipelines:

``` yaml
version: v1.0
name: Tests
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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

In some cases, it is useful to have different queue behaviours for the same
pipeline on different branches. Similar to that, you might need only
tag-triggered pipelines to be assigned to a separate queue and the rest to behave
regularly.

Solution for those and similar cases is to have multiple queue configurations
that are only applicable if certain conditions are met. Semaphore supports this
option trough [conditional queue configurations][cond-queue-defs-reference].
Here's an example:

``` yaml
version: v1.0
name: Example project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

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

In this example, if the pipeline is triggered by a push to the master branch it
will be assigned to the queue called `Production`. This queue is defined in the
scope of the organization and it can be shared with other projects.

With that queue configuration, we will achieve that only one production deployment
is possible at any given time in the whole organization.

On the other hand, if the pipeline is triggered by any git tag it will be
assigned to the queue called `Image build queue` specific to that project.

That should ensure that images are built and pushed in chronological order.

The third configuration has a "catch-all" condition and it is applied if none of
the conditions from the previous configurations is true.

That is the case for all pipelines triggered by a push to any non-master branch
or any pull request so those pipelines will run in parallel.

## See also

- [Deploying with promotions][deploying-with-promotions]
- [Auto-cancel previous pipelines in the queue][auto-cancel]
- [Defining 'when' conditions](https://docs.semaphoreci.com/reference/conditions-reference)

[queue-reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#queue
[cond-queue-defs-reference]:https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#conditional-queue-configurations
[auto-cancel]: https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/
[deploying-with-promotions]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
