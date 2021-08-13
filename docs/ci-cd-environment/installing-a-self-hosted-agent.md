---
description: This guide describes how to install a self hosted agent on various different operating systems and architectures.
---

# Installing a Self Hosted Agent

The agent is open-source and can be found at https://github.com/semaphoreci/agent. Currently, the agent is available for the following OS and architectures:

- Linux_arm64
- Linux_armv6
- Linux_i386
- Linux_x86_64

## Installing the agent on Ubuntu/Debian

If you're using ubuntu/debian, you can benefit from systemd. The agent is packed with an installation script which creates a systemd service for you:

```
sudo mkdir -p /opt/semaphore/agent
sudo chown $USER:$USER /opt/semaphore/agent/
cd /opt/semaphore/agent
curl -L https://github.com/semaphoreci/agent/releases/download/v2.0.11/agent_Linux_x86_64.tar.gz -o agent.tar.gz
tar -xf agent.tar.gz
sudo ./install.sh
```

The scripts will ask for your Semaphore organization, the agent type registration token and the linux user to use to run the service. After that, it creates the systemd service and starts it up. It will also create a `config.yaml` file in the installation directory for you to manage the [agent configuration][agent-configuration].

Note: any changes in the configuration file require a restart of the systemd service.

[agent-configuration]: ../ci-cd-environment/configuring-a-self-hosted-agent.md
