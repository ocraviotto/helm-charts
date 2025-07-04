{{/*
Expand the name of the chart.
*/}}
{{- define "ente.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ente.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ente.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ente.labels" -}}
helm.sh/chart: {{ include "ente.chart" . }}
{{ include "ente.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Chart.Name | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ente.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ente.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ente.serviceAccount.name" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ente.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Extract values of a field from a list of objects, where another field matches a string or regex.

Usage:
{{ include "ente.filterFieldValues" (dict "list" .Values.items "matchField" "myfield" "matchPattern" "^mypattern.*" "extractField" "fieldValueToReturn") }}

Returns the first match or an empty string.
*/}}
{{- define "ente.filterFieldValues" -}}
{{- $list := .list -}}
{{- $matchField := .matchField -}}
{{- $matchPattern := .matchPattern -}}
{{- $extractField := .extractField -}}
{{- $results := list -}}
{{- range $item := $list }}
  {{- $value := index $item $matchField }}
  {{- if regexMatch $matchPattern $value }}
    {{- $results = append $results (index $item $extractField) }}
  {{- end }}
{{- end }}
{{- first $results | default "" -}}
{{- end }}

