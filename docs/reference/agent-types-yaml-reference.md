---
Description: This document provides a comprehensive reference for the YAML grammar used to set up agent types.
---

# Agent types YAML Reference

The agent types YAML reference explains the YAML grammar used for
configuring self-hosted agent types.

## Properties

### apiVersion

The `apiVersion` property indicates the version of the YAML grammar employed
within the current YAML file. Different versions may introduce varying features.

Here is a list of valid values for the `apiVersion` property: `v1alpha`.

### kind

The `kind` property specifies the purpose of a YAML file. For YAML files
intended to define self-hosted agent types, the value of the `kind` property should
be `SelfHostedAgentType`.

Here is a list of valid values for the `kind` property: `SelfHostedAgentType`.

### metadata

The `metadata` property defines the metadata for an agent type YAML file,
supporting the following properties: `name`, `create_time`, `update_time`.

#### name

The `name` property is a string that represents the name of the self-hosted agent type.
The name should only consist of alphanumerical characters, dashes, underscores, `/` and plus characters, and should start with the `s1-` prefix.

#### create_time

The `create_time` property indicates the UTC when the self-hosted agent type was created.
It should not be modified.

#### update_time

The `update_time` property denotes the UTC when the self-hosted agent type was last
updated. It should not be modified.

### spec

The `spec` property contains a list of agent type properties.

#### agent_name_settings

The `agent_name_settings` property is an object with the following properties: `assignment_origin`, `release_name_after`, and `aws`.

##### assignment_origin

The `assignment_origin` property can have one of the following values: `assignment_origin_agent`, or `assignment_origin_aws_sts`. Each value has a specific meaning:

- `assignment_origin_agent`: This agent type will allow agents to choose their registration names when registering.

- `assignment_origin_aws_sts`: This agent type will not allow agents to choose their registration names. Instead agents will be required to use a pre-signed AWS STS GetCallerIdentity URL to register.

If `assignment_origin_aws_sts` is used, the `agent_name_settings.aws` property needs to be specified.

##### release_name_after

The `release_name_after` property is a number of seconds, which determines how long the agent name will be blocked from being reused by a new agent registering.

It must be either 0 - name is reusable immediately after agent disconnects - or a number of seconds above 60.

##### aws

The `aws` property is an object with the following properties: `account_id` and `role_name_patterns`.

- The `account_id` property is a string containing the AWS account allowed to use pre-signed AWS STS URLs to register agents.

- The `role_name_patterns` property is a string containing a comma-separated list of AWS IAM role names allowed to register agents. It allows wildcards.

## An example

The following YAML code provides an example of an agent type as returned by the `sem get agent_type s1-example` command:

```bash
$ sem get agent_type s1-example
apiVersion: v1alpha
kind: SelfHostedAgentType
metadata:
  name: s1-example
  create_time: 1701093702
  update_time: 1701096126
spec:
  agent_name_settings:
    assignment_origin: assignment_origin_aws_sts
    aws:
      account_id: 1234567890
      role_name_patterns: role1,role2
    release_after: 60
```

You can find out more about self-hosted agent types by visiting our
[agent types](/ci-cd-environment/self-hosted-agent-types),
and [sem command line tool](/reference/sem-command-line-tool#working-with-self-hosted-agents)
reference documentation.

## See Also

- [Agent types](/ci-cd-environment/self-hosted-agent-types)
- [sem command line tool](/reference/sem-command-line-tool#working-with-self-hosted-agents)
