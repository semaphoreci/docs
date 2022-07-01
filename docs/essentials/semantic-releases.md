# Releasing Semantic Versions

[Semantic versioning](https://semver.org/) is a formal convention for determining the version number of 
new software releases. The standard helps software users to understand the severity of changes in each 
new distribution. A project that uses semantic versioning will advertise a Major, Minor and Patch number
for each release.

Semaphore integrates with a widely used semantic versioning tool [semantic-release](https://github.com/semantic-release/semantic-release) 
that automatizes the process and reduces the possibility of human errors. The [sem-semantic-release][sem-semantic-release]
is a thin wrapper around the CLI that executes the release and exports release information making it
readily available for the rest of the delivery process.

## Setting up an automatic semantic release deployment process

To set up an automated semantic release process, you will need:

- A secret that grants access permissions to the Git repository where you want to push the release
- A release pipeline
- (optional) Configuration parameters for customizing the release process

### Step 1: Create a secret with the Git credentials

Create a new secret in your organization that contains the access credentials.
Go to Organizations Setting > New Secret:

1. Set the name to semantic-release-credentials
2. Add an environment variable (TODO)
3. Save the new secret

The release pipeline will use this secret to connect to your Git repository and 
generate the new release.

### Step 2: Create a release pipeline

In the main Semaphore pipeline `.semaphore/semaphore.yml` define a promotion that
will trigger the automated release process:

``` yaml
name: BUild & Test

blocks:
  - name: Test
    jobs:
      - name: Tests
        commands:
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
          - sem-semantic-release
```

### Step 3: Configure the release process (optional)

Create a configuration file in the root of your repository `.releaserc` to
customize the relase process. The configuration options are described in
[the documentation of the semantic release CLI](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/configuration.md#options).

### Step 4: Create a release

Switch to the main branch in your repository, and push a new fix:

``` bash
git switch main
git commit -m "fix(pencil): stop graphite breaking when too much pressure applied"
git push
```

The above command will trigger a new pipeline on Semaphore and generate a new
Patch release.

## Using the release information in the continuation of your delivery process

The `sem-semantic-release` wraps the semantic release CLI and exports the release
information to the rest of your delivery process.

The release information is handy when you want continue the delivery process
after the new release has been created. A common example would be to build
a Docker image tagged with the release version, or adding an annotation to the
Kubernetes deployment manifest.

### Exported release infromation

ReleasePublished 	  | Whether a new release was published. The return value is in the form of a string. ("true" or "false")
ReleaseVersion        | Version of the new release. (e.g. "1.3.0")
ReleaseMajorVersion   | Major version of the new release. (e.g. "1")
ReleaseMinorVersion   | Minor version of the new release. (e.g. "3")
ReleasePatchVersion   | Patch version of the new release. (e.g. "0")
ReleaseChannel 	      | The distribution channel on which the last release was initially made available.
ReleaseNotes 	      | The release notes for the new release.
PeviousReleaseVersion | The previous released version.

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
    jobs:
      - name: Build & push docker image
        commands:
          - docker build . -t my-app:$(sem-get ReleaseVersion)
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
    jobs:
      - name: Build & push docker image
        commands:
          - docker build . -t my-app:$(sem-get ReleaseVersion)
          - docker push

  - name: Update Kubernetes deployment
    secrets:
      - name: gke-credentials
    jobs:
      - name: kube apply
        commands:
          - sed -i "s/IMAGE/$(sem-get ReleaseVersion)" deployment.yml
          - kubectl apply -f deployment.yml
```
