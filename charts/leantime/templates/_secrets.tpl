{{/*
Create the environment data to set a secret for leantime and use with valueFrom.secretKeyRef.
This template handles the logic for generating and retrieving the data on upgrades.
*/}}
{{- define "leantime.secrets.data" -}}
  {{- $secretName :=  printf "%s" (tpl .Values.envFromSecret.secretName $) -}}
  {{- $existingSecret := lookup "v1" "Secret" .Release.Namespace $secretName -}}
  {{- $regenerate := .Values.envFromSecret.regenerate -}}
  {{- $existingSecretData := dict -}}
  {{- $_ := deepCopy ($existingSecret | default dict) | merge $existingSecretData -}}
  {{- $data := dict -}}

  {{/* First let's go over envFromConfigMap.data */}}
  {{- range $key, $value := .Values.envFromSecret.data }}
    {{- $valueTpl := tpl (printf "%s" $value) $ | b64enc -}}
    {{- if hasKey $existingSecretData $key -}}
      {{- $_ := set $data $key (ternary $valueTpl (get $existingSecretData $key) $regenerate) -}}
      {{- $_ := unset $existingSecretData $key -}}
    {{- else if $valueTpl -}}
      {{- $_ := set $data $key $valueTpl -}}
    {{- end -}}
  {{- end -}}
  {{/* Then let's go over the remaining $existingSecretData if we have anything left */}}
  {{- range $key, $value := $existingSecretData }}
    {{- $_ := set $data $key $value -}}
  {{- end -}}
  {{/* Put the data*/}}
  {{- $data | toYaml }}
{{- end -}}
