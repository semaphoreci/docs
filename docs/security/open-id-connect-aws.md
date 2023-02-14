---
Description: Use OpenID Connect within your pipelines to authenticate with Amazon Web Services.
---

# Configure OpenID Connect in AWS

!!! plans "Available on: <span class="plans-box">[Scaleup](/account-management/startup-plan/)</span>"

Open ID Connect allows your pipelines to access resources in Amazon Web Services (AWS) without
the need to store long-lived access credentials in secrets.

In this guide, you will learn how to configure Google Cloud Workload Identity Provider to trust
Semaphore OIDC as a federated identity and then to access cloud resources from your Semaphore
Pipelines.

## Adding Semaphore to AWS as an identity provider

To connect to Amazon Web Services (AWS) from Semaphore using OpenID Connect,
you will need to perform the following steps:

### Step 1 - Configure AWS OIDC Identity Provider

Configure AWS to support OpenID Connect by creating an IAM OIDC identity provider
and an IAM role that trusts the provider.
See [Creating OpenID Connect (OIDC) identity providers][aws-docs].

- For the provider, set the full URL to your organization. Example: `https://acme.semaphoreci.com`.
- For the audience, set the full URL to your organization. Example: `https://acme.semaphoreci.com`.`

### Step 2 - Configuring a role and trust policy

Configuring a role and trust policy that you will use to access resources on AWS.
Follow the documentation on AWS about [Creating a role for web identity or OIDC][create-role].

Edit the trust policy to restrict which projects and which branches are able to access
the resources with this role:

``` json
"Condition": {
  "StringEquals": {
    "acme.semaphoreci.com:aud": "https://rtx.semaphoreci.com/",
    "acme.semaphoreci.com:sub": "org:acme:project:936a5312-a3b8-4921-8b3f-2cec8baac574:repo:web:ref_type:branch:ref:refs/heads/main"
  }
}
```

Adjust the above policy to match the organization, project, and branch that you want to use
to access the resources.

### Step 3 - Assume the role in a Semaphore pipeline

Finally, in your Semaphore pipelines, assume the above role by adding the following commands:

``` yaml
commands:
  - export ROLE_ARN="<>" # the AWS Role ARN you want to assume
  - export SESSION_NAME="semaphore-job-${SEMAPHORE_JOB_ID}"
  - export CREDENTIALS=$(aws sts assume-role-with-web-identity --role-arn $ROLE_ARN --role-session-name $SESSION_NAME --web-identity-token $SEMAPHORE_OIDC_TOKEN)
  - export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | jq -r '.Credentials.AccessKeyId')
  - export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | jq -r '.Credentials.SessionToken')
  - export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | jq -r '.Credentials.SecretAccessKey')
```

[aws-docs]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html#manage-oidc-provider-cli
[create-role]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html
