---
Description: Extend your Continuous Deployment process with access control, configuration management and transparent overview with Deployment Targets.
---

# Deployment Targets

!!! plans "Available on: <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

**Deployment Targets** allow you to apply strict conditions for who can start individual pipelines and under which conditions. 
Using them, you have the ability to control who has the ability to start specific promoted pipelines
or select git references (branches and tags). 

Combining the functionality of [promotions](/essentials/deploying-with-promotions/) and Deployment Targets gives you
a full toolset to configure **secure Continuous Deployment** pipelines. This is backwards compatible with your previous setup.

The core advantage of using Deployment Targets is **multi-faceted** access control, i.e. taking many factors into account while
granting the right to promote. Moreover, they are backed with a **dedicated secret**, unique per Deployment Target and
inaccessible to outside Deployments. Last but not least, Deployment Targets give you a **clear overview** of your previous
deployments, so you can see which version was shipped and by whom.

# Setup and configuration

Configuring Deployment Targets consists of two phases: **Deployment Target setup** and **pipeline YAML configuration**. This section goes into detail about the entire process.

## Deployment Target setup

First and foremost, you need a target that you will bind to promotions. The **Deployments** project page is where you can browse, create, modify, and remove Deployment Targets.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/deployments-zero-state.png" alt="Create button in the zero state">

Click on the **Create new** button to create a new Deployment Target. If you cannot see this button, please check your access rights. Only **project admins** can create/modify/delete Deployment Targets. 

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-overview.png" alt="Deployment Target setup wizard overview">

The wizard easily navigates you through the setup. You can come back to previous sections if you need to change anything. Once you finish the setup, confirm the result by clicking the **Create** button.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/deployments-ready-targets.png" alt="Deployment Target tiles with Edit and Delete buttons">

If you need to modify any settings later on, you can do so by clicking on the **Edit** button in the top-right corner. You can also permanently remove targets and all previously recorded deployments using the **Delete** button. Additionally, you can _deactivate_ and _activate_ your targets (links next to the status box) to block promotions in any case.

### Basic information

You must **provide a name** for a new Target. Only alphanumeric characters with dashes and underscores are allowed. 

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-basics.png" alt="Deployments tab in project top menu">

Optionally, you can fill in the description and URL, which will be later used in the detailed view.

If you plan to use parameterized promotions with Deployment Targets, you can pass up to three parameters to index your future deployments. You will be able to filter Deployment History by their value. 

### Credentials

Deployment Targets are a secure space where you can store credentials, in the same way as [Secrets](/essentials/using-secrets/). These data may be in the form of:

- **environment variables** - in this case, please fill in a name and value
- **files** - you should provide both a file path and an uploaded file

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-credentials.png" alt="Deployments tab in project top menu">

Provided credentials will be accessible only in pipelines started by promotions associated with a given Deployment Target. 

### User access control

!!! plans "Available only on <span class="plans-box">Scaleup</span>"

You can restrict the possibility of promoting with Deployment Target to specific project roles and users. By default, anyone with access to the project can trigger promotions.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-user-access.png" alt="Deployments tab in project top menu">

After clicking on the text area, a dropdown menu presents the list of available options. In it, you can filter for particular roles or users. You can also modify permissions for auto-promotions that will override pipeline YAML configurations.

### Git access control

Deployment Targets allow you to restrict promotions from particular branches and tags. You can choose between several options: **all**, **none**, or **whitelisted**. You can also restrict deployments from pull requests.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/wizard-git-access.png" alt="Deployments tab in project top menu">

Whitelisting branches and/or tags may be configured in two ways:

