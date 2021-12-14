---
description: This guide describes how to configure a self-hosted agent and the various different configuration options.
---

# Configuring a self-hosted agent
!!! beta "Self-hosted agents - closed beta"
    Self-hosted agents are in closed beta. If you would like to run Semaphore agents in your infrastructure, please [contact us and share your use case](https://semaphoreci.com/contact). Our team will get back to you as soon as possible.

The agent can be configured in two ways:

- command line arguments
- configuration file, using the `--config-file /path/to/config.yaml` parameter

Both ways can be used at the same time, but command line arguments take precedence over the configuration file.

## Available configuration parameters

| Parameter name                  | Required | Default      |
|---------------------------------|----------|--------------|
| `endpoint`                      | Yes      | Empty string |
| `token`                         | Yes      | Empty string |
| `env-vars`                      | No       | Empty array  |
| `files`                         | No       | Empty array  |
| `fail-on-missing-files`         | No       | False        |
| `disconnect-after-job`          | No       | false        |
| `disconnect-after-idle-timeout` | No       | 0            |
| `shutdown-hook-path`            | No       | Empty string |
| `config-file`                   | No       | Empty string |

### `endpoint`

The Semaphore endpoint the agent uses to register and sync. It is formed by your Semaphore organization name, e.g., `<your-organization-name>.semaphoreci.com`.

### `token`

The agent type registration token you grab when creating an agent type in Semaphore UI. If the token specified is not correct, the agent does not start.

### `env-vars`

Environment variables to expose to the jobs. When using the command line argument `--env-vars`, the agent expects a comma-separated list of `VAR=VALUE` environment variables:

```
agent start \
  --endpoint <org>.semaphoreci.com \
  --token "..." \
  --env-vars VAR1=A,VAR2=B
```

When using the configuration file, the agent expects an array of strings using the same format above:

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

By default, if files given to `--files` are not found in the host, they are not injected into the docker container, and the job will proceed to be executed. If you want to fail the job instead, set `fail-on-missing-files` to true.

### `disconnect-after-job`

By default, the agent does not disconnect from Semaphore and shuts down after completing a job. If you want to do that instead, set `disconnect-after-job` to true.

### `disconnect-after-idle-timeout`

By default, the agent does not disconnect after some period of idleness. If you want to do that instead, set `disconnect-after-idle-timeout` to the number of idle seconds after which you want the agent to shutdown.

### `shutdown-hook-path`

By default, nothing fancy is executed when the agent shuts down. This parameter accepts a path to a bash script in the host to be executed once that happens. It can be useful to perform cleaning up operations (pushing the agent logs to some external storage, shutting down the machine).

It can also be useful when used in conjunction with `disconnect-after-job` or `disconnect-after-idle-timeout` in order to rotate the agents and make sure you get a clean one for every job you run.

For example, if you want to turn off the machine once the agent shuts down, you could use this:

```yaml
# config.yaml
endpoint: "..."
token: "..."
shutdown-hook-path: "/opt/semaphore/agent/hooks/shutdown.sh"
```

```sh
# /opt/semaphore/agent/hooks/shutdown.sh
sudo poweroff -f
```

If the path specified does not exist, an error will be logged and the agent will disconnect as usual.

Furthermore, the shutdown script will have the following environment variables available:

| Environment variable              | Description |
|-----------------------------------|-------------|
| `SEMAPHORE_AGENT_SHUTDOWN_REASON` | The reason why the agent is shutting down. Possible values are: `IDLE`, `JOB_FINISHED`, `UNABLE_TO_SYNC`, `REQUESTED` and `INTERRUPTED` |