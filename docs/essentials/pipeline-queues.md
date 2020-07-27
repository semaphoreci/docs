---
description: See how to assign pipelines to different execution queues in order
to control access to some external resource or how to configure them to run in
parallel to save time when such control is not needed.
---

# Pipeline Queues

The pipeline queues allow you to control which pipelines should be executed one
by one in order to control access to some singular resource and also which
pipelines could be run in parallel in order to save the time.

This behaviour is configured via [queue][queue-reference] property in the
pipeline's YAML configuration files.

If a queue is not configured in pipeline's YAML configuration, Semaphore will
automatically configure the default queue configuration for that pipeline.

## Default queue configuration

The pipelines are, by default, assigned to project-scoped queues based on the
git branch/tag name or pull request number and the YAML configuration file name.

This means that pipelines will only queue if they are initiated from the same
branch/tag/pull request with the same configuration, e.g. multiple pushes or
multiple promotions.

This behaviour is equivalent to the following explicit configuration:

``` yaml
queue:
  name: [branch/tag name or PR number]-[yaml-file-name]
  scope: project
  processing: serialized
```

where the values in brackets are replaced with actual values for a given pipeline.

*Note*: If you want to explicitly define the default queue behaviour in your YAML
configuration you should omit the `name` and `scope` properties and only configure
the desired type of `processing`.

## Queue scopes

The queues can be defined in the scope of the `project` or in the scope of the
`organization`.

This behaviour is configured with `scope` property of the queue configuration.

The pipelines from different projects assigned to the `organization-scoped`
queue with the same name will be queued together and executed one by one.

This is especially useful when you need to forbid parallel access to some external
resource, such as deployments to production servers or calling external APIs.

On the other hand, the `project-scoped` queues with the same names in different
projects are mutually independent and their pipelines will not be queued together.

This is useful when projects are deployed to different servers and they do not
need to be queued together.

## Running pipelines in parallel

In cases where pipeline runs are completely independent one from another, you
might want to run them in parallel to receive faster feedback.

This behaviour is configured with `processing` property of the queue configuration.

It is mostly useful for pipelines that are only running tests and when you want
to have results for each push to GitHub.

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

In some cases it is useful to have different queue behaviors for same pipeline
on different branches or maybe the tag-triggered pipelines should be assigned to
a separate queue etc.

Solution for these and similar cases is to have multiple queue configurations
that are only applicable if certain conditions are met.

The Semaphore supports this option trough [conditional queue configurations][cond-queue-defs-reference] as it is illustrated in the example bellow.

``` yaml
version: v1.0
name: Example project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

queue:
  - when: "branch = 'master'"
    name: production
    scope: organization

  - when: "tag =~ '.*'"
    name: image-build-queue

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

In this example the pipeline will be assigned to either organization-scoped queue
called `production` if it is triggered from master branch or to project-scoped
queue called `image-build-queue` if it is triggered from any git tag.

With that queue configuration we will achieve that only one deployment is
possible at any given time in the whole organization.

Similarly, tag-triggered pipelines in the same project will be queued which
should ensure that images are pushed in chronological order.

If neither of the conditions above is true (which is the case for all non-master
branches and pull request) the third configuration will be used since its
condition is always true and pipelines will be run in parallel.

## See also

- [Auto-cancel previous pipelines in the queue][auto-cancel]
- [Defining 'when' conditions](https://docs.semaphoreci.com/reference/conditions-reference)
- [Deploying with promotions](https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/)

[queue-reference]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#queue
[cond-queue-defs-reference]:https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#conditional-queue-configurations
[auto-cancel]: https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/
