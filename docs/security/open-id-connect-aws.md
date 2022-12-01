---
Description: Use OpenID Connect within your pipelines to authenticate with Amazon Web Services.
---

# Configure OpenID Connect in Google Cloud

Open ID Connect allows your pipelines to access resources in Amazon Web Services (AWS) without
the need to store long-lived access credentials in secrets.

In this guide you will learn how to configure Google Cloud Workload Identity Provider to trust
Semaphore OIDC as a federated identity and then to access cloud resources from your Semaphore
Pipelines.

## Adding Semaphore to AWS as an identity provider

To connect to Amazon Web Services (AWS) from Semaphore using OpenID Connect,
you will need to perform the following steps:

1. Configure AWS to support OpenID Connect by creating an IAM OIDC identity provider
   and an IAM role that trusts the provider. See [Creating OpenID Connect (OIDC) identity providers][aws-docs]

2. In your pipeline configuration, add a new block to authenticate with AWS using OpenID Connect. This block should contain the necessary authentication credentials and should reference the secret you created in the previous step.

Here is an example of how this block might look in your Semaphore pipeline configuration:

  - name: Authenticate with AWS
    command: |
      eval "$(aws-iam-authenticator init -i $AWS_IAM_AUTH_PROVIDER -r $AWS_IAM_ROLE_ARN -s $AWS_OIDC_CLIENT_ID -p $AWS_OIDC_CLIENT_SECRET -t $AWS_OIDC_TOKEN_ENDPOINT)"

This example assumes that you have set the following environment variables in your Semaphore project:

    AWS_IAM_ROLE_ARN: the Amazon Resource Name (ARN) of the IAM role that trusts the IAM OIDC identity provider
    AWS_OIDC_CLIENT_ID: the client ID for your OpenID Connect client
    AWS_OIDC_CLIENT_SECRET: the client secret for your OpenID Connect client
    AWS_OIDC_TOKEN_ENDPOINT: the token endpoint for your IAM OIDC identity provider

For detailed instructions on how to perform these steps, please refer to the Semaphore documentation on AWS authentication.

To add the Semaphore OpenID Connect token to IAM, see [AWS Documentation][aws-docs].

- For the provider, set the full URL to your organization. Example: `https://acme.semaphoreci.com`.
- For the audience, set the full URL to your organization. Example: `https://acme.semaphoreci.com`.`

Next, configure a role and trust policy by following the documentation in
[Creating a role for web identity or OpenID connect federation][create-role] AWS documenation.

[aws-docs]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html#manage-oidc-provider-cli
[create-role]:
