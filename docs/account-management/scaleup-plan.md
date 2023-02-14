---
Description: This page contains all the details regarding the Semaphore Scaleup plan, including pricing, machines available, and features that are included in the plan.
---

# Scaleup plan

The Scaleup plan is designed for large teams with ambitious growth goals. It provides access to the most advanced cloud resources and features available on Semaphore.

With a monthly subscription fee of **$1,800**, you receive an equal amount of credits that can be used for any combination of resources, including seats, cloud build minutes, self-hosted build minutes, artifacts storage, and premium support packages.

The subscription operates on a usage-based pricing model, allowing you to easily adjust your resource usage based on your team's changing needs.

## Subscription Details

At the start of each billing cycle, the base subscription fee of **$1,800** is added to your monthly bill and credited to your account.

These credits are part of a shared pool and can be distributed among your team's various resource needs, such as seats, build minutes, storage, and support packages.

The credits **are transferable**, so any unused credits will be carried over to the next billing period. However, there is a one-year limit on the credits, after which they will expire if not used.

Credit consumption is chronological, meaning that the oldest credits will be used first, followed by the next oldest, and so on.

For a detailed overview of how spending is calculated, please visit our [Billing Overview page](/account-management/billing-overview/).

## How to switch to Scaleup plan

If you are interested in the Scaleup plan please reach out to [customersuccess@semaphoreci.com](mailto:customersuccess@semaphoreci.com).

## Job Concurrency & Self-Hosted Agents

The Scaleup plan allows you to run an **unlimited** number of jobs in parallel and connect an **unlimited** number of self-hosted agents to your organization.  

**180,000** self-hosted agent minutes are available every month. Any additional self-hosted agent spending is charged for **$0.0005** per minute and additional usage is charged at **$0.0005** per minute.

There is a **soft limit of 150** on parallelism and self-hosted agents to protect customers and the platform from unexpected spikes in traffic. This limit can be increased **free of charge** by contacting support.

## Cloud Machine Types

In addition to the standard *E1 (Linux)* and *A1 (MacOS)* machines, the Scaleup plan also grants access to our more powerful *E2* and *F1* machine generations.

These machines offer increased memory and disk space, as well as improved build speeds of up to **25% (E2)** and **50% (F1)** respectively.

Check our [Machine Types page](/ci-cd-environment/machine-types/) for a detailed specification of each machine.

### Available Machine Types

| Generation | standard-2 | standard-4 | standard-8 |
| :--------: | :--------: | :--------: | :--------: |
| E1 (Linux) |     ✅      |     ✅      |     ✅      |
| E2 (Linux) |     ✅      |     ✅      |     ❌      |
| F1 (Linux) |     ✅      |     ✅      |     ❌      |
| A1 (MacOS) |     ❌      |     ✅      |     ❌      |

## Enterprise-level security

The Scaleup plan offers a set of advanced security features to meet the strictest security standards and regulations. In addition to the features available on other plans, Scaleup includes:

- **Audit logs**: Store logs in-app or stream them to an external location for better tracking and accountability.
- **Advanced Secrets Management**: Secure your organization and project secrets with additional restriction options.
- **Advanced Access Control**: Manage user access with improved role-based control and user group management.
- **IP Allow List**: Control from which IPs and IP range the app can be accessed to further enhance security.
- **OpenID Connect Support**: Establish a secure trust relationship between Semaphore and cloud providers for direct access with short-lived access tokens.
- **Okta Integration**: Manage user provisioning and authentication through your Okta account for streamlined security.
- **Restricted access to deployments**: this feature allows you to control who can initiate a deployment and under what circumstances in your workflows.

These enterprise-level security features are exclusively available on the Scaleup plan.

## See also

- [Billing Overview](/account-management/billing-overview/)
- [Billing FAQ](/account-management/billing-faq/)
- [Add-ons](/account-management/add-ons/)
