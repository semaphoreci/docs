---
Description: This guide describes how to set up a fleet of self-hosted agents in AWS
---

# AWS support

!!! beta "Self-hosted agents - closed beta"
    Self-hosted agents are in closed beta. If you would like to run Semaphore agents on your infrastructure, please [contact us and share your use case](https://semaphoreci.com/contact). Our team will get back to you as soon as possible.

If you intend to run your agents on AWS, the [agent-aws-stack][agent-aws-stack] can help you deploy an auto-scaling fleet of agents on your AWS account.

## Features

- Run self-hosted agents in Linux-based machines
- [Dynamically increase and decrease](#scaling-based-on-job-demand) the number of agents available based on your job demand
- Deploy [multiple stacks of agents](#multiple-stacks), one for each self-hosted agent type
- [Access agent EC2 instances](#agent-instance-access) via SSH or using [AWS Systems Manager Session Manager][aws session manager]
- Use an S3 bucket to [cache the dependencies][caching] needed for your jobs
- Control the size of your agent instances and your agent pool

## Requirements

The [agent-aws-stack][agent-aws-stack] is an [AWS CDK][aws cdk] application written in JavaScript, which depends on a few things to work:

- Node and NPM, for building and deploying the CDK application and managing its dependencies
- Make, Python 3, and Packer for AMI creation and provisioning
- Properly-configured [AWS credentials][aws credentials]

## Usage

### 1. Downloading the CDK application and installing dependencies

```
curl -sL https://github.com/renderedtext/agent-aws-stack/archive/refs/tags/v0.1.3.tar.gz -o agent-aws-stack.tar.gz
tar -xf agent-aws-stack.tar.gz
cd agent-aws-stack-0.1.3
npm i
```

You can also fork and clone the repository.

### 2. Building your AMI

```
make packer.build
```

This command uses packer to create an AMI with everything the agent needs from your AWS account. The AMI is based on the Ubuntu 20.04 server image.

### 3. Creating an encrypted SSM parameter for the agent type registration token

When creating your agent type using the Semaphore UI, you get a [registration token][registration token]. This is a sensitive piece of information, so you should create an encrypted AWS SSM parameter with it:

```
aws ssm put-parameter \
  --name YOUR_SSM_PARAMETER_NAME \
  --value "YOUR_AGENT_TYPE_REGISTRATION_TOKEN" \
  --type SecureString \
  --key-id YOUR_KMS_KEY_ID
```

### 4. Setting environment variables

```
export SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME=<your-ssm-parameter-name>
export SEMAPHORE_AGENT_TOKEN_KMS_KEY=<your-kms-key-id>
export SEMAPHORE_AGENT_STACK_NAME=<your-stack-name>
export SEMAPHORE_ENDPOINT=<your-organization>.semaphoreci.com
```

[Other environment variables](#configuration) may be configured as well, depending on your needs.

### 5. Bootstrapping the CDK application

The AWS CDK requires a few resources to be on hand for it to work properly:

```
npm run bootstrap -- aws://YOUR_AWS_ACCOUNT_ID/YOUR_AWS_REGION
```

### 6. Deploying the stack

```
npm run deploy
```

## In-place updates

When changing the configuration of your stack, you can update it in-place. AWS CDK will use AWS Cloudformation changesets to apply the required changes. Before updating, you can check what will be different with the `diff` command:

```bash
npm run diff
```

To update, use:

```bash
npm run deploy
```

!!! info "In-place updates might require an agent restart"
    A few configuration parameters are read by the agent instance during the startup process. If you change them, the running agents won't automatically reload it. Therefore, you will need to restart those instances. You can restart all the agents in your stack by disconnecting them via the Semaphore UI.

## Agent type registration token rotation

After resetting the agent type token via the Semaphore UI, currently-running agents will remain active. However, you will need to update the SSM parameter (`SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME`) with the new token for new agents to function.

## Deleting the stack

To delete the stack, use:

```bash
npm run destroy
```

Note: make sure `SEMAPHORE_AGENT_STACK_NAME` indicates to the stack you want to destroy.

## Configuration

<b>Required</b>

| Parameter name                                   | Description |
|--------------------------------------------------|-------------|
| `SEMAPHORE_ORGANIZATION` or `SEMAPHORE_ENDPOINT` | If `SEMAPHORE_ENDPOINT` is set, the agents will use that endpoint to register and sync for jobs. If `SEMAPHORE_ENDPOINT` is not set, but `SEMAPHORE_ORGANIZATION` is set, it is assumed that the organization is located at `<organization>.semaphoreci.com`, and that will be the endpoint used. |
| `SEMAPHORE_AGENT_STACK_NAME`                     | The name of the stack. This will end up being used as the Cloudformation stack name, and as a prefix to name all the resources of the stack. When deploying multiple stacks for multiple agent types, different stack names are required |
| `SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME`           | The AWS SSM parameter name containing the Semaphore agent [registration token][registration token] |

<b>Optional</b>

| Parameter name                                  | Description |
|-------------------------------------------------|-------------|
| `SEMAPHORE_AGENT_INSTANCE_TYPE`                 | Instance type used for the agents. Default is `t2.micro`. |
| `SEMAPHORE_AGENT_ASG_MIN_SIZE`                  | Minimum size for the auto-scaling group. Default is `0`. |
| `SEMAPHORE_AGENT_ASG_MAX_SIZE`                  | Maximum size for the auto-scaling group. Default is `1`. |
| `SEMAPHORE_AGENT_ASG_DESIRED`                   | Desired capacity for the auto-scaling group. Default is `1`. |
| `SEMAPHORE_AGENT_USE_DYNAMIC_SCALING`           | Whether to use a lambda to dynamically scale the number of agents in the auto-scaling group based on the job demand. Default is `true` |
| `SEMAPHORE_AGENT_SECURITY_GROUP_ID`             | Security group id to use for agent instances. If not specified, a security group will be created with (1) an egress rule allowing all outbound traffic and (2) an ingress rule for SSH, if `SEMAPHORE_AGENT_KEY_NAME` is specified. |
| `SEMAPHORE_AGENT_KEY_NAME`                      | Key name to access agents through SSH. If not specified, no SSH inbound access is allowed |
| `SEMAPHORE_AGENT_DISCONNECT_AFTER_JOB`          | If the agent should shutdown or not after completing a job. Default is `true`. |
| `SEMAPHORE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT` | Number of seconds of idleness after which the agent will shutdown. Note: setting this to 0 will disable the scaling down behavior for the stack, since the agents won't shutdown due to idleness. Default is `300`. |
| `SEMAPHORE_AGENT_CACHE_BUCKET_NAME`             | Existing S3 bucket name to use for caching. If this is not set, [caching][caching] won't work. |
| `SEMAPHORE_AGENT_TOKEN_KMS_KEY`                 | KMS key id used to encrypt and decrypt `SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME`. If nothing is given, the default `alias/aws/ssm` key is assumed. |
| `SEMAPHORE_AGENT_VPC_ID`                        | The id of an existing VPC to use when launching agent instances. By default, this is blank, and the default VPC on your AWS account will be used. |
| `SEMAPHORE_AGENT_SUBNETS`                       | Comma-separated list of existing VPC subnet ids where EC2 instances will run. This is required when using `SEMAPHORE_AGENT_VPC_ID`. If `SEMAPHORE_AGENT_SUBNETS` is set, but `SEMAPHORE_AGENT_VPC_ID` is blank, the subnets will be ignored and the default VPC will be used. Private and public subnets are possible, but isolated subnets cannot be used. |
| `SEMAPHORE_AGENT_AMI`                           | The AMI used for all instances. If empty, the stack will use the default AMIs, looking them up by name. If the default AMI isn't sufficient, you can use your own AMIs, but they need to be based off of the stack's default AMI. |

## Architecture

<img src="https://raw.githubusercontent.com/semaphoreci/docs/master/public/self-hosted-aws-stack.png" width="100%"></img>

## Networking

By default, the agents will run in your [default AWS VPC][default AWS VPC]. That means that your agents will have a public and a private IPv4 address assigned to them and will run on a public subnet, and traffic bound for the internet will be sent to an [internet gateway][internet gateway].

However, since all the communication between agents and the Semaphore API happens unidirectionally (from the agent to Semaphore), the agent instances don't need to be publicly accessible via the Internet -- they only need outbound access. Therefore, you can also run your agents on a private subnet with no public IPv4 address assigned, and use [NAT devices][nat devices] to send outbound traffic to the Internet.

Therefore, you don't need to rely on your default AWS VPC. You can create a custom VPC and subnets that fit your needs, and use the `SEMAPHORE_AGENT_VPC_ID` and `SEMAPHORE_AGENT_SUBNETS` parameters to configure the stack to use them.

### Agent instance access

There are two different ways to access your agent instances:

- Using SSH. This approach will only work for instances with a publicly-assigned IP. By default, your instances will have a security group with no inbound access. You can change that behavior by creating an EC2 key and using the `SEMAPHORE_AGENT_KEY_NAME` parameter, which will add an SSH inbound rule to the default security group created and used in your instances. If you need to further restrict or open up access to your agent instances, you can also create a security group yourself and use the `SEMAPHORE_AGENT_SECURITY_GROUP_ID` to instruct the stack to use it.
- Using [AWS Systems Manager Session Manager][aws session manager]. This kind of access doesn't rely on a publicly-accessible instance. Therefore, this is the only way to access instances running on private subnets. You can also use this approach to access publicly-available instances.

## Scaling based on job demand

By default, the stack will be created to support dynamic scaling of agents based on the job demand for your agent type.

The way the stack determines the need for an increase on the number of agents is by using a Lambda function to periodically poll the Semaphore API for the number of jobs for a given agent type. If an increase is needed, the Lambda function will update the auto-scaling group's desired capacity and new EC2 instances will be launched with new agents.

When the number of running agents outnumbers the number of jobs running, a few agents will be allowed to idle. When an agent remains idle for a given period of time, it will shutdown and decrease the capacity for the auto-scaling group. If all your agents are idle, they will all shutdown and the auto-scaling group will have a count of 0.

Finally, you can control this behavior via several configuration parameters:

- By default, the idle period after which an agent shuts down is 5 minutes. But you can configure it to what works best for you by using the `SEMAPHORE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT` parameter. Setting this parameter to 0 will stop agents from shutting down when they are idle, so your stack won't ever scale down.
- Even if you have a lot of jobs, you probably do not want your stack to grow infinitely. You can use the `SEMAPHORE_AGENT_ASG_MAX_SIZE` parameter to configure a limit for your auto-scaling group. The lambda will respect your configuration and will not increase the number of agents above that limit.
- You might want some agents to always be running even if no jobs are running. To address that, you can configure a minimum number of agents for your auto-scaling group with the `SEMAPHORE_AGENT_ASG_MIN_SIZE` parameter.
- You might also not want a dynamically-sized auto-scaling group at all. You can disable this behavior completely and have a static pool of agents by using the `SEMAPHORE_AGENT_USE_DYNAMIC_SCALING` parameter.

## Job isolation

By default, agents will shutdown after executing a job. That agent will be replaced by a new one for each subsequent job, which guarantees a clean environment.

This comes with a cost, however, as rotating EC2 instances is not always a fast operation. If you want your instances not to shutdown after a job, you can use the `SEMAPHORE_AGENT_DISCONNECT_AFTER_JOB` parameter. A faster alternative to EC2 instance rotation is using [Docker containers][using docker containers] to run your jobs.

## Multiple stacks

Each stack that is deployed creates and starts agents for one agent type only. However, you might need to deploy multiple stacks for multiple agent types. To achieve that, you need to:

- Set a different `SEMAPHORE_AGENT_STACK_NAME` parameter for each stack.
- Create one encrypted SSM parameter for each agent type registration token, and set the `SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME` appropriately for each one.

[agent-aws-stack]: https://github.com/renderedtext/agent-aws-stack
[aws cdk]: https://docs.aws.amazon.com/cdk/v2/guide/home.html
[registration token]: /ci-cd-environment/self-hosted-agents-overview
[caching]: /essentials/caching-dependencies-and-directories
[aws session manager]: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html
[using docker containers]: /ci-cd-environment/job-isolation.md
[default AWS VPC]: https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html
[internet gateway]: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
[nat devices]: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat.html
[aws credentials]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
