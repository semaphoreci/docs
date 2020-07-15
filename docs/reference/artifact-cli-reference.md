---
description: Every project on Semaphore 2.0 has access to three levels of the artifact store - project, workflow and job. See this page for more information.
---

# Artifact CLI Reference

__Note__: *Using Artifacts during the beta period is free. Once the artifacts
system is in the general availability, additional charges will apply based on
the usage.*

Every project on Semaphore has access to three levels of the artifact store:
**project**, **workflow** and **job**.
Based on this level, you can retrieve a specific artifact in the job environment and
through the web interface. You can read more about suggested use cases
[here][artifacts-use-cases].

The `artifact` command line interface (CLI), is a tool that helps you manage
deliverables created during the CI/CD process of your project on Semaphore.
Currently it is available in Linux and Docker environments on Semaphore.

The general interface of the `artifact` utility is:

```bash
artifact [COMMAND] [STORE LEVEL] [PATH] [flags]
```

- `[COMMAND]` - action to be performed for an artifact (`push`, `pull` or `yank`)
- `[STORE LEVEL]` - level on which specific artifact is available within the artifact store (`project`, `workflow`, `job`)
- `[PATH]` - points to the artifact (e.g. file or directory)
- `[flags]` - optional command line flags (e.g. `--force`, `--destination`)

## [Artifacts Management](#artifacts-management)

### Uploading Artifact

To upload an artifact from Semaphore job it is necessary to specify
the artifact store level and point to a file or directory
with the `artifact push` command:

```sh
artifact push project my-artifact-v3.tar
```

Available flags:

- `--destination`(`-d`) - Used to adjust artifact name within the artifact store.
Later, on you can use this name with `artifact pull` to download the artifact
to a Semaphore job.
Example: `artifact push project my-artifact.tar --destination releases/my-artifact-v3.tar`
- `--expire-in`(`-e`) - Used to set the artifact expiration time (Nd, Nw, Nm, Ny).
For example, you'd probably want to delete uploaded debugging log in a week or so
(`artifact push job debugging.log --expire-in 1w`).
- `--force`(`-f`) - By default, every `artifact push` command doesn't upload an artifact
if it is already available in the store. You can use this option to overwrite
existing file.

### Downloading Artifact

Similarly, use `artifact pull` to download an artifact to Semaphore job environment.
It is necessary to specify artifact store level of the target artifact
and point to a file or directory within the store.

```sh
artifact pull project my-artifact-v3.tar
```

Available flags:

- `--destination`(`-d`) - This flag can be used to specify a path to which
artifact is downloaded in the Semaphore job environment.
Example: `artifact pull project releases/my-artifact-v3.tar --destination my-artifact.tar`
- `--force`(`-f`) - Use this option to overwrite a file or directory within Semaphore job environment.

### Deleting Artifact

To remove an artifact from the specific artifact store it is necessary to specify
the store level and point to a file or directory with the `artifact yank` command.

```sh
artifact yank project my-artifact-v3.tar
```

[artifacts-use-cases]: https://docs.semaphoreci.com/essentials/artifacts/