Each project starts with the default pipeline specified in
`.semaphore/semaphore.yml`. Real world pipelines tend to branch out
when certain conditions are meant. Examples may be deploying to
production on master builds or deploying to a dev environment on topic
branches. Promotions may be automatic or manual.

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

Users will see a "Production Deploy" button once the pipeline
completes. Promotions may also be [triggered
automatically][auto-promotions]. Let's add another that automatically
promotes builds to staging.

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

Auto-promotions may be also combined with branches. Here's how to
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

There's one last thing to cover: [caching dependencies][next].

[auto-promotions]: https://docs.semaphoreci.com/article/50-pipeline-yaml#auto_promote_on
[next]: https://docs.semaphoreci.com/article/68-caching-dependencies
