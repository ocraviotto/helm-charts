# Helm Charts Repository

This repository contains a collection of public Helm charts I use in my clusters.

## Repository Structure

All Helm charts are located in the `charts/` directory. Each chart resides in its own subdirectory.

```sh
.
├── charts/
│   └── example-chart/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── templates/
│       └── ...
├── ...
└── README.md
```

## Charts

<!-- CHARTS_TABLE_START -->
| Chart | Description | Version | Packages |
|-------|-------------|---------|----------|
| [ente](charts/ente/README.md) | A Helm chart for Ente, a simple, encrypted, and self-hostable photo and video storage solution. | 0.1.12 | [ghcr.io](https://github.com/users/ocraviotto/packages/container/package/charts%2Fente) |
| [leantime](charts/leantime/README.md) | A Helm chart for Kubernetes to deploy Leantime | 0.1.2 | [ghcr.io](https://github.com/users/ocraviotto/packages/container/package/charts%2Fleantime) |
| [readeck](charts/readeck/README.md) | A Helm chart for readeck, a simple web application that lets you save the precious readable content of web pages you like and want to keep forever. | 0.1.0 | [ghcr.io](https://github.com/users/ocraviotto/packages/container/package/charts%2Freadeck) |
| [shiori](charts/shiori/README.md) | A Helm chart for shiori, a simple bookmark manager built with Go. | 0.1.2 | [ghcr.io](https://github.com/users/ocraviotto/packages/container/package/charts%2Fshiori) |
<!-- CHARTS_TABLE_END -->

## Adding a New Chart

NOTE: If not sure how to contribute to a public repository, you can follow the [Contributing to a project](https://docs.github.com/en/get-started/exploring-projects-on-github/contributing-to-a-project) guide.

To add a new chart to this repository, once you have a fork of this repository, follow these steps:

1. **Create a new directory** for your chart under the `charts/` directory.

    ```sh
    mkdir charts/<your-chart-name>
    ```

2. **Create your chart files** inside the new directory. You can use `helm create` or create them manually.

3. **Update Documentation**: Ensure your chart's `README.md` is kept up-to-date. The CI process uses `helm-docs` to automatically check if the documentation matches the `values.yaml` file. To generate or update the documentation locally, run:

    ```sh
    helm-docs --chart-search-root=./charts
    ```

4. **Submit a Pull Request**: Push your changes to your new branch and open a pull request against this repository's `main`.

## CI/CD Process

This repository uses GitHub Actions to automate linting, testing, and releasing charts.
See [.github/workflows](.github/workflows) for details.

### Pull Request Workflow (`lint-test.yaml`)

On every pull request to the `main` branch, the following checks are performed:

- **Linting**: `chart-testing` is used to lint any changed charts to ensure they are well-formed and follow best practices.
- **Documentation Check**: `helm-docs` verifies that the `README.md` for each chart is consistent with its `values.yaml`. If the documentation is out of sync, the check will fail.

All checks must pass before a pull request can be merged.

### Release Workflow (`release.yaml`)

Releases are automated and triggered by pushing to main (protected branch).

To release a new version of a chart, you need to create Pull Request against main:

1. **Branch out from main**: Make sure to create fetch latest main and create a new branch to identify your chart bump.

2. **Update `Chart.yaml`**: Increment the `version` and/or `appVersion` in the `charts/<your-chart-name>/Chart.yaml` file using [Semantic Versioning](https://semver.org/).

3. **Commit Changes**: Commit the updated `Chart.yaml` file (and any other modified one of course).

4. **Make sure that checks pass**: See details on failed actions if necessary, and only expect a review and approval/merge once all checks pass.

    See [Pull Request Workflows](#pull-request-workflow-lint-testyaml) for additional details.
    Merging to main will eventually release (create a [GitHub Release](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)) and upload the chart as an OCI artifact to [this repository's GitHub Container Registry (GHCR)](https://github.com/ocraviotto?tab=packages&repo_name=helm-charts).
