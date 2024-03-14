---
Description: This guide describes how to set up a fleet of self-hosted agents in your Kubernetes cluster
---

# Kubernetes support

!!! plans "Available on: <span class="plans-box">[Startup - Hybrid]([/account-management/discounts/](https://semaphoreci.com/pricing))</span> <span class="plans-box">[Scaleup - Hybrid]([/account-management/discounts/](https://semaphoreci.com/pricing))</span>"

If you intend to run your agents on a Kubernetes cluster, the Semaphore custom controller Helm chart provided [here][helm-charts] can help you deploy an on-demand fleet of agents on your Kubernetes cluster.

## Adding the renderedtext Helm repo

Helm must be available to use the charts. Once Helm is available, you can add the `renderedtext` repo with:

```
helm repo add renderedtext https://renderedtext.github.io/helm-charts
```

You can use `helm search repo renderedtext` to see the charts available.

## Installing the Semaphore controller

The [agent-k8s-controller][agent-k8s-controller] is a custom Kubernetes controller that helps you run Semaphore jobs on your cluster. To install it, you can use Helm:

```bash
helm upgrade --install semaphore-controller renderedtext/controller \
  --namespace semaphore \
  --create-namespace \
  --set endpoint=<your-organization>.semaphoreci.com \
  --set apiToken=<your-api-token>
```

The `apiToken` parameter is a [Semaphore API token][API token]. It is used by the controller to inspect the Semaphore job queue.

## Starting jobs for a self-hosted agent type

The controller automatically detects which agent types to monitor by looking at the secrets available in the namespace it is running on. To start monitoring the queue and creating jobs for an agent type, you need to create a Kubernetes secret with the necessary information for the controller to spin new agents for that agent type.

You can follow the guide [here][create agent type] to create an agent type. After doing so, you can start creating jobs for it by creating a secret like this:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-semaphore-agent-type
  namespace: semaphore
  labels:
    semaphoreci.com/resource-type: agent-type-configuration
stringData:
  agentTypeName: s1-my-agent-type
  registrationToken: <agent-type-registration-token>
```

Note the `semaphoreci.com/resource-type=agent-type-configuration` label. That's how the controller knows this secret has the information needed to start agents for a Semaphore agent type. After creating that secret, the controller will start monitoring its job queue, and once a job appears, the controller will create an agent to run it.

## Further configuration

The Helm chart provides a few additional configuration options so you can tweak your installation to best suit your needs. You can see all of them with `helm show values renderedtext/controller`. More information is also available in the [chart repo][controller chart].

## Semaphore agent Kubernetes executor

The Semaphore custom controller Helm chart makes it easier to run the [Semaphore agent][semaphore agent] in a Kubernetes environment. If you want to know more details about how the Semaphore agent creates the Kubernetes resources for the job, you can read the [agent documentation][kubernetes executor].

[helm-charts]: https://github.com/renderedtext/helm-charts
[controller chart]: https://github.com/renderedtext/helm-charts/tree/main/charts/controller
[semaphore agent]: https://github.com/semaphoreci/agent
[agent-k8s-controller]: https://github.com/renderedtext/agent-k8s-controller
[kubernetes executor]: https://github.com/semaphoreci/agent/blob/master/docs/kubernetes-executor.md
[API token]: /reference/api-v1alpha/#authentication
[create agent type]: /ci-cd-environment/self-hosted-agent-types/
