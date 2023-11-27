---
Description: This guide describes how to create and use a self-hosted agent type
---

# Using self-hosted agent types

!!! plans "Available on: <span class="plans-box">[Free & OS](/account-management/discounts/)</span> <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

Before running and using self-hosted agents in your pipelines, you need to register a new agent type in your organization.

## Creating a self-hosted agent type

1. Go to `<your-organization-name>.semaphoreci.com/self_hosted_agents`
2. Click the `Add a self-hosted agent type` button
3. Add a name and click `Looks good. Register`
4. Your agent type should be created. Follow the instructions to install the agent on your operating system of choice. The instructions are also available [here][installing-agents].


!!! info "Required permissions to add a new self-hosted agent type"
    Only users with the **Admin** permission level can add a new self-hosted agent type.    

## Using a self-hosted agent type in your pipelines

To use a self-hosted agent type in your pipelines, the machine type in the agent definition of your pipeline needs to be updated. For example, if you named your self-hosted machine type **s1-linux-small**, use this configuration:

```diff
agent:
  machine:
-   os_image: ubuntu1804
-   type: e1-standard-2
+   type: s1-linux-small
```

And that's it. Now jobs using that agent type will run on the agents you registered for that type.

## Using pre-signed AWS STS URLs for registration

By default, an agent type allows an agent to choose its name when registering. However, a pre-signed AWS STS GetCallerIdentity URL can be used instead. That is configured on the agent type level.

Two pieces of information are required to configure this behavior on the agent type:

1. The AWS account ID.
2. The comma-separated list of AWS IAM role names.

If the agent type is configured that way, agents can only use pre-signed AWS STS URLs for registration. The Semaphore control plane will reject the agent registration if the information in the URL response do not match what is configured for the agent type.

### How is the agent name assigned?

The Semaphore control plane will follow the pre-signed AWS STS URL sent, and if everything in the response matches what is configured on the agent type, it will use the session ID returned in the response as the agent name.

For example, if the AWS account specified is `XYZ`, and the AWS IAM role name list includes a role named `example1`, the response from the AWS STS pre-signed URL must be something like:

```json
{
  "Account": "XYZ",
  "Arn": "arn:aws:sts::XYZ:assumed-role/example1/i-1234567890"
}
```

Since the session ID in that case is `i-1234567890`, that value will be used as the new agent name.

## Agent name release

By default, an agent name is immediately available for re-use after it disconnects. You can change that behavior by specifying a number of seconds to hold the agent name after its disconnection. The minimum number is 60 seconds.

[installing-agents]: ./install-self-hosted-agent.md
