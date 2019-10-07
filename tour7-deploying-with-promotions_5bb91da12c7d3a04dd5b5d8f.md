Each Semaphore project starts with the default pipeline specified in
`.semaphore/semaphore.yml`. Real world pipelines tend to branch out
when certain conditions are met. Examples may be deploying to production on
master builds or deploying to a pre-production environment on topic branches.

On Semaphore 2.0, deployment and delivery is managed with _promotions_, which
may be performed automatically or manually and may optionally depend on
user-defined conditions.

## Manual deployment

Let's start by adding a manual confirmation to promote to production.

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Promotions and Auto-promotions
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Promotions
    task:
      jobs:
        - name: Everything
          commands:
            - echo 'Running tests'
promotions:
  - name: Production deploy
    pipeline_file: production-deploy.yml
```

Now create a new pipeline file in `.semaphore/production-deploy.yml`:

``` yaml
# .semaphore/production-deploy.yml
version: v1.0
name: Deploy to production
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Deploy
    task:
      jobs:
        - name: 'Everything'
          commands:
            - echo 'Deploying to production!'
```

In the Semaphore 2.0 web interface, you will see a Production Deploy button.
You can promote the Production Deploy target from the UI at any point, even
while the pipeline that owns that target is still running.

When you promote a revision, Semaphore records the time and name of the person
who initiated it and proceeds by executing the pipeline defined in
`production-deploy.yml`.

Note that [all pipeline features][pipeline-reference] are available in delivery
pipelines, same as in `semaphore.yml`. This enables you to chain multiple
pipelines together and automate complex workflows.

## Continuous deployment with auto-promotions

Promotions can also be [triggered automatically][auto-promotions].
Let's create another that automatically promotes builds to staging.

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Promotions and Auto-promotions
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Promotions
    task:
      jobs:
        - name: Everything
          commands:
            - echo 'Running tests'
promotions:
  - name: Production deploy
    pipeline_file: production-deploy.yml
  - name: Staging deploy
    pipeline_file: staging-deploy.yml
    auto_promote:
      when: "result = 'passed'"
```

Next, create the required `staging-deploy.yml` file:

``` yaml
# .semaphore/staging-deploy.yml
version: v1.0
name: Promotions and Auto-promotions
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Deploy
    task:
      jobs:
        - name: Staging
          commands:
            - echo 'Deploying to staging!'
```

### Continuous deployment on specific branch

Auto-promotions can also be associated to specific branches. Here's how to
automatically promote passed builds on the `master` branch:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Promotions and Auto-promotions
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Promotions
    task:
      jobs:
        - name: Everything
          commands:
            - echo 'Running tests'

promotions:
  - name: Production deploy
    pipeline_file: production-deploy.yml
    auto_promote:
      when: "result = 'passed' and branch = 'master'"
  - name: Staging deploy
    pipeline_file: staging-deploy.yml
    auto_promote:
      when: "result = 'passed'"
```

Promotions are powerful tools to build up complex multi-pipeline
workflows. Refer to the [promotions reference][reference] for complete
information.

## Next steps

This chapter concludes the guided tour of Semaphore. Hopefully you're now able
to see what Semaphore can do and how it could help improve your development
workflow.

As a next step, we recommend that you put this new knowledge to use by setting
up CI/CD pipelines for some of your existing projects. Use links in this guide
and the rest of the documentation to find answers to the questions that you
have along the way.

Happy building!

[auto-promotions]: https://docs.semaphoreci.com/article/50-pipeline-yaml#auto_promote
[pipeline-reference]: https://docs.semaphoreci.com/article/50-pipeline-yaml
[reference]: https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions
[next]: https://docs.semaphoreci.com/article/68-caching-dependencies
