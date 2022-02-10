---
Description: This guide describes how jobs can be isolated in a self-hosted environment.
---

# Self-hosted job environment isolation
!!! beta "Self-hosted agents - closed beta"
    Self-hosted agents are in closed beta. If you would like to run Semaphore agents on your infrastructure, please [contact us and share your use case](https://semaphoreci.com/contact). Our team will get back to you as soon as possible.

Even though some use cases might benefit from jobs sharing the same environment, for a few of them, a pristine environment for each and every job might be needed.

## Using docker containers

Using docker containers is the fastest approach available. Creating, starting, stopping and destroying docker containers is a very fast operation, specially if you cache your docker images in the machine running the agent.

There's two different ways docker containers can be used by the agent:

- the agent itself can run inside a docker container and [disconnect-after-job][disconnect-after-job] can be used to tell it to shutdown after a job is done.
- jobs can be configured to [use docker images][pipeline yaml], and the self-hosted agent type of your choice. In this scenario, the agent itself doesn't run in a docker container, but the jobs executed by it will. [shutdown-hook-path][shutdown-hook-path] or [disconnect-after-job][disconnect-after-job] are not required if you are doing this, since the jobs are already running in a pristine environment even if the agent is not.

Either way you choose, using docker containers is the recommended approach if you need a pristine environment for every job.

## Using cloud instances

However, something other than a Docker container might be required. For instance, you may need to run your agents in AWS EC2 instances. In this case, a combination of [shutdown-hook-path][shutdown-hook-path] or [disconnect-after-job][disconnect-after-job] would need to be used to properly instruct the EC2 instance to terminate after a job is done.

This is exactly what the [agent-aws-stack][agent-aws-stack] does. Here's a part of the [shutdown-hook-path][terminate-instance] script executed when an agent shuts down after a job:

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

In order to rotate instances and guarantee a pristine environment for every job, we use the [AWS CLI][aws cli] to tell the [auto scaling][autoscaling] group to terminate that EC2 instance once the agent shuts down. AWS will then replace that same EC2 instance with a new and pristine one, and a new agent will start up.

One important thing to keep in mind here is that rotating AWS EC2 instances is not as fast as rotating docker containers. Therefore, to obtain the same level of availability, a pool containing a larger number of agents would need to be used.

[agent-aws-stack]: https://github.com/renderedtext/agent-aws-stack
[disconnect-after-job]: ../configure-self-hosted-agent#disconnect-after-job
[shutdown-hook-path]: ../configure-self-hosted-agent#shutdown-hook-path
[pipeline yaml]: ../../reference/pipeline-yaml-reference#example-of-containers-usage
[terminate-instance]: https://github.com/renderedtext/agent-aws-stack/blob/master/packer/ansible/roles/agent/files/terminate-instance.sh
[autoscaling]: https://docs.aws.amazon.com/autoscaling/
[aws cli]: https://docs.aws.amazon.com/cli/index.html
