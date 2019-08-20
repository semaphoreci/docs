# Artifact CLI

- [Overview](#overview)
- [Artifacts Management](#artifacts-management)
  - [Uploading artifact](#uploading-artifact)
  - [Downloading artifact](#downloading-artifact)
  - [Deleting artifact](#deleting-artifact)


__Note__: Artifacts are a *beta feature* and Artifacts web interface is available on request.
Using Artifacts during the beta period is free.
Once the artifacts system is pushed to the general availability,
addional charges will apply based on the usage.

Although we make the best effort to maintain the uptime for the Artifacts system,
we cannot guarantee the 100% uptime during the beta period.

If you'd like to share a feedback or if you run into any challenges,
please reach out to support@semaphoreci.com.

## Overview

Every project on Semaphore has access to three levels of artifact store:
**project**, **workflow** and **job**.
Based on this level, specific artifact can be retreived in the job environment and
through the web interface.

The `artifact` command line interface (CLI), is a tool that helps you manage
deliverables created during the CI/CD process of your project on Semaphore.
It is available in every job environment on Semaphore.

The general interface of the `artifact` utility is:

```bash
artifact [COMMAND] [STORE LEVEL] [PATH] [flags]
```

- `[COMMAND]` - action to be performed for an artifact (`push`, `pull` or `yank`)
- `[STORE LEVEL]` - level on which specific artifact is available within the artifact store (`project`, `workflow`, `job`)
- `[PATH]` - points to the artifact (e.g. file or directory)
- `[flags]` - optional command line flags (e.g. `--force`, `--destination`)

## Artifacts management

### Uploading Artifact

To upload an artifact from Semaphore job it is neccessary to specify
the artifact store level and point to a file or directory
with the `artifact push` command:

```sh
artifact push project my-artifact-v3.tar
```

Available flags:

- `--destination`(`-d`) - Used to adjust artifact name within the artifact store.
This name should be used in combination with `artifact pull` command when called
within a Semaphore job. Example: `artifact push project my-artifact.tar --destination releases/my-artifact-v3.tar`
- `--expire-in`(`-e`) - Used to set the artifact expiration time (Nd, Nw, Nm, Ny).
For example, you'd probably want to delete uploaded debugging log in a week or so
(`artifact push job debugging.log --expire-in 1w`).
- `--force`(`-f`) - By default, every `artifact push` command doesn't upload an artifact if it is already available in the store.
This flag should be used if you'd need to be sure that the most recent version of an artifact is present within the artifact store.

### Downloading Artifact

Similarly, to download an artifact to Semaphore job environment it is neccessary to specify
a level of the artifact store and point to a file or directory within the artifact store
with the `artifact pull` command:

```sh
artifact pull project my-artifact-v3.tar
```

Available flags:

- `--destination`(`-d`) - This flag can be used to adjust artifact path in the Semaphore job environment.
Example: `artifact pull project releases/my-artifact-v3.tar --destination my-artifact.tar`
- `--force`(`-f`) - Used this option to overwrite a file or directory within Semaphore job environment
in case it was occupied before the command execution.

### Deleting Artifact

To remove an artifact from the specific artifact store it is neccessary to specify
the store level and point to a file or directory with the `artifact yank` command.

```sh
artifact yank project my-artifact-v3.tar
```
