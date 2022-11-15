---
Description: OpenID Connect allows your pipelines to connect directly to cloud providers via short-lived access tokens.
---

# OpenID Connect

OpenID Connect allows you to establish a trust relationship between Semaphore and cloud providers,
and to access resources directly with short-lived access tokens.

## Oveerview of OpenID Connect

Semaphore Pipelines are often designed to access cloud providers (ex. AWS, Google Cloud, HashiCorp Vault)
to deploy application or to fetch resources such as Docker images, objects from S3 buckets.

Traditionally, to connect to these cloud resources one would create an access token on the
cloud provider, store it in a [Secret][secret], and use it from the pipelines for authorization.

However, these long lived access tokens present an organizational challenge to keep them secure.
Access and usage of these secrets needs to be carefully monitored, secrets needs to be regularly
rotated, and the provided access rights on the cloud should follow the least principle of least
privilage. Not adhering to these practices, exposes the organization to potential security threats.

With OpenID Connect (OIDC), the organization can taka a different approach by configuring
short-lived access tokens directly from the cloud provider without storring any long-lived
secret on Semaphore. This eliminates all the above mentioned security threats from the
traditional approach.

## How OpenID Tokens works on Semaphore

Every Job on Semaphore gets a uniquely generated OIDC token that is injected into the jobs
in a form of an environment variable named `SEMAPHORE_OIDC_TOKEN`.

The injected environment variable is a [JWT][jwt] token signed by Semaphore and contains the
following claims:

```
| claim  | description                                                           | example                                  |
----------------------------------------------------------------------------------------------------------------------------|
| aud    | The intended audience of the token. The full URL to the organization. | https://test-orgnization.semaphoreci.com |
| branch | The name of the branch which on which job is running.                 | master                                   |
| exp    | The UNIX timestamp when this token expires.                           | 1660317851                               |
| iat    | The UNIX timestamp when this token was issued.                        | 1660317851                               |
| nbf    | The UNIX timestamp before which the token is not valid.               | 1660317851                               |
| iss    | The issuer of the token. The fill URL to the organization.            | https://test-orgnization.semaphoreci.com |
| job_id | The ID of the job for which this token was issued.                    | c117e453-1189-4eaf-b03a-dd6538eb49b2     |
| jti    | The Unique ID of the JWT token.                                       | 2s557dchalv2mv76kk000el1                 |
| prj_id | The project ID for which this token was issued.                       | 1e1fcfb5-09c0-487e-b051-2d0b5514c42a     |
| pr     | The name of the Pull Request for which this token was issued.         | PR #12: Update YAML                      |
| ppl_id | The pipeline ID for which this token was issued.                      | 1e1fcfb5-09c0-487e-b051-2d0b5514c42a     |
| ref    | The full git reference for which this token was issued.               | refs/heads/set-up-semaphore-oidc         |
| repo   | The name of the repository for which this token was issued.           | web                                      |
| sub    | The subject of this token. The ID of the job for which it was issued. | c117e453-1189-4eaf-b03a-dd6538eb49b2     |
| tag    | The name of the git tag for which this token was issued.              | v1.0.0                                   |
| wf_id  | The ID of the workflow for which this token was issued.               | 1be81412-6ab8-4fc0-9d0d-7af33335a6ec     |
```

The above `SEMAPHORE_OIDC_TOKEN` is then presented to the cloud provider as an authorization token.

If the cloud provider is configured to accept OIDC tokens, it will receive the token, verify its
signature by connecting back to `{org}.semaphoreci.com/.well-known/jwts`, and if the token is
valid, it will respond with a a short-lived token for this specific job that can be used to
fetch and modify cloud resources.

## Enabling OpenID Connect for your cloud provider

To enable OpenID Connect for your specific cloud provider, see the following guides:

- [Configure OpenID Connect in Amazon Web Services][configure-aws]
- [Configure OpenID Connect in Google Cloud][configure-gcloud]
- [Configure OpenID Connect in Microsoft Azure][configure-azure]
- [Configure OpenID Connect in Hashicorp Vault][configure-vault]
