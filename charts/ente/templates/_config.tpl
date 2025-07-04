{{/*
Create the credentials.yaml data.
This template handles the logic for generating and persisting secrets.
*/}}
{{- define "ente.credentials.data" -}}
{{- $fullname := include "ente.fullname" . -}}
{{- $secretName := printf "%s-credentials" $fullname -}}
{{- $existingSecret := lookup "v1" "Secret" .Release.Namespace $secretName -}}
{{- $forceRotation := .Values.enteCredentials.forceKeyRotation -}}
{{- $credentials := dict -}}
{{- if and $existingSecret (not $forceRotation) -}}
  {{- $credentials = index $existingSecret.data "credentials.yaml" | b64dec | fromYaml -}}
{{- end -}}
{{- /* Key Generation */}}
{{- $keyEncryption := "" -}}
{{- if and (not $forceRotation) ($credentials.key | default dict).encryption -}}
  {{- $keyEncryption = $credentials.key.encryption -}}
{{- else -}}
  {{- $keyEncryption = randAlphaNum 32 | b64enc -}}
{{- end -}}
{{- if .Values.enteCredentials.key.encryption -}}
  {{- $keyEncryption = .Values.enteCredentials.key.encryption -}}
{{- end -}}

{{- $keyHash := "" -}}
{{- if and (not $forceRotation) ($credentials.key | default dict).hash -}}
  {{- $keyHash = $credentials.key.hash -}}
{{- else -}}
  {{- $keyHash = randAlphaNum 64 | b64enc -}}
{{- end -}}
{{- if .Values.enteCredentials.key.hash -}}
  {{- $keyHash = .Values.enteCredentials.key.hash -}}
{{- end -}}

{{- /* JWT Secret Generation */}}
{{- $jwtSecret := "" -}}
{{- if and (not $forceRotation) ($credentials.jwt | default dict).secret -}}
  {{- $jwtSecret = $credentials.jwt.secret -}}
{{- else -}}
  {{- $jwtSecret = randAlphaNum 32 | b64enc -}}
{{- end -}}
{{- if .Values.enteCredentials.jwt.secret -}}
  {{- $jwtSecret = .Values.enteCredentials.jwt.secret -}}
{{- end -}}

{{- /* Database Credentials Logic */}}
{{- $dbHost := "" -}}
{{- $dbPort := 5432 -}}
{{- $dbUser := "" -}}
{{- $dbPassword := "" -}}
{{- $dbName := "" -}}
{{- if .Values.enteCredentials.externalDatabase.enabled }}
  {{- $dbHost = .Values.enteCredentials.externalDatabase.host -}}
  {{- $dbPort = .Values.enteCredentials.externalDatabase.port -}}
  {{- $dbUser = .Values.enteCredentials.externalDatabase.user -}}
  {{- $dbPassword = .Values.enteCredentials.externalDatabase.password -}}
  {{- $dbName = .Values.enteCredentials.externalDatabase.database -}}
{{- else if .Values.postgresql.enabled }}
  {{- $dbHost = printf "%s-postgresql" .Release.Name -}}
  {{- $dbPort = 5432 -}}
  {{- $dbUser = .Values.postgresql.auth.username -}}
  {{- $dbPassword = .Values.postgresql.auth.password -}}
  {{- $dbName = .Values.postgresql.auth.database -}}
{{- end -}}

{{- /* S3 Credentials Logic */}}
{{- $s3AccessKey := "" -}}
{{- $s3SecretKey := "" -}}
{{- $s3Endpoint := "" -}}
{{- $s3Region := "" -}}
{{- if .Values.enteCredentials.externalS3.enabled }}
  {{- $s3AccessKey = .Values.enteCredentials.externalS3.accessKey -}}
  {{- $s3SecretKey = .Values.enteCredentials.externalS3.secretKey -}}
  {{- $s3Endpoint = .Values.enteCredentials.externalS3.endpoint -}}
  {{- $s3Region = .Values.enteCredentials.externalS3.region -}}
{{- else if .Values.minio.enabled }}
  {{- $s3AccessKey = .Values.minio.auth.rootUser -}}
  {{- $s3SecretKey = .Values.minio.auth.rootPassword -}}
  {{- $s3Endpoint = printf "%s-minio:9000" .Release.Name -}}
  {{- $s3Region = "" -}}
{{- end -}}
key:
  encryption: {{ $keyEncryption | quote }}
  hash: {{ $keyHash | quote }}
jwt:
  secret: {{ $jwtSecret | quote }}
