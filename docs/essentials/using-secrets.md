---
Description: This page shows you how to use secrets to store and access sensitive data such as API keys, passwords, certificates, SSH keys, or other sensitive data.
---

# Secrets

This page shows you how to store and access sensitive data such as API keys,
passwords, certificates, SSH keys, etc. Semaphore uses "secrets" to accomplish this.

## Overview

Secrets are organization-level objects that contain environment
variables and files. The contents of secrets can be accessed in jobs that are part of
blocks or pipelines to which they have been connected.

## Using secrets in jobs

### Web UI

1. Open the project page

2. Click the **Edit Workflow** button

3. Select the block to which you want to connect the secret

4. Find the **Secrets** section in the right sidebar

5. Select the secret that you want to be connected

6. Click the **Run the workflow** button and then **Start**

### YAML

To connect a secret to a particular block add the [secrets property](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#secrets), as shown below:

```yaml
version: v1.0
name: My blue project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Test
    task:
      # Connect secret to all jobs in the block
      secrets:
        - name: blue-secret

      jobs:
      - name: Run tests
        commands:
          - checkout
          - make test
```

To connect a secret to all jobs in a pipeline use
[global_job_config](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#global_job_config), as shown below:

```yaml
version: v1.0
name: My blue project
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

global_job_config:
  # Connect secret to all jobs in the pipeline
  secrets:
    - name: blue-secret

blocks:
  ...
```

## Creating and managing secrets

### Web UI

1. Open the dashboard of your organization

2. Click **Secrets** in the sidebar -- you can find it in the **Configuration** section

3. Click the **Create New Secret** button

4. Enter your secret information:
   * Specify **Name**
   * Enter the environment variable's name and value
   * Enter the destination file path and upload the file

5. Click **Save Changes**

### CLI

The [sem create
secret](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-create)
command, shown below:

```
sem create secret blue-secret -e AWS_KEY=a1b2 -e AWS_SECRET=r2d2
```

Can be used to create a secret that also contains a file, as shown below:

```
sem create secret red-secrets -e AWS_KEY=a1b2 -f /Users/john/key.pem:/home/semaphore/key.pem
```

To view a secret use:

```
sem get secret blue-secret
```

To edit a secret use:

```
sem edit secret blue-secret
```

For more information about managing secrets check the [sem CLI Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/).


## See also

- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Secrets YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/)
