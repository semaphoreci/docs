---
Description: This guide shows you how to use Semaphore 2.0 to push Docker Images to Google Container Registry (GCR). 
---

# Pushing Docker Images to Google Container Registry (GCR)

Pushing images to your GCR is straightforward.

Semaphore includes the `gcloud` command for authenticating to the
various Google Container Registry endpoints. You'll need to create a
service account with access to Cloud Storage and an authentication key
to set this up. Download the service account's authentication key to
your computer. You can find it in `key.json`. `key.json` is used to
authenticate to the service account, which is used to authenticate
the registries.

## Creating a Secret

Assuming that your Google Cloud credentials are stored on your computer in
`/home/<username>/.secrets/gcp.json`, you can use the following command to create a
secret on Semaphore:

``` bash
sem create secret GCP \
  -f /home/<username>/.secrets/gcp.json:.secrets/gcp.json
```

Now add the secret to your pipeline and authenticate.

## Configuring the Pipeline

``` yaml
.semaphore/semaphore.yml
version: "v1.0"
name: First pipeline example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Push Image"
    task:
      secrets:
        - name: GCP
      prologue:
        commands:
          # Authenticate using the file injected from the secret
          - gcloud auth activate-service-account --key-file=.secrets/gcp.json
          # Don't forget -q to silence confirmation prompts
          - gcloud auth configure-docker -q
          - checkout
      jobs:
        - name: Docker build
          commands:
            # Replace with your GCP Project ID
            - docker build -t "asia.gcr.io/YOUR_GCP_PROJECT_ID/semaphore-example:${SEMAPHORE_GIT_SHA:0:7}" .
            - docker push "asia.gcr.io/GCP_PROJECT_ID/semaphore-example:${SEMAPHORE_GIT_SHA:0:7}"
```
