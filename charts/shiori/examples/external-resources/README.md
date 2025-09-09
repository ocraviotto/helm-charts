# Examples

## External MariaDB (with mariadb-operator)

Example to setup Shiori with an external MariaDB and a proper storageClass for a more production-like deployment in a GitOps context.

For details:

- check the [values.yaml](values.yaml) for overrides as well as additional resources (like the MariaDB User, Database and Grant).

## To apply this example

### Requirements

1. Make sure to have the mariadb-operator installed and a MariaDB resource defined and running.
    NOTE: If using TLS, you need to have either a certificate of an already trusted entity, the CA public certificate to mount on Shiori to trust the connection (as per the example), or not pass verify to PDO.
2. Have the ExternalSecrets operator with HashiCorp Vault as its ClusterSecretStore backend (or modify that to suite your configuration).

### Create Shiori

Example command using helm template instead of helm install (e.g. better compatibility with ArgoCD or simply a good way to ensure namespaces for resources defined in extra-resources if not explicitly defined):

```sh
helm template shiori oci://ghcr.io/ocraviotto/charts/shiori --namespace shiori --values /path/to/values.yaml --skip-tests | kubectl --namespace shiori diff -f -
```

And if satisfied

```sh
helm template shiori oci://ghcr.io/ocraviotto/charts/shiori --namespace shiori --values /path/to/values.yaml --skip-tests | kubectl --namespace shiori apply -f -
```

### Proceed with initial installation

Or troubleshooting!
