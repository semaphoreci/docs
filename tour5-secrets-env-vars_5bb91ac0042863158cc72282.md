Semaphore supports setting environment variables on a
[per-block][envvars-perblock] and [per-job level][envvars-perjob].
Here's an example which applies one to all jobs in the block:

``` yaml
# .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      env_vars:
        - name: GUIDED_TOUR
          value: "TRUE"
      jobs:
        - name: Lint
          commands:
            - echo "${GUIDED_TOUR}"
            - echo 'Linting code'
        - name: Unit
          commands:
            - echo "${GUIDED_TOUR}"
            - echo 'Unit tests'
```

## Managing sensitive data with secrets

Private information like API keys or deploy credentials shouldn't be
written in the pipeline definition file or elsewhere committed to source
control. On Semaphore you define these values as _secrets_ using the `sem` tool.
Secrets are shared by all projects in the organization.

Let's configure a secret for the `AWS_ACCESS_KEY_ID` and
`AWS_SECRET_ACCESS_KEY` environment variables. Start by creating a new
file called `aws-secret.yml`:

``` yaml
# aws-secret.yml
apiVersion: v1beta
kind: Secret
metadata:
  name: myapp-aws
data:
  env_vars:
    - name: AWS_ACCESS_KEY_ID
      value: "123"
    - name: AWS_SECRET_ACCESS_KEY
      value: "456"
```

Now create a secret resource with `sem`:

``` bash
$ sem create -f aws-secret.yml
```

We recommend that after this step you either remove the secret definition file,
or add it to your `.gitignore` list.

Now we can use the environment variables defined in our secret by referencing
the secret's `name` in the pipeline definition file. Just like regular
environment variables, secrets can be configured on the block or job level.

``` yaml
# .semaphore/semaphore.yml
blocks:
  - name: "Deploy"
    task:
      secrets:
        - name: myapp-aws
      jobs:
        - name: Push to S3
          commands:
            - echo "$AWS_ACCESS_KEY_ID"
            - echo "$AWS_SECRET_ACCESS_KEY"
```

### Storing files in secrets

Let's say that we've changed our mind and instead of environment variables,
we'd actually like to use configuration files, such as `.aws/config` and
`.aws/credentials`. We can store files in a secret too.

Using `sem`, we can edit any secret definition file. The following command will
fetch a secret and open its' current definition in your default editor:

``` bash
sem edit secret myapp-aws
```

Change the `data` section to define files:

``` yaml
# aws-secret.yml
apiVersion: v1beta
kind: Secret
metadata:
  name: myapp-aws
data:
  env_vars: []
  files:
  - path: /home/semaphore/.aws/config
    content: ICBzc2gtZHNzIEFBQUFCM...
  - path: /home/semaphore/.aws/credentials
    content: RudFlSSjh3cDNEWDdo...
```

In `content` you should paste the output of `base64 your-file`.
If you specify a relative path, the file will be mounted on a path
relative to `/home/semaphore/`.

Once you save and exit your editor, `sem` will automatically update
the secret on Semaphore.

### A shortcut for creating file-based secrets

There's also a quicker way of creating a new secret from local files.
In the following example, we source our local configuration files and tell
Semaphore to mount them in the job environment's home folder:

``` bash
sem create secret aws-secrets \
  --file ~/.aws/config:/home/semaphore/.aws/config \
  --file ~/.aws/credentials:/home/semaphore/.aws/credentials
```

You can inspect a secret's definition using:

``` bash
sem get secrets aws-secrets
```

## Next steps

By now you've learned a lot! These are the essentials which should guide you
in most use cases, but in case you need more information you can consult the
reference guides:

- [Secrets YAML reference][secrets]
- [sem command line tool reference][sem]

Now that you've learned how to configure environment variables and secrets,
you're ready to move on to [deploying with promotions][next].

[envvars-perblock]: https://docs.semaphoreci.com/article/50-pipeline-yaml#env_vars
[envvars-perjob]: https://docs.semaphoreci.com/article/50-pipeline-yaml#env_vars-in-jobs
[next]: https://docs.semaphoreci.com/article/67-deploying-with-promotions
[secrets]: https://docs.semaphoreci.com/article/51-secrets-yaml-reference
[sem]: https://docs.semaphoreci.com/article/53-sem-reference
