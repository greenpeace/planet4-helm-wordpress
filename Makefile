SHELL := /bin/bash
.ONESHELL:

CHART_DIRECTORY ?= ../planet4-helm-charts

CHART_BUCKET ?= gs://p4-helm-charts
CHART_URL ?= https://p4-helm-charts.storage.googleapis.com

.PHONY: all
all: pull package index push

.PHONY: pull
pull:
	@mkdir -p $(CHART_DIRECTORY)
	@pushd $(CHART_DIRECTORY) > /dev/null && \
	gsutil -m rsync -d $(CHART_BUCKET) . && \
	popd > /dev/null

.PHONY: package
package:
	@helm package .
	@mv wordpress-*.tgz $(CHART_DIRECTORY)

.PHONY: index
index:
	@pushd $(CHART_DIRECTORY) > /dev/null && \
	helm repo index . --url $(CHART_URL) && \
	popd > /dev/null

.PHONY: push
push:
	@pushd $(CHART_DIRECTORY) > /dev/null && \
	gsutil -m rsync -d . gs://p4-helm-charts && \
	popd > /dev/null 
