---
Description: This guide describes how to set up a fleet of self-hosted agents in your Kubernetes cluster
---

# Kubernetes support

!!! plans "Available on: <span class="plans-box">[Free & OS](/account-management/discounts/)</span> <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

If you intend to run your agents on a Kubernetes cluster, the Helm charts provided [here][helm-charts] can help you deploy an auto-scaling fleet of agents on your Kubernetes cluster.

## Usage

Helm must be available to use the charts. Once Helm is available, you can add the `renderedtext` repo with:

```
helm repo add renderedtext https://renderedtext.github.io/helm-charts
```

You can use `helm search repo renderedtext` to see the charts. Currently, two charts are provided:

- [agent][agent chart]
- [external-metrics-server][external-metrics-server]

## `agent` chart

This is the main Helm chart for the Semaphore agent installation. If autoscaling is not needed for your use case, this is the only Helm chart you need to install. However, if autoscaling is required for your use case, the [external-metrics-server](#external-metrics-server-chart) Helm chart also needs to be installed.

More details can be found at the [chart's README][agent chart].

## `external-metrics-server` chart

This Helm chart install a [custom metrics server][k8s-metrics-apiserver] to expose an external metrics provider. The provider will fetch Semaphore metrics and expose them to a [Kubernetes HorizontalPodAutoscaler][k8s hpa], which will use them to scale the agents accordingly. More details can be found [here][autoscaling details].

## Semaphore agent Kubernetes executor

The Helm charts provided above make it easier to run the [Semaphore agent][semaphore agent] in a Kubernetes environment. In other words, the charts make it easier to use the Semaphore agent Kubernetes executor. If you want to know more details about how that executor works, you can read the [agent documentation][kubernetes executor].

[helm-charts]: https://github.com/renderedtext/helm-charts
[agent chart]: https://github.com/renderedtext/helm-charts/blob/main/charts/agent
[external-metrics-server]: https://github.com/renderedtext/helm-charts/tree/main/charts/external-metrics-server
[k8s-metrics-apiserver]: https://github.com/renderedtext/k8s-metrics-apiserver
[k8s hpa]: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
[autoscaling details]: https://github.com/renderedtext/helm-charts/tree/main/charts/agent#autoscaling
[semaphore agent]: https://github.com/semaphoreci/agent
[kubernetes executor]: https://github.com/semaphoreci/agent/blob/master/docs/kubernetes-executor.md
