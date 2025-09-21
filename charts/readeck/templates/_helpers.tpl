{{/*
Expand the name of the chart.
*/}}
{{- define "readeck.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "readeck.fullname" -}}
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
{{- define "readeck.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "readeck.labels" -}}
helm.sh/chart: {{ include "readeck.chart" . }}
{{ include "readeck.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "readeck.selectorLabels" -}}
app.kubernetes.io/name: {{ include "readeck.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "readeck.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "readeck.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Set the directory path where to mount the readeck volume for persistence
*/}}
{{- define "readeck.dir" -}}
{{- if and .Values.persistence.enabled .Values.persistence.volumeMounts.readeck.enabled }}
{{- default (get .Values.persistence.volumeMounts.readeck "mountPath" | trimPrefix "/readeck") "data" }}
{{- else }}
{{- "" }}
{{- end }}
{{- end }}

{{/*
Create a checksum of all configuration.
This is used to trigger a rolling update when the config changes.
*/}}
{{- define "readeck.checksum" -}}
{{- $configMapData := .Values.envFromConfigMap.data -}}
{{- $secretData := "" -}}
{{- if and .Values.envFromSecret.enabled (not .Values.envFromSecret.existingSecret) -}}
{{- $secretData = include "readeck.secrets.data" . -}}
{{- end -}}
{{- printf "%s%s" $configMapData $secretData | sha256sum -}}
{{- end -}}
