{{/*
Set the db hostname
*/}}
{{- define "leantime.db.host" }}
  {{- $releaseName := regexReplaceAll "(-?[^a-z\\d\\-])+-?" (lower .Release.Name) "-" -}}
  {{- if not .Values.mariadb.enabled }}
    {{- required "If mariadb is not enabled, envVarOverrides.dbHost can't be empty!" .Values.envVarOverrides.dbHost }}
  {{- else }}
    {{- default (printf "%s-%s.%s.svc" $releaseName "mariadb" .Release.Namespace) .Values.envVarOverrides.dbHost }}
  {{- end }}
{{- end }}

{{/*
Set the db name
*/}}
{{- define "leantime.db.name" }}
  {{- if not .Values.mariadb.enabled }}
    {{- default "leantime" .Values.envVarOverrides.dbName }}
  {{- else }}
    {{- default .Values.mariadb.auth.database .Values.envVarOverrides.dbName }}
  {{- end }}
{{- end }}

{{/*
Set the db username
*/}}
{{- define "leantime.db.user" }}
  {{- if not .Values.mariadb.enabled }}
    {{- default "leantime" .Values.envVarOverrides.dbUsername }}
  {{- else }}
    {{- default .Values.mariadb.auth.username .Values.envVarOverrides.dbUsername }}
  {{- end }}
{{- end }}

{{/*
Set the db password
*/}}
{{- define "leantime.db.password" }}
  {{- if not .Values.mariadb.enabled }}
    {{- default "leantime" .Values.envVarOverrides.dbPassword }}
  {{- else }}
    {{- default .Values.mariadb.auth.password .Values.envVarOverrides.dbPassword }}
  {{- end }}
{{- end }}
