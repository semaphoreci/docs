---
Description: OpenID Connect allows your pipelines to connect directly to cloud providers via short-lived access tokens.
---

# OpenID Connect

!!! plans "Available on: <span class="plans-box">Scaleup</span>"

OpenID Connect allows you to establish a trust relationship between Semaphore and cloud providers,
and to access resources directly with short-lived access tokens.

## Overview of OpenID Connect

Semaphore Pipelines are often designed to access cloud providers (e.g. AWS, Google Cloud, HashiCorp Vault)
to deploy applications, or to fetch resources such as Docker images or objects from S3 buckets.

Traditionally, to connect to these cloud resources one would create an access token on the
cloud provider, store it in a [Secret][secret], and use it from the pipelines for authorization.

However, these long-lived access tokens present a security challenge.
Access and usage of these secrets needs to be carefully monitored. Secrets need to be regularly
rotated and the provided access rights on the cloud should follow the principle of least
privilege. Not adhering to these practices exposes the organization to potential security threats.

With OpenID Connect (OIDC), an organization can take a different approach by configuring
short-lived access tokens directly from the cloud provider without storing any long-lived
secrets on Semaphore. This eliminates all the aforementioned security threats from the
traditional approach.

## How OpenID Tokens work on Semaphore

Every Job on Semaphore gets a uniquely generated OIDC token that is injected into jobs
in a form of an environment variable named `SEMAPHORE_OIDC_TOKEN`.

The injected environment variable is a [JWT][jwt] token signed by Semaphore and contains the
following claims:

#### iss

The issuer of the token. The full URL of the organization. Example: `https://{org-name}.semaphoreci.com`.

#### aud

The intended audience of the token. The full URL of the organization. Example: `https://{org-name}.semaphoreci.com`.

#### sub

The subject of the token. A combination of org, project, repository, and git reference for which this token was issued.
Template: `org:{org-name}:project:{project-id}:repo:{repo-name}:ref_type:{branch or pr or tag}:ref:{git_reference}`.
Example: `org:{org-name}:project:936a5312-a3b8-4921-8b3f-2cec8baac574:repo:web:ref_type:branch:ref:refs/heads/main`.

#### exp

The UNIX timestamp when the token expires. Example: `1660317851`.

#### iat

The UNIX timestamp when the token was issued. Example: `1660317851`.

#### nbf

The UNIX timestamp before which the token is not valid. Example: `1660317851`.

#### jti

The Unique ID of the JWT token. Example: `2s557dchalv2mv76kk000el1`.

#### branch

The name of the branch on which the job is running. If the job was triggered by a Pull Request, then the value is
the target branch of the Pull Request that triggered that job. Example: `main`.

#### pr_branch

The name of the source branch of the Pull Request which triggered a job. Example: `feature-branch`.

#### pr

The number of the Pull Request for which the token was issued. Example: `123`.

#### ref

The full git reference for which the token was issued. Example: `refs/heads/main`.

#### ref_type

The type of git reference that triggered the job. Possible values: `branch`, `tag`, or `pull-request`.

#### tag

The name of the git tag for which the token was issued. Example: `v1.0.0`.

#### repo

The name of the repository for which the token was issued. Example: `web`.

#### repo_slug

Specifies the repository's name in the format `owner_name/repository_name` for the current Semaphore project. Example: `semaphoreci/docs`. It is associated with the environment variable [`SEMAPHORE_GIT_REPO_SLUG`](/ci-cd-environment/environment-variables/#semaphore_git_repo_slug).

#### prj_id

The project ID for which the token was issued. Example: `1e1fcfb5-09c0-487e-b051-2d0b5514c42a`.

#### wf_id

The ID of the workflow for which the token was issued. Example: `1be81412-6ab8-4fc0-9d0d-7af33335a6ec`.

#### ppl_id

The pipeline ID for which the token was issued. Example: `1e1fcfb5-09c0-487e-b051-2d0b5514c42a`.

#### job_type

The type of the job based on the way it was created.

The possible values are:

- `pipeline_job` - A regular job that is the part of a pipeline.
- `debug_job` - A job that was created to debug the other job via the `sem debug job <JOB_ID>` command.
- `project_debug_job` - A job that was created to debug the project via the `sem debug project <PROJECT_NAME>` command.

Example: `pipeline_job`.

#### job_id

The ID of the job for which the token was issued. Example: `c117e453-1189-4eaf-b03a-dd6538eb49b2`.

A token with the above claims is exported into jobs as the `SEMAPHORE_OIDC_TOKEN` environment variable,
which can then be presented to the cloud provider as an authorization token.

If the cloud provider is configured to accept OIDC tokens, it will receive the token, verify its
signature by connecting back to `{org-name}.semaphoreci.com/.well-known/jwts`, and if the token is
valid, it will respond with a short-lived token for this specific job that can be used to
fetch and modify cloud resources.

## Enabling OpenID Connect for your cloud provider

To enable OpenID Connect for your specific cloud provider, see the following guides:

- [Configure OpenID Connect in Amazon Web Services][configure-aws]
- [Configure OpenID Connect in Google Cloud][configure-gcloud]
- [Configure OpenID Connect in Hashicorp Vault][configure-vault]

[secret]: /essentials/using-secrets/
[jwt]: https://jwt.io/
[configure-aws]: /security/open-id-connect-aws
[configure-gcloud]: /security/open-id-connect-gcloud
[configure-vault]: /security/open-id-connect-vault
