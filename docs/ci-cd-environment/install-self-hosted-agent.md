---
description: This guide describes how to install a self-hosted agent on various different operating systems and architectures.
---

# Installing a self-hosted agent

The agent is open source and can be found at [https://github.com/semaphoreci/agent](https://github.com/semaphoreci/agent). The host requirements are:

- bash
- git
- docker - [manageable without sudo][docker without sudo]
- docker-compose

## Installing the agent on Ubuntu/Debian

<b>1. Prepare your machine:</b>

```
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER:$USER /opt/semaphore/agent/
cd /opt/semaphore/agent
```

<b>2. Download the agent:</b>

```
curl -L https://github.com/semaphoreci/agent/releases/download/v2.0.11/agent_Linux_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
```

<b>3. Install the agent:</b>

```
sudo ./install.sh
```

The script asks for your Semaphore organization, the [agent type registration token][agent tokens] and the Linux user used to run the service and does the following:

- downloads and installs the Semaphore toolbox
- creates a systemd service for the agent
- creates an initial `config.yaml` file in the installation directory for you to manage the [agent configuration][agent-configuration]

Note that any changes in the agent configuration file require a restart of the systemd service.

## Installing the agent on generic Linux

<b>1. Prepare your machine:</b>

```
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER:$USER /opt/semaphore/agent/
cd /opt/semaphore/agent
```

<b>2. Download the agent:</b>

```
curl -L https://github.com/semaphoreci/agent/releases/download/v2.0.11/agent_Linux_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
```

<b>3. Create the agent configuration file:</b>

```
cat > config.yaml <<EOF
endpoint: "[your-organization-name].semaphoreci.com"
token: "[token]"
EOF
```

<b>4. Download and install the toolbox:</b>

```
curl -L "https://github.com/semaphoreci/toolbox/releases/latest/download/self-hosted-linux.tar" -o toolbox.tar
tar -xf toolbox.tar
mv toolbox ~/.toolbox
bash ~/.toolbox/install-toolbox
source ~/.toolbox/toolbox
echo "source ~/.toolbox/toolbox" >> ~/.bash_profile
```

<b>5. Run the agent:</b>

```
agent start --config-file config.yaml
```

## Installing the agent on MacOS

<b>1. Install the agent using Homebrew:</b>

```
brew install semaphoreci/tap/agent
```

Note: If you don't want to use Homebrew, the agent can be downloaded directly from the [Releases page][releases-page].

<b>2. Download and install the toolbox:</b>

```
curl -L "https://github.com/semaphoreci/toolbox/releases/latest/download/self-hosted-darwin.tar" -o toolbox.tar
tar -xf toolbox.tar
mv toolbox ~/.toolbox
bash ~/.toolbox/install-toolbox
source ~/.toolbox/toolbox
echo "source ~/.toolbox/toolbox" >> ~/.bash_profile
```

<b>3. Start the agent:</b>

```
agent start --endpoint semaphore.semaphoreci.com --token [token]
```

[agent-configuration]: ./configure-self-hosted-agent.md
[agent tokens]: ./self-hosted-agents-overview.md#tokens-used-for-communication
[releases-page]: https://github.com/semaphoreci/agent/releases
[docker without sudo]: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user