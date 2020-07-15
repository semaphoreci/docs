---
description: This page shows how to store and access sensitive data such as API keys, passwords, certificates, SSH keys or other sensitive data.
---

# Secrets

This page shows how to store and access sensitive data such as API keys,
passwords, certificates, SSH keys other sensitive data.

## Overview

Secret is a organization level object that contains collection of environment
variables and files. Content of secret can be accessed in jobs that are part of
blocks or pipelines to which secret has be connected.

## Using secrets in jobs

### Web UI

1. Open project page.

2. Click **Edit Workflow** button.

3. Select block to which you want to connect secret.

4. Find **Secrets** section in the right sidebar.

5. Check secret that needs to be connected.

6. Click **Run the workflow** button and then **Start**.

### YAML

To connect secret to a particular block add [secrets property](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#secrets) like in example:

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

To connect secret to all jobs in the pipeline use
[global_job_config](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#global_job_config) like in
the example:

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

1. Open dashboard of your organization.

2. Click **Secrets** in the sidebar. Find it in the **Configuration** section.

3. Click **Create New Secret** button.

4. Enter your secret information:
   * Specify **Name**
   * Enter environment variable name and value
   * Enter destination file path and upload file

5. Click **Save Changes**

### CLI

Use the [sem create
secret](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-create)
command:

```
sem create secret blue-secret -e AWS_KEY=a1b2 -e AWS_SECRET=r2d2
```

To create secret that also contains a file use:

```
sem create secret red-secrets -e AWS_KEY=a1b2 -f /Users/john/key.pem:/home/semaphore/key.pem
```

To view secret use:

```
sem get secret blue-secret
```

To edit secret use:

```
sem edit secret blue-secret
```

For more information about managing secrets check [sem CLI Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/).


## See also

- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Secrets YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/)
