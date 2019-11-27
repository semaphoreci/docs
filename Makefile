.PHONY: build

BRANCH=$(shell echo "$(SEMAPHORE_GIT_BRANCH)" | sed 's/[^a-z]//g')

IMAGE="us.gcr.io/semaphore2-prod/docs"
IMAGE_TAG="start-$(BRANCH)-$(SEMAPHORE_WORKFLOW_ID)-sha-$(SEMAPHORE_GIT_SHA)"

IMAGE_REDIRECT="us.gcr.io/semaphore2-prod/docs-redirect"
IMAGE_TAG_REDIRECT="start-$(BRANCH)-$(SEMAPHORE_WORKFLOW_ID)-sha-$(SEMAPHORE_GIT_SHA)"

nginx.build:
	-docker pull $(IMAGE_REDIRECT):latest
	docker build --cache-from $(IMAGE_REDIRECT):latest -t $(IMAGE_REDIRECT) . -f Dockerfile

nginx.push:
	docker tag $(IMAGE_REDIRECT):latest $(IMAGE_REDIRECT):$(IMAGE_TAG_REDIRECT)
	docker push $(IMAGE_REDIRECT):$(IMAGE_TAG_REDIRECT)
	docker push $(IMAGE_REDIRECT):latest

mkdocs.build:
	-docker pull $(IMAGE):latest
	docker build --cache-from $(IMAGE):latest -t $(IMAGE) . -f Dockerfile.mkdocs

mkdocs.push:
	docker tag $(IMAGE):latest $(IMAGE):$(IMAGE_TAG)
	docker push $(IMAGE):$(IMAGE_TAG)
	docker push $(IMAGE):latest

configure.gcloud:
	gcloud auth activate-service-account deploy-from-semaphore@semaphore2-prod.iam.gserviceaccount.com --key-file ~/gce-creds.json
	gcloud --quiet auth configure-docker

