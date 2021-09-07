---
description: This guide describes how to install a self-hosted agent on various different operating systems and architectures.
---

# Installing a self-hosted agent

The agent is open source and can be found at [https://github.com/semaphoreci/agent](https://github.com/semaphoreci/agent).

## Installing the agent on Ubuntu/Debian

Prepare your machine:

```
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER:$USER /opt/semaphore/agent/
cd /opt/semaphore/agent
```

Download the agent:

```
curl -L https://github.com/semaphoreci/agent/releases/download/v2.0.11/agent_Linux_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
```

Install the agent:

```
sudo ./install.sh
```

The script asks for your Semaphore organization, the agent type registration token and the Linux user to use to run the service. After that, it creates and starts the systemd service.

It also creates a `config.yaml` file in the installation directory for you to manage the [agent configuration][agent-configuration]. Note that any changes in the configuration file require a restart of the systemd service.

## Installing the agent on generic Linux

Prepare your machine:

```
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER:$USER /opt/semaphore/agent/
cd /opt/semaphore/agent
```

Download the agent:

```
curl -L https://github.com/semaphoreci/agent/releases/download/v2.0.11/agent_Linux_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
```

Create the configuration file:

```
cat > config.yaml <<EOF
endpoint: "[your-organization-name].semaphoreci.com"
token: "[token]"
EOF
```

Run the agent:

```
agent start --config-file config.yaml
```

## Installing the agent on MacOS

Install the agent using Homebrew. If you don't want to use Homebrew, the agent can be downloaded directly from the [Releases page][releases-page].

```
brew install semaphoreci/tap/agent
```

Start the agent:

```
agent start --endpoint semaphore.semaphoreci.com --token [token]
```

[agent-configuration]: ../ci-cd-environment/configuring-a-self-hosted-agent.md
[releases-page]: https://github.com/semaphoreci/agent/releases
