# Examples

## External S3 (MinIO with SSL) and PostgreSQL (with PGO)

Example to setup Ente with replication and external components for a more production-like deployment.

For details:

- check the [values.yaml](values.yaml) for overrides
- the [example credentials](museum-credentials.yaml) used to create the museum credentials secret for an example working config (basically what I use with my own)
- and a [PGO based secret](postgres-pguser-ente.yaml) sourced from another namespace with PostgreSQL credentials to use with the example.
