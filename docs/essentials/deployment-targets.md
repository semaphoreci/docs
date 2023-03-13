---
Description: Extend your Continuous Deployment process by access control, configuration management and transparent overview with Deployment Targets.
---

# Deployment Targets

!!! plans "Available on: <span class="plans-box">[Startup](/account-management/startup-plan/)</span> <span class="plans-box">[Scaleup](/account-management/scaleup-plan/)</span>"

!!! warning "Deployment Targets are in Technical Preview stage. Documentation and feature itself are subject to change."

**Deployment Targets** allow you to apply strict conditions on the start of ensuant pipelines. 
Using them, you gain the possibility to choose specific people capable of starting a promoted pipeline 
or select git references (branches and tags) for which this action is available. 

Combining the functionality of [promotions](/essentials/deploying-with-promotions/) and Deployment Targets, you obtain
the full toolset to configure **secure Continuous Deployment** pipelines, backward compatible with your previous setup.

The core advantage of using Deployment Targets is **multi-faceted access** control, taking many factors into account while
granting the right to promote. Moreover, they are backed with **a dedicated secret**, unique per each Deployment Target and
inaccessible outside Deployments. Last but not least, Deployment Targets gives you **a clear overview** of your previous
deployments, so you instantly know what version was shipped and who did that.

# Setup and configuration

Configuring Deployment Targets consists of two phases: **Deployment Target setup** and **pipeline YAML configuration**. This section goes into detail about the entire process.

## Deployment Target setup

First and foremost, you need a target that you will bind to promotions. **Deployments** project page is the place where you can browse, create, modify, and remove Deployment Targets.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/deployments-zero-state.png" alt="Create button in the zero state">

Click on the **Create new** button. If you cannot see it, please check your access rights. **Only project admins** can modify Deployment Targets. 

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-overview.png" alt="Deployment Target setup wizard overview">

The wizard should easily navigate you through the setup. You can come back to previous sections if you need to change anything. Once you finish the setup, confirm the result by clicking **Create** button.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/deployments-ready-targets.png" alt="Deployment Target tiles with Edit and Delete buttons">

If you need to modify any of those settings later on, go to the edit form by clicking on the **Edit** button in the top-right corner. You can also permanently remove the target and all the previously recorded deployments by clicking **Delete** button.

### Basic information

You should **provide the name** of your Target. Only alphanumeric characters with dashes and underscores are allowed. 

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-basics.png" alt="Deployments tab in project top menu">

Optionally, you can fill in the description and URL, which will be later used in the detailed view.

### Credentials

Deployment Targets are a safe space where you can store your credentials, in the same way as [Secrets](/essentials/using-secrets/). Those data may be in the form of:

- **environment variables** - in this case, please fill in a name and value,
- **files** - you should provide both a file path and an uploaded file.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-credentials.png" alt="Deployments tab in project top menu">

Provided credentials will be accessible only in pipelines started by promotions with the given Deployment Target. 

### User access control

!!! plans "Available only on <span class="plans-box">[Scaleup](/account-management/scaleup-plan/)</span>"

You can restrict the possibility of promoting with Deployment Target to particular project roles and people. By default, anyone with access to the project can trigger promotions.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-user-access.png" alt="Deployments tab in project top menu">

After clicking on the text area, a dropdown presents the list of available options. Start typing to filter for particular roles or users. You can also modify permissions for auto-promotions that will override pipeline YAML configuration.
### Git access control

Deployment Targets allow to restrict promotions from particular branches and tags. You can choose between a few options: **all**, **none** or **whitelisted**. You can also restrict deployments from pull requests.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-git-access.png" alt="Deployments tab in project top menu">

Whitelisting branches and/or tags may be configured in two ways:

- **Exact match** - branch/tag names are compared as regular strings,
- **Regex match** - branch/tag names are matched against Perl-compatible regular expressions. More information about the syntax can be found in the [documentation of Erlang _re_ module](https://www.erlang.org/doc/man/re.html).

## YAML pipeline configuration

Once the deployment target is set up, you need to **attach it to promotions** defined in `.yml` pipeline configuration file. We will explain two ways of doing that: directly modifying text files and through a graphical interface (Workflow Editor). 

### Configuring Deployment Targets with Workflow Editor

To start editing pipeline YAML, go to Workflow Editor. As you can see, a newly created Deployment Target contains a direct link to it (**Edit Workflow** button):  

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/deployments-ready-targets.png" alt="Deployment Target tiles with Edit Workflow link">

After clicking on the promotion, the right pane displays configuration options:

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/workflow-editor.png" alt="Configuring Deployment Targets with Workflow Editor">

If your organization has access to the feature, you should see the **Deployment target** section where you can select one of the options from a dropdown:

- **No target** means the promotion does not use Deployment Targets. Regular promotions are available to anyone with access to the project and you can start them from any workflow. Promotions will not use Deployment Target credentials.
- **Target: _target name_**. Choosing that option binds that target to the promotion. From now on, Deployment Target will secure the promotion by forbidding unauthorized use and providing credentials to the promoted pipeline. 

### Configuring Deployment Targets directly in the `.yml` files

Under the hood, binding promotion to a deployment target is described by `deployment_target` attribute of a promotion object in the YAML configuration. This attribute is optional: **no value** is equivalent to _No target_ option described above. Otherwise, you should put the **name of the deployment target**: 

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Deployment Targets

agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Promotions
    task:
      jobs:
        - name: Everything
          commands:
            - echo 'Running tests'

promotions:
  - name: Production
    pipeline_file: deploy_production.yml
    deployment_target: production
  - name: Staging
    pipeline_file: deploy_staging.yml
    deployment_target: staging
  - name: Development
    pipeline_file: deploy_development.yml
```

!!! warning "Anyone with write access to a repository can change `.yml` pipeline specifications"
    While storing credentials in the Deployment Target is not mandatory, it effectively blocks from trespassing established promotion settings. Only project admins can modify Deployment Targets. 

Once you finish binding, commit changes by clicking **Run the workflow** button in the top right corner and start your CI/CD workflow. 


# Usage 

After a couple of seconds, you should see the workflow page with promotions secured by Deployment Targets. Compared to regular promotions, they have a **lock icon** next to them. Allowed promotions have an open lock and enabled promotion button. On the contrary, a closed lock and disabled button indicate that you cannot start the pipeline.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/workflow-page.png" alt="Workflow page with promotions secured by Deployment Targets">

The most common reasons for blocking a promotion are:

- you don’t have the right to deploy to the bound Deployment Target,
- the workflow was run from a forbidden branch, tag, or pull request,
- you are not logged in and/or you are viewing a build of a public project.

However, there are a few, less probable situations when promotions are denied, for example:

- Deployment Target is synchronizing (and it takes longer than usual),
- Deployment Target has failed to synchronize with Secret storage,
- Deployment Target used for that workflow has been removed.

Auto-promotions configured in the pipeline `.yml` file and forbidden by Deployment Target will not be shown on the workflow page, although Deployment History will register the attempt. Apart from mentioned differences, promotions with Deployment Targets act the same as the regular ones.

Your previous deployments can be tracked from the **Deployments** page. As of now, Deployment Target tiles contain data about the latest deployment (who and when started it, which commit was used, which workflow it belongs to). We plan to provide you with full **Deployment History** very soon.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/deployments-ready-targets.png" alt="Deployment Target tiles with Last Deployment information">

You can also [use our Public API (alpha)](reference/api-v1alpha/#triggering-a-promotion) to trigger promotions. If promotion is forbidden by Deployment Target, you will receive an HTTP `400 Bad Request` response with a reason as a body.

