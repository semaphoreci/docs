---
Description: Use parameterized promotions to improve code reusability and to dynamically configure your promotions and deployments.
---

# Parameterized Promotions

The **parameterized promotions** feature allows users to pass parameters to promotion
pipelines. You can do this either via a form in the UI, 
via the Semaphore API, or on auto-promotions by setting up default values.

The core advantage of this feature is **code reusability**. It is no longer necessary to create many promotion pipelines with almost identical configurations. Users can now create a single pipeline and rely on parameters for smaller but critical differences.

## Configuring the promotion parameters
Let's start with defining the parameters that our promotion will support. 

In your `.yml` file, when defining the promotion you can set up
as many parameters as you want. 

Possible options include:

- **required**: values (true/false) - If the parameter is required and
default_value is not set the promotion won’t start.
- **default_value** - Can only be set if the parameter is required, it
is a default value of the parameter.
- **options** - Use this to define a list of all possible values and the user will have to select one of them from the dropdown menu. If omitted, the user will be able to input any value via the input box.
- **description** - This is a description text that gets rendered on
the promotion UI (when a user selects values)
- **name** - This is the name of the parameter and the exported
environment variable (referenced later in the promoted
pipelines).

Here is an example of setting the two parameters for a single promotion:
``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Parameterized Promotion
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
  - name: Deploy
    pipeline_file: deploy.yml
    # Define promotion parameters
    parameters:
      env_vars:
        - required: true
          options:
            - Stage
            - Production
          default_value: Stage
          description: Where to deploy?
          name: ENVIRONMENT
       
        - required: false
          description: Release name?
          name: RELEASE
```

You can also use the in-app Workflow Editor to define the parameters for the promotion like this:

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/parameterized-promotions/wf-editor.png" alt="Parameterized promotions in Workflow Editor">


## Using the parameter values in promoted pipeline
Now that we have defined our parameters, it is time to define how they are used in the promoted pipeline. 

Promotion parameters can be used in the following way: 

- In the [pipeline name](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#example-of-name-usage)
- In the name of the [pipeline queue](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#queue)
- In the name of the [secret](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#secrets)
- As an environment variable inside a job


- In the **[pipeline name](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#example-of-name-usage)** - this enables you to easily figure out specifics for the promotions in the UI. 
- In the name of the **[pipeline queue](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#queue)** - so you can have separate queues for different kinds of promotions, e.g. staging and production deployments. 
- In the name of the **[secret](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#secrets)** - use only the specific secret you need to improve security. 
- As an environment variable inside a job

Let's create a deployment pipeline that uses promotion parameter values in all of the mentioned ways: 

``` yaml
# .semaphore/deploy.yml
version: v1.0
# Use parameter values in the pipeline name
name: '${{parameters.ENVIRONMENT}} deployment of the release: ${{parameters.RELEASE}}'
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
queue:
  # Use parameter values in the pipeline queue name
  name: '${{parameters.ENVIRONMENT}}-queue'
  scope: project
blocks:
  - name: Param. promotions example
    task:
      jobs:
        - name: Using promotion as env. var
          commands:
            # Use parameter values inside a job
            - echo $ENVIRONMENT
            - echo $RELEASE
      secrets:
        # Use parameter values when attaching a secret
        - name: 'creds-for-${{parameters.ENVIRONMENT}}'
```
**Note:** For this example pipeline to work, secrets named `creds-for-Production` and `creds-for-Stage` have to exist in the organization. 

## Setting the parameter values
Now that you have configured both the initial pipeline and the promotion pipeline, we can start using parameterized promotions. 

Values to the parameters are assigned every time a promotion is triggered. This can be done in the following ways:

- In the UI form if the promotion is triggered manually
- Via the API call 
- Via `default_value` in combination with `auto_promote`

### Setting the values through the UI
If you have a promotion set up you will see a deployment button in the Semaphore web interface. 

When clicked, a UI form will be auto-generated based on the configuration of the initial pipeline. This will prompt you for parameter values before starting the promotion. 

Here's how it looks like for the `.yml` code from our example:

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/parameterized-promotions/ui-form.png" alt="Parameterized Promotions form on the Workflow Page">

### Setting the values via the API
Parameters can also be passed to the promotion pipeline when the promotions are triggered via the [Semaphore API](https://docs.semaphoreci.com/reference/api-v1alpha/). 

The following is an example of a curl call that includes parameters:
```
curl -H "Authorization: Token {api_token}" \
     -d "name={promotion_name}&pipeline_id={parent_pipeline_id}&{param_1_name}={param_1_value}&{param_2_name}={param_2_value}" \
     -X POST "https://{org_name}.semaphoreci.com/api/v1alpha/promotions"
```

### Setting the values through the default value
If you are using the [auto_promote](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#auto_promote) to trigger the promotion, you can still set the value for the promotion parameters. 

This can be done by utilizing the `default_value` option:
``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Parameterized Promotion
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
  - name: Deploy
    pipeline_file: deploy.yml
    # Define promotion parameters
    auto_promote:
      when: pull_request =~ '.*' AND result = 'passed'
    parameters:
      env_vars:
        - required: true
          options:
            - Stage
            - Production
          default_value: Stage
          description: Where to deploy?
          name: ENVIRONMENT
          
        - required: true
          description: Release name?
          name: RELEASE
          default_value: Test release
```

In the example above, if auto-promotion is triggered, the value for `$ENVIRONMENT` will be `Stage` and the value for `$RELEASE` will be set to the name of the pull request. 

[auto-promotions]: ../reference/pipeline-yaml-reference.md#auto_promote
[pipeline-reference]: ../reference/pipeline-yaml-reference.md
[reference]: ../reference/pipeline-yaml-reference.md#promotions
[monorepo-workflows]: ../essentials/building-monorepo-projects.md
[change-in-ref]: ../reference/conditions-reference.md#change_in
