---
description: This guide describes how to configure a self hosted agent and the various different configuration options.
---

# Configuring a Self Hosted Agent

The agent can be configured in two ways:

- command line arguments
- configuration file, using the `--config-file /path/to/config.yaml` parameter

You can also use both ways at the same, but be aware that command line arguments take precedence over the configuration file. These are the configuration parameters available:

## Available configuration parameters

| Parameter name          | Required | Default      |
|-------------------------|----------|--------------|
| `endpoint`              | Yes      | Empty string |
| `token`                 | Yes      | Empty string |
| `env-vars`              | No       | Empty array  |
| `files`                 | No       | Empty array  |
| `fail-on-missing-files` | No       | False        |
| `disconnect-after-job`  | No       | false        |
| `shutdown-hook-path`    | No       | Empty string |
| `--config-file`         | No       | Empty string |

### `endpoint`

The Semaphore 2.0 endpoint the agent will use to register and sync. It is formed by your Semaphore 2.0 organization name, e.g., `<your-organization-name>.semaphoreci.com`.

### `token`

The agent type registration token you grab when creating an agent type in Semaphore 2.0 UI. If the token specified is not correct, the agent will not be able to register with Semaphore`s API and therefore won't start up.

### `env-vars`

Environment variables to expose to the jobs. When using the command line argument `--env-vars`, the agent expects a comma-separated list of `VAR=VALUE` environment variables:

```
agent start \
  --endpoint <org>.semaphoreci.com \
  --token "..." \
  --env-vars VAR1=A,VAR2=B
```

When using the configuration file, it expects an array of strings using the same format above:

```yaml
# config.yaml
endpoint: "..."
token: "..."
env-vars:
  - VAR1=A
  - VAR2=B
```

This is a way of exposing secrets to your jobs from the agent, instead of using Semaphore secrets.

### `files`

Files to inject into the docker container running the job, when using docker containers. When using the command line argument `--files`, the agent expects a comma-separated list of `/some/host/file=/some/container/file`:

```
agent start \
  --endpoint <org>.semaphoreci.com \
  --token "..." \
  --files /tmp/host/file1:/tmp/container/file1,/tmp/host/file2:/tmp/container/file2
```

When using the configuration file, it expects an array of strings using the same format above:

```yaml
# config.yaml
endpoint: "..."
token: "..."
files:
  - /tmp/host/file1:/tmp/container/file1
  - /tmp/host/file2:/tmp/container/file2
```

This is another way of exposing secrets to your jobs from the agent, instead of using Semaphore secrets.

### `fail-on-missing-files`

By default, if files given to `--files` are not found in the host, they won't be injected into the docker container, but the job will proceed to be executed. If you want to fail the job instead, set `fail-on-missing-files` to true.

### `disconnect-after-job`

By default, the agent will not disconnect from Semaphore 2.0 and shutdown after completing a job. However, if you want to do that instead, set `disconnect-after-job` to true.

### `shutdown-hook-path`

By default, nothing fancy will be executed when the agent shuts down. This parameter accepts a path to bash script in the host to be executed once that happens. It can be useful to perform cleaning up operations (pushing the agent logs to some external storage, shutting down the machine).

It can also be useful when used in conjunction with `disconnect-after-job` in order to rotate the agents and make sure you get a clean one for every job you run.
