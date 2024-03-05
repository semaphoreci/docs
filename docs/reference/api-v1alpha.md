---
Description: This page describes all the resources that make up Semaphore 2.0 API version v1alpha. The root of the API can be found at https://{org_name}.semaphoreci.com/api/v1alpha.
---

# API

This document describes all the resources that make up Semaphore 2.0 API version `v1alpha`. If you have any problems or requests please [contact support](mailto:support@semaphoreci.com).

The root of the API can be found here: `https://{org_name}.semaphoreci.com/api/v1alpha`.

## Overview

### Constraints
Every API request and response must satisfy the following constraints:

- All requests must use HTTPS.
- All data is sent and received as JSON.
- Blank fields are included as `null` instead of being omitted.
- Timestamps are in different formats due to the historical circumstances of how these public APIs appeared. In next release of the API, they will be standardized. Currently there are the following formats:
  - Unixtime Epoch time: `"create_time": "1571083003"`
  - Unixtime Epoch time with nanoseconds: `"created_at": {"seconds": 1571063401, "nanos": 559492000}`
  - Custom format: `YYYY-MM-DD HH:MM:SS.ffffffZ`, e.g.`"2019-10-14 12:11:47.824128Z"`
  - All API requests must set the User-Agent to `SemaphoreCI v2.0 Client`.

### Authentication