db:
  host: {{ $dbHost | quote }}
  port: {{ $dbPort }}
  name: {{ $dbName | quote }}
  user: {{ $dbUser | quote }}
  password: {{ $dbPassword | quote }}
s3:
  {{- if not (quote (.Values.enteCredentials.s3 | default dict).are_local_buckets | empty)  }}
  are_local_buckets: {{ .Values.enteCredentials.s3.are_local_buckets }}
  {{- end }}
  {{- if not (quote (.Values.enteCredentials.s3 | default dict).use_path_style_urls | empty) }}
  use_path_style_urls: {{ .Values.enteCredentials.s3.use_path_style_urls }}
  {{- end }}
  {{- range $name, $provider := (.Values.enteCredentials.s3 | default dict).providers }}
  {{ $name }}:
    key: {{ $s3AccessKey | quote }}
    secret: {{ $s3SecretKey | quote }}
    endpoint: {{ $s3Endpoint | quote }}
    region: {{ $provider.region | default $s3Region | quote }}
    bucket: {{ $provider.bucket | quote }}
    {{- if hasKey $provider "compliance" }}
    compliance: {{ $provider.compliance }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Create a checksum of all configuration.
This is used to trigger a rolling update when the config changes.
*/}}
{{- define "ente.config.checksum" -}}
{{- $configMapData := include "ente.museum.config.data" . -}}
{{- $secretData := "" -}}
{{- if not .Values.enteCredentials.existingSecret -}}
{{- $secretData = include "ente.credentials.data" . -}}
{{- end -}}
{{- printf "%s%s" $configMapData $secretData | sha256sum -}}
{{- end -}}


{{/*
Hostname for the API service.
If using ingress, we'll try to get the first match,
else default to api.baseDomain.
*/}}
{{- define "ente.hostname.api" -}}
  {{- $host := "" -}}
  {{- if .Values.ingress.museum.enabled -}}
    {{- $host := (first .Values.ingress.museum.hosts).host -}}
  {{- end -}}
  {{- $host | default (printf "api.%s" .Values.baseDomain) -}}
{{- end -}}

{{/*
Hostname for the public albums app.
*/}}
{{- define "ente.hostname.albums" -}}
{{- $hostname := include "ente.filterFieldValues" (dict "list" .Values.web.service.ports "matchField" "name" "matchPattern" "public-albums" "extractField" "hostname") -}}
{{- if $hostname -}}
{{- $hostname -}}
{{- else -}}
{{- printf "albums.%s" .Values.baseDomain -}}
{{- end -}}
{{- end -}}

{{/*
Hostname for the cast app.
*/}}
{{- define "ente.hostname.cast" -}}
{{- $hostname := include "ente.filterFieldValues" (dict "list" .Values.web.service.ports "matchField" "name" "matchPattern" "cast" "extractField" "hostname") -}}
{{- if $hostname -}}
{{- $hostname -}}
{{- else -}}
{{- printf "cast.%s" .Values.baseDomain -}}
{{- end -}}
{{- end -}}

{{/*
Hostname for the accounts app.
*/}}
{{- define "ente.hostname.accounts" -}}
{{- $hostname := include "ente.filterFieldValues" (dict "list" .Values.web.service.ports "matchField" "name" "matchPattern" "accounts" "extractField" "hostname") -}}
{{- if $hostname -}}
{{- $hostname -}}
{{- else -}}
{{- printf "accounts.%s" .Values.baseDomain -}}
{{- end -}}
{{- end -}}

{{/*
Hostname for the family app.
*/}}
{{- define "ente.hostname.family" -}}
{{- $hostname := include "ente.filterFieldValues" (dict "list" .Values.web.service.ports "matchField" "name" "matchPattern" "family" "extractField" "hostname") -}}
{{- if $hostname -}}
{{- $hostname -}}
{{- else -}}
{{- printf "family.%s" .Values.baseDomain -}}
{{- end -}}
{{- end -}}

{{/*
Hostname for the photos app.
*/}}
{{- define "ente.hostname.photos" -}}
{{- $hostname := include "ente.filterFieldValues" (dict "list" .Values.web.service.ports "matchField" "name" "matchPattern" "photos" "extractField" "hostname") -}}
{{- if $hostname -}}
{{- $hostname -}}
{{- else -}}
{{- .Values.baseDomain -}}
{{- end -}}
{{- end -}}

