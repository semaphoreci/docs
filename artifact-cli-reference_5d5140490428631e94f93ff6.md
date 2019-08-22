__Note__: Artifacts are a *beta feature* and Artifacts web interface is available on request.
Using Artifacts during the beta period is free.
Once the artifacts system is pushed to the general availability,
addional changes will apply based on the usage.

Although we make the best effort to maintain the uptime for the Artifacts system,
we cannot guarantee the 100% uptime during the beta period.

If you'd like to share a feedback or if you run into any challenges,
please reach out to support@semaphoreci.com.

# Overview

Every project on Semaphore has access to three levels of artifact store:
**project**, **workflow** and **job**.
Based on this level, specific artifact can be retreived in the job environment and
through the web interface.

The `artifact` command line interface (CLI), is a tool that helps you manage
deliverables created during the CI/CD process of your project on Semaphore.
It is available in every job environment on Semaphore.

The general interface of the `artifact` utility is:

```bash
artifact [COMMAND] [ARTIFACT STORE LEVEL] [SOURCE PATH] [flags]
```

- `[COMMAND]` - action to be performed for an artifact (`push`, `pull` or `yank`)
- `[ARTIFACT STORE LEVEL]` - level on which specific artifact is available within the artifact store (`project`, `workflow`, `job`)
- `[SOURCE PATH]` - points to the artifact (e.g. file or directory)
- `[flags]` - optional command line flags (e.g. `--force`, `--destination`)

- [Uploading artifact](#uploading-artifact)
- [Downloading artifact](#downloading-artifact)
- [Deleting artifact](#deleting-artifact)

## Uploading artifact

To upload an artifact from Semaphore job it is neccessary to specify
its availability level and point to a file or directory
with the `artifact push` command:

```sh
artifact push project my-artifact-v3.tar
```

Available flags:

- `--destination`(`-d`) - used to adjust artifact name within the artifact store.
This name should be used in combination with `artifact pull` command when downloading it
from the Semaphore job. Also, when saved on the specific level with,
Semaphore web interface will list this artifact
behind a click on `Artifacts` button for a specific resource. Example:
- `--expire-in`(`-e`) - used to set expiration time (Nd, Nw, Nm, Ny) for an artifact that is being uploaded.
Example:
- `--force`(`-f`) - used for overwritting an already uploaded artifact. By default, every `artifact push` command doesn't upload an artifact if it is already available in the store.

## Download artifact

To download an artifact from Semaphore job environment it is neccessary to specify
the level of artifact and point to a file or directory within the artifact store
with the `artifact pull` command:

```sh
artifact pull project my-artifact-v3.tar
```

Available flags:

- `--destination`(`-d`) - used to adjust artifact path in the Semaphore job environment.
Example:
- `--force`(`-f`) - used for overwritting a file or directory within Semaphore job environment in case it was occupied before the command execution.

## Deleting artifact

To remove an artifact from Semaphore job environment it is neccessary to specify
the level of artifact and point to a file or directory within the artifact store
with the `artifact yank` command:

```sh
artifact yank project my-artifact-v3.tar
```
