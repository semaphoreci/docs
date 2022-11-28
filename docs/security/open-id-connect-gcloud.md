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
2. Configure the mapping.
3. Add conditions.
4. Connect the pool with a Google Cloud service account.

In this guide, we will use the [gcloud][gcloud] command line utility to set up configure the
connection between GCP and Semaphore. Refer to the [Google Cloud Identity Federation documentation][gcp-identity-docs]
for further details and alternative approaches for setting up the connection.

### Creating a new identity pool

Create a new identity pool by executing the following snippet.

``` bash
export POOL_ID="<choose-an-indentity-pool>" // example: semaphoreci-com-identity-pool

gcloud iam workload-identity-pools create $POOL_ID \
  --location="global" \
  --description="Identity pool for SemaphoreCI" \
  --display-name=$POOL_ID
```

[gcloud]: https://cloud.google.com/sdk/gcloud
[gcp-identity-docs]: https://cloud.google.com/iam/docs/configuring-workload-identity-federation#oidc_1