All API requests require authentication. To authenticate, you need an
authentication token. You can find your authentication token by visiting your
[account settings](https://me.semaphoreci.com/account).

Your Authentication Token must be sent as a HTTP header in all requests, as shown below:

```
curl -H "Authorization: Token {api_token}" "https://{org_name}.semaphoreci.com/api/v1alpha/{resource_name}"
```

### Errors

There are several errors that you can receive as a response to an API request.

#### Failure to authenticate

```
HTTP/1.1 401 Unauthorized
```

#### Requesting non-existing resources

```
HTTP/1.1 404 Not Found
```

#### Requesting resources that are not visible to the user

```
HTTP/1.1 404 Not Found
```

### Pagination

Every request that that returns more than 30 items will be paginated.
To avoid this, you should form calls with `link` header values instead of constructing your own URLs.

A `link` header includes information about pagination, as shown below:

```
link: <http://{org_name}.semaphoreci.com/api/v1alpha/?PAGE_PARAMS>; rel="first",
      <http://{org_name}.semaphoreci.com/api/orgs?PAGE_PARAMS>; rel="next"
```

The possible `rel` values are:

- **next** - The link for the next page of results.
- **prev** - The link for the previous page of results.
- **first** - The link for the first page of results.

### Stability

- Compatible and emergency changes may be made with no advance notice.
- Disruptive changes will not occur without advanced notice. In the event that a disruptive change is needed, a new major version will be developed.

#### Types of changes

##### Compatible change

Small in scope and unlikely to break or change semantics of existing methods.

- Adding nested resources, methods, and attributes.
- Change of documentation.
- Change of undocumented behavior.

##### Disruptive change

May have a larger impact and effort will be made to provide migration paths as needed.

- Changing semantics of existing methods.
- Removing resources, methods, and attributes.

##### Emergency change

- May have larger impact, but is unavoidable due to legal compliance, security vulnerabilities, or violation of specification.

### Changelog

No changes.

## Workflows

### Running a workflow

```
POST {org_name}.semaphoreci.com/api/v1alpha/plumber-workflows
```

**Params**

- `project_id` (**required**) - ID of a project.
- `reference` (**required**) - git reference for the desired branch, tag, or pull request--e.g. *refs/heads/master*, *refs/tags/v1.0*, or *refs/pull/123*.
- `commit_sha` (*optional*) - Commit sha of the desired commit.
- `pipeline_file` (*optional*) - The path within the repository to the YAML file that contains the pipeline definition. The default value is *.semaphore/semaphore.yml*.

**Response**

```json
HTTP status: 200

{
  "workflow_id": "32a689e0-9082-4c5b-a648-bb3dc645452d",
  "pipeline_id": "2abeb1a9-eb4a-4834-84b8-cb7806aec063",
  "hook_id": "ff7d57ef-92c5-4fcd-9c0c-6ae9e24bfcec"
}
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     -d "project_id={project_id}&reference={reference}" \
     -X POST  "https://{org_name}.semaphoreci.com/api/v1alpha/plumber-workflows"
```

### Describing a workflow

```
GET {org_name}.semaphoreci.com/api/v1alpha/plumber-workflows/:workflow_id
```

**Params**

- `workflow_id` (**required**) - ID of a workflow.

**Response**

```json
HTTP status: 200

{
  "workflow": {
    "wf_id": "72c434c4-6589-493d-97cd-22f46681c893",
    "requester_id": "d32141ca-1552-4370-b0d4-4030aa9cf524",
    "project_id": "adaede30-9de5-471f-9f95-b7d437170f10",
    "initial_ppl_id": "f86b3b5e-c3de-4f77-849f-39e080374ce4",
    "hook_id": "6d7ed9d3-3047-4d5e-9b27-f0b68b228409",
    "created_at": {
      "seconds": 1571063401,
      "nanos": 559492000
    },
    "commit_sha": "6fe03f118b7aa7b8ea1a983c3faee4f8b54213a5",
    "branch_name": "master",
    "branch_id": "e8a4ad3b-4951-4520-aed7-6292ebd70076"
  }
}
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/plumber-workflows/:workflow_id"
```

### Listing workflows

```
GET https://{org_name}.semaphoreci.com/api/v1alpha/plumber-workflows?project_id=:project_id
```

**Params**

- `project_id` (**required**) - ID of a project.
- `branch_name` (*optional*) - Name of branch (used as a filter).

**Response**

```json
HTTP status: 200

[
  {
    "wf_id": "a99a75c3-f921-4fa9-a43f-69b2cede6274",
    "requester_id": "fcd7fe34-f73f-4686-821b-ce02cb970b22",
    "project_id": "c394d20b-b3c6-4c90-b743-a9a65fa95a78",
    "initial_ppl_id": "e1a678ba-ed2d-412f-b350-7333579bb0d3",
    "hook_id": "4a1d3cf7-c3d5-42ec-aa22-c31dffa9f05d",
    "created_at": {
      "seconds": 1570792145,
      "nanos": 544028000
    },
    "commit_sha": "cac345d0a7d425e23e18f7be33e9b441f95c65f5",
    "branch_name": "gallery",
    "branch_id": "70f52bdd-2dab-427a-81b1-d2999bc8c2a8"
  },
  {
    "wf_id": "e08a7a60-413c-4224-a208-9c67302d3ba1",
    "requester_id": "fcd7fe34-f73f-4686-821b-ce02cb970b22",
    "project_id": "c394d20b-b3c6-4c90-b743-a9a65fa95a78",
    "initial_ppl_id": "64dc1837-aaad-4907-a7db-aedfe091a987",
    "hook_id": "84de6482-8f5b-4f31-996f-528b6d8fa771",
    "created_at": {
      "seconds": 1570715702,
      "nanos": 345824000
    },
    "commit_sha": "aa292a7a8de08bc6246de697b84d2531fc64a43b",
    "branch_name": "gallery",
    "branch_id": "70f52bdd-2dab-427a-81b1-d2999bc8c2a8"
  }
]
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/plumber-workflows\?project_id\=:project_id"
```

### Rerunning a workflow

```
POST {org_name}.semaphoreci.com/api/v1alpha/plumber-workflows/:workflow_id/reschedule?request_token=:request_token
```

**Params**

- `workflow_id` (**required**) - ID of the workflow that you want to rerun.
- `request_token` (**required**) - Idempotency token (can be any string).

**Response**

```json
HTTP status: 200

{
  "wf_id": "965d3c3d-bbe6-4ff7-b62a-1ff51a92bdc0",
  "ppl_id": "6cf4569c-f76c-4dea-b293-3e4282ba1153"
}
```

**Example**

```
curl -i -X POST -H "Authorization: Token {api_token}" \
        "https://{org_name}.semaphoreci.com/api/v1alpha/plumber-workflows/:workflow_id/reschedule\?request_token\=:request_token"
```

### Stopping a workflow

```
POST {org_name}.semaphoreci.com/api/v1alpha/plumber-workflows/:workflow_id/terminate
```

**Params**

- `workflow_id` (**required**) - ID of the workflow that you want to stop.

**Response**

```
HTTP status: 200
```

**Example**

```
curl -i -X POST -H "Authorization: Token {api_token}" \
        "https://{org_name}.semaphoreci.com/api/v1alpha/plumber-workflows/:workflow_id/terminate"
```

## Pipelines

### Describing a pipeline

```
GET {org_name}.semaphoreci.com/api/v1alpha/pipelines/:pipeline_id
```

**Params**

- `pipeline_id` (**required**) - ID of a pipeline.
- `detailed` (*optional*) - Default: `false`, which includes all information about all blocks and jobs. This option is much more expensive--if you are only interested in the status of a pipeline, don't set detailed to `true`.

**Response**

```json
HTTP status: 200

{
  "pipeline": {
    "yaml_file_name": "semaphore.yml",
    "working_directory": ".semaphore",
    "wf_id": "965d3c3d-bbe6-4ff7-b62a-1ff51a92bdc0",
    "terminated_by": "",
    "terminate_request": "",
    "switch_id": "",
    "stopping_at": "1970-01-01 00:00:00.000000Z",
    "state": "done",
    "snapshot_id": "",
    "running_at": "2019-10-14 18:31:20.232006Z",
    "result_reason": "test",
    "result": "passed",
    "queuing_at": "2019-10-14 18:31:18.553131Z",
    "project_id": "162987ba-bda7-4e54-9c45-977a8cc6087d",
    "ppl_id": "6cf4569c-f76c-4dea-b293-3e4282ba1153",
    "pending_at": "2019-10-14 18:31:18.527207Z",
    "name": "First pipeline example",
    "hook_id": "788fd118-fb8f-45f9-9c18-07163721640b",
    "error_description": "",
    "done_at": "2019-10-14 18:31:32.507034Z",
    "created_at": "2019-10-14 18:31:17.293456Z",
    "commit_sha": "a38c3e1506d12fb1510e4b1bca2682abd9681984",
    "branch_name": "master",
    "branch_id": "b032fd6b-8d2d-4ac7-83b4-0a8bc1db192b"
  },
  "blocks": [
  ]
}
```

A response with the `detailed` param set to `true` is shown below:

```json
HTTP status: 200

{
  "pipeline": {
    "yaml_file_name": "semaphore.yml",
    "working_directory": ".semaphore",
    "wf_id": "965d3c3d-bbe6-4ff7-b62a-1ff51a92bdc0",
    "terminated_by": "",
    "terminate_request": "",
    "switch_id": "",
    "stopping_at": "1970-01-01 00:00:00.000000Z",
    "state": "done",
    "snapshot_id": "",
    "running_at": "2019-10-14 18:31:20.232006Z",
    "result_reason": "test",
    "result": "passed",
    "queuing_at": "2019-10-14 18:31:18.553131Z",
    "project_id": "162987ba-bda7-4e54-9c45-977a8cc6087d",
    "ppl_id": "6cf4569c-f76c-4dea-b293-3e4282ba1153",
    "pending_at": "2019-10-14 18:31:18.527207Z",
    "name": "First pipeline example",
    "hook_id": "788fd118-fb8f-45f9-9c18-07163721640b",
    "error_description": "",
    "done_at": "2019-10-14 18:31:32.507034Z",
    "created_at": "2019-10-14 18:31:17.293456Z",
    "commit_sha": "a38c3e1506d12fb1510e4b1bca2682abd9681984",
    "branch_name": "master",
    "branch_id": "b032fd6b-8d2d-4ac7-83b4-0a8bc1db192b"
  },
  "blocks": [
    {
      "state": "done",
      "result_reason": "test",
      "result": "passed",
      "name": "RSpec",
      "jobs": [
        {
          "status": "FINISHED",
          "result": "PASSED",
          "name": "Push results - 2/11",
          "job_id": "31094182-03bf-4e39-acfe-ed1058d7eb6c",
          "index": 1
        },
        {
          "status": "FINISHED",
          "result": "PASSED",
          "name": "Push results - 4/11",
          "job_id": "97bfb7ad-0b31-4a74-877a-b4ef1f357c5f",
          "index": 3
        },
        {
          "status": "FINISHED",
          "result": "PASSED",
          "name": "Push results - 3/11",
          "job_id": "a7e072d0-7996-4aee-b719-72c95e53a3b2",
          "index": 2
        },
        {
          "status": "FINISHED",
          "result": "PASSED",
          "name": "Push results - 1/11",
          "job_id": "4629b620-f7b0-44e7-b3fb-c2802899b1ea",
          "index": 0
        },
      ],
      "error_description": "",
      "build_req_id": "4a45fe07-6dd0-49b9-88a4-1cf49746b642",
      "block_id": "83b79652-bdfa-439c-a210-a3f0d07bbca6"
    },
    {
      "state": "done",
      "result_reason": "test",
      "result": "passed",
      "name": "ExUnit",
      "jobs": [
        {
          "status": "FINISHED",
          "result": "PASSED",
          "name": "All passed",
          "job_id": "6f90f363-dd85-408b-a656-e37244daf8c7",
          "index": 0
        },
        {
          "status": "FINISHED",
          "result": "PASSED",
          "name": "Failures",
          "job_id": "54976a64-867f-4d02-997f-fc6a31a5dfe0",
          "index": 1
        }
      ],
      "error_description": "",
      "build_req_id": "5e563b94-b133-48c5-ac9d-d3a04650f457",
      "block_id": "58911c16-04f1-4084-9a01-d3948df1bd49"
    }
  ]
}
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/pipelines/:pipeline_id"
```


### Listing pipelines

```
GET {org_name}.semaphoreci.com/api/v1alpha/pipelines?project_id=:project_id
```

**Params**

- `project_id` (**required, optional if** `wf_id` **is present**) - ID of a project.
- `wf_id` (**required, optional if** `project_id` **is present**) - ID of a workflow.
- `branch_name` (*optional*) - Name of a branch.
- `yml_file_path` (*optional*) - YML file that contains the pipeline definition.
- `created_after` (*optional*) - Only pipelines created after this Unix timestamp will be returned.
- `created_before` (*optional*) - Only pipelines created before this Unix timestamp will be returned.
- `done_after` (*optional*) - Only pipelines finished after this Unix timestamp will be returned.
- `done_before` (*optional*) - Only pipelines finished before this Unix timestamp will be returned.


**Response**

```json
HTTP status: 200

[
  {
    "yaml_file_name": "semaphore.yml",
    "working_directory": ".semaphore",
    "wf_id": "484e263a-424a-4820-bff0-bba436c54042",
    "terminated_by": "",
    "terminate_request": "",
    "switch_id": "c3e752e9-74ab-4207-bda9-4a9ce4ef17a0",
    "stopping_at": {
      "seconds": 0,
      "nanos": 0
    },
    "state": "DONE",
    "snapshot_id": "",
    "running_at": {
      "seconds": 1571076845,
      "nanos": 810862000
    },
    "result": "FAILED",
    "result_reason":"TEST",
    "queuing_at": {
      "seconds": 1571076843,
      "nanos": 878741000
    },
    "project_id": "c394d20b-b3c6-4c90-b743-a9a65fa95a78",
    "ppl_id": "0a9563f9-09a3-4450-a9bf-75b75373881a",
    "pending_at": {
      "seconds": 1571076843,
      "nanos": 868054000
    },
    "name": "Pipeline",
    "hook_id": "cd7f6162-9b6e-435a-89a7-3968b542e9c7",
    "error_description": "",
    "done_at": {
      "seconds": 1571076991,
      "nanos": 166159000
    },
    "created_at": {
      "seconds": 1571076843,
      "nanos": 537730000
    },
    "commit_sha": "ac3f9796df42db976814e3fee670e11e3fd4b98a",
    "branch_name": "ms\/another-test-branch",
    "branch_id": "a79557f2-dc4e-4807-ba89-601401eb3b1e"
  }
]
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/pipelines\?project_id\=:project_id"
```

### Stopping a pipeline

```
PATCH {org_name}.semaphoreci.com/api/v1alpha/pipelines/:pipeline_id
```

**Params**

- `pipeline_id` (**required**) - ID of a pipeline.
- `terminate_request` (**required**) - Must be set to `true`.

**Response**

```
HTTP status: 200
```

**Example**

```
curl -i -X PATCH  -H "Authorization: Token {api_token}" \
     --header "Accept: application/json"  --header "Content-Type: application/json" \
     --data '{"terminate_request": true}' \
     "https://{org_name}.semaphoreci.com/api/v1alpha/pipelines/:pipeline_id"
```

### Validating a pipeline YAML

```
POST {org_name}.semaphoreci.com/api/v1alpha/yaml
```

**Params**

- `yaml_definition` (**required**) - the YAML document for the pipeline

**Response**

```
HTTP status: 200
{"pipeline_id":"","message":"YAML definition is valid."}
```

**Example**

```
curl -i -X POST \
        -H "Authorization: Token {api_token}" \
        -H "Content-Type: application/json" \
        --data "{\"yaml_definition\": \"$(cat .semaphore/semaphore.yml | sed 's/\"/\\\"/g')\"}" \
        "https://{org_name}.semaphoreci.com/api/v1alpha/yaml"
```

## Promotions

### Listing promotions

```
GET {org_name}.semaphoreci.com/api/v1alpha/promotions?pipeline_id=:pipeline_id
```

**Params**

- `pipeline_id` (**required**) - ID of a pipeline.

**Response**

```json
HTTP status: 200

[
  {
    "triggered_by": "Pipeline Done request",
    "triggered_at": {
      "seconds": 1571065763,
      "nanos": 817290000
    },
    "status": "passed",
    "scheduled_pipeline_id": "d605c1ed-5664-4ce3-8419-14d3d7337c35",
    "scheduled_at": {
      "seconds": 1571065764,
      "nanos": 900999000
    },
    "override": false,
    "name": "production"
  }
]
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/promotions\?pipeline_id\=:pipeline_id"
```

### Triggering a promotion

```
POST {org_name}.semaphoreci.com/api/v1alpha/promotions
```

**Params**

- `pipeline_id` (**required**) - ID of a pipeline.
- `name` (**required**) - Name of the promotion, e.g. `Production deployment`.
- `override` (*optional*) - Boolean safeguard flag that needs to be set to `true` if you want to trigger a promotion for a pipeline that has failed or is still running.
- *parameter_name* - (*optional*) - name of the parameter used in the [parameterized promotion](/essentials/parameterized-promotions/#setting-the-values-via-the-api)

**Response**

```
HTTP status: 200
```

**Example**

```
curl -H "Authorization: Token {api_token}"  \
     -d "name=:promotion_name&pipeline_id=:pipeline_id"  \
     -X POST  "https://{org_name}.semaphoreci.com/api/v1alpha/promotions"
```

## Jobs

### Describing a job

```
GET {org_name}.semaphoreci.com/api/v1alpha/jobs/:job_id
```

**Response**

```json
HTTP status: 200

{
  "metadata": {
    "name": "Job #1",
    "id": "bc8826bd-dbb2-4d28-8c90-7f370ce478fe",
    "create_time": "1571083003",
    "update_time": "1571083507",
    "start_time": "1571083006",
    "finish_time": "1571083507"
  },
  "spec": {
    "project_id": "162987ba-bda7-4e54-9c45-977a8cc6087d",
    "agent": {
      "machine": {
        "type": "e1-standard-2",
        "os_image": "ubuntu1804"
      }
    },
    "env_vars": [
      {
        "name": "SEMAPHORE_WORKFLOW_ID",
        "value": "59b32e16-3c4a-4940-899e-348c28396884"
      },
      {
        "name": "SEMAPHORE_WORKFLOW_NUMBER",
        "value": "2"
      },
      {
        "name": "SEMAPHORE_PIPELINE_ARTEFACT_ID",
        "value": "abb4fb87-309d-490a-bf0d-84972641b130"
      },
      {
        "name": "SEMAPHORE_PIPELINE_ID",
        "value": "abb4fb87-309d-490a-bf0d-84972641b130"
      },
      {
        "name": "SEMAPHORE_PIPELINE_0_ARTEFACT_ID",
        "value": "abb4fb87-309d-490a-bf0d-84972641b130"
      }
    ],
    "commands": [
      "sleep 3600"
    ]
  },
  "status": {
    "result": "STOPPED",
    "state": "FINISHED",
    "agent": {
      "ip": "88.99.26.221",
      "name": "",
      "ports": [
        {
          "name": "ssh",
          "number": 30000
        }
      ]
    }
  }
}
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/jobs/:job_id"
```

### Stopping a job

```
POST {org_name}.semaphoreci.com/api/v1alpha/jobs/:job_id/stop
```

**Response**

```json
HTTP status: 200
```

**Example**

```
curl -i -X POST -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/jobs/:job_id/stop"
```

### Getting a log

```
GET https://{org_name}.semaphoreci.com/jobs/:job_id/plain_logs.json
```

**Response**

```
HTTP status: 200

BranchPage.Models.ProjectTest
  * test .find when the response is succesfull => it returns a project model instance (1.1ms)
  * test .find when the response is unsuccesfull => it returns nil (1.1ms)

BranchPage.Models.BranchTest
  * test .find when the response is succesfull => it returns a branch model instance (1.1ms)
  * test .find when the response is unsuccesfull => it returns nil (1.4ms)
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/jobs/:job_id/plain_logs.json"
```

## Self-hosted agent types

### Listing agent types

```
GET {org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types
```

**Response**

```json
HTTP status: 200

{
  "agent_types": [
    {
      "status": {
        "total_agent_count": 0
      },
      "spec": {
        "agent_name_settings": {
          "assignment_origin": "assignment_origin_agent",
          "release_after": 0
        }
      },
      "metadata": {
        "update_time": 1644963451,
        "name": "s1-aws-small",
        "create_time": 1632129338
      }
    },
    {
      "status": {
        "total_agent_count": 0
      },
      "spec": {
        "agent_name_settings": {
          "assignment_origin": "assignment_origin_aws_sts",
          "release_after": 0,
          "aws": {
            "account_id": "1234567890",
            "role_name_patterns": "role1,role2"
          }
        }
      },
      "metadata": {
        "update_time": 1641302626,
        "name": "s1-aws-large",
        "create_time": 1638470284
      }
    }
  ]
}
```

**Example**

```
curl -i \
  -H "Authorization: Token {api_token}" \
  "https://{org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types"
```

### Create an agent type

```
POST {org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types
```

**Params**

- `metadata.name` (**required**) - the name of the agent type to be created.
- `spec.agent_name_settings.assignment_origin` (*optional*) - the origin of the agent name assignment during its registration. The possible values are: `assignment_origin_agent` (*default*) and `assignment_origin_aws_sts`.
- `spec.agent_name_settings.release_after` (*optional*) - how long to hold the agent name after its disconnection, not allowing other agents to register with its name. By default, this is 0.
- `spec.agent_name_settings.aws.account_id` (**required** if `assignment_origin_aws_sts` is used)
- `spec.agent_name_settings.aws.role_name_patterns` (**required** if `assignment_origin_aws_sts` is used) - comma-separated list of AWS role names. Wildcards (*) can be used too.

**Response**

```json
HTTP status: 200

{
  "metadata": {
    "update_time": 1668626650,
    "name": "s1-aws-small",
    "create_time": 1668626650
  },
  "spec": {
    "agent_name_settings": {
      "assignment_origin": "assignment_origin_aws_sts",
      "release_after": 0,
      "aws": {
        "account_id": "1234567890",
        "role_name_patterns": "role1,role2,role3*"
      }
    }
  },
  "status": {
    "total_agent_count": 0,
    "registration_token": "..."
  }
}
```

**Example**

```
curl -i \
  -H "Authorization: Token {api_token}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  --data '{"metadata": {"name": "s1-aws-small"}, "spec": {"agent_name_settings": {"assignment_origin": "assignment_origin_agent", "release_after": 0}}}' \
  "https://{org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types"
```

### Update an agent type

```
PATCH {org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types/:agent_type_name
```

**Params**

- `agent_type_name` (**required**) - the name of the agent type to describe.

**Request body**

The request body should be a JSON object, encapsulating details about the agent type to be updated. The available fields are the same as those for creating an agent type.

**Response**

```json
HTTP status: 200

{
  "metadata": {
    "update_time": 1668626650,
    "name": "s1-aws-small",
    "create_time": 1668626650
  },
  "spec": {
    "agent_name_settings": {
      "assignment_origin": "assignment_origin_aws_sts",
      "release_after": 0,
      "aws": {
        "account_id": "1234567890",
        "role_name_patterns": "role1,role2,role3*"
      }
    }
  },
  "status": {
    "total_agent_count": 0
  }
}
```

**Example**

```
curl -X PATCH -i \
  -H "Authorization: Token {api_token}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  --data '{"metadata": {"name": "s1-aws-small"}, "spec": {"agent_name_settings": {"assignment_origin": "assignment_origin_agent", "release_after": 0}}}' \
  "https://{org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types/s1-aws-small"
```

### Describe an agent type

```
GET {org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types/:agent_type_name
```

**Params**

- `agent_type_name` (**required**) - the name of the agent type to describe.

**Response**

```json
HTTP status: 200

{
  "status": {
    "total_agent_count": 0
  },
  "spec": {
    "agent_name_settings": {
      "assignment_origin": "assignment_origin_agent",
      "release_after": 0
    }
  },
  "metadata": {
    "update_time": 1644963451,
    "name": "s1-aws-small",
    "create_time": 1632129338
  }
}
```

**Example**

```
curl -i \
  -H "Authorization: Token {api_token}" \
  "https://{org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types/s1-aws-small"
```

### Delete an agent type

```
DELETE {org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types/:agent_type_name
```

**Params**

- `agent_type_name` (**required**) - the name of the agent type to delete.

**Response**

```json
HTTP status: 200
{}
```

**Example**

```
curl -i -X DELETE \
  -H "Authorization: Token {api_token}" \
  "https://{org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types/s1-aws-small"
```

### Disable agents for an agent type

```
POST {org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types/:agent_type_name/disable_all
```

**Params**

- `agent_type_name` (**required**) - the name of the agent type to disable agents for.
- `only_idle` (*optional*) - a boolean flag that controls whether all agents are disabled or only idle ones. By default, this is set to `true`.

**Response**

```json
HTTP status: 200
{}
```

**Example**

```
curl -i \
  -H "Authorization: Token {api_token}" \
  -d 'only_idle=false' \
  "https://{org_name}.semaphoreci.com/api/v1alpha/self_hosted_agent_types/s1-aws-small/disable_all"
```

## Self-hosted agents

### Listing agents for an agent type

```
GET {org_name}.semaphoreci.com/api/v1alpha/agents?agent_type=:agent_type&page_size=:page_size&cursor=:cursor
```

**Params**

- `agent_type` (*optional*) - the name of the agent type to filter for. If not specified, agents for all agent types will be returned.
- `page_size` (*optional*) - the number of agents to return per page. By default, this is 200. If the current number of agents is more than the page size, the response will contain a non-empty `cursor` field.
- `cursor` (*optional*) - a cursor used to return agents for the next page.

**Response**

```json
HTTP status: 200

{
  "agents": [
    {
      "status": {
        "state": "waiting_for_job"
      },
      "metadata": {
        "version": "v2.2.6",
        "type": "s1-my-type",
        "pid": 14,
        "os": "Ubuntu 20.04.6 LTS",
        "name": "JE1wNRR53A9IORQTMQhb",
        "ip_address": "XXX.XXX.XXX.XXX",
        "hostname": "myhost",
        "connected_at": 1686917254,
        "arch": "x86"
      }
    },
    {
      "status": {
        "state": "waiting_for_job"
      },
      "metadata": {
        "version": "v2.2.6",
        "type": "s1-my-type",
        "pid": 14,
        "os": "Ubuntu 20.04.6 LTS",
        "name": "tE77rxu2gHy2clIe4tHV",
        "ip_address": "XXX.XXX.XXX.XXX",
        "hostname": "myhost",
        "connected_at": 1686917261,
        "arch": "x86"
      }
    }
  ],
  "cursor": ""
}
```

**Example**

```
curl -i \
  -H "Authorization: Token {api_token}" \
  "https://{org_name}.semaphoreci.com/api/v1alpha/agents"
```

### Describe an agent

```
GET {org_name}.semaphoreci.com/api/v1alpha/agents/:agent_name
```

**Params**

- `agent_name` (**required**) - the name of the agent to describe.

**Response**

```json
HTTP status: 200

{
  "status": {
    "state": "waiting_for_job"
  },
  "metadata": {
    "version": "v2.2.6",
    "type": "s1-my-type",
    "pid": 14,
    "os": "Ubuntu 20.04.6 LTS",
    "name": "tE77rxu2gHy2clIe4tHV",
    "ip_address": "XXX.XXX.XXX.XXX",
    "hostname": "myhost",
    "connected_at": 1686917261,
    "arch": "x86"
  }
}
```

**Example**

```
curl -i \
  -H "Authorization: Token {api_token}" \
  "https://{org_name}.semaphoreci.com/api/v1alpha/agents/{agent_name}"
```


## Deployment targets

### Listing targets

This API endpoint provides a list of deployment targets linked to a given project.

```
GET {org_name}.semaphoreci.com/api/v1alpha/deployment_targets?project_id=:project_id
```
**Params**

- `project_id` (**required**) - UUID of the project for which deployment targets are to be listed.

**Response**

The response is a JSON object comprising an array of deployment target objects for the specified project ID.

```json
HTTP status: 200

[
  {
    "url": "project_1234.zyx",
    "updated_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
    "updated_at": "2023-06-07T09:24:04.000000Z",
    "subject_rules": [
      {
        "type": "ANY",
        "subject_id": ""
      }
    ],
    "state_message": "",
    "state": "USABLE",
    "project_id": "a426b4db-1919-483d-926d-06ba1320b209",
    "organization_id": "7304b7f9-7482-46d4-9b95-3cd5a6ef2e6f",
    "object_rules": [
      {
        "type": "BRANCH",
        "pattern": "",
        "match_mode": "ALL"
      },
      {
        "type": "TAG",
        "pattern": "",
        "match_mode": "ALL"
      },
      {
        "type": "PR",
        "pattern": "",
        "match_mode": "ALL"
      }
    ],
    "name": "DTName123",
    "last_deployment": null,
    "id": "e79d3d1c-61cc-4e07-ba32-f86694f5e80d",
    "description": "DT description",
    "created_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
    "created_at": "2023-06-01T10:07:36.000000Z",
    "bookmark_parameter3": "",
    "bookmark_parameter2": "",
    "bookmark_parameter1": "",
    "active": true
  }
]
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/deployment_targets?project_id=:project_id"
```

### Describing a target

This API endpoint retrieves the details about a deployment target specified by its UUID.

```
GET {org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id
```

**Params**

- `target_id` (**required**) - The UUID of the deployment target.

**Response**

```json
HTTP status: 200

{
  "url": "project_1234.zyx",
  "updated_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
  "updated_at": "2023-06-07T09:24:04.000000Z",
  "subject_rules": [
    {
      "type": "ANY",
      "subject_id": ""
    }
  ],
  "state_message": "",
  "state": "USABLE",
  "project_id": "a426b4db-1919-483d-926d-06ba1320b209",
  "organization_id": "7304b7f9-7482-46d4-9b95-3cd5a6ef2e6f",
  "object_rules": [
    {
      "type": "BRANCH",
      "pattern": "",
      "match_mode": "ALL"
    },
    {
      "type": "TAG",
      "pattern": "",
      "match_mode": "ALL"
    },
    {
      "type": "PR",
      "pattern": "",
      "match_mode": "ALL"
    }
  ],
  "name": "DTName123",
  "last_deployment": null,
  "id": "e79d3d1c-61cc-4e07-ba32-f86694f5e80d",
  "description": "DT description",
  "created_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
  "created_at": "2023-06-01T10:07:36.000000Z",
  "bookmark_parameter3": "",
  "bookmark_parameter2": "",
  "bookmark_parameter1": "",
  "active": true
}
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id"
```

#### Describing by name and project UUID

This API endpoint retrieves a deployment target based on its name and the UUID of the project it is linked to.

```
GET {org_name}.semaphoreci.com/api/v1alpha/deployment_targets?project_id=:project_id&target_name=:target_name
```

**Params**

- `project_id` (**required**) - The UUID of the project to which the deployment target is linked.
- `target_name` (**required**) - The name of the deployment target.

**Response**

```json
HTTP status: 200

[
  {
    "url": "project_1234.zyx",
    "updated_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
    "updated_at": "2023-06-07T09:24:04.000000Z",
    "subject_rules": [
      {
        "type": "ANY",
        "subject_id": ""
      }
    ],
    "state_message": "",
    "state": "USABLE",
    "project_id": "a426b4db-1919-483d-926d-06ba1320b209",
    "organization_id": "7304b7f9-7482-46d4-9b95-3cd5a6ef2e6f",
    "object_rules": [
      {
        "type": "BRANCH",
        "pattern": "",
        "match_mode": "ALL"
      },
      {
        "type": "TAG",
        "pattern": "",
        "match_mode": "ALL"
      },
      {
        "type": "PR",
        "pattern": "",
        "match_mode": "ALL"
      }
    ],
    "name": "DTName123",
    "last_deployment": null,
    "id": "e79d3d1c-61cc-4e07-ba32-f86694f5e80d",
    "description": "DT description",
    "created_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
    "created_at": "2023-06-01T10:07:36.000000Z",
    "bookmark_parameter3": "",
    "bookmark_parameter2": "",
    "bookmark_parameter1": "",
    "active": true
  }
]
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/deployment_targets?project_id=:project_id&target_name=:target_name"
```

### Creating a target

This API endpoint allows you to create a new deployment target and assign it to a specific project.

```
POST {org_name}.semaphoreci.com/api/v1alpha/deployment_targets?project_id=:project_id
```

**Request Body**

The request body should be a JSON object, encapsulating details about the deployment target to be created. The available fields are as follows:

  - `name` (**required**) - Unique name for the target within the project.
  - `project_id` (**required**) - UUID of the project.
  - `unique_token` (**required**) - Idempotency UUID token.
  - `description` (*optional*) - A description of the target.
  - `url` (*optional*) - The URL of the target.
  - `bookmark_parameter1`, `bookmark_parameter2`, `bookmark_parameter3` (*optional*) - Bookmark parameters - string values that represent the names of the promotion parameters. You can later use values of these parameters to [filter deployments in deployment history](/reference/deployment-targets-yaml-reference/#bookmark_parameter1-bookmark_parameter2-bookmark_parameter3).
  - `subject_rules` (*optional*) - Configures **who** can trigger a promotion of the given deployment target. It should be a list of elements structured as `{"type": RULE_TYPE, "subject_id": ID}`. The `RULE_TYPE` can be one of `"ANY"`, `"USER"`, `"ROLE"`, `"AUTO"` and the `ID` should be the name of the role (which must be valid for the project) or the UUID of a user. For the `USER` type you can use `{"type": "USER", "git_login": GITLOGIN}` where `GITLOGIN` is the user's git handle. The user must be assigned to the project to be used in the rule. The `AUTO` rule configures the behavior of auto-promotions. The auto-promotions will not start, even if all the conditions are met, if this rule is not present. In the case of `ANY` and `AUTO` rules, there is no need to specify the `subject_id`.
  - `object_rules` (*optional*) - Configures **which git references** are allowed for a promotion of the given deployment target. It should be a list of elements structured as `{"type": RULE_TYPE, "match_mode": MODE, "pattern": PATTERN}`. The `RULE_TYPE` can be `"BRANCH"`, `"TAG"`, or `"PR"`, and the `MODE` can be `"ALL"`, `"EXACT"`, or `"REGEX"`. When using the `PR` rule type, the `match_mode` and `pattern` parameters cannot be utilized. Simply including `PR` in the `object_rules` is sufficient to ensure that any pull request will automatically trigger a promotion.
  - `env_vars` (*optional*) - A list of environment variables structured as `{"name": NAME, "value": VALUE}`, where `NAME` is the variable name and `VALUE` is its value.
  - `files` (*optional*) - A list of files structured as `{"path": PATH, "content": CONTENT}`, where `PATH` is the file path and `CONTENT` is its base64-encoded content.

You can find more details about each parameter in the [Deployment Targets YAML Reference](/reference/deployment-targets-yaml-reference)

**Response**

```json
HTTP status: 200

{
  "url": "www.myurl.zyx",
  "updated_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
  "updated_at": "2023-06-08T07:48:27.000000Z",
  "subject_rules": [
    {
      "type": "ANY",
      "subject_id": ""
    }
  ],
  "state_message": "",
  "state": "SYNCING",
  "project_id": "a426b4db-1919-483d-926d-06ba1320b209",
  "organization_id": "7304b7f9-7482-46d4-9b95-3cd5a6ef2e6f",
  "object_rules": [
    {
      "type": "BRANCH",
      "pattern": "",
      "match_mode": "ALL"
    },
    {
      "type": "TAG",
      "pattern": "",
      "match_mode": "ALL"
    },
    {
      "type": "PR",
      "pattern": "",
      "match_mode": "ALL"
    }
  ],
  "name": "testTarget",
  "last_deployment": null,
  "id": "ed25bfb6-7149-40c6-8334-4eaf11337569",
  "description": "Target description",
  "created_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
  "created_at": "2023-06-08T07:48:27.000000Z",
  "bookmark_parameter3": "",
  "bookmark_parameter2": "",
  "bookmark_parameter1": "my book 1",
  "active": true
}

```

**Example request**

```
curl -i -X POST -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/deployment_targets?project_id=:project_id" \
     -H "Content-Type: application/json" \
     -d '<json object>' 
```
```
curl -XPOST {org_name}.semaphoreci.com/api/v1alpha/deployment_targets?project_id=a426b4db-1919-483d-926d-06ba1320b209 -H "Authorization: Token {api_token}" -H "Content-Type: application/json" --data '{ "name": "testTarget", "description": "Target description", "url": "www.myurl.zyx","bookmark_parameter1": "my book 1", "unique_token": "6063dd03-ecfb-11ed-b539-0045e2f582b7",  "env_vars": [ {"name": "env1","value": "val1" }  ],  "files": [ {"path": "/etc/my.conf","content": "'"$(base64 -w 0 /home/pc/proj/someconf.conf)"'" }  ]}'
```


### Updating a target

This API endpoint allows you to update an existing deployment target.

```
PATCH {org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id
```

**Parameters**

  - `target_id` (**required**) - UUID of the deployment target to be updated.

**Request Body**

The request body should be a JSON object, encapsulating details about the deployment target to be updated. The available fields are the same as those for creating a target. The difference here is that all fields are optional.

**Response**

```json
HTTP status: 200

{
  "url": "www.myurl2.zyx",
  "updated_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
  "updated_at": "2023-06-08T08:47:53.000000Z",
  "subject_rules": [
    {
      "type": "ANY",
      "subject_id": ""
    }
  ],
  "state_message": "",
  "state": "SYNCING",
  "project_id": "a426b4db-1919-483d-926d-06ba1320b209",
  "organization_id": "7304b7f9-7482-46d4-9b95-3cd5a6ef2e6f",
  "object_rules": [
    {
      "type": "BRANCH",
      "pattern": "",
      "match_mode": "ALL"
    },
    {
      "type": "TAG",
      "pattern": "",
      "match_mode": "ALL"
    },
    {
      "type": "PR",
      "pattern": "",
      "match_mode": "ALL"
    }
  ],
  "name": "testTargetChanged",
  "last_deployment": null,
  "id": "ed25bfb6-7149-40c6-8334-4eaf11337569",
  "description": "Target description changed",
  "created_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
  "created_at": "2023-06-08T07:48:27.000000Z",
  "bookmark_parameter3": "",
  "bookmark_parameter2": "",
  "bookmark_parameter1": "my book 1c",
  "active": true
}
```

**Example**

```
curl -i -X PATCH -H "Authorization: Token {api_token}"  \
     "https://{org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id" \
     -H "Content-Type: application/json" \
     -d '<json object>'
```
```
curl -X PATCH https://{org_name}.semaphoreci.com/deployment_targets/3a9196d7-f740-4451-b8f2-9d19b10a4520 \
     -H "Authorization: Token {api_token}" \
     -d'{"name": "testTargetChanged", "description": "Target description changed", "url": "www.myurl2.zyx","bookmark_parameter1": "my book 1c", "unique_token": "6063dd03-ecfb-11ed-b539-0045e2f582b8",  "env_vars": [ {"name": "env1","value": "val2" }  ],  "files": [ {"path": "/etc/my.conf","content": "'"$(base64 -w 0 /home/pc/proje/updated.conf)"'" }]}' \
     -H "Content-Type: application/json"
```

### Deleting a target

This API endpoint allows you to delete a specific deployment target.

```
DELETE {org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id?unique_token=:unique_token
```

**Params**

- `target_id` (**required**) - The UUID of the deployment target to be deleted.
- `unique_token` (**required**) - The idempotency UUID token.

**Response**

```json
HTTP status: 200

{"target_id":"38572f07-15ec-459e-a122-eefa2bd19230"}
```

**Example**

```
curl -i -X DELETE -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id?unique_token=:unique_token"
```

### Deactivating a target

This API endpoint allows you to deactivate a specific deployment target.

```
PATCH {org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id/deactivate
```

**Params**

- `target_id` (**required**) - The UUID of the deployment target to be deactivated.

**Response**

```json
HTTP status: 200

{
  "target_id": "a3db05c5-4345-493d-a038-6b5f2f2ba2b5",
  "cordoned": true
}
```

**Example**

```
curl -i -X PATCH -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id/deactivate"
```


### Activating a target

This API endpoint allows you to (re)activate a specific deployment target.

```
PATCH {org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id/activate
```

- `target_id` (**required**) - The UUID of the deployment target to be (re)activated.

**Response**

```
HTTP status: 200

{
  "target_id": "a3db05c5-4345-493d-a038-6b5f2f2ba2b5",
  "cordoned": false
}
```

**Example**

```
curl -i -X PATCH -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id/activate"
```

### Retrieving deployment history

This endpoint provides the deployment history for a specific deployment target.

```
GET {org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id/history
```

**Params**

- `target_id` (**required**) - The UUID of the deployment target for which the deployment history is being retrieved.
- `cursor_type` (*optional*) - Specifies the starting point for data retrieval. Valid values include `"FIRST"`, `"AFTER"`, and `"BEFORE"`. If not specified, `FIRST` is used, which retrieves the latest deployments.
- `cursor_value` (*optional*) - Represents the timestamp, given in UNIX microseconds, at which the cursor is positioned to retrieve deployment history. If `cursor_type` is set to `AFTER`, it retrieves the oldest deployments triggered after the `cursor_value`. If `cursor_type` is set to `BEFORE`, it retrieves the latest deployments triggered before the `cursor_value`. For the `FIRST` cursor type, this value is not required.
- `git_ref_type` (*optional*) - Filters deployments based on the git reference that triggered them, such as `branch`, `tag`, or `pr` (for pull requests).
- `git_ref_label` (*optional*) - Filters deployments based on the label of the git reference, such as the name of the branch.
- `triggered_by` (*optional*) - Filters deployments based on the entity that triggered them. To filter by the user who triggered the deployments, provide the user ID.

The response includes `cursor_before` and `cursor_after` values that allow you to navigate by moving backward or forward accordingly. The response contains at most `10` deployments.

**Response**

```json
HTTP status: 200

{
  "deployments": [
    {
      "triggered_by": "02984c87-efe8-4ea1-bcac-9511a34a3df3",
      "triggered_at": "2023-05-26T10:35:00.000000Z",
      "target_name": "Production 2 deploy",
      "target_id": "410bf56b-b0dc-46d2-b939-87c88a21bb84",
      "switch_id": "8b751422-1322-4a9c-b3ab-e97c451cfbdc",
      "state_message": "",
      "state": "STARTED",
      "prev_pipeline_id": "f65a5c7a-6d69-4f3e-8251-adcae6c4d6d7",
      "pipeline_id": "bf4dcb8b-fbf3-4aab-a67f-ffc1f53d6bc8",
      "id": "4885f77e-30eb-49cb-b351-d5a637d09ed8",
      "env_vars": [
        {
          "value": "Passed message 2 as parameter",
          "name": "MESSAGE"
        }
      ]
    },
    {
      "triggered_by": "Pipeline Done request",
      "triggered_at": "2023-05-26T10:34:31.000000Z",
      "target_name": "Production deploy",
      "target_id": "410bf56b-b0dc-46d2-b939-87c88a21bb84",
      "switch_id": "8b751422-1322-4a9c-b3ab-e97c451cfbdc",
      "state_message": "",
      "state": "STARTED",
      "prev_pipeline_id": "f65a5c7a-6d69-4f3e-8251-adcae6c4d6d7",
      "pipeline_id": "f4e1413b-2fac-4ba6-9625-921f66ef1802",
      "id": "9ef2194e-d13d-432e-8c97-c8fda64c4aa1",
      "env_vars": [
        {
          "value": "Passed message as parameter",
          "name": "MESSAGE"
        }
      ]
    }
  ],
  "cursor_before": 1685096881121173,
  "cursor_after": 0
}
```

**Example**

```
curl -i -H "Authorization: Token {api_token}" \
     "https://{org_name}.semaphoreci.com/api/v1alpha/deployment_targets/:target_id/history"
```

## Schedulers

You can learn more about schedulers in the [Scheduler](/essentials/schedule-a-workflow-run) section.

### Listing schedulers

This API endpoint provides a list of schedulers for a given project.

```
GET {org_name}.semaphoreci.com/api/v1alpha/schedules?project_id=:project_id
```
**Params**

- `project_id` (**required**) - UUID of the project for which schedulers are to be listed.
- `page` (*optional*) - the page number to return. By default, this is 1.
- `page_size` (*optional*) - the number of schedulers to return per page. By default, this is 30.

**Response**

The response is a JSON object comprising an array of scheduler objects for the specified project ID.

```json
HTTP status: 200

[
  {
    "updated_at": "2023-07-25 08:35:54.819164Z",
    "suspended": false,
    "requester_id": "f14146cf-7e15-4c5c-8514-5686b0842f1f",
    "project_id": "826f406c-9d21-4650-8cbe-e2f9d39537dd",
    "pipeline_file": ".semaphore/semaphore.yml",
    "paused": false,
    "pause_toggled_by": "",
    "pause_toggled_at": "",
    "name": "some_scheduler",
    "inserted_at": "2023-07-25 08:35:54.819164Z",
    "id": "1dd4908b-1484-4ab7-81d9-f50a03e7fdc5",
    "branch": "master",
    "at": "0 0 * * *"
  }
]
```

**Example**
```
curl "https://{org_name}.semaphoreci.com/api/v1alpha/schedules?project_id=:project_id" -H "Authorization: Token {api_token}" | jq .
```

### Describe a scheduler

```
GET {org_name}.semaphoreci.com/api/v1alpha/schedules/:scheduler_id
```

**Params**

- `scheduler_id` (**required**) - The UUID of the scheduler.

**Response**

The response is a JSON object comprising a scheduler object for the specified scheduler ID, trigger objects representing the last 10 triggers of the scheduler with information about the workflow. The `run_now_requester_id` field is empty when automatically triggered by the scheduler, and if run now is used it contains the UUID of the user who triggered the scheduler workflow.

```json
HTTP status: 200

{
  "triggers": [
    {
      "triggered_at": "2023-07-25 10:03:52.929821Z",
      "scheduling_status": "passed",
      "scheduled_workflow_id": "3f60fbd7-aad5-4457-a58a-e1ec0253ffa3",
      "scheduled_at": "2023-07-25 10:03:53.119981Z",
      "run_now_requester_id": "f14146cf-7e15-4c5c-8514-5686b0842f1f",
      "project_id": "826f406c-9d21-4650-8cbe-e2f9d39537dd",
      "pipeline_file": ".semaphore/semaphore.yml",
      "periodic_id": "1dd4908b-1484-4ab7-81d9-f50a03e7fdc5",
      "error_description": "",
      "branch": "master"
    }
  ],
  "schedule": {
    "updated_at": "2023-07-25 08:35:54.819164Z",
    "suspended": false,
    "requester_id": "f14146cf-7e15-4c5c-8514-5686b0842f1f",
    "project_id": "826f406c-9d21-4650-8cbe-e2f9d39537dd",
    "pipeline_file": ".semaphore/semaphore.yml",
    "paused": false,
    "pause_toggled_by": "",
    "pause_toggled_at": "",
    "name": "some_scheduler",
    "inserted_at": "2023-07-25 08:35:54.819164Z",
    "id": "1dd4908b-1484-4ab7-81d9-f50a03e7fdc5",
    "branch": "master",
    "at": "0 0 * * *"
  }
}
```

**Example**

```
curl "https://{org_name}.semaphoreci.com/api/v1alpha/schedules/:schedule_id" -H "Authorization: Token {api_token}" | jq .
```

### Upserting a scheduler

This API endpoint allows to create or update a scheduler. If creating a scheduler provide the `project_name` parameter. If updating a scheduler provide the `periodic_id` parameter.

```
POST {org_name}.semaphoreci.com/api/v1alpha/schedules?periodic_id={peroidic_id}
```
**Params**

- `periodic_id` (**optional**) - The UUID of the scheduler. If the scheduler with the given UUID exists, it will be updated. If creating a new scheduler, `project_name` is **required**
- `project_name` (**optional**) - The name of the project. If creating a new scheduler this param is **required**

**Request Body**

The request body should be a JSON object containing project YAML definition

 - `yml_definition` (**required**) - YAML definition of the scheduler

You can find more about the YAML definition in the [Scheduler](/reference/scheduler-reference) section.

### Delete a scheduler

This API endpoint allows to delete a scheduler.

```
DELETE {org_name}.semaphoreci.com/api/v1alpha/schedules/:scheduler_id
```

**Params**

- `scheduler_id` (**required**) - The UUID of the scheduler to be deleted.


**Response**

```
"Schedule successfully deleted."
```

## Artifacts

You can gain access to signed URLS of artifacts with the following API endpoints. Artifacts endpoints are available as JSON or gRPC.

### Generate signed URLs

This API endpoint is defined in the [semaphoreci/api](github.com/semaphoreci/api) repository.

```
POST {org_name}.semaphoreci.com/api/v1/artifacts
```

**Request Body**

Request body should be a JSON object containing the following fields:
- `paths` (**required**) - A list of paths to artifacts.
- `type`  (**required**) - The type of the action. Valid values are `PUSH`, `PUSHFORCE`, `PULL`, and `YANK`.

```json
{
  "paths": [
    "semaphoreci-art"
  ],
  "type": "PULL"
}
```

**Response**

If request is successful, the response will contain a list of signed URLs.

```json
{
  "URLs":[
    {
      "URL":"https://storage.googleapis.com/semaphoreci-art",
      "method":"GET"
    }
  ]
}

Method can be one of the following: `DELETE`, `GET`, `HEAD`, `PUT`, `POST`.

If the request is unsuccessful, the response will contain an error message.

```json
{
  "code": 16,
  "error":"Artifact token is not correct",
  "details": []
}
```

## Dashboards

Dashboards API is defined as a protobuf service in the [semaphoreci/api](github.com/semaphoreci/api) repository.

### List dashboards

```
GET {org_name}.semaphoreci.com/api/v1alpha/dashboards
```

**Params**
- page_size (*optional*) - the number of dashboards to return per page. By default, this is 30.
- page_token (*optional*) - the page token to return. By default, this is the first page.

**Response**

A list of dashboard objects, along with the `next_page_token` and `total_size` values.

```json
HTTP status: 200

{
  "dashboards": [
    {
      "metadata": {
        "name": "tech-support",
        "id": "61740a6d-500d-4910-9b5e-7e7885da3f21",
        "title": "Tech Support",
        "create_time": "1665556362",
        "update_time": "1690390061"
      },
      "spec": {
        "widgets": [
          {
            "name": "Deployment A",
            "type": "list_pipelines",
            "filters": {
              "branch": "master",
              "pipeline_file": ".semaphore/semaphore.yml",
              "project_id": "fea1701a-3b37-4b00-a0dc-2af4c326ab66"
            }
          },
          {
            "name": "Deployment B",
            "type": "list_pipelines",
            "filters": {
              "branch": "master",
              "pipeline_file": ".semaphore/semaphore.yml",
              "project_id": "fc685ebf-4b7b-4421-9204-1c1c950e0b0f"
            }
          },
          {
            "name": "Deployment C",
            "type": "list_pipelines",
            "filters": {
              "branch": "data_branch",
              "pipeline_file": ".semaphore/semaphore.yml",
              "project_id": "fea1701a-3b37-4b00-a0dc-2af4c326ab66"
            }
          }
        ]
      }
    }
  ],
  "next_page_token": "",
  "total_size": 0
}
```

**Example**

```
curl \
  -H "Authorization: Token {api_token}" \
  "https://{org_name}.semaphoreci.com/api/v1alpha/dashboards" | jq .
```

### Get dashboard

```
GET {org_name}.semaphoreci.com/api/v1alpha/dashboards/:dashboard_id_or_name
```

**Params**

- `dashboard_id_or_name` (**required**) - The UUID or name of the dashboard.

**Response**

```json
{
  "metadata": {
    "name": "tech-support",
    "id": "61740a6d-500d-4910-9b5e-7e7885da3f21",
    "title": "Tech Support",
    "create_time": "1665556362",
    "update_time": "1690390061"
  },
  "spec": {
    "widgets": [
      {
        "name": "Deployment A",
        "type": "list_pipelines",
        "filters": {
          "branch": "master",
          "pipeline_file": ".semaphore/semaphore.yml",
          "project_id": "fea1701a-3b37-4b00-a0dc-2af4c326ab66"
        }
      },
      {
        "name": "Deployment B",
        "type": "list_pipelines",
        "filters": {
          "branch": "master",
          "pipeline_file": ".semaphore/semaphore.yml",
          "project_id": "fc685ebf-4b7b-4421-9204-1c1c950e0b0f"
        }
      },
      {
        "name": "Deployment C",
        "type": "list_pipelines",
        "filters": {
          "branch": "data_branch",
          "pipeline_file": ".semaphore/semaphore.yml",
          "project_id": "fea1701a-3b37-4b00-a0dc-2af4c326ab66"
        }
      }
    ]
  }
}
```
### Create dashboard

```
POST {org_name}.semaphoreci.com/api/v1alpha/dashboards
```

**Request Body**

A dashboard object defined in the [semaphoreci/api](github.com/semaphoreci/api) repository.

```json
{
  "metadata": {
    "name": "tech-support-a",
    "title": "Tech Support A"
  },
  "spec": {
    "widgets": [
      {
        "name": "Deployment A",
        "type": "list_pipelines",
        "filters": {
          "branch": "master",
          "pipeline_file": ".semaphore/semaphore.yml",
          "project_id": "fea1701a-3b37-4b00-a0dc-2af4c326ab66"
        }
      },
      {
        "name": "Deployment B",
        "type": "list_pipelines",
        "filters": {
          "branch": "master",
          "pipeline_file": ".semaphore/semaphore.yml",
          "project_id": "fc685ebf-4b7b-4421-9204-1c1c950e0b0f"
        }
      },
      {
        "name": "Deployment C",
        "type": "list_pipelines",
        "filters": {
          "branch": "data_branch",
          "pipeline_file": ".semaphore/semaphore.yml",
          "project_id": "fea1701a-3b37-4b00-a0dc-2af4c326ab66"
        }
      }
    ]
  }
}
```

**Response**

Response can be a created dashboard, or an error in a format of [google/rpc/status.proto](https://github.com/googleapis/googleapis/blob/master/google/rpc/status.proto):

```json
HTTP status: 400

{
  "code": 3,
  "message": "invalid character ',' looking for beginning of object key string",
  "details": []
}
```

### Update dashboard

```
PATCH {org_name}.semaphoreci.com/api/v1alpha/dashboards/:dashboard_id_or_name
```

**Params**

- `dashboard_id_or_name` (**required**) - The UUID or name of the dashboard.

**Request Body**

A json of the dashboard. Timestamps will be ignored.

### Delete dashboard

```
DELETE {org_name}.semaphoreci.com/api/v1alpha/dashboards/:dashboard_id_or_name
```

**Params**

- `dashboard_id_or_name` (**required**) - The UUID or name of the dashboard.

**Response**

Empty JSON object if successful with 200 response code, or an error JSON representation of [google/rpc/status.proto](https://github.com/googleapis/googleapis/blob/master/google/rpc/status.proto)



## Notifications

### List notifications

```
GET {org_name}.semaphoreci.com/api/v1alpha/notifications
```

**Params**
- page_size (*optional*) - the number of notifications to return per page. By default, this is 30.
- page_token (*optional*) - the page token to return. By default, this is the first page.

**Response**

A list of notification objects, along with the `next_page_token` value.


```json
{
  "notifications": [
    {
      "metadata": {
        "name": "test-notif",
        "id": "79892e40-2118-407a-895c-5cc8e708161e",
        "create_time": "1652655667",
        "update_time": "1652657216"
      },
      "spec": {
        "rules": [
          {
            "name": "Passed",
            "filter": {
              "projects": [
                "dummy-repo"
              ],
              "branches": [
                "main"
              ],
              "pipelines": [],
              "blocks": [],
              "states": [],
              "results": [
                "passed"
              ]
            },
            "notify": {
              "slack": {
                "endpoint": "https://hooks.slack.com/services/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",
                "channels": [],
                "message": "",
                "status": "ACTIVE"
              },
              "email": {
                "subject": "",
                "cc": [],
                "bcc": [],
                "content": "",
                "status": "ACTIVE"
              },
              "webhook": {
                "endpoint": "",
                "timeout": 0,
                "action": "",
                "retries": 0,
                "status": "ACTIVE",
                "secret": ""
              }
            }
          }
        ]
      },
      "status": {
        "failures": []
      }
    }
  ],
  "next_page_token": ""
}
```


### Get notification

```
GET {org_name}.semaphoreci.com/api/v1alpha/notifications/:notification_id_or_name
```

**Params**

- `notification_id_or_name` (**required**) - The UUID or name of the notification.

**Response**

Response contains a JSON representation of Notification object in [semaphoreci/api](github.com/semaphoreci/api)

### Create notification

```
POST {org_name}.semaphoreci.com/api/v1alpha/notifications
```

**Request Body**

If any errors occur the response will contain JSON representation of [google/rpc/status.proto](https://github.com/googleapis/googleapis/blob/master/google/rpc/status.proto).

```json
{
  "code": 3,
  "message": "invalid character '}' looking for beginning of object key string",
  "details": []
}
```

Success response will contain a JSON representation of the created notification object in [semaphoreci/api](github.com/semaphoreci/api) with timestamps and id.

```json
{
  "metadata": {
    "name": "test-notif-a"
  },
  "spec": {
    "rules": [
      {
        "name": "Passed",
        "filter": {
          "projects": [
            "dummy-repo"
          ],
          "branches": [
            "main"
          ],
          "pipelines": [],
          "blocks": [],
          "states": [],
          "results": [
            "passed"
          ]
        },
        "notify": {
          "slack": {
            "endpoint": "https://hooks.slack.com/services/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",
            "channels": [],
            "message": "",
            "status": "INACTIVE"
          },
          "email": {
            "subject": "",
            "cc": [],
            "bcc": [],
            "content": "",
            "status": "ACTIVE"
          },
          "webhook": {
            "endpoint": "",
            "timeout": 0,
            "action": "",
            "retries": 0,
            "status": "ACTIVE",
            "secret": ""
          }
        }
      }
    ]
  }
}
```

### Update notification

```
PATCH {org_name}.semaphoreci.com/api/v1alpha/notifications/:notification_id_or_name
```

**Params**

- `notification_id_or_name` (**required**) - The UUID or name of the notification.

**Request Body**

Request body should contain a JSON representation of Notification object in [semaphoreci/api](github.com/semaphoreci/api).

**Response**

Response contains a JSON representation of Notification object in [semaphoreci/api](github.com/semaphoreci/api), or an error message.

### Delete notification

```
DELETE {org_name}.semaphoreci.com/api/v1alpha/notifications/:notification_id_or_name
```

**Params**

- `notification_id_or_name` (**required**) - The UUID or name of the notification.


## Secrets

**Note:**
The API endpoint for organization secrets is `v1beta`, and the API endpoint for project secrets is `v1`.

### List secrets

Organization secrets:
```
GET {org_name}.semaphoreci.com/api/v1beta/secrets
```

Project secrets:
```
GET {org_name}.semaphoreci.com/api/v1/projects/:project_id_or_name/secrets
```

**Params**

- page_size (*optional*) - the number of secrets to return per page. By default, this is 30.
- page_token (*optional*) - the page token to return. By default, this is the first page.
- order (*optional*) - the order of secrets to return. By default, this is `BY_NAME_ASC`. the other valid value is `BY_CREATE_TIME_ASC`.
- project_id_or_name (**required** for project secrets) - The UUID or name of the project.

**Response**

The response contains a list of secret objects (either project or organization level secret), along with the `next_page_token`.
The data of the secrets is returned in the `data` field, files are base64 representation of the file content, and enviroment variables are returned raw.

Organization secrets have additional fields with `org_config` that can be used to configure the secret access policy.

### Get secret

Organization secrets:
```
GET {org_name}.semaphoreci.com/api/v1beta/secrets/:secret_id_or_name
```
Project secrets:
```
GET {org_name}.semaphoreci.com/api/v1/projects/:project_id_or_name/secrets/:secret_id_or_name
```

**Params**

- secret_id_or_name (**required**) - The UUID or name of the secret.
- project_id_or_name (**required** for project secrets) - The UUID or name of the project.

**Response**

The response contains a secret object (either project or organization level secret).

### Create secret

Organization secrets:
```
POST {org_name}.semaphoreci.com/api/v1beta/secrets
```
Project secrets:
```
POST {org_name}.semaphoreci.com/api/v1/projects/:project_id_or_name/secrets
```

**Params**

- project_id_or_name (**required** for project secrets) - The UUID or name of the project.

**Request Body**

The request body is a JSON that must containin the following fields:
- `metadata` 
- `data`
- `org_config` (**optional** for organization secrets)

The `metadata` field is a JSON object that must contain the following fields:
- `name` (**required**) - The name of the secret.
- `project_id_or_name` (**required** for project secrets) - The UUID or name of the project.

The `data` field is a JSON object that must contain the following fields:
- `env_vars` (**optional**) - A list of environment variables. (Environment variables are JSON objects containing name and value.)
- `files` (**optional**) - A list of files. (Files are JSON objects containing path and content in base64 encoding.)

The `org_config` field is a JSON object that must contain the following fields:
- `project_access` (**optional**) - A list of project access objects. Possible values are `ALL`, `ALLOWED`, `NONE`. If `ALLOWED` is used, the `project_ids` list must not be empty.
- `project_ids` (**optional**) - A list of project IDs that can access the secret. This field is required if `project_access` is set to `ALLOWED`.
- `debug_access` (**optional**) - A list of debug access objects. Possible values are `JOB_DEBUG_YES`, `JOB_DEBUG_NO`. The default is `JOB_DEBUG_YES`.
- `attach_access` (**optional**) - A list of attach access objects. Possible values are `JOB_ATTACH_YES`, `JOB_ATTACH_NO`. The default is `JOB_ATTACH_YES`.

**Response**

The JSON representation of the created secret object or an error object in [google/rpc/status.proto](https://github.com/googleapis/googleapis/blob/master/google/rpc/status.proto) format.

### Update secret

Organization secrets:
```
PATCH {org_name}.semaphoreci.com/api/v1beta/secrets/:secret_id_or_name
```
Project secrets:
```
PATCH {org_name}.semaphoreci.com/api/v1/projects/:project_id_or_name/secrets/:secret_id_or_name
```

**Params**

- secret_id_or_name (**required**) - The UUID or name of the secret.
- project_id_or_name (**required** for project secrets) - The UUID or name of the project.

**Request Body**

The request body is a JSON secret object.

**Response**

The JSON representation of the updated secret object or an error object in [google/rpc/status.proto](https://github.com/googleapis/googleapis/blob/master/google/rpc/status.proto) format.

### Delete secret

Organization secrets:
```
DELETE {org_name}.semaphoreci.com/api/v1beta/secrets/:secret_id_or_name
```
Project secrets:
```
DELETE {org_name}.semaphoreci.com/api/v1/projects/:project_id_or_name/secrets/:secret_id_or_name
```

**Params**

- secret_id_or_name (**required**) - The UUID or name of the secret.
- project_id_or_name (**required** for project secrets) - The UUID or name of the project.

**Response**

Empty JSON object if successful with 200 response code, or an error JSON representation of [google/rpc/status.proto](https://github.com/googleapis/googleapis/blob/master/google/rpc/status.proto) format.

## Projects

### List projects

```
GET {org_name}.semaphoreci.com/api/v1alpha/projects
```

**Response**

Currently there is no pagination support, so the response will contain a list of all projects (max 500).

```json
[
  {
    "spec": {
      "visibility": "private",
      "schedulers": [],
      "repository": {
        "whitelist": {
          "tags": [],
          "branches": []
        },
        "url": "...",
        "status": {
          "pipeline_files": [
            {
              "path": ".semaphore/semaphore.yml",
              "level": "pipeline"
            }
          ]
        },
        "run_on": [
          "tags",
          "branches"
        ],
        "pipeline_file": ".semaphore/semaphore.yml",
        "owner": "...",
        "name": "semaphore-demo-go",
        "integration_type": "github_token",
        "forked_pull_requests": {
          "allowed_secrets": [],
          "allowed_contributors": []
        }
      }
    },
    "metadata": {
      "owner_id": "...",
      "org_id": "...",
      "name": "semaphore-demo-go",
      "id": "...",
      "description": ""
    },
    "kind": "Project",
    "apiVersion": "v1alpha"
  }
]
```

### Create project

```
POST {org_name}.semaphoreci.com/api/v1alpha/projects
```

**Request Body**

The request body is a JSON object that must contain the following fields:
- `metadata` - A JSON object that must contain the following fields:
  - `name` (**required**) - The name of the project.
  - `description` (**optional**) - The description of the project.
- `spec` - A JSON object with project spec
  - `visibility` (**required**) - The visibility of the project. Possible values are `public` and `private`.
  - `repository` - A JSON object that must contain the following fields:
    - `url` (**required**) - The URL of the repository.
    - `integration_type` (**required**) - The integration type of the repository. Possible values are `github_token`, `github_app`, `gitlab_token`, `gitlab_app`, `bitbucket_token`, `bitbucket_app`, `gitea_token`, `gitea_app`, `gogs_token`, `gogs_app`, `custom_token`, `custom_app`.
    - `name` (**required**) - The name of the repository.
    - `run_on` (**required**) - A list of run on values. Possible values are `tags` and `branches`.
    - `pipeline_file` (**required**) - The path to the pipeline file.
    - `whitelist` - A JSON object that must contain the following fields:
      - `tags` (**required**) - A list of tags.
      - `branches` (**required**) - A list of branches.
    - `forked_pull_requests` - A JSON object that must contain the following fields:
      - `allowed_secrets` (**required**) - A list of allowed secrets.
      - `allowed_contributors` (**required**) - A list of allowed contributors.

**Example**

```json
{
  "apiVersion": "v1alpha",
  "kind": "Project",
  "metadata": {
    "name": "my-project"
  },
  "spec": {
    "repository": {
      "url": "git@github.com:semaphoreci/my-project.git",
      "run_on": [
        "branches",
        "tags"
      ],
      "forked_pull_requests": {},
      "pipeline_file": "",
      "whitelist": {},
      "integration_type": "github_token"
    }
  }
}
```

**Response**

```json
{
  "spec": {
    "visibility": "private",
    "schedulers": [],
    "repository": {
      "whitelist": {
        "tags": [],
        "branches": []
      },
      "url": "git@github.com:semaphoreci/my-project.git",
      "status": {
        "pipeline_files": [
          {
            "path": ".semaphore/semaphore.yml",
            "level": "pipeline"
          }
        ]
      },
      "run_on": [
        "tags",
        "branches"
      ],
      "pipeline_file": ".semaphore/semaphore.yml",
      "owner": "semaphoreci",
      "name": "my-project",
      "integration_type": "github_token",
      "forked_pull_requests": {
        "allowed_secrets": [],
        "allowed_contributors": []
      }
    }
  },
  "metadata": {
    "owner_id": "f14146cf-7e15-4c5c-8514-5686b0842f1f",
    "org_id": "51980207-699f-4732-8ace-42af2b732a85",
    "name": "my-project",
    "id": "a8b75bd0-6db9-48d6-abaa-98139aef9e69",
    "description": ""
  },
  "kind": "Project",
  "apiVersion": "v1alpha"
}
```

### Update project

```
PATCH {org_name}.semaphoreci.com/api/v1alpha/projects/:project_name
```

**Params**

- `project_name` (**required**) - The name of the project.

**Request Body**

The same JSON as the create project request body.


### Delete project

```
DELETE {org_name}.semaphoreci.com/api/v1alpha/projects/:project_name
```

**Params**

- `project_name` (**required**) - The name of the project.

**Response**

Empty response with 200 status code on success.
