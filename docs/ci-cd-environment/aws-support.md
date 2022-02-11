---
Description: This guide describes how to set up a fleet of self-hosted agents in AWS
---

# AWS support

Running one-off agents is not the most sofisticated solution for having a highly available fleet of agents at your disposal. Having a dynamically sized pool of agents which automatically resizes itself on high and low load periods is a more interesting solution.

However, that solution is highly dependent on the environment where you are running your agents. The [agent-aws-stack][agent-aws-stack] can help you deploy a fleet of agents in your AWS account.

## Features

<img src="https://raw.githubusercontent.com/semaphoreci/docs/aws-support/public/self-hosted-aws-stack.png" width="600"></img>

- Dynamically scale the number of agents based on job demand
- Configurable instance and fleet sizes
- Support for multiple fleets of agents
- SSH and AWS Systems Manager Session Manager access
- S3-based caching
- Linux-based agents support

## Requirements

The [agent-aws-stack][agent-aws-stack] is an [AWS CDK][aws cdk] application written in JavaScript, which depends on a few things to work:

- [Node](https://nodejs.org/en/)
- [NPM](https://www.npmjs.com/)
- [Packer](https://www.packer.io/)
- [Ansible](https://www.ansible.com/)

## Before you start

There are a few required AWS resources you need to create before deploying the stack:

- The [agent type registration token][registration token] is a sensitive piece of information. Therefore, you need to create an encrypted AWS SSM parameter to hold it. You can check how to create it [here][aws ssm parameter creation].
- The agent EC2 instances requires an AMI to be used. You can check how to create it [here][ami creation].
- The AWS CDK requires a few resources to be in place for it to work properly. You can check how to create them [here][aws cdk bootstrap].

There are a few other optional resources that may be created, but are not required. If these resources are not previously created and specified, the stack will follow its default behavior. Make sure you either create these optional resources or are aware that the stack defaults work for your use case.

### Caching

By default, the [cache CLI][cache cli] will not work in your agent instances. If you need to [cache dependencies][caching] in your jobs, you will need to create an S3 bucket to use as a caching store.

After creating it, make sure the `SEMAPHORE_AGENT_CACHE_BUCKET_NAME` parameter is set to your bucket's name.

### Networking

By default, the agents will run in your default AWS VPC. That means that they will have public assigned IPs, since the default AWS VPC has only public subnets.

However, since all the communication between agents and the Semaphore API happens unidirectionally (from the agent), the agent instances don't need to allow inbound traffic to them, only outbound traffic. That means that they can run in a private subnet with an attached internet gateway.

You can create custom VPC and subnets that fits your needs and use the `SEMAPHORE_AGENT_VPC_ID` and `SEMAPHORE_AGENT_SUBNETS` parameters to configure the stack to use them.

### Agent instance access

There are two different ways to access your agent instances:

- Using SSH. By default, your agent instances will have a security group with no inbound access. You can change that behavior by creating an EC2 key and using the `SEMAPHORE_AGENT_KEY_NAME` parameter, which will add an SSH inbound rule to the default security group created and used in your agent instances. If you need to further restrict or open up the access to your agent instances, you can also create a security group yourself and use the `SEMAPHORE_AGENT_SECURITY_GROUP_ID` to instruct the stack to use your security group. However, this approach will only work for agent instances with a public assigned IP.
- Using [AWS Systems Manager Session Manager][aws session manager]. This kind of access doesn't rely on a publicly accessible agent instance. Therefore, this is the only way to access agent instances running in private subnets. You can also use this approach to access publicly available agent instances.

## Scaling based on job demand

By default, the stack will be created to support dynamic scaling of agents based on the job demand for your agent type.

The way the stack determines the need for an increase on the number of agents is by using a Lambda function to periodically poll the Semaphore API for the number of jobs for that particular agent type. If there's a need for an increase, the Lambda function will update the auto scaling group's desired count and new EC2 instances will be launched with new agents.

When the number of agents running outweigh the number of jobs running, a few agents will be idle. When an agent remains idle for a period of time, it will shutdown and decrease the desired count on the auto scaling group. If all your agents are idle, they will all shutdown and the auto scaling group will have a desired count of 0.

Finally, you can control that behavior through a few configuration parameters:

- The default idleness period after which an agent shuts down is 5 minutes. But you can configure that to what works best for you by using the `SEMAPHORE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT` parameter. Setting that parameter to 0 will stop shutting down agents by idleness, so your stack won't ever scale down, and you'll need to scale it down manually.
- Even if you have a lot of jobs, you might not want your stack to grow infinitely. You can use the `SEMAPHORE_AGENT_ASG_MAX_SIZE` parameter to configure a limit for your auto scaling group. The lambda will respect your configuration and will not increase the number of agents above that limit.
- You might want some agents to always be running even if no jobs are running. To address that, you can configure a minimum number of agents for your auto scaling group with the `SEMAPHORE_AGENT_ASG_MIN_SIZE` parameter.
- You might also not want a dynamically sized auto scaling group at all. You can disable this behavior completely and have a statically sized pool of agents by using the `SEMAPHORE_AGENT_USE_DYNAMIC_SCALING` parameter.

## Job isolation

By default, agents will shutdown after executing a job. That agent will be replaced by a new one, which guarantees a clean environment for each and every job.

This comes with a cost, as rotating EC2 instances may not be a fast operation. If you want your instances to not shutdown after a job, you can use the `SEMAPHORE_AGENT_DISCONNECT_AFTER_JOB` parameter. A faster alternative to EC2 instance rotation is using [Docker containers][using docker containers] to run your jobs.

## Configuration reference

TODO

[agent-aws-stack]: https://github.com/renderedtext/agent-aws-stack
[aws cdk]: https://docs.aws.amazon.com/cdk/v2/guide/home.html
[registration token]: ../ci-cd-environment/self-hosted-agents-overview#tokens-used-for-communication
[aws ssm parameter creation]: https://github.com/renderedtext/agent-aws-stack#create-encrypted-aws-ssm-parameter
[ami creation]: https://github.com/renderedtext/agent-aws-stack#building-the-ami
[aws cdk bootstrap]: https://github.com/renderedtext/agent-aws-stack#deploying-the-stack
[caching]: ../reference/caching-dependencies-and-directories
[aws session manager]: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html
[using docker containers]: ../ci-cd-environment/job-isolation.md
[cache cli]: ../reference/toolbox-reference#cache