---
Description: This guide describes how jobs can be isolated in a self-hosted environment.
---

# Self-hosted job environment isolation
!!! beta "Self-hosted agents - closed beta"
    Self-hosted agents are in closed beta. If you would like to run Semaphore agents on your infrastructure, please [contact us and share your use case](https://semaphoreci.com/contact). Our team will get back to you as soon as possible.

Even though some use cases might benefit from jobs sharing the same environment, for a few of them, a clean environment for each and every job might be needed.

## Using docker containers

Using docker containers is the fastest approach available. Creating, starting, stopping and destroying docker containers is a very fast operation, specially if you cache your docker images in the machine running the agent.

There are two different ways that Docker containers can be used by the agent:

- the agent itself can run inside a docker container. [disconnect-after-job][disconnect-after-job] can be used to instruct the agent to shutdown after a job is done.
- You can configure jobs to [use docker images][pipeline yaml], and also the self-hosted agent type of your choice. In this scenario, the agent won't run inside a Docker container. However, the agent will execute the jobs inside the container. This approach doesn't require [shutdown-hook-path][shutdown-hook-path] or [disconnect-after-job][disconnect-after-job].

**If you need a clean environment for every job, the recommended approach is to use Docker containers.**

## Using cloud instances

However, something other than a Docker container might be required. For instance, you may need to run your agents in AWS EC2 instances. In this case, you might need a combination of [shutdown-hook-path][shutdown-hook-path] and [disconnect-after-job][disconnect-after-job] to properly instruct the EC2 instance to terminate after a job is done.

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

In order to rotate instances and guarantee a clean environment for every job, we use the [AWS CLI][aws cli] to instruct the [auto scaling][autoscaling] group to terminate that EC2 instance once the agent shuts down. AWS will then replace that same EC2 instance with a new and clean one, and a new agent will start up.

One important thing to keep in mind here is that rotating AWS EC2 instances is not as fast as rotating docker containers. Therefore, to obtain the same level of availability, a pool containing a larger number of agents would need to be used.

[agent-aws-stack]: https://github.com/renderedtext/agent-aws-stack
[disconnect-after-job]: ../configure-self-hosted-agent#disconnect-after-job
[shutdown-hook-path]: ../configure-self-hosted-agent#shutdown-hook-path
[pipeline yaml]: ../../reference/pipeline-yaml-reference#example-of-containers-usage
[terminate-instance]: https://github.com/renderedtext/agent-aws-stack/blob/master/packer/ansible/roles/agent/files/terminate-instance.sh
[autoscaling]: https://docs.aws.amazon.com/autoscaling/
[aws cli]: https://docs.aws.amazon.com/cli/index.html
