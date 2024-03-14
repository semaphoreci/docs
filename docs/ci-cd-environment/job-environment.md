---
Description: This guide describes how commands in a job are executed and how jobs can be isolated in a self-hosted environment.
---

# Job environment

!!! plans "Available on: <span class="plans-box">[Startup - Hybrid]([/account-management/discounts/](https://semaphoreci.com/pricing))</span> <span class="plans-box">[Scaleup - Hybrid]([/account-management/discounts/](https://semaphoreci.com/pricing))</span>"

The commands in a job are executed differently depending on the operating system where the Semaphore agent is running:

- On Linux, a new PTY session is created at the beginning of every job, and all the commands are executed in that session.
- On Windows, a PTY session is not used and each command is executed in a new PowerShell process with `powershell -NonInteractive -NoProfile`.

!!! info "Alias usage on Windows"
    On Windows, each command in a job is executed in a new non-interactive PowerShell process without profiles, so the only way to have aliases available to commands is through PowerShell modules.

## Job isolation

Even though some use cases might benefit from jobs sharing the same environment, a clean environment for each and every job might be needed for others.

### Using docker containers

Using docker containers is the fastest approach available. Creating, starting, stopping, and destroying docker containers is a very fast operation, especially if you cache your docker images in the machine running the agent.

There are two different ways that Docker containers can be used by an agent:

- the agent itself can run inside a docker container. [disconnect-after-job][disconnect-after-job] can be used to instruct the agent to shutdown after a job is done.
- You can configure jobs to [use docker images][pipeline yaml] and the self-hosted agent type of your choice. In this scenario, the agent won't run inside a Docker container, rather it will execute jobs inside the container. This approach doesn't require [shutdown-hook-path][shutdown-hook-path] or [disconnect-after-job][disconnect-after-job].

**If you need a clean environment for every job, the recommended approach is to use Docker containers.**

### Using cloud instances

Sometimes, something other than a Docker container might be required. For instance, you may need to run your agents in AWS EC2 instances. In this case, you might need a combination of [shutdown-hook-path][shutdown-hook-path] and [disconnect-after-job][disconnect-after-job] to properly instruct the EC2 instance to terminate after a job is done.

A part of the [shutdown-hook-path][terminate-instance] script used by [agent-aws-stack][agent-aws-stack] and executed when an agent shuts down after a job is finished is shown below:

```bash
if [[ $SEMAPHORE_AGENT_SHUTDOWN_REASON == "IDLE" ]]; then
  aws autoscaling terminate-instance-in-auto-scaling-group \
    --region "$region" \
    --instance-id "$instance_id" \
    --should-decrement-desired-capacity
else
  aws autoscaling terminate-instance-in-auto-scaling-group \
    --region "$region" \
    --instance-id "$instance_id" \
    --no-should-decrement-desired-capacity
fi
```

In order to rotate instances and guarantee a clean environment for every job, you can use the [AWS CLI][aws cli] to instruct the [auto scaling][autoscaling] group to terminate the EC2 instance once the agent shuts down. AWS will then replace the EC2 instance with a new, clean one and a new agent will start up.

!!! info "EC2 instance rotation"
    Keep in mind that rotating AWS EC2 instances is not as fast as rotating Docker containers.

[agent-aws-stack]: https://github.com/renderedtext/agent-aws-stack
[disconnect-after-job]: ../configure-self-hosted-agent#disconnect-after-job
[shutdown-hook-path]: ../configure-self-hosted-agent#shutdown-hook-path
[pipeline yaml]: ../../reference/pipeline-yaml-reference#example-of-containers-usage
[terminate-instance]: https://github.com/renderedtext/agent-aws-stack/blob/master/packer/ansible/roles/agent/files/terminate-instance.sh
[autoscaling]: https://docs.aws.amazon.com/autoscaling/
[aws cli]: https://docs.aws.amazon.com/cli/index.html
[checkout script]: https://github.com/semaphoreci/toolbox/blob/master/Checkout.psm1
