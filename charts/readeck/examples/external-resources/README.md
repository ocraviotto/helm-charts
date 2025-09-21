# Examples

## External PostgreSQL (with postgres-operator)

Example to setup Readeck with an external PostgreSQL and a proper storageClass for a more production-like deployment in a GitOps context.

For details:

- check the [values.yaml](values.yaml) for overrides as well as additional resources (like the PushSecrets and other ExternalSecrets resources).

## To apply this example

### Requirements

1. Make sure to have a PostgreSQL cluster installed with the CrunchyData postgres-operator and the db and user readeck crated. NOTE: You can probably make this example work with the CloudNativePG too but I have not tested it with it.
2. Have the ExternalSecrets operator with HashiCorp Vault as its ClusterSecretStore backend (or modify that to suite your configuration).

### Create Readeck

Example command using helm template instead of helm install (e.g. better compatibility with ArgoCD or simply a good way to ensure namespaces for resources defined in extra-resources if not explicitly defined):

```sh
helm template readeck oci://ghcr.io/ocraviotto/charts/readeck --namespace readeck --values /path/to/values.yaml --skip-tests | kubectl --namespace readeck diff -f -
```

And if satisfied

```sh
helm template readeck oci://ghcr.io/ocraviotto/charts/readeck --namespace readeck --values /path/to/values.yaml --skip-tests | kubectl --namespace readeck apply -f -
```

### Proceed with initial installation

Or troubleshooting!
