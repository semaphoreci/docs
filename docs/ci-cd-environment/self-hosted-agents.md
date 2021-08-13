---
description: This guide describes self hosted agents and how to use them.
---

# Self Hosted Agents

When running jobs in Semaphore, you need to specify a [machine type][machine-types]. When you don't want to manage the machines yourself, you can use the standard `e1-*` and `a1-*` machine types and Semaphore will take care of finding machines, starting the agent and running your jobs on those agents for you.

However, if you want to run the agents yourself, inside your own infrastructure, you can use self hosted agents.

## Agent communication with Semaphore

All communication between the agent and Semaphore is unidirectional, from the agent to Semaphore.

When booting, the agent will attempt to register with the Semaphore 2.0 API using the endpoint and registration token you use. If it succeeds, it will enter sync mode, sending periodic requests to Semaphore's API to tell it what it is doing and be told what to do next.

If it fails to register, the agent won't start and won't receive any jobs. If it fails to sync, it also won't receive any more jobs and will eventually shutdown.

## Creating an agent type

1. Go to `<your-organization-name>.semaphoreci.com/self_hosted_agents`
2. Click the `Add a self hosted agent type`
3. Give it a name and click `I'm happy with this. Register it`
4. Your agent is created. Reveal the registration token and copy the registration token. You will need to use that token when starting agents of this type. Note that you won't be able to see that token again, so make sure you save it in somewhere safe
5. Done! Now, you can start [running agents][installing-agents]

[machine-types]: ../ci-cd-environment/machine-types.md
[installing-agents]: ../ci-cd-environment/installing-a-self-hosted-agent.md