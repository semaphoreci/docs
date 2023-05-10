---
Description: This guide describes how to set up a fleet of self-hosted agents in AWS
---

# AWS support

!!! plans "Available on: <span class="plans-box">[Free & OS](/account-management/free-and-open-source-plans/)</span> <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

If you intend to run your agents on AWS, the [agent-aws-stack][agent-aws-stack] can help you deploy an auto-scaling fleet of agents on your AWS account.

## Features

- Run self-hosted agents in Linux, Windows and MacOS machines
- [Dynamically increase and decrease](#scaling-based-on-job-demand) the number of agents available based on your job demand
- Deploy [multiple stacks of agents](#multiple-stacks), one for each self-hosted agent type
- [Access agent EC2 instances](#agent-instance-access) via SSH or using [AWS Systems Manager Session Manager][aws session manager]
- Use an S3 bucket to [cache the dependencies][caching] needed for your jobs
- Control the size of your agent instances and your agent pool

## Requirements

The [agent-aws-stack][agent-aws-stack] is an [AWS CDK][aws cdk] application written in JavaScript, which depends on a few things to work:

- Node v16+ and NPM, for building and deploying the CDK application and managing its dependencies
- Make, Python 3, and Packer for AMI creation and provisioning
- Properly-configured [AWS credentials][aws credentials]

## Usage

In order to follow the steps below, please make sure that your AWS user has the [required permissions](#aws-permissions).

### 1. Download the CDK application and installing dependencies

```
curl -sL https://github.com/renderedtext/agent-aws-stack/archive/refs/tags/v0.2.8.tar.gz -o agent-aws-stack.tar.gz
tar -xf agent-aws-stack.tar.gz
cd agent-aws-stack-0.2.8
npm i
```

You can also fork and clone the repository.

### 2. Build the AMI

We use packer to create an AMI with everything the agent needs in your AWS account.

#### Build a Linux AMI

The Linux AMI is based on the Ubuntu 20.04 server image. To build it, run the following commands:

```
make packer.init
make packer.build
```

#### Build a Windows AMI

The Windows AMI is based on the Microsoft Windows Server 2019 with Containers image, provided by AWS. To build it, run the following commands:

```
make packer.init
make packer.build PACKER_OS=windows
```

#### Build a MacOS AMI

Make sure you have an available dedicated host first. After that, an AMD or an ARM AMI can be built. To build it, run the following commands:

```bash
make packer.init

# To build an AMD AMI (EC2 mac1 family)
make packer.build PACKER_OS=macos AMI_ARCH=x86_64 AMI_INSTANCE_TYPE=mac1.metal

# To build an ARM AMI (EC2 mac2 family)
make packer.build PACKER_OS=macos AMI_ARCH=arm64 AMI_INSTANCE_TYPE=mac2.metal
```

#### Build the AMIs in a specific AWS region

By default, the AMI is built in the `us-east` AWS region. If you want to build the AMI in a different AWS region, you can use the `AWS_REGION` variable:

```
make packer.build AWS_REGION=us-west-1
```

### 3. Create an encrypted SSM parameter for the agent type registration token

When creating your agent type using the Semaphore UI, you get a [registration token][registration token]. This is a sensitive piece of information, so you should create an encrypted AWS SSM parameter with it.

You can use the default SSM `aws/ssm` KMS key or a custom KMS key of your choice to encrypt your registration token.

#### Use the default `aws/ssm` KMS key

```
aws ssm put-parameter \
  --name <your-ssm-parameter-name> \
  --value "<your-agent-type-registration-token>" \
  --type SecureString
```

#### Use a customer managed KMS key

When using a customer managed KMS key, make sure you have `kms:Encrypt` permissions for that key. If you want to create a new KMS key, you can use the [create-key][kms create key] operation.

After that, create the encrypted SSM parameter using your KMS key with:

```
aws ssm put-parameter \
  --name <your-ssm-parameter-name> \
  --value "<your-agent-type-registration-token>" \
  --type SecureString \
  --key-id <your-kms-key-id>
```

### 4. Create the execution policy that will be used by Cloudformation

When deploying the stack, you can instruct the AWS CDK to use only the permissions it needs to manage all the stack resources. To do that, create an AWS IAM policy with all the required permissions:

```bash
aws iam create-policy \
  --policy-name agent-aws-stack-cfn-execution-policy \
  --policy-document file://$(pwd)/execution-policy.json \
  --description "Policy used by Cloudformation to deploy the agent-aws-stack CDK application"
```

After creating the AWS IAM policy, save the ARN.

### 4. Create the stack configuration

The stack accepts a number of [parameters for configuration](#configuration). These parameters can be specified either with a configuration file or using environment variables.

#### Create configuration for Linux agents

Create a `config.json` file with the following:

```json
{
  "SEMAPHORE_AGENT_STACK_NAME": "<your-stack-name>",
  "SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME": "<your-ssm-parameter-name>",
  "SEMAPHORE_AGENT_TOKEN_KMS_KEY": "<your-ssm-parameter-name>",
  "SEMAPHORE_ENDPOINT": "<your-organization>.semaphoreci.com"
}
```

#### Create configuration for Windows agents

Create a `config.json` file with the following:

```json
{
  "SEMAPHORE_AGENT_STACK_NAME": "<your-stack-name>",
  "SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME": "<your-ssm-parameter-name>",
  "SEMAPHORE_AGENT_TOKEN_KMS_KEY": "<your-ssm-parameter-name>",
  "SEMAPHORE_ENDPOINT": "<your-organization>.semaphoreci.com",
  "SEMAPHORE_AGENT_OS": "windows"
}
```

#### Create configuration for MacOS agents

Create a `config.json` file with the following:

```json
{
  "SEMAPHORE_AGENT_STACK_NAME": "<your-stack-name>",
  "SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME": "<your-ssm-parameter-name>",
  "SEMAPHORE_AGENT_TOKEN_KMS_KEY": "<your-ssm-parameter-name>",
  "SEMAPHORE_ENDPOINT": "<your-organization>.semaphoreci.com",
  "SEMAPHORE_AGENT_OS": "macos",
  "SEMAPHORE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT": "86400",
  "SEMAPHORE_AGENT_MAC_FAMILY": "mac1",
  "SEMAPHORE_AGENT_AZS": "us-east-1a,us-east-1b,us-east-1d",
  "SEMAPHORE_AGENT_LICENSE_CONFIGURATION_ARN": "arn:aws:license-manager:<region>:<accountId>:license-configuration:<your-license-configuration>"
}
```

!!! info "Rotation of MacOS instances"
    MacOS EC2 instances run on top of AWS EC2 dedicated hosts. When an instance is terminated, a new instance might take a long time to start in its place, depending on how many dedicated hosts you have available, and the time it takes for MacOS to be launched into them.
    
    See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-mac-instances.html) for more details.

!!! info "Automatic scaling MacOS instances"
    AWS EC2 MacOS dedicated hosts need to be allocated for at least 24 hours, so it's recommended to use a `SEMAPHORE_AGENT_DISCONNECT_AFTER_IDLE_TIMEOUT` of at least 24 hours for agents running in MacOS instances. Also due to that restriction, it's important to note that, if `SEMAPHORE_AGENT_USE_DYNAMIC_SCALING` is enabled and the stack scales up to meet a burst of new jobs, the new dedicated hosts created might end up being idle for a long time.
    
    See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-mac-instances.html) for more details.

#### Using environment variables

Alternatively, you can also configure the stack using environment variables:

```
export SEMAPHORE_AGENT_TOKEN_PARAMETER_NAME=<your-ssm-parameter-name>
export SEMAPHORE_AGENT_TOKEN_KMS_KEY=<your-kms-key-id>
export SEMAPHORE_AGENT_STACK_NAME=<your-stack-name>
export SEMAPHORE_ENDPOINT=<your-organization>.semaphoreci.com
```

Note: if your key was encrypted using the default `aws/ssm` KMS key, `SEMAPHORE_AGENT_TOKEN_KMS_KEY` does not need to be set.

### 5. Bootstrap the CDK application

Using the ARN of the execution policy created in step 3, bootstrap the CDK application:

```
SEMAPHORE_AGENT_STACK_CONFIG=config.json \
  npm run bootstrap -- aws://YOUR_AWS_ACCOUNT_ID/YOUR_AWS_REGION \
  --cloudformation-execution-policies <arn-of-the-executed-policy-created-previously>
```

If you are using environment variables to configure the stack, you can omit `SEMAPHORE_AGENT_STACK_CONFIG`:

```
npm run bootstrap -- aws://YOUR_AWS_ACCOUNT_ID/YOUR_AWS_REGION \
  --cloudformation-execution-policies <arn-of-the-executed-policy-created-previously>
```

Note: if you don't use `--cloudformation-execution-policies`, the AWS CDK will instruct AWS CloudFormation to deploy your stack using full administrator permissions from the `AdministratorAccess` policy.

### 6. Deploy the stack

```
SEMAPHORE_AGENT_STACK_CONFIG=config.json npm run deploy
```

If you are using environment variables to configure the stack, you can omit `SEMAPHORE_AGENT_STACK_CONFIG`:

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
SEMAPHORE_AGENT_STACK_CONFIG=config.json npm run destroy
```

If you are using environment variables to configure the stack, you can omit `SEMAPHORE_AGENT_STACK_CONFIG`:

```
npm run destroy
```

Note: make sure `SEMAPHORE_AGENT_STACK_NAME` indicates to the stack you want to destroy.

!!! info "Deleting a MacOS stack"
    After destroying the stack, you'll need to manually delete the host resource group after the dedicated hosts attached to it leave the pending state. You'll also need to manually release the dedicated hosts associated with that resource group.

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
| `SEMAPHORE_AGENT_STACK_CONFIG`                  | Path to a JSON file containing the parameters to use. This is an alternative to using environment variables for setting the stack's configuration parameters. |
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
| `SEMAPHORE_AGENT_OS`                            | The OS type for agents. Possible values: `ubuntu-focal` and `windows`. |
| `SEMAPHORE_AGENT_ARCH`                          | The arch type for agents. Possible values: `x86_64` and `arm64`. |
| `SEMAPHORE_AGENT_AZS`                           | A comma-separated list of availability zones to use for the auto scaling group. |
| `SEMAPHORE_AGENT_MANAGED_POLICY_NAMES`          | A comma-separated list of custom IAM policy names to attach to the instance profile role. |
| `SEMAPHORE_AGENT_ASG_METRICS`                   | A comma-separated list of ASG metrics to collect. Available metrics can be found [here](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_autoscaling.CfnAutoScalingGroup.MetricsCollectionProperty.html). |
| `SEMAPHORE_AGENT_VOLUME_NAME`                   | The EBS volume's device name to use for a custom volume. If this is not set, the EC2 instances will have an EBS volume based on the AMI's one. |
| `SEMAPHORE_AGENT_VOLUME_TYPE`                   | The EBS volume's type, when using `SEMAPHORE_AGENT_VOLUME_NAME`. By default, this is `gp2`. |
| `SEMAPHORE_AGENT_VOLUME_SIZE`                   | The EBS volume's size, in GB, when using `SEMAPHORE_AGENT_VOLUME_NAME`. By default, this is `64`. |
| `SEMAPHORE_AGENT_LICENSE_CONFIGURATION_ARN`     | The license configuration ARN associated with the AMI used by the stack. |
| `SEMAPHORE_AGENT_MAC_FAMILY`                    | The EC2 Mac instance family to use. Possible values: `mac1` and `mac2`. |
| `SEMAPHORE_AGENT_MAC_DEDICATED_HOSTS`           | A comma-separated list of dedicated host IDs to include in the host resource group. |

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

## AWS permissions

The following AWS IAM policy document describes all the permissions required:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudformation:*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeParameters",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:PutParameter",
        "ssm:DeleteParameter"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreatePolicy",
        "iam:CreateRole",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:GetPolicy",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:PassRole",
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:DeletePolicy",
        "iam:TagPolicy",
        "iam:UntagPolicy",
        "iam:TagRole",
        "iam:UntagRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:ListBucket*",
        "s3:GetBucket*",
        "s3:GetObject*",
        "s3:DeleteObject*",
        "s3:DeleteBucket*",
        "s3:PutBucket*",
        "s3:PutObject*",
        "s3:GetEncryptionConfiguration",
        "s3:PutEncryptionConfiguration"
      ],
      "Resource": "arn:aws:s3:::cdk*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:DescribeRepositories",
        "ecr:CreateRepository",
        "ecr:DeleteRepository",
        "ecr:SetRepositoryPolicy",
        "ecr:GetLifecyclePolicy",
        "ecr:PutImageTagMutability",
        "ecr:PutImageScanningConfiguration",
        "ecr:ListTagsForResource"
      ],
      "Resource": "arn:aws:ecr:*:*:repository/cdk*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CopyImage",
        "ec2:CreateImage",
        "ec2:CreateKeypair",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteKeyPair",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeRegions",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:GetPasswordData",
        "ec2:ModifyImageAttribute",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifySnapshotAttribute",
        "ec2:RegisterImage",
        "ec2:RunInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": "arn:aws:iam::*:role/cdk-*"
    }
  ]
}
```

The policy above is needed due to the following operations:

- Building the AWS EC2 AMI with Packer
- Bootstrapping the AWS CDK application
- Assuming the AWS CDK application's roles

The policy to deploy the CDK application, used by CloudFormation, is a different set of permissions, defined in the `execution-policy.json` file. That policy should be used when bootstrapping the CDK application with the `--cloudformation-execution-policies` parameter.

## Troubleshooting

Agent logs, cloud init logs and systems logs are pushed from the EC2 instance to CloudWatch using the [CloudWatch agent][cloudwatch agent]:

- Agent logs are pushed to the `semaphore/agent` log group. In Linux instances, the agent logs are located at `/tmp/agent_log`. In Windows instances, the agent logs are located at `C:\\semaphore-agent\\agent.log`.
- In Linux instances, the cloud init logs are pushed to the `/semaphore/cloud-init` and `/semaphore/cloud-init/output` log groups. In Windows instances, the cloud init logs are pushed to the `/semaphore/EC2Launch/UserdataExecution` log group.
- System logs are pushed to the `/semaphore/system` log group

### Invalid agent type registration token

If an invalid agent type registration token is used, the agent won't be able to register with the Semaphore API. To troubleshoot this issue, follow these steps:

1. Go to the CloudWatch console
2. Select Log Groups
3. Select the `semaphore/agent` log group
4. Select the EC2 instance id for the instance running your agent
5. Verify if the agent is running. If not, verify if you have messages of failed registration requests

[agent-aws-stack]: https://github.com/renderedtext/agent-aws-stack
[aws cdk]: https://docs.aws.amazon.com/cdk/v2/guide/home.html
[registration token]: /ci-cd-environment/self-hosted-agents-overview
[caching]: /essentials/caching-dependencies-and-directories
[aws session manager]: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html
[using docker containers]: /ci-cd-environment/job-environment
[default AWS VPC]: https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html
[internet gateway]: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
[nat devices]: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat.html
[aws credentials]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
[kms create key]: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kms/create-key.html
[cloudwatch agent]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
