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
Render the LEAN_APP_URL value.

Leantime 3.10.2+ verifies the request origin against LEAN_APP_URL and 3.10.3+
builds password-reset and invitation links from it, so it must be the public
URL users reach, never the in-cluster database/service host. When neither an
ingress nor an explicit URL is configured we render it empty: Leantime then
learns the URL at the first owner/admin login, and the chart NOTES warn about
the limitations of that mode.
*/}}
{{- define "leantime.appUrl" -}}
  {{- if .Values.envVarOverrides.appUrl }}
    {{- printf "%s" .Values.envVarOverrides.appUrl }}
  {{- else if .Values.ingress.enabled }}
    {{- $proto := ternary "https" "http" (gt (len $.Values.ingress.tls) 0) }}
    {{- printf "%s://%s" $proto (index .Values.ingress.hosts 0).host }}
  {{- else }}
    {{- "" }}
  {{- end }}
{{- end }}

{{/*
Create a checksum of the PHP ini configuration.

The file is mounted through subPath, so ConfigMap updates do not propagate
into a running container. For a chart-managed ConfigMap the data is hashed
directly; for an existing ConfigMap its current data is read with lookup so
out-of-band changes also roll the pod on the next upgrade.
*/}}
{{- define "leantime.phpIniChecksum" -}}
  {{- if .Values.phpIni.existingConfigMap -}}
    {{- $configMap := lookup "v1" "ConfigMap" .Release.Namespace .Values.phpIni.existingConfigMap -}}
    {{- $data := (($configMap | default dict).data | default dict) -}}
    {{- toYaml $data | sha256sum -}}
  {{- else -}}
    {{- .Values.phpIni.data | sha256sum -}}
  {{- end -}}
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
{{- end }}
