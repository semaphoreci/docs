Semaphore has flexible support for environment variables and secrets.
They may be configured for the task or job. This example applies to
all jobs in the block:

<pre><code class="language-yaml"># .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      env_vars:
        - name: CI
          value: "TRUE"
      jobs:
        - name: Lint
          commands:
            - echo "${CI}"
            - echo 'Linting code'
        - name: Unit
          commands:
            - echo "${CI}"
            - echo 'Unit tests'
        - name: Integration
          commands:
            - echo "${CI}"
            - echo 'Integration tests'
</code></pre>

Occasionally you'll need to customize a specific job:

<pre><code class="language-yaml"># .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      env_vars:
        - name: CI
          value: "TRUE"
      jobs:
        - name: Lint
          commands:
            - echo "$CI"
            - echo 'Linting code'
        - name: Unit
          commands:
            - echo "$CI"
            - echo 'Unit tests'
        - name: Integration
          commands:
            - echo "$CI"
            - echo "$OUTPUT_FORMAT"
            - echo 'Integration tests'
          env_vars:
            - name: OUTPUT_FORMAT
              echo: "json"
</code></pre>

Using environment variables inevitably leads to configuring secrets.
Secrets are private values like API keys or passwords. They shouldn't
be committed to source control or written directly into the pipeline.
Instead, they're created with the `sem` command line. Secrets are
shared by all projects in the organization. This makes it easier to
reuse shared secrets like AWS credentials or deploy keys.

Let's configure a secret for the `AWS_ACCESS_KEY_ID` and
`AWS_SECRET_ACCESS_KEY` environment variables. Start by creating a new
file named `aws-secret.yml`.

<pre><code class="language-yaml"># aws-secret.yml
apiVersion: v1alpha
kind: Secret
metadata:
  name: aws
data:
  env_vars:
    - name: AWS_ACCESS_KEY_ID
      value: "placholder"
    - name: AWS_SECRET_ACCESS_KEY
      value: "placeholder"
</code></pre>

Now create the secrets with `sem`:

```
$ sem create -f aws-secret.yml
```

Now list the secret's `name` in the pipeline file. Secrets may be
configured for the block or for the job just like environment
variables.

<pre><code class="language-yaml"># .semaphore/semaphore.yml
blocks:
  - name: "Deploy"
    task:
      env_vars:
        - name: AWS_DEFAULT_REGION
          value: ap-southeast-1
      secerts:
        - name: aws
      jobs:
        - name: Push to S3
          commands:
            - echo "$CI"
            - echo "$AWS_ACCESS_KEY_ID"
            - echo "$AWS_SECRET_ACCESS_KEY"
</code></pre>

Now that you can configure environment variable and secrets, you're
ready to move onto [deploying with promotions][next].

[next]: https://docs.semaphoreci.com/article/67-deploying-with-promotions
