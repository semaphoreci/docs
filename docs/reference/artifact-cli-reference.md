---
Description: Every project on Semaphore has access to an artifact store. This page describes the Artifact CLI, used for pushing and pulling artifacts from the store.
---

# Artifact CLI Reference

__Note__: *Using Artifacts during the beta period is free. Once the artifacts
system is in general availability, additional charges will apply based on
usage.*

Every project on Semaphore has access to three levels of artifact store:
project, workflow, and job.
Based on this level, you can retrieve a specific artifact in the job environment and
via the web interface. You can read more about suggested use cases
[here][artifacts-use-cases].

The `artifact` command line interface (CLI), is a tool that helps you manage
deliverables created during the CI/CD process of your project on Semaphore.
Currently it is available in Linux and Docker environments on Semaphore.

The general interface of the `artifact` utility is:

``` bash
artifact [COMMAND] [LEVEL] [PATH] [flags]

 COMMAND - action to be performed for an artifact (push, pull or yank/delete)
 LEVEL   - artifact store level (one of project, workflow, job)
 PATH    - indicates an artifact (e.g. file or directory)
 flags   - optional command line flags (e.g. --force, --destination)
```

Examples:

``` bash
# push a final deliverable to the project level
artifact push project app-v1.tar.gz

# push a screenshot to the job level
artifact push job screenshots/app.png

# push a binary to the workflow level 
artifact push workflow build/app

# pull a binary from the workflow level 
artifact pull workflow build/app

# delete a binary from the workflow level 
artifact yank workflow build/app
```

## Uploading Artifacts

To upload an artifact from Semaphore job, it is necessary to specify
the artifact store level and indicate a file or directory
with the `artifact push` command:

```sh
artifact push project my-artifact-v3.tar
```

Available flags:

```
--destination(-d)

  Used to adjust artifact name within the artifact store.
  Later, you can use this name with `artifact pull` to download the artifact
  to a Semaphore job. For example: 

    artifact push project my-artifact.tar --destination releases/my-artifact-v3.tar
    artifact pull project releases/my-artifact-v3.tar

--force(-f)

  By default, the `artifact push` command doesn't upload an artifact
  if it is already available in the store. You can use this option to overwrite
  existing file. For example:

    artifact push project my-artifact.tar --force
```

## Downloading Artifacts

Similarly, you can use the `artifact pull` command to download an artifact to the Semaphore 
job environment. You need to specify the artifact store level of the target artifact
and to indicate a file or directory within the store.

```sh
artifact pull project my-artifact-v3.tar
```

Available flags:

```
--destination(-d)

  This flag can be used to specify a path to which an artifact is downloaded 
  in the Semaphore job environment. For example: 

    artifact pull project releases/my-artifact-v3.tar --destination my-artifact.tar

--force(-f) 
  
  Use this option to overwrite a file or directory within a Semaphore job environment.
```

## Deleting Artifacts

To remove an artifact from an artifact store, specify the store level 
and indicate a file or directory with the `artifact yank` or `artifact delete` command.

``` bash
artifact yank project my-artifact-v3.tar
```

## Supported file names

The uploaded files must meet the following requirements:

- File names can contain any sequence of valid Unicode characters, and must be of a length of 1-1024 bytes when UTF-8 encoded.
- File names cannot contain Carriage Return or Line Feed characters.
- File names cannot start with `.well-known/acme-challenge/`.
- File names cannot contain non URI encodable characters `{`, `}`, `|`, `\`, `^`, `~`, `[`, `]`
- Files cannot be named `.` or `...`

In the event that you have a file that is not able to fit the above criteria, the recommended solution 
is to create a tarball before uploading the files to the artifact store.

For example, if you have the following structure:

```
example/
├─ [id].json
├─ {username}.json
├─ user|character.json
├─ README.md
```

Create a tarball before pushing to artifacts with:

``` bash
tar -czvf example.tar.gz ~/example
artifact push workflow example.tar.gz
```

Then, when pulling the artifact, extract the content with:

```
artifact pull workflow example.tar.gz
tar -xzf example.tar.gz
```

[artifacts-use-cases]: https://docs.semaphoreci.com/essentials/artifacts/
