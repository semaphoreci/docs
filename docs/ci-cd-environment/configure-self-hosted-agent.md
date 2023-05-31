---
Description: This guide describes the various different configuration options for how to configure a self-hosted agent.
---

# Configuring a self-hosted agent

!!! plans "Available on: <span class="plans-box">[Free & OS](/account-management/free-and-open-source-plans/)</span> <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

An agent can be configured in two ways:

- using command line arguments
- using a configuration file with the `--config-file /path/to/config.yaml` parameter

Both ways can be used at the same time, but command line arguments take precedence over the configuration file.

## Available configuration parameters

| Parameter name                  | Required | Default      |
|---------------------------------|----------|--------------|
| `endpoint`                      | Yes      | Empty string |
| `token`                         | Yes      | Empty string |
| `name`                          | No       | Empty string |
| `env-vars`                      | No       | Empty array  |
| `files`                         | No       | Empty array  |
| `fail-on-missing-files`         | No       | False        |
| `fail-on-pre-job-hook-error`    | No       | False        |
| `disconnect-after-job`          | No       | false        |
| `disconnect-after-idle-timeout` | No       | 0            |
| `shutdown-hook-path`            | No       | Empty string |
| `pre-job-hook-path`             | No       | Empty string |
| `post-job-hook-path`            | No       | Empty string |
| `upload-job-logs`               | No       | never        |
| `config-file`                   | No       | Empty string |

### `endpoint`

The Semaphore endpoint that the agent uses to register and sync is determined by your Semaphore organization name, e.g. `<your-organization-name>.semaphoreci.com`.

### `token`

You get an agent type registration token when you create an agent type in the Semaphore UI. If the token specified is not correct, the agent will not start.

### `name`

By default, the agent will generate a random name. If you want to set a custom name, you can use this configuration parameter. The name must have between 8 and 64 characters.

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

### `fail-on-pre-job-hook-error`

Controls whether the agent should fail the job if the pre-job hook configured with `--pre-job-hook-path` fails execution. By default, the job won't fail if the pre-job hook fails.

### `disconnect-after-job`

By default, an agent does not disconnect from Semaphore and shut down after completing a job. If you want to disconnect from Semaphore instead, set `disconnect-after-job` to true.

### `disconnect-after-idle-timeout`

By default, an agent does not disconnect after a given period of idleness. If you want an agent to disconnect after a set period of idleness, set `disconnect-after-idle-timeout` to the desired amount of time (in seconds).

### `upload-job-logs`

By default, the logs for a job are not uploaded as a [job artifact](https://docs.semaphoreci.com/essentials/artifacts/#job-artifacts) after a job finishes. However, you can change that behavior. This parameter accepts three values:

- **never**: the default one, job logs will never be uploaded as a job artifact.
- **when-trimmed**: job logs will only be uploaded as a job artifact if the logs were trimmed for being above the current [limit of 16MB](https://docs.semaphoreci.com/reference/quotas-and-limits/#job-log-size-limit).
- **always**: job logs will always be uploaded as a job artifact.

The artifact is uploaded using the path `agent/job_logs.txt`. The agent will use the [artifact CLI](https://docs.semaphoreci.com/reference/artifact-cli-reference/) to upload the logs to Semaphore. If the artifact CLI is not available to the agent, nothing will be uploaded.

### `pre-job-hook-path`

By default, nothing else is executed before the agent starts executing the commands for a job. This parameter allows you to configure a hook to execute before a job starts. It accepts the path to a script (Bash/PowerShell) that will be run right after the job environment is set, but before the job commands start.

Additionally, you can use `fail-on-pre-job-hook-error` to control whether the job should proceed or fail if an error occurs while executing that script.

### `post-job-hook-path`

This parameter allows you to configure a hook to execute after a job finishes. It accepts the path to a script (Bash/PowerShell) that will be run right after the job's epilogue commands. The hook is executed before terminating the PTY created for the job, so the hook has access to the environment variables exposed in the job.

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
