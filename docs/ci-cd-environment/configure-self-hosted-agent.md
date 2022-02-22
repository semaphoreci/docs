---
Description: This guide describes the various different configuration options for how to configure a self-hosted agent.
---

# Configuring a self-hosted agent
!!! beta "Self-hosted agents - closed beta"
    Self-hosted agents are in closed beta. If you would like to run Semaphore agents on your infrastructure, please [contact us and share your use case](https://semaphoreci.com/contact). Our team will get back to you as soon as possible.

An agent can be configured in two ways:

- using command line arguments
- using a configuration file with the `--config-file /path/to/config.yaml` parameter

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

The Semaphore endpoint that the agent uses to register and sync is determined by your Semaphore organization name, e.g. `<your-organization-name>.semaphoreci.com`.

### `token`

You get an agent type registration token when you create an agent type in the Semaphore UI. If the token specified is not correct, the agent will not start.

### `env-vars`

Environment variables are used to expose agents to jobs. When using the command line argument `--env-vars`, the agent expects a comma-separated list of `VAR=VALUE` environment variables:

```
agent start \
  --endpoint <org>.semaphoreci.com \
  --token "..." \
  --env-vars VAR1=A,VAR2=B
```

When using the configuration file, the agent expects an array of strings using the same format as shown above:

```yaml
# config.yaml
endpoint: "..."
token: "..."
env-vars:
  - VAR1=A
  - VAR2=B
```

This is a way of exposing secrets to your jobs via an agent, instead of using Semaphore secrets.

### `files`

You can inject files into the container running the job when using docker containers. When using the command line argument `--files`, the agent expects a comma-separated list of `/some/host/file=/some/container/file` files:

```
agent start \
  --endpoint <org>.semaphoreci.com \
  --token "..." \
  --files /tmp/host/file1:/tmp/container/file1,/tmp/host/file2:/tmp/container/file2
```

When using the configuration file, it expects an array of strings using the same format as above:

```yaml
# config.yaml
endpoint: "..."
token: "..."
files:
  - /tmp/host/file1:/tmp/container/file1
  - /tmp/host/file2:/tmp/container/file2
```

This is another way of exposing secrets to your jobs via an agent, instead of using Semaphore secrets.

### `fail-on-missing-files`

By default, if files given to `--files` are not found in the host, they are not injected into the docker container and the job will be executed as normal. If you want to fail the job instead, set `fail-on-missing-files` to true.

### `disconnect-after-job`

By default, an agent does not disconnect from Semaphore and shut down after completing a job. If you want to disconnect from Semaphore instead, set `disconnect-after-job` to true.

### `disconnect-after-idle-timeout`

By default, an agent does not disconnect after a given period of idleness. If you want an agent to disconnect after a set period of idleness, set `disconnect-after-idle-timeout` to the desired amount of time (in seconds).

### `shutdown-hook-path`

By default, nothing else is executed when the agent shuts down. This parameter accepts a path to a bash script in the host to be executed when an agent shuts down. This can be useful to perform clean-up operations (e.g. pushing the agent's logs to external storage or shutting down the machine).

It can also be useful when used in conjunction with `disconnect-after-job` or `disconnect-after-idle-timeout` in order to rotate agents and make sure you get a clean one for every job you run.

For example, if you want to turn off the machine once the agent shuts down, use the following:

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