- **Exact match** - branch/tag names are compared as regular strings
- **Regex match** - branch/tag names are matched against Perl-compatible regular expressions. More information about the syntax can be found in the [Erlang _re_ module documentation](https://www.erlang.org/doc/man/re.html)

## YAML pipeline configuration

Once the deployment target is set up, you need to **attach it to one or more promotions**, defined in `.yml` pipeline configuration file. There are two ways of doing this: directly modifying text files and using a graphical interface (Workflow Editor). 

### Configuring Deployment Targets with Workflow Editor

To start editing pipeline YAML, go to the Workflow Editor. As you can see, newly-created Deployment Targets contain direct links to them (**Edit Workflow** button):  

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/deployments-ready-targets.png" alt="Deployment Target tiles with Edit Workflow link">

After clicking on the promotion, the right pane displays configuration options:

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/workflow-editor.png" alt="Configuring Deployment Targets with Workflow Editor">

If your organization has access to the feature, you should see the **Deployment target** section, where you can select from the following options from a dropdown menu:

- **No target** means the promotion does not use Deployment Targets. Regular promotions are available to anyone with access to the project and you can start them from any workflow. Promotions will not use Deployment Target credentials.
- **Target: _target name_**. Choosing this option binds a target to a promotion. From now on, the Deployment Target will secure the promotion by forbidding unauthorized use and providing credentials to the promoted pipeline. 

### Configuring Deployment Targets directly in `.yml` files

Under the hood, binding promotion to a deployment target is described by the `deployment_target` attribute of a promotion object in the YAML configuration. This attribute is optional: **no value** is equivalent to the _No target_ option described above. Otherwise, you should enter the **name of the deployment target**, like in the example below: 

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
    While storing credentials in a Deployment Target is not mandatory, it effectively blocks anyone without the proper permissions from meddling with established promotion settings. As stated earlier, only project admins can modify Deployment Targets. 

Once you finish binding, you can commit changes by clicking the **Run the workflow** button in the top right corner and starting your CI/CD workflow. 


# Usage

## Running promotions with Deployment Targets

After a couple of seconds, you should see the workflow page with promotions secured by Deployment Targets. Compared to regular promotions, they have a **lock icon** next to them. The promotions that are allowed will have an open lock and enabled promotion button. A closed lock and disabled button indicate that you do not have the proper permissions to start the pipeline.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/workflow-page.png" alt="Workflow page with promotions secured by Deployment Targets">

The most common reasons that a promotion appears as blocked are:

- the user doesn’t have the correct permissions to deploy to the bound Deployment Target
- the workflow was run from a forbidden branch, tag, or pull request
- you are not logged in and/or you are viewing a build of a public project
- Deployment Target was deactivated

However, there are a few, less probable situations when promotions are denied, for example:

- The Deployment Target is synchronizing (and is taking longer than normal)
- The Deployment Target has failed to synchronize with Secret storage
- The Deployment Target used for the workflow has been removed.

Auto-promotions configured in the pipeline `.yml` file that are forbidden by the Deployment Target will not be shown on the workflow page, although Deployment History will register attempts to start such promotions. Apart from the mentioned differences, promotions with Deployment Targets behave the same as regular promotions.

## Browsing Deployment History

Deployment Targets allow you to track your previous deployments. In the overview page, Deployment Target tiles contain data about the latest deployment (who and when started it, which commit was used, which workflow it belongs to). You can also **stop a pipeline** from here (if it is in progress) or **rerun a promotion** (if you have rights to do so). 

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/deployments-ready-targets.png" alt="Deployment Target tiles with Last Deployment information">

After you click **View full history**, you will see the latest deployments in the reverse-chronological order. 
With **Deployment History** you can easily find and rerun deployments.

Use _Newer_ and _Older_ buttons to navigate to other pages. If you want to jump to a specific date, click on the right top _Jump to date_ button. 

You can also filter deployments by:

- author (everyone or just you),
- origin (branch, tag, or pull request),
- specific branch or tag name,
- indexed promotion parameters (if configured).

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/deployment-targets/deployments-history.png" alt="Deployment Target history view">

## Public API interoperability

You can also [use our Public API (alpha)](/reference/api-v1alpha/#triggering-a-promotion) to trigger promotions. If promotion is forbidden by Deployment Target, you will receive an HTTP `400 Bad Request` response with a reason as a body.
