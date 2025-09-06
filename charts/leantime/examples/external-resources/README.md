# Examples

## External S3 (MinIO with SSL) with MariaDB (with mariadb-operator) and Redis (using Dragonfly)

Example to setup Leantime with an external MariaDB, a Redis (Dragonfly) cache, and an S3-like persistence for a more production-like deployment.

For details:

- check the [values.yaml](values.yaml) for overrides as well as additional resources (like the MariaDB User, Database and Grant).

## To apply this example

### Requirements

1. Make sure to have the mariadb-operator installed and a MariaDB resource defined and running.
    NOTE: If using TLS, you need to have either a certificate of an already trusted entity, or the CA public certificate to mount on Leantime to trust the connection (as per the example)
2. Have a Redis (Valkey, Dragonfly) server
3. Use MinIO or any other S3 compatible object storage, either locally or remotely.

### Create Leantime

Example command using helm template instead of helm install (e.g. better compatibility with ArgoCD or simply a good way to ensure namespaces for resources defined in extra-resources if not explicitly defined):

```sh
helm template leantime oci://ghcr.io/ocraviotto/charts/leantime --namespace leantime --values /path/to/values.yaml --skip-tests | kubectl --namespace leantime diff -f -
```

And if satisfied

```sh
helm template leantime oci://ghcr.io/ocraviotto/charts/leantime --namespace leantime --values /path/to/values.yaml --skip-tests | kubectl --namespace leantime apply -f -
```

### Proceed with initial installation

Or troubleshooting!

NOTE: In working on this chart and installing Leantime, I came across a bug on the installation code that instantiates its own PDO client with different parameters than those defined in the main configuration block. I will update this readme with the link to the issue once created.
