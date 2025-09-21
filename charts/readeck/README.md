# Readeck Helm Chart

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.20.3](https://img.shields.io/badge/AppVersion-0.20.3-informational?style=flat-square)

This is a Helm chart for [readeck](https://readeck.org), a tool to keep all that web content you’ll want to revisit in an hour, tomorrow, or in 20 years.

## Introduction

This chart bootstraps a Readeck deployment on a Kubernetes cluster using the Helm package manager.
The chart itself has no dependencies, as Readeck can run with SQLite (which requires persistence), but it supports configuring a separate PostgreSQL database for better scalability.
Though the chart takes care of multiple aspects of Readeck's configuration, make sure to read the [documentation](https://readeck.org/en/docs/),
in particular in relation to the [configuration](https://readeck.org/en/docs/configuration).

## Prerequisites

* Kubernetes 1.23+
* Helm 3.8.0+

### Additionally

If enabling persistence with claim enabled:

* PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `readeck`:

```bash
helm install readeck oci://ghcr.io/ocraviotto/charts/readeck --version 0.1.0
```

## Uninstalling the Chart

To uninstall/delete the `readeck` release:

```bash
helm delete readeck
```

## Example

The [external-resources example](examples/external-resources) contains a modified values file to use with a more production-like environment.
Make sure to check it out if intending on a more serious use of Readeck.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | This section is for setting up autoscaling  (more information can be found here: <https://kubernetes.io/docs/concepts/workloads/autoscaling/>), but until Readeck decouples downloads from the local storage, or unless using an NFS or similar `ReadWriteMany` storage, this should NOT be enabled. |
| env | object | `{}` | Container [EnvVar](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.33/#envvar-v1-core) object Use it to override single values. Takes precedence over envFrom* values. |
| envFromConfigMap | object | Enabled and populated with all of the values in data | This is the default configuration passed to Readeck via environment variables. In principle any sensitive value should be provided via `envFronSecret.data`, or via an externally managed secret mapped to the environment via `env[].valueFrom.secretKeyRef` NOTE: Any variable overlap from the envFromSecret.data section takes precedence over those defined here. |
| envFromConfigMap.cmAnnotations | object | `{}` | Additional annotations to add to the generated ConfigMap |
| envFromConfigMap.cmLabels | object | `{}` | Additional labels to add to the generated ConfigMap |
| envFromConfigMap.cmName | string | `"{{ include \"readeck.fullname\" . }}-env"` | Sets the configMap name |
| envFromConfigMap.data | object | `{"READECK_ALLOWED_HOSTS":"","READECK_DATA_DIRECTORY":"{{ include \"readeck.dir\" . }}","READECK_LOG_FORMAT":"json","READECK_LOG_LEVEL":"info","READECK_MAIL_ENCRYPTION":"","READECK_MAIL_FROM":"","READECK_MAIL_FROMNOREPLY":"","READECK_MAIL_HOST":"","READECK_MAIL_INSECURE":"false","READECK_MAIL_PASSWORD":"","READECK_MAIL_PORT":"","READECK_MAIL_USERNAME":"","READECK_METRICS_HOST":"127.0.0.1","READECK_METRICS_PORT":"8002","READECK_PUBLIC_SHARE_TTL":"24","READECK_SERVER_BASE_URL":"","READECK_SERVER_CERT_FILE":"","READECK_SERVER_HOST":"0.0.0.0","READECK_SERVER_KEY_FILE":"","READECK_SERVER_PORT":"8000","READECK_SERVER_PREFIX":"/","READECK_TRUSTED_PROXIES":"127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,fd00::/8,::1/128","READECK_WORKER_DSN":"","READECK_WORKER_NUMBER":"","READECK_WORKER_START":"true"}` | The default contents for configMap. Based on [Readeck's Configuration Options](https://readeck.org/en/docs/configuration), with the exception of any sensitive variable, that is set in `envFromSecret.data`. Values support helm templating. NOTE: Make sure these are all strings! |
| envFromConfigMap.data.READECK_ALLOWED_HOSTS | string | `""` | A list of hostnames allowed in HTTP requests. |
| envFromConfigMap.data.READECK_DATA_DIRECTORY | string | "data" | The directory where we'll mount the volume for Readeck persistence. This is relative to the container workingdir (/readeck) |
| envFromConfigMap.data.READECK_LOG_FORMAT | string | `"json"` | Defines the log format. Can be one of `json`, `text` or `dev`. |
| envFromConfigMap.data.READECK_LOG_LEVEL | string | `"info"` | Defines the application log level. Can be one of `error`, `warn`, `info`, `debug`. |
| envFromConfigMap.data.READECK_MAIL_ENCRYPTION | string | `""` | One of `starttls` or `ssltls`. Sets the encryption mechanism of the SMTP host |
| envFromConfigMap.data.READECK_MAIL_FROM | string | `""` | Email address of the `From` messages header. |
| envFromConfigMap.data.READECK_MAIL_FROMNOREPLY | string | `""` | Email address of the `From` header for messages that don't need a reply. |
| envFromConfigMap.data.READECK_MAIL_HOST | string | `""` | The SMTP Host to send emails through |
| envFromConfigMap.data.READECK_MAIL_INSECURE | string | `"false"` | If `true`, it will NOT verify the server certificate |
| envFromConfigMap.data.READECK_MAIL_PASSWORD | string | `""` | The SMTP password if needed |
| envFromConfigMap.data.READECK_MAIL_PORT | string | `""` | The TCP Port of the SMTP host |
| envFromConfigMap.data.READECK_MAIL_USERNAME | string | `""` | The SMTP username if needed |
| envFromConfigMap.data.READECK_METRICS_HOST | string | `"127.0.0.1"` | Host to bind to listen for /metrics (prometheus) and /debug (profiler) requests. |
| envFromConfigMap.data.READECK_METRICS_PORT | string | `"8002"` | Port to bind to listen for /metrics (prometheus) and /debug (profiler) requests. |
| envFromConfigMap.data.READECK_PUBLIC_SHARE_TTL | string | `"24"` | Number of hours a shared bookmark is available. |
| envFromConfigMap.data.READECK_SERVER_BASE_URL | string | `""` | Instance URL (optional) Important: When this is set to an HTTP or HTTPS URL, it's used as the only valid URL of your instance. Any information sent by a reverse proxy is ignored. If this URL contains a path other than `/`, it replaces the `prefix` value. |
| envFromConfigMap.data.READECK_SERVER_CERT_FILE | string | `""` | Path to the cert file for Readeck to use HTTPS (and HTTP/2) |
| envFromConfigMap.data.READECK_SERVER_HOST | string | `"0.0.0.0"` | The IP address or Unix socket on which Readeck listens to. |
| envFromConfigMap.data.READECK_SERVER_KEY_FILE | string | `""` | Path to the key file for Readeck to use HTTPS (and HTTP/2) |
| envFromConfigMap.data.READECK_SERVER_PORT | string | `"8000"` | The TCP port on which Readeck listens to. |
| envFromConfigMap.data.READECK_SERVER_PREFIX | string | `"/"` | The URL prefix of Readeck. |
| envFromConfigMap.data.READECK_TRUSTED_PROXIES | string | `"127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,fd00::/8,::1/128"` | Sets the trusted IP addresses that can set `X-Forwarded` headers. |
| envFromConfigMap.data.READECK_WORKER_DSN | string | "memory://" | Data Source Name for Readeck's message bus and task executor Can be either `memory://` or `redis://` |
| envFromConfigMap.data.READECK_WORKER_NUMBER | string | min of 1 | Number of Readeck's message bus and task executor workers If not given, it's calculated based on runtime.NumCPU(), so if no limits are set, runtime.NumCPU() will see all of the node's logical CPUs. IMPORTANT: If not setting limits, make sure to set this value. |
| envFromConfigMap.data.READECK_WORKER_START | string | `"true"` | Whether to start Readeck's message bus and task executor worker(s) |
| envFromConfigMap.enabled | bool | `true` | Defines if we include this in readeck |
| envFromConfigMap.existingConfigMap | string | `""` | The name of an existing ConfigMap to use with `configMapRef.name`. If this is not empty, we will NOT create the resource with the values defined in data. |
| envFromSecret | object | Enabled and populated with all of the values in data | This is the default configuration passed to Readeck via environment variables. Variables here take precedence over envFromConfigMap. NOTE: If enabled and no existingSecret passed, we will attempt to read the values from the target Kubernetes unless regenerate is "true" |
| envFromSecret.data | object | `{"READECK_DATABASE_SOURCE":"","READECK_SECRET_KEY":"{{ randAlphaNum 32 }}"}` | The default contents for the Secret to mount. |
| envFromSecret.data.READECK_DATABASE_SOURCE | string | "sqlite3:data/db.sqlite3" | Readeck uses an SQLite3 database stored in the READECK_DATA_DIRECTORY data directory by default. If you prefer, you can also use a PostgreSQL database by setting the READECK_DATABASE_SOURCE environment variable. If using GitOps or otherwise sharing this values file, please consider setting this value via the `.valueFrom.secretKeyRef`. All relative file locations are relative to the /readeck workingdir. |
| envFromSecret.data.READECK_SECRET_KEY | string | `"{{ randAlphaNum 32 }}"` | The main secret key. It must be set and be a long string of random characters. |
| envFromSecret.enabled | bool | `true` | Defines if we include a secret as envFrom in the readeck container. |
| envFromSecret.existingSecret | string | `""` | The name of an existing Secret to use with `secretRef.name`. If this is not empty, we will NOT create the resource with the values defined in data. So if you have your own secret, set it here and make sure it has all required variables set. NOTE: Required variables are basically every one listed in the data section. |
| envFromSecret.regenerate | bool | `false` | Force regeneration of dynamically set values in the secret |
| envFromSecret.secretAnnotations | object | `{}` | Additional annotations to add to the generated secret |
| envFromSecret.secretLabels | object | `{}` | Additional labels to add to the generated secret |
| envFromSecret.secretName | string | `"{{ include \"readeck.fullname\" . }}-env"` | If existingSecret is empty, we'll create a secret whose name is defined with this entry. Supports templating. |
| extraEnvFrom | object | `{}` |  |
| extraResources | list | `[]` | A list of extra Kubernetes resources to be deployed with the chart. This can be used to deploy resources like ExternalSecrets or other custom resources. |
| fullnameOverride | string | `""` | This is to override the Helm Release name + the chart name. |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"codeberg.org","repository":"readeck/readeck","tag":""}` | This sets the container image more information can be found here: <https://kubernetes.io/docs/concepts/containers/images/> |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.registry | string | `"codeberg.org"` | Set to allow to easily change registry and in our case, mainly to support renovate regular expressions (not required for the Docker hub). |
| image.repository | string | `"readeck/readeck"` | We use the upstream readeck image by default. The image build script in python is here: <https://codeberg.org/readeck/readeck/src/branch/main/tools/build-container> |
| image.tag | string |  value of chart appVersion | Use it to override the image tag. Note: Readeck builds 2 images, one from scratch, and one from alpine, that can be used for troubleshooting. The alpine-based version has the "alpine-" prefix, e.g. "alpine-v1.7.4" |
| imagePullSecrets | list | `[]` | This is for the secrets for pulling an image from a private repository more information can be found here: <https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/> |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` | Pod [nodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| persistence | object | `{"claim":{"accessMode":"ReadWriteOnce","annotations":{},"enabled":true,"size":"5Gi","storageClass":""},"enabled":true,"existingClaim":"","volumeMounts":{"readeck":{"enabled":true,"mountPath":"/readeck","subPath":"readeck"}}}` | For now unless we enable persistence all Readeck downloads will be lost... NOTE: Make sure your cluster has at least a loca path provisioner and a default storageClass. |
| persistence.claim | object | `{"accessMode":"ReadWriteOnce","annotations":{},"enabled":true,"size":"5Gi","storageClass":""}` | If existingClaim is empty and persistence is enabled, when `claim.enabled`is `true` we'll create a pvc based on these details |
| persistence.claim.accessMode | string | `"ReadWriteOnce"` | See [accessMode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) |
| persistence.claim.enabled | bool | `true` | If false, we'll use an emptyDir, which is an ephemeral volume and a very bad idea for production, but might be useful for testing |
| persistence.claim.size | string | `"5Gi"` | Requested size |
| persistence.enabled | bool | `true` | Enable persistent storage for user files. The Claim is enabled by default, but if testing this chart, it is OK to disable it, in which case we'll use an emptyDir. |
| persistence.existingClaim | string | `""` | If not empty, it will use this existing Persistent Volume Claim |
| persistence.volumeMounts | object | `{"readeck":{"enabled":true,"mountPath":"/readeck","subPath":"readeck"}}` | Pod volumes to mount into the container's filesystem. Cannot be updated. They will only be rendered if persistence.enabled is true. |
| persistence.volumeMounts.readeck | object | `{"enabled":true,"mountPath":"/readeck","subPath":"readeck"}` | For now a single volumeMount Readeck is supported |
| persistence.volumeMounts.readeck.enabled | bool | `true` | Whether to mount the volume |
| persistence.volumeMounts.readeck.mountPath | string | `"/readeck"` | Path within the container at which the volume with the plugins should be mounted. Must not contain ':' |
| persistence.volumeMounts.readeck.subPath | string | `"readeck"` | Path within the volume from which the readeck dir should be mounted. |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: <https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/> |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: <https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/> |
| podSecurityContext | object | `{"fsGroup":1000,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod level [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod). |
| probes.liveness.failureThreshold | int | `3` |  |
| probes.liveness.httpGet.path | string | `"/api/info"` |  |
| probes.liveness.httpGet.port | string | `"http"` |  |
| probes.liveness.initialDelaySeconds | int | `5` |  |
| probes.liveness.periodSeconds | int | `10` |  |
| probes.liveness.timeoutSeconds | int | `2` |  |
| probes.readiness.failureThreshold | int | `3` |  |
| probes.readiness.httpGet.path | string | `"/api/info"` |  |
| probes.readiness.httpGet.port | string | `"http"` |  |
| probes.readiness.initialDelaySeconds | int | `2` |  |
| probes.readiness.periodSeconds | int | `5` |  |
| probes.readiness.timeoutSeconds | int | `1` |  |
| probes.startup | object | `{}` |  |
| replicaCount | int | `1` | This will set the replicaset count, more information can be found here: <https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/> NOTE: Readeck keeps downloads in the READECK_DATA_DIRECTORY value (see below), and at this time having more than a single replica does not make sense. NOTE2: We set the strategy to `type: Recreate` |
| resources | object | `{}` | We usually recommend not to specify default resources and to leave this as a conscious choice for the user. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":false}` | Readeck container level [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container). |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | This section builds out the service account more information can be found here: <https://kubernetes.io/docs/concepts/security/service-accounts/> |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| updateStrategy | object | `{"type":"Recreate"}` | [Update Strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) for Readeck. Since we have a persistentVolume with ReadWriteOnce (RWO) we need to make sure that we don't end up in deadlock. |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
