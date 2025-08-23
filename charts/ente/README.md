# Ente Helm Chart

![Version: 0.1.5](https://img.shields.io/badge/Version-0.1.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.20250823-80.1](https://img.shields.io/badge/AppVersion-0.0.20250823--80.1-informational?style=flat-square)

This is a Helm chart for [Ente](https://ente.io), a simple, encrypted, and self-hostable photo and video storage solution.

## Introduction

This chart bootstraps an Ente deployment on a Kubernetes cluster using the Helm package manager. It defaults to deploying PostgreSQL and MinIO as dependencies.
Though the chart takes care of multiple aspects of Ente's configuration, make sure to read the documentation, in particular in relation to the [configuration](https://help.ente.io/self-hosting/installation/config).

## Prerequisites

* Kubernetes 1.23+
* Helm 3.8.0+

### Additionally

If using the included PostgreSQL and/or MinIO:

* PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `home-ente`:

```bash
helm install home-ente oci://ghcr.io/ocraviotto/charts/ente --version 0.1.5
```

## Uninstalling the Chart

To uninstall/delete the `home-ente` release:

```bash
helm delete home-ente
```

## Example

The [external-resources example](examples/external-resources) contains a modified values file to use with a more production-like environment.
Make sure to check it out if intending on a more serious use of Ente.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | minio | 17.0.21 |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 16.7.26 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling | object | `{"museum":{"enabled":false,"maxReplicas":10,"minReplicas":1,"targetCPUUtilizationPercentage":80},"web":{"enabled":false,"maxReplicas":10,"minReplicas":1,"targetCPUUtilizationPercentage":80}}` | Autoscaling - not currently implemented |
| baseDomain | string | `"ente.example.com"` | The base domain for the ente installation, used to generate default URLs |
| enteCredentials | object | `{"existingSecret":"","externalDatabase":{"database":"","enabled":false,"host":"","password":"","port":5432,"user":""},"externalS3":{"accessKey":"","enabled":false,"endpoint":"","region":"","secretKey":""},"forceKeyRotation":false,"jwt":{},"key":{},"s3":{"are_local_buckets":true,"providers":{"b2-eu-cen":{"bucket":"b2-eu-cen","region":"eu-central-2"},"scw-eu-fr-v3":{"bucket":"scw-eu-fr-v3","region":"eu-central-2"},"wasabi-eu-central-2-v3":{"bucket":"wasabi-eu-central-2-v3","compliance":false,"region":"eu-central-2"}},"use_path_style_urls":null}}` | Configuration for Ente application (`credentials.yaml`) [See the docs](https://help.ente.io/self-hosting/museum) for more details, and in particular the example [local.yaml](https://github.com/ente-io/ente/blob/main/server/configurations/local.yaml). These will override the default config (in that default `local.yaml`) but will be overridden by `museum.yaml`, which we set with values from museum.config. |
| enteCredentials.existingSecret | string | `""` | Optionally (recommended) specify an existing secret containing the `credentials.yaml` key. If set, we will not create a chart secret and you will need to make sure to provide `jwt`, `key`, `db` and `s3` configuration details in your secret, along others (like smpt etc.). The secret must have the configuration under the `credentials.yaml` key. If providing your own secret, you'll need to restart the museum container on secret changes (or use something like <https://github.com/stakater/Reloader>) |
| enteCredentials.externalDatabase | object | `{"database":"","enabled":false,"host":"","password":"","port":5432,"user":""}` | Configuration for external services if sub-charts are disabled NOTE: These values will be set in a secret and will not be used if `existingSecret` is set |
| enteCredentials.forceKeyRotation | bool | `false` | Set to true to force regeneration of auto-generated secrets on every helm upgrade. We'll otherwise try to fetch the jwt and key material from the existing secret. |
| enteCredentials.jwt | object | `{}` | Provide a static secret for JWT. If empty, it will be auto-generated and persisted in the secret. |
| enteCredentials.key | object | `{}` | Provide static secrets for key generation. If empty, they will be auto-generated and persisted in the secret. |
| enteCredentials.s3 | object | `{"are_local_buckets":true,"providers":{"b2-eu-cen":{"bucket":"b2-eu-cen","region":"eu-central-2"},"scw-eu-fr-v3":{"bucket":"scw-eu-fr-v3","region":"eu-central-2"},"wasabi-eu-central-2-v3":{"bucket":"wasabi-eu-central-2-v3","compliance":false,"region":"eu-central-2"}},"use_path_style_urls":null}` | s3 configuration for ente. [See the docs](https://help.ente.io/self-hosting/guides/configuring-s3) for details. Here to allow credentials merged into the secret if not providing one. |
| enteCredentials.s3.are_local_buckets | bool | `true` | If true, enable some workarounds to allow us to use a local minio instance by disabling SSL, using path style URLs, not use Cloudflare workers for replication and not specify specify storage classes when uploading objects. Set to false if using SSL for instance and if with MinIO, see `use_path_style_urls` below. |
| enteCredentials.s3.providers | object | `{"b2-eu-cen":{"bucket":"b2-eu-cen","region":"eu-central-2"},"scw-eu-fr-v3":{"bucket":"scw-eu-fr-v3","region":"eu-central-2"},"wasabi-eu-central-2-v3":{"bucket":"wasabi-eu-central-2-v3","compliance":false,"region":"eu-central-2"}}` | Define your S3 providers here. The `key`, `secret` and `endpoint` will be taken from externalS3 or the minio subchart. |
| enteCredentials.s3.use_path_style_urls | string | `nil` | Can override the behavior of `are_local_buckets` by forcing enabling path style. Can also be used without enabling other behaviors of non-prod buckets, like lack of SSL. @default By default this is not used to prevent overriding the use of `are_local_buckets` |
| extraResources | list | `[]` | A list of extra Kubernetes resources to be deployed with the chart. This can be used to deploy resources like ExternalSecrets or other custom resources. |
| fullnameOverride | string | `""` | When set, replaces the generated name (a combination of the release name and the chart's) |
| imagePullSecrets | list | `[]` | Optional list of references to secrets in the same namespace to use for pulling any of the images used. |
| ingress | object | `{"museum":{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]},"web":{"annotations":{},"className":"","enabled":false,"path":"/","pathType":"ImplementationSpecific","tls":[]}}` | Ingress section with both targets |
| ingress.web | object | `{"annotations":{},"className":"","enabled":false,"path":"/","pathType":"ImplementationSpecific","tls":[]}` | If enabled, hostnames are generated automatically from .Values.web.service.ports and baseDomain e.g. photos.{{ .Values.baseDomain }} So if you need to modify hostnames, you need to set the hostname name under the web.service.ports values |
| ingress.web.className | string | `""` | See [ingressClassName](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.33/#ingressspec-v1-networking-k8s-io) If empty if will use the default class. If no ingress operator exists the resource will be created but will have no effect. |
| ingress.web.path | string | `"/"` | Default path match used with all hosts |
| ingress.web.pathType | string | `"ImplementationSpecific"` | Default pathType for path matching |
| ingress.web.tls | list | `[]` | [IngressTLS list](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.33/#ingresstls-v1-networking-k8s-io) Required for the web ingress |
| minio | object | `{"auth":{"rootPassword":"changeme1234","rootUser":"changeme"},"enabled":true,"persistence":{"enabled":true,"size":"10Gi"}}` | Included MinIO configuration |
| minio.auth | object | `{"rootPassword":"changeme1234","rootUser":"changeme"}` | Values to pass to the minio sub-chart. See <https://github.com/bitnami/charts/tree/main/bitnami/minio> |
| minio.enabled | bool | `true` | In "production-like" environments you should modify the mino values if enabled or even better, run MinIO via its own operator. |
| minio.persistence | object | `{"enabled":true,"size":"10Gi"}` | [MinIO® Persistence parameters](https://github.com/bitnami/charts/tree/main/bitnami/minio#minio-persistence-parameters) |
| minio.persistence.enabled | bool | `true` | Enable MinIO® data persistence using PVC. If false, use emptyDir |
| minio.persistence.size | string | `"10Gi"` | PVC Storage Request for MinIO® data volume |
| minioSetup | object | `{"buckets":["b2-eu-cen","wasabi-eu-central-2-v3","scw-eu-fr-v3\""],"enabled":true,"minioUrl":""}` | The minio-setup job used to create ente buckets when enabled. |
| minioSetup.buckets | list | `["b2-eu-cen","wasabi-eu-central-2-v3","scw-eu-fr-v3\""]` | List of buckets to be created by the minio-setup job, used by ente on If emptied, the job will not be created |
| minioSetup.minioUrl | string | <http://[helm-release]-minio:9000> | If using an external minio instance, set to the service endpoint |
| museum.affinity | object | `{}` | Web Pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) |
| museum.config | object | `{}` | Non-sensitive configuration for museum, based on [local.yaml](https://github.com/ente-io/ente/blob/main/server/configurations/local.yaml) and used instead. Will be overwritten by anything in credentials See <https://github.com/ente-io/ente/blob/886ceec05c9db07627afeb560fd29f45b0142d1b/server/pkg/utils/config/config.go#L48-L69> for config loading order. |
| museum.extraEnvFromSecret | list | `[]` | List of names for secrets whose keys will be mounted as environment variables with [envFrom](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#configure-all-key-value-pairs-in-a-secret-as-container-environment-variables) If any of the defined secrets does not exist, the pod will fail starting up. |
| museum.image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"ocraviotto/container-images/ente-server","tag":"0.0.20250823-80.1"}` | The upstream image is built once a week. This image is built every time there is a new server deployed at ente.io as detected by [renovate](https://github.com/ocraviotto/container-images/blob/main/renovate.json) and the [GitHub workflow here](https://github.com/ocraviotto/container-images/blob/main/.github/workflows/build-images.yml). |
| museum.image.registry | string | `"ghcr.io"` | Using GitHub Container Registry, same as the upstream [ente server image](https://github.com/ente-io/ente/pkgs/container/server) |
| museum.image.repository | string | `"ocraviotto/container-images/ente-server"` | My own repository to ensure timely builds [ghcr.io repository](https://github.com/ocraviotto/container-images/pkgs/container/container-images%2Fente-server). |
| museum.image.tag | string | `"0.0.20250823-80.1"` | If empty, it uses the chart appVersion, based on the latest Docker image release in the image [GitHub Packages](https://github.com/ocraviotto/container-images/pkgs/container/container-images%2Fente-server)</br> These tags are generated based on time build and build number + attempt. Read the image metadata to know what hash revision is built from: e.g. `skopeo inspect docker://ghcr.io/ocraviotto/container-images/ente-server:0.0.20250814-1 \| jq '.Labels."org.opencontainers.image.revision"'`</br> For details see: <https://github.com/ocraviotto/container-images/blob/main/specs/ente.yml> |
| museum.metrics | object | `{"enabled":true}` | Enable Prometheus metrics. For now not fully implemented (missing ServiceMonitor\|PodMonitor) |
| museum.nodeSelector | object | `{}` | Web Pod [nodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| museum.persistence.enabled | bool | `false` |  |
| museum.persistence.size | string | `"1Gi"` |  |
| museum.podSecurityContext | object | `{"fsGroup":568,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":568,"runAsNonRoot":true,"runAsUser":568,"seccompProfile":{"type":"RuntimeDefault"}}` | Museum pod level [securityContenxt](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod). |
| museum.replicaCount | int | `1` | Number of [museum](https://help.ente.io/self-hosting/museum) instances to run. Since persistence is handled by MinIO and PostgreSQL, this should be(TM) stateless. |
| museum.resources | object | `{"limits":{"cpu":"250m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Container level [resource limits and requests](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-requests-and-limits-of-pod-and-container) |
| museum.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"add":["NET_BIND_SERVICE"],"drop":["ALL"]},"readOnlyRootFilesystem":false}` | Museum container level [securityContenxt](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container). |
| museum.service.port | int | `8080` |  |
| museum.service.type | string | `"ClusterIP"` |  |
| museum.tls | object | `{"enabled":false,"secretName":""}` | TLS configuration for the museum pod When enabled, the TLS secret needs to exist and its contents will be mounted under /etc/ente/credentials</br> The secret needs to have these keys defined: tls.cert and tls.key. See the [production deployment readme](https://github.com/ente-io/ente/blob/main/server/scripts/deploy/README.md) |
| museum.tls.enabled | bool | `false` | Enable TLS for the museum service |
| museum.tls.secretName | string | `""` | Name of the secret containing the TLS certificate and key |
| museum.tolerations | list | `[]` | Web Pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| nameOverride | string | `""` | When set, used instead of the name of the chart in the Chart.yaml file |
| podAnnotations | object | `{}` | Pod annotations used with both web and museum Can be overwritten with museum.podAnnotations or web.podAnnotations. |
| podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | Default pod level [securityContenxt](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod) used with both web and museum. Can be overwritten by setting museum.podSecurityContext or web.podSecurityContext. |
| postgresql | object | `{"auth":{"database":"ente_db","password":"changeme","username":"pguser"},"enabled":true,"primary":{"persistence":{"enabled":true,"size":"8Gi"}}}` | Included PostgreSQL configuration |
| postgresql.enabled | bool | `true` | In "production-like" environments you should modify the values below or better still, run one of Crunchy Postgres Operator (PGO) or CloudNativePG |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"add":["CHOWN","DAC_OVERRIDE","NET_BIND_SERVICE","SETGID","SETUID"],"drop":["ALL"]},"readOnlyRootFilesystem":false}` | Default Container level [securityContenxt](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container) used with both web and museum Can be overwritten with museum.securityContext or web.securityContext. These are more generous than the permissions we default to for the server (museum) and the web applications separately, and are here for reference, as they are used if the web or museum versions are not provided. Web needs to modify js files on startup does some other changes (nginx docker-entrypoint) NET_BIND_SERVICE is required when running with TLS by the museum API Both write to the FS outside the mounted points |
| serviceAccount | object | `{"annotations":{},"create":false,"name":""}` | Create a separate serviceAccount for ente museum At the moment we |
| web.affinity | object | `{}` | Web Pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) |
| web.config | object | `{"enteAlbumsOrigin":"","enteApiOrigin":"","nodeEnv":"production"}` | Various convenience settings exposed as fields to manage web configuration |
| web.config.enteAlbumsOrigin | string | `""` | The value of the 'ENTE_ALBUMS_ORIGIN' env var Leave empty unless you know what you're doing and are willing to see where else this is used... @default <http://albums.ente.example.com> -> http(s)://albums.[baseDomain] |
| web.config.enteApiOrigin | string | `""` | The value of the 'ENTE_API_ORIGIN' env var. Leave empty unless you know what you're doing and are willing to see where else this is used... @default <http://api.ente.example.com> -> http(s)://api.[baseDomain] |
| web.config.nodeEnv | string | `"production"` | The value of the 'NODE_ENV' env var |
| web.image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"ocraviotto/container-images/ente-web","tag":"0.0.20250823-80.1"}` | The upstream image is built once a week. This image is built every time there is a new server deployed at ente.io as detected by [renovate](https://github.com/ocraviotto/container-images/blob/main/renovate.json) and the [GitHub workflow here](https://github.com/ocraviotto/container-images/blob/main/.github/workflows/build-images.yml). |
| web.image.registry | string | `"ghcr.io"` | Using GitHub Container Registry, same as the upstream [ente server image](https://github.com/ente-io/ente/pkgs/container/web) |
| web.image.repository | string | `"ocraviotto/container-images/ente-web"` | My own repository to ensure timely builds [ghcr.io repository](https://github.com/ocraviotto/container-images/pkgs/container/container-images%2Fente-web). |
| web.image.tag | string | `"0.0.20250823-80.1"` | Can be a tag or digest. The image is built every time we trigger a server build, and the source uses ente's main branch.</br> The tags are generated based on time build and build number + attempt. Read the image metadata to know what hash revision is built from: e.g. `skopeo inspect docker://ghcr.io/ocraviotto/container-images/ente-web:0.0.20250814-1 \| jq '.Labels."org.opencontainers.image.revision"'`</br> For details see: <https://github.com/ocraviotto/container-images/blob/main/specs/ente.yml> |
| web.nodeSelector | object | `{}` | Web Pod [nodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| web.podSecurityContext | object | `{}` | Web pod level [securityContenxt](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod) used with both web and museum. |
| web.replicaCount | int | `1` |  |
| web.resources | object | `{"limits":{"cpu":"250m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Container level [resource limits and requests](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-requests-and-limits-of-pod-and-container) |
| web.securityContext | object | `{}` | Web container level [securityContenxt](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container). |
| web.service | object | `{"ports":[{"hostname":"","name":"photos","port":3000,"targetPort":3000},{"hostname":"","name":"accounts","port":3001,"targetPort":3001},{"hostname":"","name":"public-albums","port":3002,"targetPort":3002},{"hostname":"","name":"auth","port":3003,"targetPort":3003},{"hostname":"","name":"cast","port":3004,"targetPort":3004}],"type":"ClusterIP"}` | Web [service](https://kubernetes.io/docs/concepts/services-networking/service/) resource configuration exposing only service type and ports to serve |
| web.service.ports | list | `[{"hostname":"","name":"photos","port":3000,"targetPort":3000},{"hostname":"","name":"accounts","port":3001,"targetPort":3001},{"hostname":"","name":"public-albums","port":3002,"targetPort":3002},{"hostname":"","name":"auth","port":3003,"targetPort":3003},{"hostname":"","name":"cast","port":3004,"targetPort":3004}]` | The list of ports that are exposed by this service. See the [ServiceSpec](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec) for details on fields. See [docs for an additional background on service ports and virtual IPs](https://kubernetes.io/docs/reference/networking/virtual-ips/).\n NOTE: If you manually override any of these, make sure that's reflected elsewhere (e.g. .museum.config.enteAlbumsOrigin for public-albums etc.) |
| web.service.ports[0].hostname | string | `""` | Optional override. Defaults to `baseDomain` if empty. |
| web.service.ports[1].hostname | string | `""` | Optional override. Defaults to `accounts.baseDomain` if empty. |
| web.service.ports[2].hostname | string | `""` | Optional override. Defaults to `albums.baseDomain` if empty. |
| web.service.ports[3].hostname | string | `""` | Optional override. Defaults to `auth.baseDomain` if empty. |
| web.service.ports[4].hostname | string | `""` | Optional override. Defaults to `cast.baseDomain` if empty. |
| web.service.type | string | `"ClusterIP"` | Service [Type](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) |
| web.tolerations | list | `[]` | Web Pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
