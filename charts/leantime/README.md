# Leantime Helm Chart

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.5.12](https://img.shields.io/badge/AppVersion-3.5.12-informational?style=flat-square)

This is a Helm chart for [Leantime](https://leantime.io), a goals focused project management system for non-project managers.
Building with ADHD, Autism, and dyslexia in mind.

## Introduction

This chart bootstraps an Leantime deployment on a Kubernetes cluster using the Helm package manager. It defaults to deploying MariaDB as dependency.
Though the chart takes care of multiple aspects of Leantime's configuration, make sure to read the documentation, in particular in relation to the [configuration](https://docs.leantime.io/installation/configuration).

## Prerequisites

* Kubernetes 1.23+
* Helm 3.8.0+

### Additionally

If using the included MariaDB and/or enabling persistence with claim enabled:

* PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `leantime`:

```bash
helm install leantime oci://ghcr.io/ocraviotto/charts/leantime --version 0.1.2
```

## Uninstalling the Chart

To uninstall/delete the `leantime` release:

```bash
helm delete leantime
```

## Example

The [external-resources example](examples/external-resources) contains a modified values file to use with a more production-like environment.
Make sure to check it out if intending on a more serious use of Leantime.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity) |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | This section is for setting up autoscaling more information can be found here: <https://kubernetes.io/docs/concepts/workloads/autoscaling/> |
| env | object | `{}` | Container [EnvVar](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.33/#envvar-v1-core) object Use it to override single values. Takes precedence over envFrom* values. |
| envFromConfigMap | object | Enabled and populated with all of the values in data | This is the default configuration passed to Leantime via environment variables. In principle any sensitive value should be provided via `envFronSecret.data`, or via an externally managed secret mapped to the environment via `env[].valueFrom.secretKeyRef` NOTE: Any variable overlap from the envFromSecret.data section takes precedence over those defined here. |
| envFromConfigMap.cmAnnotations | object | `{}` | Additional annotations to add to the generated ConfigMap |
| envFromConfigMap.cmLabels | object | `{}` | Additional labels to add to the generated ConfigMap |
| envFromConfigMap.cmName | string | `"{{ include \"leantime.fullname\" . }}-env"` | Sets the configMap name |
| envFromConfigMap.data | object | `{"LEAN_ALLOW_TELEMETRY":"false","LEAN_APP_URL":"{{ include \"leantime.appUrl\" . }}","LEAN_DB_BACKUP_PATH":"backupdb/","LEAN_DB_DATABASE":"{{ include \"leantime.db.name\" . }}","LEAN_DB_HOST":"{{ include \"leantime.db.host\" . }}","LEAN_DB_PORT":"3306","LEAN_DEBUG":"0","LEAN_DEFAULT_THEME":"default","LEAN_DEFAULT_TIMEZONE":"America/Los_Angeles","LEAN_DISABLE_LOGIN_FORM":"false","LEAN_EMAIL_RETURN":"","LEAN_EMAIL_SMTP_AUTH":"true","LEAN_EMAIL_SMTP_AUTO_TLS":"true","LEAN_EMAIL_SMTP_HOSTS":"","LEAN_EMAIL_SMTP_PORT":"587","LEAN_EMAIL_SMTP_SECURE":"STARTTLS","LEAN_EMAIL_SMTP_SSLNOVERIFY":"false","LEAN_EMAIL_USE_SMTP":"false","LEAN_LANGUAGE":"en-US","LEAN_LDAP_DEFAULT_ROLE_KEY":"20;","LEAN_LDAP_DN":"","LEAN_LDAP_GROUP_ASSIGNMENT":"{\"5\":{\"ltRole\":\"readonly\",\"ldapRole\":\"readonly\"},\"10\":{\"ltRole\":\"commenter\",\"ldapRole\":\"commenter\"},\"20\":{\"ltRole\":\"editor\",\"ldapRole\":\"editor\"},\"30\":{\"ltRole\":\"manager\",\"ldapRole\":\"manager\"},\"40\":{\"ltRole\":\"admin\",\"ldapRole\":\"administrators\"},\"50\":{\"ltRole\":\"owner\",\"ldapRole\":\"administrators\"}}","LEAN_LDAP_HOST":"","LEAN_LDAP_KEYS":"{\"username\":\"uid\",\"groups\":\"memberOf\",\"email\":\"mail\",\"firstname\":\"displayname\",\"lastname\":\"\",\"phone\":\"telephoneNumber\",\"jobTitle\":\"title\"\"jobLevel\":\"level\"\"department\":\"department\"}","LEAN_LDAP_LDAP_DOMAIN":"","LEAN_LDAP_LDAP_TYPE":"OL","LEAN_LDAP_PORT":"389","LEAN_LDAP_URI":"","LEAN_LDAP_USE_LDAP":"false","LEAN_LOGO_PATH":"/dist/images/logo.svg","LEAN_LOG_PATH":"","LEAN_OIDC_CREATE_USER":"false","LEAN_OIDC_DEFAULT_ROLE":"20","LEAN_OIDC_ENABLE":"false","LEAN_OIDC_PROVIDER_URL":"https://token.actions.githubusercontent.com/","LEAN_PRIMARY_COLOR":"#006d9f","LEAN_PRINT_LOGO_URL":"/dist/images/logo.png","LEAN_RATELIMIT_API":"10","LEAN_RATELIMIT_AUTH":"20","LEAN_RATELIMIT_GENERAL":"1000","LEAN_REDIS_HOST":"","LEAN_REDIS_PORT":"6379","LEAN_REDIS_SCHEME":"","LEAN_REDIS_URL":"","LEAN_REDIS_USERNAME":"","LEAN_S3_BUCKET":"","LEAN_S3_FOLDER_NAME":"","LEAN_S3_REGION":"","LEAN_S3_USE_PATH_STYLE_ENDPOINT":"true","LEAN_SECONDARY_COLOR":"#00a886","LEAN_SESSION_EXPIRATION":"28800","LEAN_SESSION_SECURE":"false","LEAN_SITENAME":"Leantime","LEAN_USER_FILE_PATH":"userfiles/","LEAN_USE_REDIS":"false","LEAN_USE_S3":"false"}` | The default contents for configMap. Based on [Leantime's sample.env](https://github.com/Leantime/docker-leantime/blob/master/sample.env) Values support helm templating. NOTE: Make sure these are all strings! |
| envFromConfigMap.data.LEAN_ALLOW_TELEMETRY | string | `"false"` | Whether to allow telemetry. If `false`, this will disable the telemetry submission and remove your unique instance ID. |
| envFromConfigMap.data.LEAN_APP_URL | string | The value of ingress.hosts[0].host if ingress is enabled. | Base URL, needed for subfolder or proxy installs (including http:// or https://) You can either modify this string or override (preferred) with `envVarOverrides.appUrl` |
| envFromConfigMap.data.LEAN_DB_BACKUP_PATH | string | `"backupdb/"` | Local relative path to store backup files, need permission to write (used if not using S3) |
| envFromConfigMap.data.LEAN_DB_DATABASE | string | `"{{ include \"leantime.db.name\" . }}"` | Database name |
| envFromConfigMap.data.LEAN_DB_HOST | string | `"{{ include \"leantime.db.host\" . }}"` | Database host. If MariaDB is not enabled, make sure to set `envVarOverrides.dbHost` |
| envFromConfigMap.data.LEAN_DB_PORT | string | `"3306"` | Database port |
| envFromConfigMap.data.LEAN_DEBUG | string | `"0"` | Debug flag. |
| envFromConfigMap.data.LEAN_DEFAULT_THEME | string | `"default"` | Default theme |
| envFromConfigMap.data.LEAN_DEFAULT_TIMEZONE | string | `"America/Los_Angeles"` | Set default timezone |
| envFromConfigMap.data.LEAN_DISABLE_LOGIN_FORM | string | `"false"` | If true then don't show the login form (useful only if additional auth method[s] are available) |
| envFromConfigMap.data.LEAN_EMAIL_RETURN | string | `""` | Return email address, needs to be valid email address format |
| envFromConfigMap.data.LEAN_EMAIL_SMTP_AUTH | string | `"true"` | SMTP authentication required |
| envFromConfigMap.data.LEAN_EMAIL_SMTP_AUTO_TLS | string | `"true"` | SMTP Enable TLS encryption automatically if a server supports it |
| envFromConfigMap.data.LEAN_EMAIL_SMTP_HOSTS | string | `""` | SMTP host. e.g. `smtp.gmail.com` |
| envFromConfigMap.data.LEAN_EMAIL_SMTP_PORT | string | `"587"` | Port (usually one of 25, 465, 587, 2526) |
| envFromConfigMap.data.LEAN_EMAIL_SMTP_SECURE | string | `"STARTTLS"` | SMTP Security protocol (usually one of: TLS, SSL, STARTTLS) |
| envFromConfigMap.data.LEAN_EMAIL_SMTP_SSLNOVERIFY | string | `"false"` | SMTP Allow insecure SSL: Don't verify certificate, accept self-signed, etc. |
| envFromConfigMap.data.LEAN_EMAIL_USE_SMTP | string | `"false"` | Use SMTP? If set to false, the default php mail() function will be used NOTE: If true, make sure to set `LEAN_EMAIL_SMTP_USERNAME` and `LEAN_EMAIL_SMTP_PASSWORD` in the env or `envFromSecret.data` |
| envFromConfigMap.data.LEAN_LANGUAGE | string | `"en-US"` | Default language |
| envFromConfigMap.data.LEAN_LDAP_DEFAULT_ROLE_KEY | string | `"20;"` | Default Leantime Role on creation. (set to editor) |
| envFromConfigMap.data.LEAN_LDAP_GROUP_ASSIGNMENT | string | `"{\"5\":{\"ltRole\":\"readonly\",\"ldapRole\":\"readonly\"},\"10\":{\"ltRole\":\"commenter\",\"ldapRole\":\"commenter\"},\"20\":{\"ltRole\":\"editor\",\"ldapRole\":\"editor\"},\"30\":{\"ltRole\":\"manager\",\"ldapRole\":\"manager\"},\"40\":{\"ltRole\":\"admin\",\"ldapRole\":\"administrators\"},\"50\":{\"ltRole\":\"owner\",\"ldapRole\":\"administrators\"}}"` | Default role assignments upon first login. optional - Can be updated later in user settings for each user |
| envFromConfigMap.data.LEAN_LDAP_HOST | string | `""` | FQDN |
| envFromConfigMap.data.LEAN_LDAP_KEYS | string | `"{\"username\":\"uid\",\"groups\":\"memberOf\",\"email\":\"mail\",\"firstname\":\"displayname\",\"lastname\":\"\",\"phone\":\"telephoneNumber\",\"jobTitle\":\"title\"\"jobLevel\":\"level\"\"department\":\"department\"}"` | Leantime->Ldap attribute mapping For AD use these default attributes `{\"username\":\"cn\",\"groups\":\"memberOf\",\"email\":\"mail\",\"firstname\":\"givenName\",\"lastname\":\"sn\",\"phone\":\"telephoneNumber\",\"jobTitle\":\"title\"\"jobLevel\":\"level\"\"department\":\"department\"}` |
| envFromConfigMap.data.LEAN_LDAP_LDAP_DOMAIN | string | `""` | Domain name after username@ so users can login without domain definition |
| envFromConfigMap.data.LEAN_LDAP_LDAP_TYPE | string | `"OL"` | Select the correct directory type. Currently Supported: OL - OpenLdap, AD - Active Directory |
| envFromConfigMap.data.LEAN_LDAP_PORT | string | `"389"` | Default Port |
| envFromConfigMap.data.LEAN_LDAP_URI | string | `""` | LDAP URI as alternative to hostname and port. Uses ldap://hostname:port |
| envFromConfigMap.data.LEAN_LDAP_USE_LDAP | string | `"false"` | Set to true if you want to use LDAP |
| envFromConfigMap.data.LEAN_LOGO_PATH | string | `"/dist/images/logo.svg"` | Default logo path, can be changed later |
| envFromConfigMap.data.LEAN_LOG_PATH | string | `""` | Default Log Path (including filename), if not set /logs/error.log will be used |
| envFromConfigMap.data.LEAN_OIDC_CREATE_USER | string | `"false"` | If true, it creates the User in Leantime db if it doesn't exist, otherwise (if false) fails login |
| envFromConfigMap.data.LEAN_OIDC_ENABLE | string | `"false"` | Use to enable or disable OpenID Connect. NOTE: If true, make sure to set `LEAN_OIDC_CLIENT_ID` and `LEAN_OIDC_CLIENT_SECRET` in the env or `envFromSecret.data` |
| envFromConfigMap.data.LEAN_OIDC_PROVIDER_URL | string | `"https://token.actions.githubusercontent.com/"` | required - the URL for your provider (examples value for GitHub) Change if using another provider! |
| envFromConfigMap.data.LEAN_PRIMARY_COLOR | string | `"#006d9f"` | Primary Theme color |
| envFromConfigMap.data.LEAN_PRINT_LOGO_URL | string | `"/dist/images/logo.png"` | Default logo URL use for printing (must be JPG or PNG format) |
| envFromConfigMap.data.LEAN_RATELIMIT_API | string | `"10"` | API rate limiting per minute, calculated per a combo of IP and session or anonymous user |
| envFromConfigMap.data.LEAN_RATELIMIT_AUTH | string | `"20"` | Login rate limiting per minute, calculated per a combo of IP and session or anonymous user |
| envFromConfigMap.data.LEAN_RATELIMIT_GENERAL | string | `"1000"` | General rate limiting per minute for all requests, calculated per a combo of IP and session or anonymous user |
| envFromConfigMap.data.LEAN_REDIS_HOST | string | `""` | The Redis host |
| envFromConfigMap.data.LEAN_REDIS_PORT | string | `"6379"` | The Redis port |
| envFromConfigMap.data.LEAN_REDIS_SCHEME | string | `""` | The Redis scheme for phpredis. Can be `tcp` or `tls`. |
| envFromConfigMap.data.LEAN_REDIS_URL | string | `""` | Redis full URL. e.g. `tcp://1.2.3.4:6379`. If you are using a password, please either use the env with valueFrom, or place this in the `envFromSecret.data` section. |
| envFromConfigMap.data.LEAN_REDIS_USERNAME | string | `""` | The Redis username |
| envFromConfigMap.data.LEAN_S3_BUCKET | string | `""` | Your S3 bucket |
| envFromConfigMap.data.LEAN_S3_FOLDER_NAME | string | `""` | Foldername within S3 (can be empty) |
| envFromConfigMap.data.LEAN_S3_REGION | string | `""` | S3 region |
| envFromConfigMap.data.LEAN_S3_USE_PATH_STYLE_ENDPOINT | string | `"true"` | Sets the endpoint style: false => https://[bucket].[endpoint]; true => https://[endpoint]/[bucket] |
| envFromConfigMap.data.LEAN_SECONDARY_COLOR | string | `"#00a886"` | Secondary Theme Color |
| envFromConfigMap.data.LEAN_SESSION_EXPIRATION | string | `"28800"` | How many seconds after inactivity should we logout?  28800seconds = 8hours |
| envFromConfigMap.data.LEAN_SESSION_SECURE | string | `"false"` | Serve cookies via https only? Set to true when using https, set to false when using http. NOTE: If you're terminating TLS at the ingress, leave `false`! |
| envFromConfigMap.data.LEAN_SITENAME | string | `"Leantime"` | Name of your site, can be changed later |
| envFromConfigMap.data.LEAN_USER_FILE_PATH | string | `"userfiles/"` | Local relative path to store uploaded files (if not using S3) |
| envFromConfigMap.data.LEAN_USE_REDIS | string | `"false"` | Set to true to use redis as for session storage and cache If enabled, and if not using a password, either set `LEAN_REDIS_URL` below or the other values. If using a password, please set the env `LEAN_REDIS_URL` or use the `envVarFromSecret.data` |
| envFromConfigMap.data.LEAN_USE_S3 | string | `"false"` | S3 File Uploads. If enabled, use s3 instead of local files. NOTE: If true, make sure to set `LEAN_S3_KEY` and `LEAN_S3_SECRET` in the env or `envFromSecret.data` |
| envFromConfigMap.enabled | bool | `true` | Defines if we include this in leantime |
| envFromConfigMap.existingConfigMap | string | `""` | The name of an existing ConfigMap to use with `configMapRef.name`. If this is not empty, we will NOT create the resource with the values defined in data. |
| envFromSecret | object | Enabled and populated with all of the values in data | This is the default configuration passed to Leantime via environment variables. Variables here take precedence over envFromConfigMap. |
| envFromSecret.data | object | `{"LEAN_DB_PASSWORD":"{{ include \"leantime.db.password\" . }}","LEAN_DB_USER":"{{ include \"leantime.db.user\" . }}","LEAN_EMAIL_SMTP_PASSWORD":"","LEAN_EMAIL_SMTP_USERNAME":"","LEAN_OIDC_CLIENT_ID":"","LEAN_OIDC_CLIENT_SECRET":"","LEAN_REDIS_PASSWORD":"","LEAN_REDIS_URL":"","LEAN_S3_KEY":"","LEAN_S3_SECRET":"","LEAN_SESSION_PASSWORD":"{{ randAlphaNum 32 }}"}` | The default contents for Secret. Based on [Leantime's sample.env](https://github.com/Leantime/docker-leantime/blob/master/sample.env) and used for sensitive details. Values here are all empty string and should be used only if overriding auto-generation. |
| envFromSecret.data.LEAN_DB_PASSWORD | string | `"{{ include \"leantime.db.password\" . }}"` | Database password. If you are not using mariadb and prefer to set this value with `valueFrom.secretKeyRef`, you can leave this value empty or comment the variable out. There is no need to use the `envVarOverride.dbPassword` in that case. |
| envFromSecret.data.LEAN_DB_USER | string | `"{{ include \"leantime.db.user\" . }}"` | Database username. If you are not using mariadb and prefer to set this value with `valueFrom.secretKeyRef`, you can leave this value empty or comment the variable out. There is no need to use the `envVarOverride.dbUser` in that case. |
| envFromSecret.data.LEAN_EMAIL_SMTP_PASSWORD | string | `""` | SMTP password. If LEAN_EMAIL_USE_SMTP is `true`, either set this here or better still use the .env object and a separate secret. |
| envFromSecret.data.LEAN_EMAIL_SMTP_USERNAME | string | `""` | SMTP username. If LEAN_EMAIL_USE_SMTP is `true`, either set this here or better still use the .env object and a separate secret. |
| envFromSecret.data.LEAN_OIDC_CLIENT_ID | string | `""` | The OIDC client_id. Required if LEAN_OIDC_ENABLE is `true`. Client ID identifies the client in OAuth exchanges (including the authorization request). If OpenID COnnect is enabled, either set here or better still, use the .env object and a separate secret |
| envFromSecret.data.LEAN_OIDC_CLIENT_SECRET | string | `""` | The OIDC ClientID. See <https://www.oauth.com/oauth2-servers/client-registration/client-id-secret/> Required if LEAN_OIDC_ENABLE is `true`. Client Secret validates the client in secret-authenticated flows, such as exchanging the authorization code for an ID Token and access token. If OpenID COnnect is enabled, either set here or better still, use the .env object and a separate secret |
| envFromSecret.data.LEAN_REDIS_PASSWORD | string | `""` | The Redis password Required if not using setting Redis URL (and of course, if used with your Redis host) If Redis is enabled, either set here or better still, use the .env object and a separate secret |
| envFromSecret.data.LEAN_REDIS_URL | string | `""` | Redis full URL. e.g. `tcp://1.2.3.4:6379`. If you are using a password, add `?auth=your-password` to your URL If Redis is enabled, either set here or better still, use the .env object and a separate secret |
| envFromSecret.data.LEAN_S3_KEY | string | `""` | The S3 key. If S3 is enabled, either set here or better still, use the .env object and a separate secret. |
| envFromSecret.data.LEAN_S3_SECRET | string | `""` | S3 Secret. If S3 is enabled, either set here or better still, use the .env object and a separate secret |
| envFromSecret.data.LEAN_SESSION_PASSWORD | string | `"{{ randAlphaNum 32 }}"` | Session Management. Salting sessions. |
| envFromSecret.enabled | bool | `true` | Defines if we include a secret as envFrom in the leantime container. |
| envFromSecret.existingSecret | string | `""` | The name of an existing Secret to use with `secretRef.name`. If this is not empty, we will NOT create the resource with the values defined in data. So if you have your own secret, set it here and make sure it has all required variables set. NOTE: Required variables are basically every one listed in the data section. |
| envFromSecret.regenerate | bool | `false` | Force regeneration of dynamically set values in the secret |
| envFromSecret.secretAnnotations | object | `{}` | Additional annotations to add to the generated secret |
| envFromSecret.secretLabels | object | `{}` | Additional labels to add to the generated secret |
| envFromSecret.secretName | string | `"{{ include \"leantime.fullname\" . }}-env"` | If existingSecret is empty, we'll create a secret whose name is defined with this entry. Supports templating. |
| envVarOverrides | object | `{"appUrl":"","dbHost":"","dbName":"","dbPassword":"","dbUsername":""}` | This dictionary holds particular env var overrides used with variables set with envFrom*. These might be required depending on other values or places where they're set but they will be overridden in the actual environment by any defined variable in `env` |
| envVarOverrides.appUrl | string | `""` | Sets the value of LEAN_APP_URL, needed for subfolder or proxy installs (including http:// or https://) Required if ingress is not enabled. |
| envVarOverrides.dbHost | string | `""` | Sets the value of LEAN_DB_HOST, needed for subfolder or proxy installs (including http:// or https://) Required if ingress is not enabled and you are still using a proxy (e.g. svc of type LoadBalancer) |
| envVarOverrides.dbName | string | `""` | Sets the value of LEAN_DB_DATABASE. If this is empty and mariadb is enabled we'll use the db name defined there, else "leantime" |
| envVarOverrides.dbPassword | string | `""` | The password for the user to access the leantime database. This sets the value of LEAN_DB_PASSWORD. If this is empty and mariadb is enabled we'll use the password defined there, else "leantime" |
| envVarOverrides.dbUsername | string | `""` | The name of the user for the database to set LEAN_DB_USER. If this is empty and mariadb is enabled we'll use the username defined there, else "leantime" |
| extraEnvFrom | object | `{}` |  |
| extraResources | list | `[]` | A list of extra Kubernetes resources to be deployed with the chart. This can be used to deploy resources like ExternalSecrets or other custom resources. |
| fullnameOverride | string | `""` | This is to override the Helm Release name + the chart name. |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"leantime/leantime","tag":""}` | This sets the container image more information can be found here: <https://kubernetes.io/docs/concepts/containers/images/> |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.registry | string | `"docker.io"` | Set to allow to easily change registry and in our case, mainly to support renovate regular expressions (not required for the Docker hub). |
| image.repository | string | `"leantime/leantime"` | We use the upstream leantime by default. Images are built from this repository: <https://github.com/Leantime/docker-leantime> NOTE: This might change as work started to move the configuration to the main repository. |
| image.tag | string |  value of chart appVersion | Used to override the image tag. |
| imagePullSecrets | list | `[]` | This is for the secrets for pulling an image from a private repository more information can be found here: <https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/> |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| mariadb | object | `{"Secondary":{},"auth":{"database":"leantime","existingSecret":"","password":"changeme!","username":"leantime"},"enabled":true,"image":{"repository":"bitnamilegacy/mariadb"},"primary":{}}` | Values to pass to the mariadb sub-chart. See <https://github.com/bitnami/charts/tree/main/bitnami/mariadb> NOTE: Because of <https://github.com/bitnami/charts/issues/35164> there will be more changes to this section and you should use something different for production (e.g. mariadb-operator). Included here for convenience but not recommended for production (see examples for a production configuration) |
| mariadb.Secondary | object | `{}` | Secondary values if different from defaults NOTE: persistence is enabled by default so with a request of 8Gi |
| mariadb.auth | object | `{"database":"leantime","existingSecret":"","password":"changeme!","username":"leantime"}` | auth contains details the user, database and credentials used by leantime If modifying this section, make sure to sync leantime database credentials to match |
| mariadb.auth.database | string | `"leantime"` | Name for the Leantime database to create |
| mariadb.auth.existingSecret | string | `""` | Only set the existing secret if you have provided your own with the required fields: `mariadb-root-password`, `mariadb-replication-password` and `mariadb-password` and passed the `LEAN_DB_PASSWORD` var to Leantime via env or envFromSecret as well. |
| mariadb.auth.password | string | `"changeme!"` | Password for the Leantime user |
| mariadb.auth.username | string | `"leantime"` | Name for the Leantime user to create |
| mariadb.enabled | bool | `true` | In "production-like" environments you should modify the values below or better still, run one an external DB or use the MariaDB operator. |
| mariadb.image.repository | string | `"bitnamilegacy/mariadb"` | Required because of <https://github.com/bitnami/charts/issues/35164> |
| mariadb.primary | object | `{}` | Primary values if different from defaults. NOTE: persistence is enabled by default so with a request of 8Gi |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` | Pod [nodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| persistence | object | `{"claim":{"accessMode":"ReadWriteOnce","annotations":{},"enabled":true,"size":"5Gi","storageClass":""},"enabled":false,"existingClaim":"","volumeMounts":{"plugins":{"enabled":false,"mountPath":"/var/www/html/app/Plugins","subPath":"plugins"},"publicUserFiles":{"enabled":true,"mountPath":"/var/www/public/userfiles","subPath":"public-userfiles"},"userFiles":{"enabled":true,"mountPath":"/var/www/html/userfiles","subPath":"userfiles"}}}` | A single volume will be used with both 'userfiles' for /var/www/userfiles, and 'public-userfiles' for /var/www/public/userfiles |
| persistence.claim | object | `{"accessMode":"ReadWriteOnce","annotations":{},"enabled":true,"size":"5Gi","storageClass":""}` | If existingClaim is empty and persistence is enabled, when `claim.enabled`is `true` we'll create a pvc based on these details |
| persistence.claim.accessMode | string | `"ReadWriteOnce"` | See [accessMode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) |
| persistence.claim.enabled | bool | `true` | If false, we'll use an emptyDir, which is an ephemeral volume and a very bad idea for production, but might be useful for testing |
| persistence.claim.size | string | `"5Gi"` | Requested size |
| persistence.enabled | bool | `false` | Enable persistent storage for user files. Unless claim is enabled or we have an existing claim, we'll use an emptyDir, which is kind of persistence. NOTE: If you're using S3, no need to use persistence. |
| persistence.existingClaim | string | `""` | If not empty, it will use this existing Persistent Volume Claim |
| persistence.volumeMounts | object | `{"plugins":{"enabled":false,"mountPath":"/var/www/html/app/Plugins","subPath":"plugins"},"publicUserFiles":{"enabled":true,"mountPath":"/var/www/public/userfiles","subPath":"public-userfiles"},"userFiles":{"enabled":true,"mountPath":"/var/www/html/userfiles","subPath":"userfiles"}}` | Pod volumes to mount into the container's filesystem. Cannot be updated. They will only be rendered if persistence.enabled is true and the volumeMount is also enabled. |
| persistence.volumeMounts.plugins | object | `{"enabled":false,"mountPath":"/var/www/html/app/Plugins","subPath":"plugins"}` | This is meant to persist plugin installations. Unfortunately enabling it limits the scalability of Leantime as we then need to rely on a single persistence volume or deal with a ReadWriteMany setup and deal with performance issues. The alternative is to bake plugins on top of the Leantime image, but that requires automation and work around building and privately hosting the image. |
| persistence.volumeMounts.plugins.enabled | bool | `false` | Whether to enable the plugins volumeMount |
| persistence.volumeMounts.plugins.mountPath | string | `"/var/www/html/app/Plugins"` | Path within the container at which the volume with the plugins should be mounted. Must not contain ':' |
| persistence.volumeMounts.plugins.subPath | string | `"plugins"` | Path within the volume from which plugins should be mounted. |
| persistence.volumeMounts.publicUserFiles | object | `{"enabled":true,"mountPath":"/var/www/public/userfiles","subPath":"public-userfiles"}` | The original mount name for User uploaded files, here for compatibility, |
| persistence.volumeMounts.publicUserFiles.enabled | bool | `true` | Whether to enable the public userfiles volumeMount |
| persistence.volumeMounts.publicUserFiles.mountPath | string | `"/var/www/public/userfiles"` | Path within the container at which the volume with the public userfiles should be mounted. Must not contain ':' |
| persistence.volumeMounts.publicUserFiles.subPath | string | `"public-userfiles"` | Path within the volume from which public userfiles should be mounted. |
| persistence.volumeMounts.userFiles | object | `{"enabled":true,"mountPath":"/var/www/html/userfiles","subPath":"userfiles"}` | The mount to store public files, logo etc. If S3 is enabled, this is NOT used. |
| persistence.volumeMounts.userFiles.enabled | bool | `true` | Whether to enable the userfiles volumeMount |
| persistence.volumeMounts.userFiles.mountPath | string | `"/var/www/html/userfiles"` | Path within the container at which the volume with the userfiles should be mounted. Must not contain ':' |
| persistence.volumeMounts.userFiles.subPath | string | `"userfiles"` | Path within the volume from which userfiles should be mounted. |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: <https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/> |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: <https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/> |
| podSecurityContext | object | `{"fsGroup":1000,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod level [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod). |
| replicaCount | int | `1` | This will set the replicaset count more information can be found here: <https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/> |
| resources | object | `{}` | We usually recommend not to specify default resources and to leave this as a conscious choice for the user. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":false}` | Leantime container level [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container). |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | This section builds out the service account more information can be found here: <https://kubernetes.io/docs/concepts/security/service-accounts/> |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| testing | object | `{"enabled":false}` | Should be set to true ONLY for CI/CD chart testing. When enabled, the probe path check is /healthCheck.php, which will always return 200 if the server is up regardless of internal errors. In production we'd like to ensure probes fail on e.g. a database error. |
| tolerations | list | `[]` | Pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
