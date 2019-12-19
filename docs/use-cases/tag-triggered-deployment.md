# Tag-triggered Deployment

This guide shows you how to use Semaphore to set up automatic deployment for
each new tagged commit in your repository.

For this guide you will need:

- A working Semaphore project
- A basic CI pipeline defined in `.semaphore/semaphore.yml` file. You can use one
of the documented use cases or language guides as a starting point.
- A deployment pipeline defined in `.semaphore/deployment.yml` file. You can find
examples for deployment to AWS, DockerHub, Kubernetes cluster etc. in our
documentation.

## Set up automatic deployment on a new tag

Let say that your CI pipeline looks something like this:

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

In order to automatically promote this pipeline to deployment phase defined in
your deployment pipeline you need to expand it with [promotions][promotions]:

```yaml
promotions:
  - name: Deployment to production
    pipeline_file: deployment.yml
    auto_promote:
      when: "result = 'passed' and tag =~ '.*'"
```

Here we defined the condition in `when` sub-field of `auto_promote` field and if
it is fulfilled the deployment pipeline will be automatically triggered.

The condition in the example above will be fulfilled when tests in the main CI
pipeline pass and if the whole workflow was triggered for a tag.

You can find out more about ways to express conditions [here][conditions].

## Full examples for CI and deployment pipeline

Here is the full CI pipeline example with promotions block included:

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

[promotions]: https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions
[conditions]: https://docs.semaphoreci.com/article/142-conditions-reference
[guided-tour]: https://docs.semaphoreci.com/category/56-guided-tour
[wf-trigger-options]: https://docs.semaphoreci.com/article/152-project-workflow-tigger-options
[pipelines-ref]: https://docs.semaphoreci.com/article/50-pipeline-yaml
