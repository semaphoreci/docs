.PHONY: build

BRANCH=$(shell echo "$(SEMAPHORE_GIT_BRANCH)" | sed 's/[^a-z]//g')

IMAGE_REDIRECT="us.gcr.io/semaphore2-prod/docs-redirect"
IMAGE_TAG_REDIRECT="$(BRANCH)-$(SEMAPHORE_WORKFLOW_ID)-sha-$(SEMAPHORE_GIT_SHA)"

server:
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material:4.6.3

configure.gcloud:
	gcloud auth activate-service-account $(GCP_REGISTRY_WRITER_EMAIL) --key-file ~/gce-registry-writer-key.json
	gcloud --quiet auth configure-docker

mkdocs.build:
	docker run --rm -it -p 8001:8000 -v ${PWD}:/docs squidfunk/mkdocs-material:4.6.3 -- build

nginx.build:
	-docker pull $(IMAGE_REDIRECT):latest
	docker build --cache-from $(IMAGE_REDIRECT):latest -t $(IMAGE_REDIRECT) . -f Dockerfile.nginx

nginx.test:
	docker run --rm -t -a stdout $(IMAGE_REDIRECT) nginx -c /etc/nginx/nginx.conf -t

nginx.push:
	docker tag $(IMAGE_REDIRECT):latest $(IMAGE_REDIRECT):$(IMAGE_TAG_REDIRECT)
	docker push $(IMAGE_REDIRECT):$(IMAGE_TAG_REDIRECT)
	docker push $(IMAGE_REDIRECT):latest
