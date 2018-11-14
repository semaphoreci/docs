Semaphore includes the `gcloud` command for authenticating to the
various Google Container Registry endpoints. You'll need to create a
service account with access to Cloud Storage with an authenication key
to set this up. Download the service account's authenication key to
your computer. Assume it's in `key.json`. The `key.json` is used to
authenciate to the service account which is used to authenticate to
the registries.

## Create the Secret

1. Base64 encode the `key.json` and save the output: `base64 key.json`
1. Create a new file `secret.yml` and paste in the content:

```yml
# secret.yml
apiVersion: v1alpha
kind: Secret
metadata:
  name: GCP
data:
  files:
    - path: .secrets.gcp.json
      content: PASTE_BASE64_ENCODED_CONTENT_HERE
```

1. Create the `GCP` secret with sem: `sem create -f secret.yml`

## Configure the Pipeline

```yml
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
          - gcloud auth activate-service-account --key-file=.secrets.gcp.json
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
