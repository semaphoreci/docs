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
This means that you will need to create a [new Semaphore 2.0 account][signup]. 
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

### How to check out my code?

In Semaphore Classic, your repository is automatically cloned into the job environment when the machine starts. However, in Semaphore 2, you have the option to use the [checkout][checkout] command to clone your repository.

Using `checkout` provides more control over the process and allows you to choose between full or shallow cloning, depending on your needs. Shallow cloning can be useful for large repositories as it only retrieves the latest commit, reducing the time it takes to clone the repository. In addition, `checkout` can be used to pull in external dependencies or submodules needed for your job. Overall, the `checkout` command provides greater flexibility and customization options than the automatic cloning approach used in Semaphore Classic.

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

```yaml
blocks:
  - name: Setup
    task:
      jobs:
        - name: bundle
          commands:
          - checkout
          # Restore dependencies from cache.
          - cache restore
          # Set Ruby version:
          - sem-version ruby 3.2.2
```

### Starting Databases and Other Services

In Semaphore Classic, databases and other services like Elasticsearch were automatically started when firing up a machine to run a job.
However, this led to significant overhead time. 
In Semaphore 2, services are not automatically started, but instead can be initiated manually using [sem-service][sem-service].

For example, to start Postgres version 13, you would simply run the command `sem-service start postgres 13`. 
This approach provides greater flexibility and control over which services are started for each job. 
It also results in faster startup times for the job, since only the necessary services are started.

Semaphore 2's approach to services is also beneficial in terms of cost savings. 
With Semaphore 2's à la carte pricing model, users can choose which services to start and only pay for the ones that they use, resulting in more efficient resource utilization and cost savings.

```yaml
  - name: Unit tests
    task:
      jobs:
        commands:
          - checkout
          - cache restore
          # Start Postgres database service.
          - sem-service start postgres 13
          - sem-version ruby 3.2.2
          - bundle install --deployment --path vendor/bundle
          - bundle exec rake db:setup
```

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

![Rails CI pipeline](https://github.com/semaphoreci-demos/semaphore-demo-ruby-rails/raw/master/public/ci-pipeline.png)

### How to manage my deployment?

In Classic, you typically used deployment servers to control the environment to which you wanted to deploy as well as the deployment credentials and instructions. In Semaphore 2, this and more is supported with [Deployment Targets][deployment-targets] and [Promotions][promotions].

Deployment targets provide multi-faceted access control that is fully configurable from the UI accessible from your project settings.

Promotions are independent pipelines, usually used for deployment, that can be attached to the main pipeline. Here, we combine them with Deployment Targets to have full control over the process and enhance security.

### Less assumptions, more transparency

S2 job logs provide much more information about your CI/CD environment in an
easy-to-use, full-page format. For example, you will see exactly how long it
takes Semaphore to start your job and all the details of environment
preparation.



[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
[machine-type]: https://docs.semaphoreci.com/ci-cd-environment/machine-types/
[caching]: https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/
[billing]: https://docs.semaphoreci.com/account-management/billing-faq/
[signup]: https://semaphoreci.com/signup
[pricing]: https://semaphoreci.com/pricing
[deployment-targets]: https://semaphoreci.com/blog/deployment-targets
[project-secrets]: https://semaphoreci.com/blog/project-secrets
[sem-version]: https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/
[secrets]: https://docs.semaphoreci.com/essentials/using-secrets/
[promotions]: https://docs.semaphoreci.com/essentials/deploying-with-promotions/
[faq]: https://docs.semaphoreci.com/faq/faq/
[checkout]: https://docs.semaphoreci.com/reference/toolbox-reference/#checkout
