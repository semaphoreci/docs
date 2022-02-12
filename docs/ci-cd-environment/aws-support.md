---
Description: This guide describes how to set up a fleet of self-hosted agents in AWS
---

# AWS support

Even though manually starting and stopping agents might serve your purposes, having a dynamically sized pool of agents which automatically resizes itself on high and low load periods allows you to have a more highly available fleet of agents at your disposal. 

Semaphore exposes ways for you to implement that. However, that solution is highly dependent on the environment where you are running your agents.

If you intend to run your agents in AWS, the [agent-aws-stack][agent-aws-stack] can help you deploy an autoscaling fleet of agents in your AWS account.

## Features

- Run self-hosted agents in Linux-based machines
- [Dynamically increase and decrease](#scaling-based-on-job-demand) the number of agents available based on your job demand
- Deploy [multiple stacks of agents](#multiple-stacks), one for each self-hosted agent type
- [Access the agent EC2 instances](#agent-instance-access) through SSH or using [AWS Systems Manager Session Manager][aws session manager]
- Use an S3 bucket to [cache the dependencies](#caching) needed for your jobs
- Control the size of your agent instances and of your agent pool

## Architecture

<img src="https://raw.githubusercontent.com/semaphoreci/docs/aws-support/public/self-hosted-aws-stack.png" width="100%"></img>

## Requirements

The [agent-aws-stack][agent-aws-stack] is an [AWS CDK][aws cdk] application written in JavaScript, which depends on a few things to work:

- [Node](https://nodejs.org/en/)
- [NPM](https://www.npmjs.com/)
- [Packer](https://www.packer.io/)
- [Ansible](https://www.ansible.com/)

There are also a few required AWS resources you need to create before deploying the stack:

- The [agent type registration token][registration token] is a sensitive piece of information. Therefore, you need to create an encrypted AWS SSM parameter to hold it. You can check how to create it [here][aws ssm parameter creation].
- The agent EC2 instances requires an AMI to be used. You can check how to create it [here][ami creation].
- The AWS CDK requires a few resources to be in place for it to work properly. You can check how to create them [here][aws cdk bootstrap].

There are a few other optional resources that may be created, but are not required. If these optional resources are not previously created and specified, the stack will follow its default behavior. Make sure you either create these optional resources and pass them to the stack or you are aware that the stack defaults work for your use case.

### Caching

By default, the [cache CLI][cache cli] will not work in your agent instances. If you need to [cache dependencies][caching] in your jobs, you will need to create an S3 bucket to use as a caching store.

After creating it, make sure the `SEMAPHORE_AGENT_CACHE_BUCKET_NAME` parameter is set to your bucket's name.

### Networking

By default, the agents will run in your [default AWS VPC][default AWS VPC]. That means that your agents will have a public and a private IPv4 address assigned to them and will run in a public subnet, having its traffic destined to the internet sent to an [internet gateway][internet gateway].

However, since all the communication between agents and the Semaphore API happens unidirectionally (from the agent), the agent instances don't really need to be publicly accessible through the Internet. They only need outbound access to the internet. Therefore, you can also run your agents in a private subnet with no public IPv4 address assigned, and use [NAT devices][nat devices] to send its outbound traffic to the internet.

Therefore, you don't need to rely on your default AWS VPC. You can create a custom VPC and subnets that fit your needs and use the `SEMAPHORE_AGENT_VPC_ID` and `SEMAPHORE_AGENT_SUBNETS` parameters to configure the stack to use them.

### Agent instance access

There are two different ways to access your agent instances:

- Using SSH. This approach will only work for instances with a public assigned IP. By default, your instances will have a security group with no inbound access. You can change that behavior by creating an EC2 key and using the `SEMAPHORE_AGENT_KEY_NAME` parameter, which will add an SSH inbound rule to the default security group created and used in your instances. If you need to further restrict or open up access to your agent instances, you can also create a security group yourself and use the `SEMAPHORE_AGENT_SECURITY_GROUP_ID` to instruct the stack to use it.
- Using [AWS Systems Manager Session Manager][aws session manager]. This kind of access doesn't rely on a publicly accessible instance. Therefore, this is the only way to access instances running in private subnets. You can also use this approach to access publicly available instances.

## Scaling based on job demand

By default, the stack will be created to support dynamic scaling of agents based on the job demand for your agent type.

The way the stack determines the need for an increase on the number of agents is by using a Lambda function to periodically poll the Semaphore API for the number of jobs for that particular agent type. If an increase is needed, the Lambda function will update the auto scaling group's desired capacity and new EC2 instances will be launched with new agents.

When the number of agents running outnumber the number of jobs running, a few agents will be idle. When an agent remains idle for a long period of time, it will shutdown and decrease the desired capacity for the auto scaling group. If all your agents are idle, they will all shutdown and the auto scaling group will have a desired count of 0.

Finally, you can control this behavior through a few configuration parameters:

- The default, the idle period after which an agent shuts down is 5 minutes. But you can configure that to what works best for you by using the `SEMAPHORE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT` parameter. Setting that parameter to 0 will stop shutting down agents when they are idle, so your stack won't ever scale down.
- Even if you have a lot of jobs, you might not want your stack to grow infinitely. You can use the `SEMAPHORE_AGENT_ASG_MAX_SIZE` parameter to configure a limit for your auto scaling group. The lambda will respect your configuration and will not increase the number of agents above that limit.
- You might want some agents to always be running even if no jobs are running. To address that, you can configure a minimum number of agents for your auto scaling group with the `SEMAPHORE_AGENT_ASG_MIN_SIZE` parameter.
- You might also not want a dynamically sized auto scaling group at all. You can disable this behavior completely and have a statically sized pool of agents by using the `SEMAPHORE_AGENT_USE_DYNAMIC_SCALING` parameter.

## Job isolation

By default, agents will shutdown after executing a job. That agent will be replaced by a new one, which guarantees a clean environment for each and every job.

This comes with a cost, as rotating EC2 instances may not be a fast operation. If you want your instances to not shutdown after a job, you can use the `SEMAPHORE_AGENT_DISCONNECT_AFTER_JOB` parameter. A faster alternative to EC2 instance rotation is using [Docker containers][using docker containers] to run your jobs.

## Multiple stacks

Each stack that is deployed spins up agents for one agent type. However, you might need to deploy multiple stacks for multiple agent types. To achieve that, you need to:

- Set a different `SEMAPHORE_AGENT_STACK_NAME` parameter for each stack.
- Create one encrypted SSM parameter for each agent type registration token, and set the `SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME` appropriately for each one.

## Configuration reference

The stack configuration is done through environment variables. All the available configuration parameters can be found [here][config parameters].

[agent-aws-stack]: https://github.com/renderedtext/agent-aws-stack
[aws cdk]: https://docs.aws.amazon.com/cdk/v2/guide/home.html
[registration token]: /ci-cd-environment/self-hosted-agents-overview#tokens-used-for-communication
[aws ssm parameter creation]: https://github.com/renderedtext/agent-aws-stack#create-encrypted-aws-ssm-parameter
[ami creation]: https://github.com/renderedtext/agent-aws-stack#building-the-ami
[aws cdk bootstrap]: https://github.com/renderedtext/agent-aws-stack#deploying-the-stack
[caching]: /reference/caching-dependencies-and-directories
[aws session manager]: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html
[using docker containers]: /ci-cd-environment/job-isolation.md
[cache cli]: /reference/toolbox-reference#cache
[config parameters]: https://github.com/renderedtext/agent-aws-stack#configuration
[default AWS VPC]: https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html
[internet gateway]: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
[nat devices]: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat.html