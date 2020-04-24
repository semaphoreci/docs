# Environment Variables and Secrets

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
control. On Semaphore you define these values as _secrets_ using either
the `sem` CLI or through the web interface (Configuration part of the
sidebar -> Secrets).
Secrets are shared by all projects in the organization.

Let's configure a secret for the `AWS_ACCESS_KEY_ID` and
`AWS_SECRET_ACCESS_KEY` environment variables.

``` bash
sem create secret aws-secrets \
  -e AWS_ACCESS_KEY_ID=123 \
  -e AWS_SECRET_ACCESS_KEY=456
```

Now we can use the environment variables defined in our secret by referencing
the secret's `name` in the pipeline definition file. Just like regular
environment variables, secrets can be configured on the block or job level.

``` yaml
# .semaphore/semaphore.yml
blocks:
  - name: "Deploy"
    task:
      secrets:
        - name: aws-secrets
      jobs:
        - name: Push to S3
          commands:
            - echo "$AWS_ACCESS_KEY_ID"
            - echo "$AWS_SECRET_ACCESS_KEY"
```

### Storing files in secrets

Let's say that we've changed our mind and instead of environment variables,
we'd actually like to use configuration files, such as `.aws/config` and
`.aws/credentials`. We can store files in a secret too by passing a `-f` or
`--file` to `sem create`.


Provide the path to the local file and location where the remote file should
be mounted, separated by a colon. In the following example, we source our local
configuration files and tell Semaphore to mount them in the job environment's
home folder:

``` bash
sem create secret aws-secrets-with-files \
  -f ~/.aws/config:~/.aws/config \
  -f ~/.aws/credentials:~/.aws/credentials
```

If you specify a relative path, the file will be mounted on a path
relative to `/home/semaphore/` on Linux and `/Users/semaphore` on macOS.

### Editing files and environment variables in a secret

Using `sem`, we can edit any secret on Semaphore. For example let's say that we
want to edit the following secret:

``` bash
sem create secret example-secret \
  -e FOO=BAR \
  -f ~/hello.txt:~/hello.txt
```

To edit the secret use the following command that will fetch a secret and
open its' current definition in your default editor:

``` bash
sem edit secret aws-secrets
```

Change the `env_vars` and `files` in the bellow definition:

``` yaml
# aws-secret.yml
apiVersion: v1beta
kind: Secret
metadata:
  name: myapp-aws
data:
  env_vars:
  - name: FOO
    value: BAR
  files:
  - path: ~/hello.txt
    content: ICBzc2gtZHNzIEFBQUFCM...
```

Keep in mind that files are stored as Base64 encoded string. To update the
content, use `base64 <your-file>` to get its Base64 encoded version before
updating the definition file.

Once you save and exit your editor, `sem` will automatically update the secret
on Semaphore.

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

[envvars-perblock]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#env_vars
[envvars-perjob]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#env_vars-in-jobs
[next]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
[secrets]: https://docs.semaphoreci.com/reference/secrets-yaml-reference/
[sem]: https://docs.semaphoreci.com/reference/sem-command-line-tool/
