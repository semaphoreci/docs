---
Description: This guide shows you how to use sem-context cli tool to store key value pairs for communication between jobs
---

# Sem-context

Sem-context is a cli tool for exporting data in a form of a key-value store. This
tool can be used for communication between different jobs, blocks, and pipelines
within the same workflow.

## Commands

Flag ```--ignore-failure``` can be added to all of the commands below, and they
will return ```exit code 0``` no matter the outcome. This can be useful if you
want your job to continue despite the sem-context command failing.

### Put

```
sem-context put [key]=[value]

[key] - alphanumerical string (special characters - and _ are allowed), between
3 and 256 characters in length
[value] - string up to 20KB in size
```
Exports data in key-value pair format, for later use within the same workflow.

#### Exit status codes
  - ```0``` If the key-value pair was successfully exported
  - ```1``` If the key already exists
  - ```2``` If the connection to hhe artifacts server failed *
  - ```3``` If the key or value aren't in the correct format

*```sem-context``` is wrapped around [artifacts cli](https://docs.semaphoreci.com/reference/artifact-cli-reference/),
so this will probably happen when artifacts cli cant connect to the server where artifacts are kept.

#### Command specific flags

If flag ```---force``` is used, the value will be written regardless if the same
key already exists, and ```status code 0``` will be returned

### Get

```
sem-context get [key]
```

Gets the value exported under the given key.

#### Exit status codes
  - ```0``` If the key was found
  - ```1``` If the key does not exist
  - ```2``` If the connection to the artifacts server failed
  - ```3``` If the key isn't in the correct format

#### Command specific flags

If flag ```--fallback "[value]"``` is used, then the given value will be returned
with ```status code 0``` in case the key does not exist

### Delete

```
sem-context delete [key]
```
#### Exit status codes
  - ```0``` If the key was found
  - ```1``` If the key does not exist
  - ```2``` If the connection to the artifacts server failed
  - ```3``` If the key isn't in the correct format

## Example usage

### Sharing data between blocks:

```yaml
blocks:
name: Release
jobs:
  name: CLI Release
  commands:
  - sem-context put ReleaseVersion=1.2.3

name: Docker Build
jobs:
  name:
  commands:
  - docker build . –tag $(sem-context get ReleaseVersion)
```

### Sharing data between pipelines:

```yaml
# semaphore.yml
blocks:
name: Release
jobs:
  name: CLI Release
  commands:
  - sem-context put ReleaseVersion=1.2.3

# deploy.yml
blocks:
name: Docker Build
jobs:
  name:
  commands:
  - docker build . –tag $(sem-context get ReleaseVersion)
```

### Each executed pipeline sees only data within its context

Here is a bit more complex example, where we have three pipelines as part of a single
workflow:

```
Build Pipeline -> Spin Up Cluster -> Spin Down  Cluster
```

And here are YAML files defining these pipelines:

```yaml
# semaphore.yaml
name: Build
blocks:
  - name: Build
    jobs: 
      - name: Make Build
        commands:
          - make build
          - sem-context put RelaseVersion=$(make calc.version)
          - make upload.docker

promotions:
  - name: Spin Up Cluster
    file: spin-up.yml
    parameter:
    - name: CLUSTER_OWNER
    - type: string

# spin-up.yaml
name: Spin Up Cluster
blocks:
  - name: Start
    jobs:
    - name: Boot Up
      commands:
      - make gce.create.k8s.cluster
      - make gce.apply $(sem-context get ReleaseVersion)
      - sem-context put ClusterID=$CLUSTER_ID

promotions:
  - name: Spin Down Cluster
    file: spin-down.yaml

# spin-down.yaml
name: Spin Down Cluster
blocks:
  - name: Destroy
    jobs:
    - name: Destroy
      commands:
      - make gce.destroy.k8s.cluster ID=$(sem-context get ClusterID)
```

In this example, promotions are run manually, and multiple clusters can be spun
up from a single build. That means that Spin Up Pipeline can be run twice, and both
of those pipelines will export the value of their cluster id under the 'ClusterID' key.

Those values will not overwrite each other but rather exists simultaneously within
their own contexts. Later, when Spin Down Pipeline is run, and ```sem-context get ClusterID```
command is executed, it will fetch the value exported by the instance of Spin Up Pipeline 
that is a part of its execution path (its context).

Both ```put``` and ```delete``` commands
cant affect values that will be visible to the pipelines that are running in different (parallel)
execution paths. These commands can affect the outcome of the current pipeline, and 
all pipelines started from the current pipeline.
