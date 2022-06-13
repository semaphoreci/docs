---
Description: This guide shows you how to set up pre-flight checks run before each pipeline in Semaphore 2.0.
---

!!! warning "This feature is in the private beta stage and a part of the Semaphore Enterprise feature plan."

# Pre-flight checks

Pre-flight checks are user-defined steps executed for each pipeline within the 
[pipeline initialization job](pipeline-initialization). Their purpose is to provide 
users with a way to manually define necessary commands before the execution of a whole 
pipeline, including (but not limited to):

- adding custom security checks,
- detailed dependency management,
- self-configured access control.

This feature comes with great potential and allows to configure pipelines on a lower 
level. It can also serve as a last-resort check preventing further pipeline processing.

!!! warning "This feature might affect the execution of pipelines in the whole organization" 
    We expect anyone using this feature to comprehend how our product works. Please be aware 
    of potential ramifications from ill-defined pre-flight checks, including failure of all
    your CI/CD pipelines in Semaphore 2.0.

As a security feature, pre-flight checks can be modified only by people who can:

- **manage organization settings** - organization pre-flight checks,
- **manage project settings** - project pre-flight checks.

## Configuring pre-flight checks

### Organization pre-flight checks

Follow the steps below to configure pre-flight checks for the whole organization:

1. Open the **Settings** from the **Organization menu** in the right part of the page header.

2. Click **Pre-flight checks** on the left side of the settings view.

3. Type **Commands** to execute before each pipeline. 

4. Choose **Secrets** you want to use in **Commands**. 

5. Provide **Agent configuration** for pipeline initialization job. 

    You can choose between different machine types:

    - **Linux Based Virtual Machines** - hosted by Semaphore
    - **Mac Based Virtual Machines** - hosted by Semaphore
    - **Self-Hosted Machines** - hosted by the customer (if applicable)

    For machines hosted by Semaphore, choose a proper **Machine type** and **OS image** 
    of the agent. 
    
    For self-hosted machines choose a **Machine type** that matches your
    self-hosted agent type.

6. Click **Save changes** button.

To remove pre-flight checks for the whole organization, click the red button
**Delete pre-flight checks**, which should be visible if you have pre-flight checks
configured.

### Project pre-flight checks

Configuring project pre-flight checks requires you to follow these steps:

1. Open the project page and go to the **Settings** tab.

2. Click **Pre-flight checks** on the left side of the settings view.

3. Type **Commands** to execute before each pipeline.     

4. Choose **Secrets** you want to use in **Commands**. 

5. Click **Save changes** button.

To remove pre-flight checks for the project, just click **Delete pre-flight checks**
button, which should be visible if you have pre-flight checks configured.

## Examples of pre-flight checks configuration

### Limiting using secrets in your organization

In the initialization job, the following information is available as environment variables:

- [the project name](/ci-cd-environment/environment-variables/#semaphore_project_name) for which the pipeline started
- [repository branch](/ci-cd-environment/environment-variables/#semaphore_git_branch) for which the pipeline started
- YAML file describing the running pipeline (`SEMAPHORE_YAML_FILE_PATH`)

Based on that, you can define commands in pre-flight checks ensuring that
a particular pipeline can use certain secrets. You can use this [snippet](https://gist.githubusercontent.com/shiroyasha/49b57770371f4684a8a12bcec0047d7a/raw/b35e51953069dc1b21c62a41b8717aa5fb4bcf88/check-secret)
as a reference on how to achieve that result. In practice, using it for restricting 
`deployment-secret` secret for pipeline defined in `.semaphore/deployment.yml`
in the `example-project` on the `master` branch comes down to the following commands:

```bash
curl https://gist.githubusercontent.com/shiroyasha/49b57770371f4684a8a12bcec0047d7a/raw/b35e51953069dc1b21c62a41b8717aa5fb4bcf88/check-secret -o check-secret

bash check-secret "deployment-secret" "example-project" ".semaphore/deployment.yml" "master"
```

You can also combine it with [secrets](/essentials/using-secrets/) or cloned GitOps repository,
as well as other [Semaphore Environment Variables](/ci-cd-environment/environment-variables)
to fine-tune the commands to your particular use case. 

### Limiting triggering promotions in your organization

In the initialization job, the following information is available as environment variables:

- [GitHub repository](/ci-cd-environment/environment-variables/#semaphore_git_repo_slug) for which the pipeline started
- [repository branch](/ci-cd-environment/environment-variables/#semaphore_git_branch) for which the pipeline started
- [boolean flag](/ci-cd-environment/environment-variables/#semaphore_pipeline_promotion) describing if the pipeline is an initial one or a promotion
- [GitHub username](/ci-cd-environment/environment-variables/#semaphore_pipeline_promoted_by) of a person triggering the promotion

Based on that, you can define commands in pre-flight checks ensuring that a person who 
started a promotion is entitled to do so. As an example, we'll demonstrate how to restrict
the possibility of promoting to a selected group of users:

```bash
printf '%s\n' 'user-1' 'user-2' 'user-3' > allowed_users.txt
user_is_allowed () { grep -Fxq $SEMAPHORE_PIPELINE_PROMOTED_BY allowed_users.txt; }
is_promotion () { [ $SEMAPHORE_PIPELINE_PROMOTION == "true" ]; }
if is_promotion && user_is_allowed; then echo "Promotion allowed."; else false; fi
```

The list of users might come from other sources, for example [secrets](/essentials/using-secrets)
or cloned repository. It is also possible to extend the functionality
to restrict promotions from particular repositories branches. 