---
Description: This guide shows you how to set up pre-flight checks run before each pipeline in Semaphore 2.0.
---

!!! warning "This feature is in the private beta stage and a part of the Semaphore Enterprise feature plan."
    Please contact our Customer Success for more details.


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
    - **Self Hosted Machines** - hosted by the customer (if applicable)

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

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute 
irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia 
deserunt mollit anim id est laborum.

### Limiting triggering promotions in your organization

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute 
irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia 
deserunt mollit anim id est laborum.