---
Description: This guide outlines the key differences between Semaphore Classic and Semaphore 2.0, and provides you with instructions for migrating from Semaphore Classic to Semaphore 2.0.
---

# Migration guide for Semaphore Classic users

Welcome to the migration guide from Semaphore Classic to Semaphore 2. 
We understand that switching to a new platform can be a daunting task, 
but we’re here to help you every step of the way. In this guide, 
we’ll walk you through the process of replicating your basic CI/CD functionalities from Semaphore Classic projects into Semaphore 2.

This guide has been crafted based on frequently asked questions we’ve received from already migrated happy customers. 
We want to ensure that you have a smooth transition experience.

Even if you're a pro Semaphore user, we recommend that you read through the
[guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) for
hands-on examples.

### Semaphore Classic and Semaphore 2.0 are distinct products

Semaphore 2.0 is a superset of Semaphore Classic. 
Everything that you've been able to do with Semaphore Classic, you'll be able to do with 2.0 — and much more. 
Semaphore 2.0 offers more flexible features, better performance, and an enhanced user experience.

It's important to note that Semaphore Classic and Semaphore 2.0 are distinct products. 
This means that you will need to create a new Semaphore 2.0 account. 
Semaphore Classic accounts and organization's historic data won't be migrated over.

Here are some key aspects to consider:

- Semaphore 2.0 stores the pipeline configuration in a YML file that lives in `.semaphore` in your repository. 
In contrast, Semaphore Classic stores the pipeline configuration in the UI via the Project Settings.
- Semaphore 2.0 offers a [newer generation of machines][machine-type] to choose from.
This means you'll have access to faster build times and better performance.
- Semaphore 2.0 offers a more flexible [caching mechanism][caching]. 
This means that you can cache specific directories or files and have more control over how your cache is used.
- Semaphore 2.0 has a different [billing system][billing] with pay-as-you-go model.
This means you only pay for what you use, making it more cost-effective for smaller projects. 
You can choose between our new pricing or keeping the Semaphore Classic pricing. 
If you're interested in keeping your current pricing, send us a message to support@semaphoreci.com and we’ll take care of it.
- Semaphore 2.0 offers a better overview of your deployment strategies and secrets storage with [deployment targets][deployment-targets] and [project secrets][project-secrets].

In this article, we'll dive into these elements individually and provide step-by-step instructions 
on how to migrate your projects from Semaphore Classic to Semaphore 2.0.

### How to select an agent for my job?

In Semaphore Classic, you can select your platform from the Project Settings. 
In Semaphore 2, you can configure the agent by selecting the OS and machine type in the Visual Builder or directly in your `.semaphore/semaphore.yml` pipeline configuration file using the `machine` attribute:

```yaml
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
```

### How to select a language for my project?

In Classic, you pick the language version you need from the Project Settings. 
Semaphore 2 uses the `sem-version` tool to facilitate this process since it [supports several languages][sem-version] with different versions. 
For example, to select Ruby version 3.2.2, you would run `sem-version ruby 3.2.2`.

### How to cache?

Semaphore Classic caches a few directories automatically, but it doesn’t offer an easy way to selectively cache directories or files depending on the language used. 
Semaphore 2 solves this problem with a more flexible [caching mechanism][caching]. 
By calling `cache store` for uploads and `cache restore` for downloads in your pipeline configuration file, Semaphore will take care of the rest depending on the language used.

### How to create secrets?

In Semaphore Classic, you could create secrets in your organization's page. 
In Semaphore 2, it’s possible to create [project and organization-level secrets][secrets] that can contain both environment variables and configuration files. 
You can access these options from the project or the organization settings.

### How to model my pipeline?

In Semaphore Classic, you could only work with one block that contained one or more jobs running in parallel. 
Semaphore 2 allows you to model pretty much any pipeline you want. 
You can create multiple blocks with several jobs and all of this can run sequentially and/or in parallel. 
Creating rich pipelines has never been easier than with the Visual Builder.

### How to manage my deployment?

In Classic, you typically used deployment servers to control the environment to which you wanted to deploy as well as the deployment credentials and instructions. In Semaphore 2, this and more is supported with [Deployment Targets][deployment-targets] and [Promotions][promotions].

Deployment targets provide multi-faceted access control that is fully configurable from the UI accessible from your project settings.

Promotions are independent pipelines, usually used for deployment, that can be attached to the main pipeline. Here, we combine them with Deployment Targets to have full control over the process and enhance security.

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
[sem-version]: https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/
[secrets]: https://docs.semaphoreci.com/essentials/using-secrets/
[promotions:] https://docs.semaphoreci.com/essentials/deploying-with-promotions/
