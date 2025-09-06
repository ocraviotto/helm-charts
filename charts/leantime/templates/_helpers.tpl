{{/*
Expand the name of the chart.
*/}}
{{- define "leantime.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "leantime.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- $releaseName := regexReplaceAll "(-?[^a-z\\d\\-])+-?" (lower .Release.Name) "-" -}}
{{- if contains $name $releaseName }}
{{- $releaseName | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $releaseName $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "leantime.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "leantime.labels" -}}
helm.sh/chart: {{ include "leantime.chart" . }}
{{ include "leantime.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "leantime.selectorLabels" -}}
app.kubernetes.io/name: {{ include "leantime.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "leantime.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "leantime.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Render the LEAN_APP_URL value
*/}}
{{- define "leantime.appUrl" -}}
  {{- if not .Values.ingress.enabled }}
    {{- printf "%s" (.Values.envVarOverrides.appUrl | default (include "leantime.db.host" .) ) }}
  {{- else }}
    {{- $proto := ternary "https" "http" (gt (len $.Values.ingress.tls) 0) }}
    {{- $noOverride := printf "%s://%s" $proto (index .Values.ingress.hosts 0).host }}
    {{- .Values.envVarOverrides.appUrl | default $noOverride }}
  {{- end }}
{{- end }}

{{/*
Create a checksum of all configuration.
This is used to trigger a rolling update when the config changes.
*/}}
{{- define "leantime.checksum" -}}
{{- $configMapData := .Values.envFromConfigMap.data -}}
{{- $secretData := "" -}}
{{- if and .Values.envFromSecret.enabled (not .Values.envFromSecret.existingSecret) -}}
{{- $secretData = include "leantime.secrets.data" . -}}
{{- end -}}
{{- printf "%s%s" $configMapData $secretData | sha256sum -}}
{{- end -}}
