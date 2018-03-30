{{/* vim: set filetype=mustache: */}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wordpress.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "php.name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-php" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "php.fullname" -}}
{{- if .Values.php.fullnameOverride -}}
{{- .Values.php.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.php.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- $name := .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- printf "%s-%s-php" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-php" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Expand the name of the chart and service
*/}}
{{- define "openresty.name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-openresty" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app - service name pair.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openresty.fullname" -}}
{{- if .Values.openresty.fullnameOverride -}}
{{- .Values.openresty.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.openresty.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- $name := .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- printf "%s-%s-openresty" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-openresty" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart and service
*/}}
{{- define "exim.name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-exim" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified redis hostname.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "exim.fullname" -}}
{{- printf "%s-%s" .Release.Name "exim" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

<!-- {{/*
Create a default fully qualified database hostname.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mariadb.fullname" -}}
{{- $chartname := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-mariadb" .Release.Name $chartname | trunc 63 | trimSuffix "-" -}}
{{- end -}} -->

{{/*
Create a default fully qualified redis hostname.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
