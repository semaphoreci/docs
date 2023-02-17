---
Description: This guide describes how to set up the cache CLI to work with an AWS S3 bucket
---

# Setting up caching with AWS S3

!!! plans "Available on: <span class="plans-box">[Free & OS](/account-management/free-and-open-source-plans/)</span> <span class="plans-box">[Startup](/account-management/startup-plan/)</span> <span class="plans-box">[Scaleup](/account-management/scaleup-plan/)</span>"

When running a Semaphore agent in a self-hosted environment, cache storage in hosted jobs is not available. However, you can use an AWS S3 bucket to store our cache dependencies instead. In order to do so, the cache CLI needs access to perform a few actions on an S3 bucket in your AWS account.

## Creating AWS resources

The instructions that follow assume you already have the AWS CLI properly installed and configured on your personal machine. If you’re not sure how to configure it, you can follow [this tutorial from AWS][set up aws cli]. You can also create the AWS resources described in this guide using the AWS console.

The bucket name we will use in this example is `semaphore-cache` and the AWS region will be `us-east-1`. Make sure you adjust the commands to match your bucket name and region of choice.

**1. Create your AWS S3 bucket and block public access to it:**

This is the bucket that the cache CLI will use to store and retrieve archives.

```
aws s3api create-bucket \
  --region us-east-1 \
  --bucket semaphore-cache

aws s3api put-public-access-block \
  --bucket semaphore-cache \
  --public-access-block-configuration \
BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

If you are using the [aws-agent-stack][agent aws stack], this is the only thing you need to do. After creating the bucket, set the `SEMAPHORE_AGENT_CACHE_BUCKET_NAME` and you are all set.

**2. Create an AWS IAM policy**

It is always good practice to give services only the permissions that they need. The cache CLI only needs access to perform the following AWS S3 actions:

- `s3:PutObject`
- `s3:GetObject`
- `s3:ListBucket`
- `s3:DeleteObject`

One way to grant access for only these actions is through an AWS IAM policy. You can create one with the following commands:

```
cat > /tmp/semaphore-cache-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "statement1",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::semaphore-cache/*",
        "arn:aws:s3:::semaphore-cache"
      ]
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name semaphore-cache-policy \
  --policy-document file:///tmp/semaphore-cache-policy.json \
  --description "Restricts access to some operations on the semaphore-cache S3 bucket"
```

The `aws iam create-policy` command will generate an output like the one shown below:

```json
{
  "Policy": {
    "PolicyName": "semaphore-cache-policy",
    "CreateDate": "2015-06-01T19:31:18.620Z",
    "AttachmentCount": 0,
    "IsAttachable": true,
    "PolicyId": "ZXR6A36LTYANPAI7NJ5UV",
    "DefaultVersionId": "v1",
    "Path": "/",
    "Arn": "arn:aws:iam::0123456789012:policy/semaphore-cache-policy",
    "UpdateDate": "2015-06-01T19:31:18.620Z"
  }
}
```

Make sure you save the `Arn` of the AWS IAM policy. You'll use this value when attaching the AWS IAM policy to the AWS IAM user.

**3. Create the AWS IAM user and its access keys:**

This is the AWS IAM user that the cache CLI will use to authorize and access to your AWS bucket:

```
aws iam create-user --user-name semaphore
aws iam create-access-key --user-name semaphore
```

The `aws iam create-access-key` command will generate an output like the one shown below:

```json
{
  "AccessKey": {
    "UserName": "semaphore",
    "Status": "Active",
    "CreateDate": "...",
    "SecretAccessKey": "...",
    "AccessKeyId": "..."
  }
}
```

Make sure you save the `SecretAccessKey` and the `AccessKeyId` values. We will need them when configuring the `~/.aws` folder in the agent machine.

**4. Attach the AWS IAM policy to the AWS IAM user:**

Let's attach the AWS IAM policy we created in step #2 to the user we created in step #3:

```
aws iam attach-user-policy \
  --user-name semaphore \
  --policy-arn "[this is where the policy ARN you saved on step #2 needs to go]"
```

## Configuring your machine

Once you have all the AWS resources created, let's jump to the machine running the agent and configure the AWS credentials for the cache CLI to use.

**1. Configuring the `~/.aws` folder:**

Make sure you use the `SecretAccessKey` and `AccessKeyId` for the proper AWS IAM user. Also, make sure you replace `us-east-1` with your region of choice and `semaphore-cache` with your bucket name.

```
mkdir ~/.aws

cat > ~/.aws/config <<EOF
[default]
region = us-east-1
output = json
EOF

cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id = SecretAccessKey
aws_secret_access_key = AccessKeyId
EOF
```

Note that the `~/.aws` folder should be created in the home directory of the user running the agent.

**2. Updating the agent configuration:**

Finally, let's instruct the agent to pass the required environment variables to the cache CLI, by adding them to your agent's `config.yaml`:

```yaml
env-vars:
  - SEMAPHORE_CACHE_BACKEND=s3
  - SEMAPHORE_CACHE_S3_BUCKET=semaphore-cache
```

We're all set. After restarting your agent, you should be able to start using the cache CLI with your AWS S3 bucket in your pipelines.

[set up aws cli]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config
[aws create bucket]: https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html
[agent aws stack]: https://github.com/renderedtext/agent-aws-stack