{{/*
Hostname for the auth app.
*/}}
{{- define "ente.hostname.auth" -}}
{{- $hostname := include "ente.filterFieldValues" (dict "list" .Values.web.service.ports "matchField" "name" "matchPattern" "auth" "extractField" "hostname") -}}
{{- if $hostname -}}
{{- $hostname -}}
{{- else -}}
{{- printf "auth.%s" .Values.baseDomain -}}
{{- end -}}
{{- end -}}


{{/*
Create the API origin URL for the web service.
*/}}
{{- define "ente.web.apiOrigin" -}}
  {{- $protocol := "http" -}}
  {{- if .Values.museum.tls.enabled -}}
    {{- $protocol = "https" -}}
  {{- end -}}
  {{- printf "%s://%s" $protocol (include "ente.hostname.api" .) -}}
{{- end -}}

{{/*
Create the public albums URL.
*/}}
{{- define "ente.apps.publicAlbumsUrl" -}}
{{- $protocol := "http" -}}
{{- if and .Values.ingress.web.enabled .Values.ingress.web.tls  -}}
{{- $protocol = "https" -}}
{{- end -}}
{{- printf "%s://%s" $protocol (include "ente.hostname.albums" .) -}}
{{- end -}}

{{/*
Create the cast URL.
*/}}
{{- define "ente.apps.castUrl" -}}
{{- $protocol := "http" -}}
{{- if and .Values.ingress.web.enabled .Values.ingress.web.tls -}}
{{- $protocol = "https" -}}
{{- end -}}
{{- printf "%s://%s" $protocol (include "ente.hostname.cast" .) -}}
{{- end -}}

{{/*
Create the accounts URL.
*/}}
{{- define "ente.apps.accountsUrl" -}}
  {{- $protocol := "http" -}}
  {{- if and .Values.ingress.web.enabled .Values.ingress.web.tls  -}}
    {{- $protocol = "https" -}}
  {{- end -}}
  {{- printf "%s://%s" $protocol (include "ente.hostname.accounts" .) -}}
{{- end -}}

{{/*
Create the family URL.
*/}}
{{- define "ente.apps.familyUrl" -}}
{{- $protocol := "http" -}}
{{- if .Values.museum.tls.enabled -}}
{{- $protocol = "https" -}}
{{- end -}}
{{- printf "%s://%s" $protocol (include "ente.hostname.family" .) -}}
{{- end -}}

{{/*
Create the photos URL.
*/}}
{{- define "ente.apps.photosUrl" -}}
{{- $protocol := "http" -}}
{{- if and .Values.ingress.web.enabled .Values.ingress.web.tls  -}}
{{- $protocol = "https" -}}
{{- end -}}
{{- printf "%s://%s" $protocol (include "ente.hostname.photos" .) -}}
{{- end -}}

{{/*
Create the auth URL.
*/}}
{{- define "ente.apps.authUrl" -}}
{{- $protocol := "http" -}}
{{- if and .Values.ingress.web.enabled .Values.ingress.web.tls  -}}
{{- $protocol = "https" -}}
{{- end -}}
{{- printf "%s://%s" $protocol (include "ente.hostname.auth" .) -}}
{{- end -}}


{{/*
Create the museum.yaml data.
This template merges default values with user-provided configuration.
*/}}
{{- define "ente.museum.config.data" -}}
{{- $defaultConfig := dict -}}
{{- $_ := set $defaultConfig "http" (dict "use-tls" .Values.museum.tls.enabled) -}}
{{- $_ := set $defaultConfig "apps" (dict
      "public-albums" (include "ente.apps.publicAlbumsUrl" .)
      "cast" (include "ente.apps.castUrl" .)
      "accounts" (include "ente.apps.accountsUrl" .)
      "family" (include "ente.apps.familyUrl" .)
    ) -}}
{{- $_ := set $defaultConfig "webauthn" (dict
      "rpid" .Values.baseDomain
      "rporigins" (list (include "ente.apps.accountsUrl" .))
    ) -}}

{{- $finalConfig := mergeOverwrite ($defaultConfig | deepCopy) .Values.museum.config -}}

{{- /* Special handling for webauthn rporigins to merge lists instead of overwriting */}}
{{- if (.Values.museum.config.webauthn | default dict).rporigins -}}
  {{- $defaultOrigin := include "ente.apps.accountsUrl" . -}}
  {{- $allOrigins := append .Values.museum.config.webauthn.rporigins $defaultOrigin | uniq -}}
  {{- $_ := set $finalConfig.webauthn "rporigins" $allOrigins -}}
{{- end -}}

{{- toYaml $finalConfig -}}
{{- end -}}
