# Releasing semantic versions

[Semantic versioning](https://semver.org/) is a formal convention for determining the version number of 
new software releases. The standard helps software users to understand the severity of changes in each 
new distribution. A project that uses semantic versioning will advertise a Major, Minor, and Patch number
for each release.

Semaphore integrates with a widely used semantic versioning tool: [semantic-release](https://github.com/semantic-release/semantic-release). 
It automates the process and reduces the possibility of human errors. `sem-semantic-release` is a thin 
wrapper around semantic-release CLI that executes the release and exports release information. It makes 
a version number available for the rest of the delivery process.

## Setting up an automatic semantic release process

To set up an automated semantic release process, you will need:

- a configured release pipeline
- a secret with necessary credentials (e.g. GitHub personal access token)
- the latest version of Node.js (it is already installed on hosted machines)
- (optional) Configuration parameters for customizing the release process

### Step 1: Create a secret with the Git credentials

The secret will contain access credentials to your repository. Go to Organizations Setting > New Secret:

1. Set the name to `semantic-release-credentials`.
2. Add an environment variable according to the [documentation here](https://semantic-release.gitbook.io/semantic-release/usage/ci-configuration#push-access-to-the-remote-repository). As an example, for GitHub set the following:

    - name: `GITHUB_TOKEN` or `GH_TOKEN`,
    - value: [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with repository (`repo`) permissions.

3. Save the new secret.

The release pipeline will use this secret to connect to GitHub and generate the new release.

### Step 2: Create a release pipeline

In the main Semaphore pipeline `.semaphore/semaphore.yml` define a promotion that
will trigger the automated release process:

``` yaml
name: Build & Test

blocks:
  - name: Test
    jobs:
      - name: Tests
        commands:
          - checkout
          - make test

promotions:
  - name: Automatic SemVer Release
    pipeline: release.yaml
    auto_promote:
      when: "branch = 'master' or branch =~ 'release/.*'"
```

Define the release pipeline in your Git repository `.semaphore/release.yml` with the
following content:

``` yaml
name: Release

blocks:
  - name: Release
    secrets:
      - name: semantic-release-credentials
    jobs:
      - name: Release
        commands:
          - checkout
          - sem-semantic-release
```

### Step 3: Configure the release process (optional)

Create a configuration file in the root of your repository `.releaserc` to customize the release process.
The configuration options and their default values are described in 
[the documentation of the semantic release CLI](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/configuration.md#options). `sem-semantic-release` uses the latest version of `semantic-release` with pre-installed plugins
[available in npm](https://www.npmjs.com/package/semantic-release) and its default values.

### Step 4: Create a release

Switch to the default branch in your repository, and push a new fix:

``` bash
git switch main
# ... make some changes to your code
git commit -m "fix(pencil): stop graphite breaking when too much pressure applied"
git push
```

The above command will trigger a new pipeline on Semaphore and generate a new patch release.

## Using the release information in the continuation of your delivery process

`sem-semantic-release` wraps the semantic release CLI and exports the release information to the rest 
of your delivery process. It is handy when you want to continue the delivery process once the release 
has been created. A common example would be to build a Docker image tagged with the release version, 
or add an annotation to a Kubernetes deployment manifest.

All information is provided as string values.

### Exported release information

| **Key**                 | **Description**                                             |
| :---                    | :---                                                        |
| `ReleasePublished` 	    | Whether a new release was published (`"true"` or `"false"`) |
| `ReleaseVersion`        | Version of the new release. (e.g. `"1.3.0"`)                |
| `ReleaseMajorVersion`   | Major version of the new release. (e.g. `"1"`)              |
| `ReleaseMinorVersion`   | Minor version of the new release. (e.g. `"3"`)              |
| `ReleasePatchVersion`   | Patch version of the new release. (e.g. `"0"`)              |

### Example 1: Tagging a Docker image with the ReleaseVersion

``` yaml
name: Release

blocks:
  - name: Make New Release
    secrets:
      - name: semantic-release-credentials
    jobs:
      - name: Release
        commands:
          - sem-semantic-release

  - name: Release Docker Image
    secrets:
      - name: gcr-credentials
    dependencies:
      - Make New Release
    jobs:
      - name: Build & push docker image
        commands:
          - docker build . -t my-app:$(sem-context get ReleaseVersion)
          - docker push
```

### Example 2: Tagging a Docker image and releasing a new Kubernetes version

``` yaml
name: Release

blocks:
  - name: Make New Release
    secrets:
      - name: semantic-release-credentials
    jobs:
      - name: Release
        commands:
          - sem-semantic-release

  - name: Release Docker Image
    secrets:
      - name: gcr-credentials
    dependencies:
      - Make New Release
    jobs:
      - name: Build & push docker image
        commands:
          - docker build . -t my-app:$(sem-context get ReleaseVersion)
          - docker push

  - name: Update Kubernetes deployment
    secrets:
      - name: gke-credentials
    dependencies:
      - Release Docker Image
    jobs:
      - name: kube apply
        commands:
          - sed -i "s/IMAGE/$(sem-context get ReleaseVersion)" deployment.yml
          - kubectl apply -f deployment.yml
```
