Each project starts with the default pipeline specified in
`.semaphore/semaphore.yml`. Real world pipelines tend to branch out
when certain conditions are met. Examples may be deploying to
production on master builds or deploying to a pre-production environment
on topic branches.

On Semaphore deployment and delivery is managed with _promotions_, which may
be automatic or manual and optionally depend on conditions.

## Manual deployment

Let's start by adding a manual confirmation to promote to production.

<pre><code class="language-yaml"># .semaphore/semaphore.yml
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: Test
    task:
      jobs:
        - name: 'Everything'
          commands:
            - echo 'running tests'
promotions:
  - name: Production deploy
    pipeline_file: production-deploy.yml
</code></pre>

Now create a new pipeline file in `.semaphore/production-deploy.yml`:

<pre><code class="language-yaml"># .semaphore/production-deploy.yml
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
</code></pre>

In the Semaphore web interface, users will see a "Production Deploy" button
once all blocks in the pipeline defined in `semaphore.yml` pass.
When a user promotes a revision, Semaphore records the time and name of the
person who initiated it, and proceeds by executing the pipeline defined in
`production-deploy.yml`.

Note that [all pipeline features][pipeline-reference] are available in delivery
pipelines, same as in `semaphore.yml`. This enables you to chain multiple
pipelines together and automate complex workflows.

## Continuous deployment with auto-promotions

Promotions can also be [triggered automatically][auto-promotions].
Let's create another that automatically promotes builds to staging.

<pre><code class="language-yaml"># .semaphore/semaphore.yml
promotions:
  - name: Production deploy
    pipeline_file: production-deploy.yml
  - name: Staging deploy
    pipeline_file: staging-deploy.yml
    auto_promote_on:
      - result: passed
</code></pre>

Create the new `staging-deploy.yml` file:

<pre><code class="language-yaml"># .semaphore/staging-deploy.yml
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
            - echo 'Deploying to staging!'
</code></pre>

Auto-promotions can also be associated to specific branches. Here's how to
automatically promote passed builds on master:

<pre><code class="language-yaml"># .semaphore/semaphore.yml
promotions:
  - name: Production deploy
    pipeline_file: production-deploy.yml
    auto_promote_on:
      - result: passed
        branches:
          - master
  - name: Staging deploy
    pipeline_file: staging-deploy.yml
    auto_promote_on:
      - result: passed
</code></pre>

Promotions are powerful tools to build up complex multi-pipeline
workflows. Refer to the [promotions reference][reference] for complete
information.

## Next steps

This chapter concludes the guided tour of Semaphore. Hopefully you're now able
to see what Semaphore can do and how it could help improve your development
workflow.

As a next step, we recommend that you put this new knowledge to use by setting
up CI/CD pipelines for some of your existing projects. Use links in this guide
and rest of the documentation to find answers to the questions that you have
along the way.

Happy building!

[auto-promotions]: https://docs.semaphoreci.com/article/50-pipeline-yaml#auto_promote_on
[pipeline-reference]: https://docs.semaphoreci.com/article/50-pipeline-yaml
[reference]: https://docs.semaphoreci.com/article/50-pipeline-yaml#promotions
[next]: https://docs.semaphoreci.com/article/68-caching-dependencies
