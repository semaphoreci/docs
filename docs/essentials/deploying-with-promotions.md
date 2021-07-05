---
description: Deployment and delivery is managed with promotions, which may be performed automatically or manually and may depend on user-defined conditions.
---

# Deploying With Promotions

Each Semaphore project starts with the default pipeline specified in
`.semaphore/semaphore.yml`. Real-world pipelines tend to branch out
when certain conditions are met. Examples may be deploying to production on
master builds or deploying to a pre-production environment on topic branches.

On Semaphore, deployment and delivery is managed with _promotions_, which
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

In the Semaphore web interface, you will see a Production Deploy button.
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
### Change-based continuous deployment

Pipelines can also be promoted on file change. When two or more independent
projects share a single repository, you may want to trigger different pipelines
depending on which project was modified in the recent commits. These is a pattern
typically found in [monorepo workflows][monorepo-workflows]. 

You can define what folders or files you're interested in deploying with `change_in`. 
Let's say you have an Android and an iOS application in the same repository.
In this case, each app must be deployed using a different pipeline. The following 
example shows two promotions:

- The *Android release* pipeline starts automatically when all jobs have passed on the `master` branch, and at least one file has changed in the `android` folder.
- The *iOS release* pipeline does the same when at least one file has changed in the `ios` folder.

In both cases, paths are relative the the repository's root.


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
  - name: Android release
    pipeline_file: android-deploy.yml
    auto_promote:
      when: "result = 'passed' and branch = 'master' and change_in('/android/')"
  - name: iOS release
    pipeline_file: ios-deploy.yml
    auto_promote:
      when: "result = 'passed' and branch = 'master' and change_in('/ios/')"
```

Note that `change_in` can also be used to run or skip blocks in the pipeline. 
For more information, consult the [change_in][change-in-ref] reference page.

Promotions are powerful tools to build up complex multi-pipeline
workflows. Refer to the [promotions reference][reference] for complete
information.

[auto-promotions]: ../reference/pipeline-yaml-reference.md#auto_promote
[pipeline-reference]: ../reference/pipeline-yaml-reference.md
[reference]: ../reference/pipeline-yaml-reference.md#promotions
[monorepo-workflows]: ../essentials/building-monorepo-projects.md
[change-in-ref]: ../reference/conditions-reference.md#change_in
