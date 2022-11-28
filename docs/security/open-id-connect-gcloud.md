---
Description: Use OpenID Connect within your pipelines to authenticate with Google Cloud Platform.
---

# Configure OpenID Connect in Google Cloud

Open ID Connect allows your pipelines to access resources in Google Cloud Platform (GCP) without
the need to store long-lived access credentials in secrets.

In this guide you will learn how to configure Google Cloud Workload Identity Provider to trust
Semaphore OIDC as a federated identity and then to access cloud resources from your Semaphore
Pipelines.

## Adding a Google Cloud Workload Identity Provider

To configure OIDC identity provider in GCP, you will perform the following actions:

1. Create a new identity pool.
2. Configure the mapping and conditions.
3. Connect the pool with a Google Cloud service account.

In this guide, we will use the [gcloud][gcloud] command line utility to set up configure the
connection between GCP and Semaphore. Refer to the [Google Cloud Identity Federation documentation][gcp-identity-docs]
for further details and alternative approaches for setting up the connection.

### Creating a new identity pool

Create a new identity pool by executing the following snippet.

``` bash
export POOL_ID="<unique-pool-name>" // example: semaphoreci-com-identity-pool

gcloud iam workload-identity-pools create $POOL_ID \
  --location="global" \
  --description="Identity pool for SemaphoreCI" \
  --display-name=$POOL_ID
```

### Configure mappings and conditions

In this step we are going to map fields from the Semaphore OIDC token to Google attributes, and then
set up conditions under which the token is able to access the identity pool.

The combination of mappings and conditions is a powerful combination that allows you to set up various
levels of access policies. To use the full power of this mechanism, refer to the Google Cloud documentation
about [attribute mapping][gcloud-attr-mapping] and [condition mapping][gcloud-condition-mapping].

In the following example, you will configure Google Cloud to allow access to the previously created
identity pool from the `main` branch of the `web` project.

``` bash
export PROVIDER_ID="<unique-provider-name>" // example: semaphoreci-com-web
export ISSUER_URI="https://{org-name}.semaphoreci.com" // set this to your full organization path, ex. https://acme.semapohoreci.com

gcloud iam workload-identity-pools providers create-oidc $PROVIDER_ID \
  --location='global' \
  --workload-identity-pool=$POOL_ID \
  --issuer-uri="$ISSUER_URI" \
  --allowed-audiences="$ISSUER_URI" \
  --attribute-mapping='google.subject="semaphore::" + assertion.repo + "::" + assertion.ref' \
  --attribute-condition="'semaphore::web::refs/heads/main' == google.subject"
```

### Connect the pool with a service account

When connecting to Google Cloud, your pipelines would impersonate a Google Cloud Service Account.
To set up which service account is accessible via the previously configured Workload Identity pool,
we need to set up a binding between the workload identity user and the service account.

First, we will construct an external identity URI based on the following pattern:

```
principal://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/subject/SUBJECT
```

In this URI:

- The `PROJECT_NUMBER` is the project number of your Google Cloud project which you can find by running the
  following command: `gcloud projects describe $(gcloud config get-value core/project) --format=value\(projectNumber\)`.
- The `POOL_ID` is the ID of the worload identity pool we created in the first step.
- The `SUBJECT` is the value of the mapping we set up in the second step.



Read more about [Granting external identities permission to impersonate a service account][gcloud-granting-external]
in Google Cloud docs.

[gcloud]: https://cloud.google.com/sdk/gcloud
[gcp-identity-docs]: https://cloud.google.com/iam/docs/configuring-workload-identity-federation#oidc_1
[gcloud-attr-mapping]: https://cloud.google.com/iam/docs/configuring-workload-identity-federation#mappings-and-conditions
[gcloud-condition-mapping]: https://cloud.google.com/iam/docs/configuring-workload-identity-federation#mappings-and-conditions
[gcloud-granting-externl]: https://cloud.google.com/iam/docs/using-workload-identity-federation#impersonate
