---
description: This guide describes how to install a self-hosted agent on various different operating systems and architectures.
---

# Installing a self-hosted agent

The Semaphore agent is open source and can be found [here][agent repo]. Before installing it in your machine, you need to make sure the following requirements are also available in it:

- bash
- git
- docker - [manageable without sudo][docker without sudo]
- docker-compose

Please, follow the installation instructions for your operating system of choice below.

## Installing the agent on Ubuntu/Debian

**1. Prepare your machine:**

```
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER:$USER /opt/semaphore/agent/
cd /opt/semaphore/agent
```

**2. Download the agent:**

```
curl -L https://github.com/semaphoreci/agent/releases/download/v2.0.11/agent_Linux_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
```

**3. Install the agent:**

```
sudo ./install.sh
```

The script asks for your Semaphore organization name, the [agent type registration token][agent tokens] and the Linux user used to run the service and does the following:

- downloads and installs the [Semaphore toolbox][toolbox]
- creates a systemd service for the agent
- creates an initial `config.yaml` file in the installation directory for you to manage the [agent configuration][agent-configuration]

Note that any changes in the agent configuration file require a restart of the systemd service.

## Installing the agent on generic Linux

**1. Prepare your machine:**

```
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER:$USER /opt/semaphore/agent/
cd /opt/semaphore/agent
```

**2. Download the agent:**

```
curl -L https://github.com/semaphoreci/agent/releases/download/v2.0.11/agent_Linux_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
```

**3. Create the agent configuration file:**

```
cat > config.yaml <<EOF
endpoint: "[your-organization-name].semaphoreci.com"
token: "[token]"
EOF
```

**4. Download and install the [toolbox][toolbox]:**

```
curl -L "https://github.com/semaphoreci/toolbox/releases/latest/download/self-hosted-linux.tar" -o toolbox.tar
tar -xf toolbox.tar
mv toolbox ~/.toolbox
bash ~/.toolbox/install-toolbox
source ~/.toolbox/toolbox
echo "source ~/.toolbox/toolbox" >> ~/.bash_profile
```

**5. Run the agent:**

```
agent start --config-file config.yaml
```

## Installing the agent on MacOS

**1. Install the agent using Homebrew:**

```
brew install semaphoreci/tap/agent
```

Note: If you don't want to use Homebrew, the agent can be downloaded directly from the [Releases page][releases-page].

**2. Download and install the [toolbox][toolbox]:**

```
curl -L "https://github.com/semaphoreci/toolbox/releases/latest/download/self-hosted-darwin.tar" -o toolbox.tar
tar -xf toolbox.tar
mv toolbox ~/.toolbox
bash ~/.toolbox/install-toolbox
source ~/.toolbox/toolbox
echo "source ~/.toolbox/toolbox" >> ~/.bash_profile
```

**3. Start the agent:**

```
agent start --endpoint semaphore.semaphoreci.com --token [token]
```

[agent-configuration]: ./configure-self-hosted-agent.md
[agent tokens]: ./self-hosted-agents-overview.md#tokens-used-for-communication
[releases-page]: https://github.com/semaphoreci/agent/releases
[docker without sudo]: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
[toolbox]: ./self-hosted-agents-overview.md#available-toolbox-features
[agent repo]: https://github.com/semaphoreci/agent