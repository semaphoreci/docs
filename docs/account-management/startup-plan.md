---
Description: This page contains all the details regarding the Semaphore Startup plan, including pricing, available machines, and the features that are included in the plan.
---

# Startup plan

The Startup plan is suitable for a wide range of organizations, whether you're just starting your CI/CD journey or growing your team. This plan represents a flexible solution that accommodates the needs of different types of organizations.

With a **$10 subscription fee**, you get access to the resources you need to get started. This plan operates on a usage-based pricing model, allowing you to easily scale your CI/CD operations without any limitations on machine minutes or number of team members.

## Subscription

The Startup subscription includes the following resources every month:

| Seats | Credits | Self-hosted minutes | Storage | Egress |
| :---: | :-----: | :-----------------: | :-----: | :----: |
|   5   |   $45   |       60,000        | 100 GB/month  | 30 GB  |

Any usage within these limits will not incur additional charges. However, you are not limited by these quotas, and you can generate additional spending depending on your organization's needs.

To understand how additional spending is calculated, please visit our [Billing Overview page](/account-management/billing-overview/).

### Seat cost

In addition to the 5 free seats provided in the Subscription, any additional seat used will be charged at **$15** per seat per month.

You can see how the seat pricing works in more detail in the [Seat billing overview](/account-management/billing-overview/#seats) section.

### Free credits

Your Startup subscription comes with **$45** of free credits every month. These credits equal to **6,000** minutes (*based on e1-standard-2 pricing*) of cloud machine time.

The free credits are applied to all additional spending, including machine time, seats, storage, and egress.

Please note that free credits are not transferable and will be reset at the start of each billing period.

## Job concurrency & self-hosted agents

On the Startup plan, you can run **up to 80 jobs** in parallel, regardless of the machine type.

Additionally, you can connect **up to 40** [self-hosted agents](/ci-cd-environment/self-hosted-agents-overview/) to your organization.

## Cloud machine types

In addition to the standard *E1 (Linux)* and *A1 (MacOS)* machines, the Startup plan also grants access to our more powerful *E2* and *F1* machine generations.

These machines offer increased memory and disk space, as well as improved build speeds of up to **25% (E2)** and **50% (F1)** respectively.

Check our [Machine Types page](/ci-cd-environment/machine-types/) for a detailed specification of each machine.

### Available Machine Types

| Generation | standard-2 | standard-4 | standard-8 |
| :--------: | :--------: | :--------: | :--------: |
| E1 (Linux) |     ✅      |     ✅      |     ✅      |
| E2 (Linux) |     ✅      |     ✅      |     ❌      |
| F1 (Linux) |     ✅      |     ✅      |     ❌      |
| A1 (MacOS) |     ❌      |     ✅      |     ❌      |

## Features and add-ons

The Startup plan provides access to advanced features to enhance your CI/CD strategy.

### Metrics and insights

Get a comprehensive view of your CI/CD performance with the [Project Insights](/score/project-insights/) feature. With Project Insights, you can monitor key metrics such as pipeline speed, deployment frequency, mean time to recovery, and pipeline failure rate.

Custom dashboards can also be created to track the metrics that matter most to your team.

### Complex CD workflows

Take your deployment strategy to the next level with the following features:

- **[Parameterized Promotions](/essentials/parameterized-promotions/)** - use the same deployment pipeline file for different environments by creating a promotion form and passing parameters to your promoted pipeline
- **Deployment Targets** - enjoy greater control over your deployments with the ability to limit which branches can be deployed and view the deployment history for each environment

### Project Secrets

In addition to organization-level secrets, this plan also includes access to project-level secrets. These secrets can only be viewed and updated by users with access to the project and cannot be used in jobs outside of that project.

### Add-ons

Optimize your CI/CD experience even further with add-ons such as a dedicated cache server, dedicated container registry, and Advanced or Premium Support packages.

For more information on available add-ons and how to enable them, visit our [add-ons page](/account-management/add-ons/).

## See also

- [Billing Overview](/account-management/billing-overview/)
- [Billing FAQ](/account-management/billing-faq/)
- [Scaleup plan](/account-management/scaleup-plan/)
- [Add-ons](/account-management/add-ons/)
