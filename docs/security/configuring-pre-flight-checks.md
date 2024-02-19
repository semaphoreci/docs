---
Description: This guide shows you how to set up pre-flight checks that run before each pipeline in Semaphore.
---

# Pre-flight checks

!!! plans "Available on: <span class="plans-box">Scaleup</span>"

Pre-flight checks are user-defined steps executed for each pipeline within the 
[pipeline initialization job](/reference/pipeline-initialization/). Their purpose is to provide 
users with a way to manually define commands before the execution of a pipeline, 
including (but not limited to):

- adding custom security checks,
- detailed dependency management,
- self-configured access control.

This feature comes with great potential and allows you to configure pipelines on a lower 
level. It can also serve as a last-resort check preventing further pipeline processing.

!!! warning "This feature might affect the execution of pipelines for the whole organization" 
    We advise caution when using this feature and encourage you to first get familiar with our product. 
    This feature could potentially affect the pipeline execution process of the entire organization. 
    Ill-defined pre-flights checks might lead to complete failure of your CI/CD pipelines.

As a security measure, pre-flight checks can only be modified by members of the organization who can:

- **manage organization settings** - organization pre-flight checks
- **manage project settings** - project pre-flight checks

## Configuring pre-flight checks

### Organization pre-flight checks

Follow the steps below to configure pre-flight checks for the whole organization:

1. Open **Settings** in the **Organization menu** on the right side of the page header.

2. Click **Initialization jobs** on the left side of the settings panel and scroll down to **Pre-flight checks**.

3. Type the **Commands** you would like to execute before each pipeline. 

4. Choose the **Secrets** you want to use in the **Commands**. 

5. Click the **Save changes** button.

To remove pre-flight checks from the organization, click the red button labeled
**Delete pre-flight checks**. This button should be visible if you have 
pre-flight checks configured.

### Initilization jobs configuration

Additionally, on the aforementioned page, you can [configure machines and OS images for initialization jobs](/reference/pipeline-initialization/#configuring-agents-for-intialization-job) across your organization:

You can choose from different machine types:

- **Linux-Based Virtual Machines** - hosted by Semaphore
- **Mac-Based Virtual Machines** - hosted by Semaphore
- **Self-Hosted Machines** - hosted by the customer (if applicable)

For machines hosted by Semaphore, choose a proper **Machine type** and **OS image** 
for the agent. 

For self-hosted machines choose the **Machine type** that matches your
self-hosted agent type.

### Project pre-flight checks

Enabling project pre-flight checks requires you to follow these steps:

1. Open the project page and go to the **Settings** tab.

2. Click **Pre-flight checks** on the left side of the settings panel.

3. Type the **Commands** you would like to execute before each pipeline.     

4. Choose the **Secrets** you want to use in the **Commands**. 

5. You can override the agent specification of initialization jobs for a project. Select **Override default agent specification** and choose the machine and/or OS image, same as shown [here](#initilization-jobs-configuration).

5. Click the **Save changes** button.

To remove pre-flight checks from the project, just click the red **Delete pre-flight checks** button.
This button should be visible if you have pre-flight checks configured.

## Examples of pre-flight checks configurations

### Limiting secret use in your organization

In the initialization job, the following information is available as environment variables:

- [the project name](/ci-cd-environment/environment-variables/#semaphore_project_name) for which the pipeline started
- [repository branch](/ci-cd-environment/environment-variables/#semaphore_git_branch) for which the pipeline started
- YAML file describing the running pipeline (`SEMAPHORE_YAML_FILE_PATH`)

Based on this, you can define commands in pre-flight checks to ensure that
a particular pipeline can use specific secrets. You can use this [snippet](https://raw.githubusercontent.com/renderedtext/snippets/master/check-secret.sh)
as a reference for how to achieve the desired result. In practice, using this for restricting 
`deployment-secret` secrets for pipelines defined in `.semaphore/deployment.yml`
in the `example-project` on the `master` branch comes down to the following commands:

```bash
curl https://raw.githubusercontent.com/renderedtext/snippets/master/check-secret.sh -o check-secret

bash check-secret "deployment-secret" "example-project" ".semaphore/deployment.yml" "master"
```

You can also combine this with [secrets](/essentials/using-secrets/) or cloned GitOps repositories,
as well as other [Semaphore Environment Variables](/ci-cd-environment/environment-variables)
to fine-tune commands for your particular use case.

You can also check out the [organization secrets access policy](/essentials/using-secrets/#organization-level-secrets-access-policy) or [project-level secrets](/essentials/using-secrets/#project-level-secrets), to see if they might be more suitable for your use case.

### Limiting promotion triggering in your organization

In the initialization job, the following information is available as environment variables:

- [Repository](/ci-cd-environment/environment-variables/#semaphore_git_repo_slug) for which the pipeline started
- [repository branch](/ci-cd-environment/environment-variables/#semaphore_git_branch) for which the pipeline started
- [boolean flag](/ci-cd-environment/environment-variables/#semaphore_pipeline_promotion) describing if the pipeline is an initial pipeline or a promotion
- [GitHub/Bitbucket username](/ci-cd-environment/environment-variables/#semaphore_pipeline_promoted_by) of a user who triggered the promotion

Based on that, you can define commands in pre-flight checks to ensure that the user who 
started a promotion has sufficient permission levels. As an example, let's demonstrate 
how to restrict the ability to promote a pipeline to a selected group of users:

```bash
printf '%s\n' 'user-1' 'user-2' 'user-3' > allowed_users.txt
user_is_allowed () { grep -Fxq $SEMAPHORE_PIPELINE_PROMOTED_BY allowed_users.txt; }
is_promotion () { [ $SEMAPHORE_PIPELINE_PROMOTION == "true" ]; }

if is_promotion; then if user_is_allowed; then echo "Promotion allowed."; else false; fi; else echo "Initial pipelines are allowed."; fi
```

The list of users might come from other sources, for example [secrets](/essentials/using-secrets)
or a cloned repository. It is also possible to extend the functionality
to restrict promotions from specific repository branches. 

Please note that Semaphore offers [Deployment Targets](/essentials/deployment-targets/) that allow you to secure your deployment strategies with restricting promotions for particular users, groups, and roles within your organization. 

### Dynamically editing your pipeline files

During the initialization job, two important variables are exported:

- `INPUT_FILE`: This variable points to the unmodified pipeline file, in this case, `semaphore.yml`.  
- `OUTPUT_FILE`: This variable refers to the fully compiled pipeline file created from the original file (`INPUT_FILE`) during the [pipeline initialization](https://docs.semaphoreci.com/reference/pipeline-initialization/).
Ultimately, Semaphore uses this compiled file to execute the defined pipeline.

By modifying the `OUTPUT_FILE`, it's possible to change the pipeline configuration for that particular run.

In the following example, we'll modify the number of parallel jobs in a block from 2 to 10, 
but only if the push that triggered the workflow contains changes in the `my_lib` directory:

```bash
my_lib_dir_changed () { spc list-diff --default-branch main | grep -q "^my_lib/"; }
increase_parallelism () { `sed -i 's/parallelism: 2/parallelism: 10/' $OUTPUT_FILE`; }

if my_lib_dir_changed; then increase_parallelism; fi
```
