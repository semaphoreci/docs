The `artifact` command line interface (CLI), is a tool that helps you manage
deliverables created during the CI/CD process of your project on Semaphore.

 Semaphore offers three levels of artifact stores:

- project
- workflow
- job

You can read more about this [here](use-case-doc).

Based on its level you can retrieve an artifact in the job environment and
through the web interface.

# Overview

- [Uploading artifact](#uploading-artifact)
- [Downloading artifact](#downloading-artifact)
- [Deleting artifact](#deleting-artifact)

The general interface of the `artifact` utility is:

```bash
artifact [COMMAND] [ARTIFACT STORE LEVEL] [SOURCE PATH] [flags]
```

where `[COMMAND]` is the name of the action to be performed for an artifact,
`[ARTIFACT STORE LEVEL]` represents the availability level of the artifact,
`[SOURCE PATH]` points to the artifact, e.g. file or directory
available in the job environment. `[flags]` stand for optional command line flags.

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
