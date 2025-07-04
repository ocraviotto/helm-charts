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

Releases are automated and triggered by pushing a Git tag that matches the chart's version.

To release a new version of a chart:

1. **Update `Chart.yaml`**: Increment the `version` and/or `appVersion` in the `charts/<your-chart-name>/Chart.yaml` file.

2. **Commit Changes**: Commit the updated `Chart.yaml` file.

3. **Tag the Release**: Create and push a Git tag that matches the chart name and the new version. The tag format is `<chart-name>-v<version>`.

    For example, to release version `0.2.0` of `example-chart`:

    ```sh
    git tag example-chart-v0.2.0
    git push origin example-chart-v0.2.0
    ```

Pushing a tag will trigger the release workflow, which packages the chart and publishes it as an OCI artifact to the GitHub Container Registry (GHCR).
