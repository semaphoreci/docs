---
description: Artifact retention policies control the lifetime of every artifact in a project.
---

# Artifact Retention Policies Reference

You can define artifact retention policies to control the lifetime of [artifacts][artifacts]
in your projects. The retention can be configured by visiting the project settings > artifacts.

There are three types of retention policies:

- Project artifact retention policies which control the lifetime of artifacts 
  pushed to the project level with `artifact push project <path-to-file>`.
- Workflow artifact retention policies which control the lifetime of artifacts 
  pushed to the workflow level with `artifact push workflow <path-to-file>`.
- Job artifact retention policies which control the lifetime of artifacts 
  pushed to the job level with `artifact push job <path-to-file>`.

A single retention policy is defined by two properties:

- The path selector of the artifact (ex. `/logs/**/*.txt`) which is a double-star
  glob pattern used for identifying the artifacts paths.
- The age of the artifact after which the artifact is deleted.

For example, if you set a project level retention policy to `/logs/**/*.txt` with
the age of `1 week` all logs in the `/logs/` directory that have a `.txt` extention will
be deleted.

## Example retention policies and glob patterns

Glob pattern for deleting all test screenshots in the `/screenshots` directory:

```
/screenshots/**/*.png
```

Glob pattern for deleting all logs in the `/logs` directory:

```
/logs/**/*.log
```

Glob pattern for deleting all test results in the `/test-results` directory:

```
/test-results/**/*
```

## Setting different policies for different directories

You can set up multiple rules for artifact retention. The rules are evaluated
from top to bottom and the first matched rule is applied.

For example, if you have these policies:

- `/logs/**/*.txt` - 1 month
- `/screenshots/**/*` - 1 month
- `/**/*` - 1 week

Files in the `/logs` and `/screenshots` directory will be deleted in 1 month,
while any other artifact that is not in those two directories will be deleted 
in 1 week.

## Doublestar glob pattern

The doublestar (aka globstar) glob pattern is a path matching mechanism for 
selectring files in a hirerarchical directory structure.

Doublestar patterns match files and directories recursevly. For example, if you
have the following directory structure:

```
grandparent
`-- parent
    |-- child1
    `-- child2
```

You could find the children with patterns such as: `/**/child*`, 
`/grandparent/**/child`, `/**/parent/*`, or even just `/**/*` by itself 
(which will return all files and directories recursively).

## Frequency of deletion 

Semaphore checks and applies the rules the retention policies in your project once
every day.

[artifacts]: /essentials/artifacts/
