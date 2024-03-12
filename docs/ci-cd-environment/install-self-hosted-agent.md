---
Description: This guide describes how to install a self-hosted agent on various operating systems and architectures.
---

# Installing a self-hosted agent

!!! plans "Available on: <span class="plans-box">[Free & OS](/account-management/discounts/)</span> <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

The Semaphore agent is open source and can be found [here][agent repo]. Before installing it on your machine, you need to make sure the following requirements are also available:

- git
- bash (Linux/MacOS) or PowerShell (Windows)
- docker - [manageable without sudo][docker without sudo] (Linux/MacOS)
- docker-compose (Linux/MacOS)

Please, follow the installation instructions for your operating system of choice below.

## Installing the agent on Ubuntu/Debian

**1. Prepare your machine:**

```bash
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER:$USER /opt/semaphore/agent/
cd /opt/semaphore/agent
```

**2. Download the agent:**

```bash
curl -L https://github.com/semaphoreci/agent/releases/download/v2.2.16/agent_Linux_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
```

**3. Install the agent:**

```bash
sudo ./install.sh
```

The script asks for your Semaphore organization name, the [agent type registration token][agent tokens], the Linux user used to run the service, and does the following:

- downloads and installs the [Semaphore toolbox][toolbox]
- creates a systemd service for the agent
- creates an initial `config.yaml` file in the installation directory for you to manage [agent configuration][agent-configuration]

Note that any changes in the agent configuration file require a restart of the systemd service.

**4. Configure GitHub SSH keys**:

In order to use the [checkout][checkout] command, GitHub's SSH keys must be added to SSH known hosts for the user running the agent. You can check how to do that on Linux [here](#configure-github-ssh-keys-on-linux).

## Installing the agent on generic Linux

**1. Prepare your machine:**

```bash
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER:$USER /opt/semaphore/agent/
cd /opt/semaphore/agent
```

**2. Download the agent:**

```bash
curl -L https://github.com/semaphoreci/agent/releases/download/v2.2.16/agent_Linux_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
```

**3. Create the agent configuration file:**

```bash
cat > config.yaml <<EOF
endpoint: "[your-organization-name].semaphoreci.com"
token: "[token]"
EOF
```

**4. Download and install the [toolbox][toolbox]:**

```bash
curl -L "https://github.com/semaphoreci/toolbox/releases/latest/download/self-hosted-linux.tar" -o toolbox.tar
tar -xf toolbox.tar
mv toolbox ~/.toolbox
bash ~/.toolbox/install-toolbox
source ~/.toolbox/toolbox
echo "source ~/.toolbox/toolbox" >> ~/.bash_profile
```

**5. Configure GitHub SSH keys**:

In order to use the [checkout][checkout] command, GitHub's SSH keys must be added to SSH known hosts for the user running the agent. You can check how to do that on Linux [here](#configure-github-ssh-keys-on-linux).

**6. Run the agent:**

```bash
agent start --config-file config.yaml
```

## Installing the agent on MacOS

**1. Prepare your machine:**

```bash
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER /opt/semaphore/agent/
cd /opt/semaphore/agent
```

**2. Download the agent:**

```bash
curl -L https://github.com/semaphoreci/agent/releases/download/v2.2.16/agent_Darwin_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
```

**3. Install the agent:**

```bash
sudo ./install.sh
```

The script asks for your Semaphore organization name, the [agent type registration token][agent tokens], the macOS user used to run the agent, and does the following:

- downloads and installs the [Semaphore toolbox][toolbox]
- creates a launchd daemon for the agent
- creates an initial `config.yaml` file in the installation directory for you to manage [agent configuration][agent-configuration]

Note that any changes in the agent configuration file require a restart of the launchd daemon.

**4. Configure GitHub SSH keys**:

In order to use the [checkout][checkout] command, GitHub's SSH keys must be added to SSH known hosts for the user running the agent. You can check how to do that on MacOS [here](#configure-github-ssh-keys-on-macos).

## Installing the agent on MacOS using Homebrew

**1. Install the agent using Homebrew:**

```bash
brew install semaphoreci/tap/agent
```

**2. Download and install the [toolbox][toolbox]:**

When installing the agent using Homebrew, the toolbox isn't installed. You need to manually install it:

```bash
curl -L "https://github.com/semaphoreci/toolbox/releases/latest/download/self-hosted-darwin.tar" -o toolbox.tar
tar -xf toolbox.tar
mv toolbox ~/.toolbox
bash ~/.toolbox/install-toolbox
source ~/.toolbox/toolbox
echo "source ~/.toolbox/toolbox" >> ~/.bash_profile
```

**3. Configure GitHub SSH keys**:

In order to use the [checkout][checkout] command, GitHub's SSH keys must be added to SSH known hosts for the user running the agent. You can check how to do that on MacOS [here](#configure-github-ssh-keys-on-macos).

**4. Start the agent:**

```bash
agent start --endpoint semaphore.semaphoreci.com --token [token]
```

## Installing the agent on Windows

**1. Prepare your machine:**

```
New-Item -ItemType Directory -Path C:\semaphore-agent
Set-Location C:\semaphore-agent
```

**2. Download the agent:**

```
Invoke-WebRequest "https://github.com/semaphoreci/agent/releases/download/v2.2.16/agent_Windows_x86_64.tar.gz" -OutFile agent.tar.gz
tar.exe xvf agent.tar.gz
```

**3. Install the agent:**

```
$env:SemaphoreEndpoint = "<your-organization>.semaphoreci.com"
$env:SemaphoreRegistrationToken = "<your-agent-type-registration-token>"
.\install.ps1
```

## Configure GitHub SSH keys

The GitHub SSH keys can be fetched from [GitHub's meta API][GH meta API].

### Configure GitHub SSH keys on Linux

```bash
# Create the ~/.ssh folder for the user
# running the agent, if it doesn't exist yet.
mkdir -p /home/$USER/.ssh

# Fetch GitHub SSH keys from api.github.com/meta
# and put them into ~/.ssh/known_hosts
curl -sL https://api.github.com/meta | jq -r ".ssh_keys[]" | sed 's/^/github.com /' | sudo tee -a /home/$USER/.ssh/known_hosts
sudo chown $USER:$USER /home/$USER/.ssh
```

### Configure GitHub SSH keys on MacOS

```bash
# Create the ~/.ssh folder for the user
# running the agent, if it doesn't exist yet.
mkdir -p /home/$USER/.ssh

# Fetch GitHub SSH keys from api.github.com/meta
# and put them into ~/.ssh/known_hosts
curl -sL https://api.github.com/meta | jq -r ".ssh_keys[]" | sed 's/^/github.com /' | sudo tee -a /home/$USER/.ssh/known_hosts
sudo chown $USER: /home/$USER/.ssh
```

[agent-configuration]: ./configure-self-hosted-agent.md
[agent tokens]: ./self-hosted-agents-overview.md#tokens-used-for-communication
[releases-page]: https://github.com/semaphoreci/agent/releases
[docker without sudo]: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
[toolbox]: ./self-hosted-agents-overview.md#available-toolbox-features
[agent repo]: https://github.com/semaphoreci/agent
[checkout]: /reference/toolbox-reference/#checkout
[GH meta API]: https://docs.github.com/en/rest/meta/meta#get-github-meta-information
