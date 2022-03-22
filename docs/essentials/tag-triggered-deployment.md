---
Description: This guide shows you how to use Semaphore to set up automatic deployment for each new tagged commit in your repository.
---

# Tag-triggered Deployment

This guide shows you how to use Semaphore to set up automatic deployment for
each new tagged commit in your repository.

For this guide you will need:

- A working Semaphore project
- A basic CI pipeline defined in your `.semaphore/semaphore.yml` file. You can use one
of the documented use cases or language guides as a starting point.
- A deployment pipeline defined in your `.semaphore/deployment.yml` file. You can find
examples for deployments to AWS, DockerHub, Kubernetes cluster, etc. in our
documentation.

## Setting up automatic deployment on a new tag

Let's say that your CI pipeline looks something like this:

```yaml
version: v1.0
name: CI pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Run tests"
    task:
      jobs:
        - name: "Tests"
          commands:
            - checkout
            - make test
```

In order to automatically promote this pipeline to the deployment phase defined in
your deployment pipeline, you need to expand it with [promotions][promotions], 
as shown below:

```yaml
promotions:
  - name: Deployment to production
    pipeline_file: deployment.yml
    auto_promote:
      when: "result = 'passed' and tag =~ '.*'"
```

Here we have defined the condition in the `when` sub-field of the `auto_promote` 
field and the deployment pipeline will be automatically triggered if it is fulfilled.

The condition in the example above will be fulfilled when tests in the main CI
pipeline pass and the whole workflow was triggered for a tag.

You can learn more about ways to express conditions [here][conditions].

## Full examples for CI and deployment pipelines

Here is the full CI pipeline example with the promotions block included:

```yaml
version: v1.0
name: CI pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Run tests"
    task:
      jobs:
        - name: "Tests"
          commands:
            - checkout
            - make test
promotions:
  - name: Deployment to production
    pipeline_file: deployment.yml
    auto_promote:
      when: "result = 'passed' and tag =~ '.*'"
```

And here is the basic deployment pipeline example:

```yaml
version: v1.0
name: Deployment to production
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Deployment"
    task:
      jobs:
        - name: "Build and deploy"
          commands:
            - checkout
            - make deploy
```

## See also

- [Semaphore guided tour][guided-tour]
- [Project workflow trigger options][wf-trigger-options]
- [Pipelines reference][pipelines-ref]

[promotions]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
[conditions]: https://docs.semaphoreci.com/reference/conditions-reference/
[guided-tour]: https://docs.semaphoreci.com/guided-tour/getting-started/
[wf-trigger-options]: https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/
[pipelines-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
