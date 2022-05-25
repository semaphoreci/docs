---
Description: This guide describes how to create and use a self-hosted agent type
---

# Using self-hosted agent types
!!! beta "Self-hosted agents - closed beta"
    Self-hosted agents are in closed beta. If you would like to run Semaphore agents on your infrastructure, please [contact us and share your use case](https://semaphoreci.com/contact). Our team will get back to you as soon as possible.

Before running and using self-hosted agents in your pipelines, you need to register a new agent type in your organization.

## Creating a self-hosted agent type

1. Go to `<your-organization-name>.semaphoreci.com/self_hosted_agents`
2. Click the `Add a self-hosted agent type` button
3. Add a name and click `Looks good. Register`
4. Your agent type should be created. Follow the instructions to install the agent on your operating system of choice. The instructions are also available [here][installing-agents].

**Note:** only users with the Admin permission level can add a self-hosted agent type

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

[installing-agents]: ./install-self-hosted-agent.md
