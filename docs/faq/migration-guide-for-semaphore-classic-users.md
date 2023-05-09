---
Description: This guide outlines the key differences between Semaphore Classic and Semaphore 2.0, and provides you with instructions for migrating from Semaphore Classic to Semaphore 2.0.
---

# Migration guide for Semaphore Classic users

Welcome to the migration guide from Semaphore Classic to Semaphore 2. 
We’ve crafted this guide based on frequently asked questions we’ve received from already migrated happy customers. 
So you can have a transition experience as smoothly as possible.

By the end of this document, you’ll understand how to replicate the basic CI/CD functionalities from your Semaphore Classic projects into Semaphore 2. 

Even if you're a pro Semaphore user, we recommend that you read through the
[guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) for
hands-on examples.

### Semaphore Classic and Semaphore 2.0 are distinct products

Semaphore 2.0 is a superset of Semaphore Classic. Everything that you've been able to do with Semaphore Classic, 
you'll be able to do with 2.0 — and much more.

The only Classic feature that isn't currently present in 2.0 is Boosters, 
which will be addressed soon.

A key aspect to consider is that you will need to create a Semaphore 2.0 account. 
Semaphore Classic accounts and organization's historic data won't be migrated over.

Other important elements to consider are as follow:

- Semaphore 2.0 stores the pipeline configuration in a YML file that lives in `.semaphore` in your repository. 
In contrast, Semaphore Classic stores the pipeline configuration in the UI via the Project Settings.
- [Newer generation of machines][machine-type] to choose from.
- More flexible [caching mechanism][caching].
- Different [billing system][billing] with pay-as-you-go model.
- Have a better overview of your deployment strategies and secrets storage with [deployment targets][deployment-targets] and [project secrets][project-secrets].

But no worries, in this article we'll dive into these elements individually.

### Billing

Before we continue migrating the projects let's make sure you have created a Semaphore 2.0 account. 
You can sign up here on [this link][signup].

You can choose between our [new pricing][pricing] or keeping the Semaphore Classic pricing.
If you're interested in keeping your current pricing, 
send us a message to support@semaphoreci.com and we’ll take care of it.


### Pipelines can orchestrate any workflow

Semaphore 2.0 gives you unlimited flexibility in automating CI/CD workflows. You
can still run simple builds easily, and you can also run multi-stage builds, each
with its own configuration.

Servers on Semaphore Classic have been superseded by
[promotions](https://docs.semaphoreci.com/essentials/deploying-with-promotions/)
in Semaphore 2.0. Promotions connect different pipelines together, with optional 
conditions. For example, you could set up an auto-promotion on the master branch 
that triggers deployment to production and runs smoke tests, and a manual promotion 
for any branch which deploys to the staging environment.

### All configuration is in YML and executed in the command line

You'll primarily interact with Semaphore 2.0 as you do with your other development
tools and platforms, using the command line.

In most cases, you'll migrate your projects from Semaphore Classic by copying
your build and deploy commands to YAML files and moving your environment variables 
and configuration files to [secrets](../essentials/environment-variables.md).

As you explore the [sem command line tool](https://docs.semaphoreci.com/reference/sem-command-line-tool/),
you'll discover how much more you can do in Semaphore 2.0. Things like running
one-off jobs and attaching to live-running jobs is just one command away.

### Pay only for what you use with auto-scaling

In Semaphore Classic, your CI/CD capacity was fixed to a certain number of
boxes. Semaphore 2.0 adopts the ["pay only for what you use"][pricing]
cloud model, in which CI/CD resources scale automatically to support your
team’s actual needs.

S2 also introduces several machine types with different CPU/memory capacity,
for use in your pipelines.

### Less assumptions, more transparency

Because you can use Semaphore 2.0 to automate just about anything with code, it
doesn't make assumptions about what you might want to do in each stage of your
pipelines, i.e. this does not happen automatically:

- S2 doesn't check out code: use the [`checkout` command](https://docs.semaphoreci.com/reference/toolbox-reference/#libcheckout).

- Databases and other services are disabled by default: use [`sem-service`
  tool][sem-service]
  to start them.

- Dependencies are not cached by default: see the
  [caching guide](https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/)
  and examples in the Programming Languages category.

S2 job logs provide much more information about your CI/CD environment in an
easy-to-use, full-page format. For example, you will see exactly how long it
takes Semaphore to start your job and all the details of environment
preparation.


[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
[machine-type]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[caching]: https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/
[billing]: https://docs.semaphoreci.com/account-management/billing-overview/
[signup]: https://semaphoreci.com/signup
[pricing]: https://semaphoreci.com/pricing
[deployment-targets]: https://semaphoreci.com/blog/deployment-targets
[project-secrets]: https://semaphoreci.com/blog/project-secrets
