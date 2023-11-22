---
Description: This page shows you how to use secrets to store and access sensitive data such as API keys, passwords, certificates, SSH keys, etc.
---

# Secrets

<div class="docs-video-wrapper">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/rAJIRX81DeA?si=sZepLMUyVtBP6yqj" title="Getting Started with Semaphore - How to Use Secrets" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</div>

This page shows you how to store and access sensitive data such as API keys,
passwords, certificates, SSH keys, etc. Semaphore uses "secrets" to accomplish this.

## Overview

Secrets are organization-level or project-level objects that contain environment
variables and files. The contents of secrets can be accessed in jobs that are part of
blocks or pipelines to which they have been connected.

### Organization-level secrets access policy

Organizations with the Startup plan or higher 
have additional control over the secrets access policy. It is possible to add a project 
whitelist so a given secret is available for only a subset of projects within the organization.
This can be achieved by setting the projects access policy to "Whitelisted" and providing a list 
of projects that can access the secret in question.
Another part of the access policy is the ability to restrict access to attach and to debug jobs. If you restrict 
attach access for a secret, then only authorized users can attach the secret to a running job.
Likewise, restricting debug jobs will prevent unauthorized users from starting any debug job that is attached to the secret.

### Project-level secrets
Project-level secrets are a feature available to organizations on 
the Startup plan or higher. 
These secrets are intended to securely store sensitive information, 
such as API keys, access tokens, and other credentials that are 
required to authenticate and authorize access to various services.

To access project-level secrets, you can navigate to the settings 
of your project and locate the "secrets" section. 
Here, you can define a new secret by providing a name and its value, 
which will be encrypted and securely stored by the platform. 
Once a project-level secret has been defined, it can be used 
in project workflows to provide access to sensitive information.

It's worth noting that if you define a secret with the same name 
at both the organization and project levels, and use it in a workflow, 
the project-level secret will take precedence over the organization-level secret. 

You can manage your project-level secrets in project settings in the "secrets" section.

## Using secrets in jobs

### Web UI

1. Open the project page

2. Click the **Edit Workflow** button

3. Select the block to which you want to connect the secret

4. Find the **Secrets** section in the right sidebar

5. Select the secret that you want to be connected

6. Click the **Run the workflow** button and then **Start**

### YAML

#### Organization secrets 

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

#### Project-level secrets

Project-level secrets are included in jobs same as organization-level secrets, just add the secret name
in the same way and the secret will be in your jobs. It is important to note that if organization-level 
and project-level secret with the same name are used simultaneously, the project-level secret will take precedence.

## Creating and managing secrets

When creating secrets, we recommend that you make them available to the smallest subset of projects possible. 
To do this, you can use access policies to control which projects can use which of the organization's secrets. 
Organization-level secrets let you share secrets between multiple projects, 
which reduces the need for creating duplicate secrets. Updating an organization secret in 
one location also ensures that the change takes effect in all projects that use that secret.
By default, all projects have access to secrets, but it is possible to restrict a secret to a specific subset of projects using
the project whitelist when creating a new secret, or editing an existing one.
To do this, choose **Whitelisted** and enter the project name(s).

### Web UI
#### Organization-level secrets

1. Open the dashboard of your organization

2. Click **Secrets** in the sidebar -- you can find it in the **Configuration** section

3. Click the **Create New Secret** button

4. Enter your secret information:
   * Specify **Name**
   * Enter the environment variable's name and value
   * Enter the destination file path and upload the file

5. Click **Save Changes**

#### Project-level secrets

Project-level secrets are managed from your project settings.

1. Navigate to your project

2. Open the settings of project you wish to add secrets to

3. Click **Secrets** in the sidebar -- you can find it in the **Configuration** section

4. Click the **Create New Secret** button

5. Enter your secret information:
   * Specify **Name**
   * Enter the environment variable's name and value
   * Enter the destination file path and upload the file

6. Click **Save Changes**


### CLI

#### Organization-level secrets
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

#### Project-level secrets

Project-level secrets can be managed same as organization secrets but with
`-p [project-name]` or `-i [project-id]` flags that specify the project 
scope of the secret, as shown below:
```
sem create secret -p <project-name> <secret-name> -e <variable1>=<value1> -e <variable2>=<value2> -f <file_path>:<destination_path>
```
To get the created secret 
```
sem get secret -p <project-name> <secret-name>
```

## See also

- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Secrets YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/)
