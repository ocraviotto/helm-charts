{{/*
Expand the name of the chart.
*/}}
{{- define "shiori.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "shiori.fullname" -}}
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
{{- define "shiori.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "shiori.labels" -}}
helm.sh/chart: {{ include "shiori.chart" . }}
{{ include "shiori.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "shiori.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shiori.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "shiori.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shiori.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Set the directory path where to mount the shiori volume for persistence
*/}}
{{- define "shiori.dir" -}}
{{- if and .Values.persistence.enabled .Values.persistence.volumeMounts.shiori.enabled }}
{{- default (get .Values.persistence.volumeMounts.shiori "mountPath") "/shiori" }}
{{- else }}
{{- "" }}
{{- end }}
{{- end }}

{{/*
Create a checksum of all configuration.
This is used to trigger a rolling update when the config changes.
*/}}
{{- define "shiori.checksum" -}}
{{- $configMapData := .Values.envFromConfigMap.data -}}
{{- $secretData := "" -}}
{{- if and .Values.envFromSecret.enabled (not .Values.envFromSecret.existingSecret) -}}
{{- $secretData = include "shiori.secrets.data" . -}}
{{- end -}}
{{- printf "%s%s" $configMapData $secretData | sha256sum -}}
{{- end -}}
