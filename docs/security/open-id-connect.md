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
following fields:

```
| field  | description                                                           | example                                  |
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
