SHELL := /bin/bash
.ONESHELL:

GCLOUD_CHART_VERSION ?= 0.6.0
REDIS_CHART_VERSION ?= 4.2.7

CHART_DIRECTORY ?= ../planet4-helm-charts

CHART_BUCKET ?= gs://planet4-helm-charts
CHART_URL ?= https://planet4-helm-charts.storage.googleapis.com

CHART_NAME := $(shell basename "$(PWD)")

SED_MATCH := [^a-zA-Z0-9._-]

# If BUILD_TAG is not set
ifeq ($(strip $(BUILD_TAG)),)
ifeq ($(CIRCLECI),true)
# Configure build variables based on CircleCI environment vars
BUILD_TAG ?= $(shell sed 's/$(SED_MATCH)/-/g' <<< "$(CIRCLE_TAG)")
else
# Not in CircleCI environment, try to set sane defaults
BUILD_TAG ?= $(shell git tag -l --points-at HEAD | tail -n1 | sed 's/$(SED_MATCH)/-/g')
endif
endif

# If BUILD_TAG is blank there's no tag on this commit
ifeq ($(strip $(BUILD_TAG)),)
# Default to branch name - this will lint but not package
BUILD_TAG := testing
endif

.PHONY: all
all: lint pull dep package index push

.PHONY: lint
lint: lint-yaml lint-helm

.PHONY: lint-yaml
lint-yaml:
	yamllint .circleci/config.yaml
	yamllint values.yaml
	yamllint requirements.yaml

.PHONY: lint-helm
	@helm lint .

.PHONY: dep
dep: lint
	@helm dependency update

.PHONY: pull
pull:
	@mkdir -p $(CHART_DIRECTORY)
	@pushd $(CHART_DIRECTORY) > /dev/null && \
	gsutil -m rsync -d $(CHART_BUCKET) . && \
	popd > /dev/null

.PHONY: rewrite rewrite-chart rewrite-requirements
rewrite: Chart.yaml requirements.yaml

Chart.yaml:
	BUILD_TAG=$(BUILD_TAG) \
	envsubst < Chart.yaml.in > Chart.yaml

requirements.yaml:
	GCLOUD_CHART_VERSION=$(GCLOUD_CHART_VERSION) \
	REDIS_CHART_VERSION=$(REDIS_CHART_VERSION) \
	envsubst < requirements.yaml.in > requirements.yaml

.PHONY: package
package: lint
	@helm package .
	@mv $(CHART_NAME)-*.tgz $(CHART_DIRECTORY)

.PHONY: verify
verify: lint
	@helm verify $(CHART_DIRECTORY)

.PHONY: index
index: lint
	@pushd $(CHART_DIRECTORY) > /dev/null && \
	helm repo index . --url $(CHART_URL) && \
	popd > /dev/null

.PHONY: push
push:
	@pushd $(CHART_DIRECTORY) > /dev/null && \
	gsutil -m rsync -d . $(CHART_BUCKET) && \
	popd > /dev/null
