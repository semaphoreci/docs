.PHONY: build

BRANCH=$(shell echo "$(SEMAPHORE_GIT_BRANCH)" | sed 's/[^a-z]//g')

IMAGE_REDIRECT="us.gcr.io/semaphore2-prod/docs-redirect"
IMAGE_TAG_REDIRECT="start-$(BRANCH)-$(SEMAPHORE_WORKFLOW_ID)-sha-$(SEMAPHORE_GIT_SHA)"

configure.gcloud:
	gcloud auth activate-service-account deploy-from-semaphore@semaphore2-prod.iam.gserviceaccount.com --key-file ~/gce-creds.json
	gcloud --quiet auth configure-docker

mkdocs.build:
	docker run --rm -it -p 8001:8000 -v ${PWD}:/docs squidfunk/mkdocs-material -- build

nginx.build:
	-docker pull $(IMAGE_REDIRECT):latest
	docker build --cache-from $(IMAGE_REDIRECT):latest -t $(IMAGE_REDIRECT) . -f Dockerfile.nginx

nginx.test:
	docker run --rm -t -a stdout $(IMAGE_REDIRECT) nginx -c /etc/nginx/nginx.conf -t

nginx.push:
	docker tag $(IMAGE_REDIRECT):latest $(IMAGE_REDIRECT):$(IMAGE_TAG_REDIRECT)
	docker push $(IMAGE_REDIRECT):$(IMAGE_TAG_REDIRECT)
	docker push $(IMAGE_REDIRECT):latest
