# Getting Started

Welcome to the guided tour of Semaphore! In this guide we help you get up and
running with Semaphore and introduce you to its key features. If you're new
to Semaphore or have limited Semaphore experience, then this is the best place
to start.

## What is Semaphore?

Semaphore is a cloud-based automation service for building, testing and
deploying software.

Developers use Semaphore to implement
[continuous integration (CI)](https://semaphoreci.com/continuous-integration) and
continuous delivery (CD) pipelines, which help get software from version
control right to users in a safe and automated way.

Semaphore is built for developer productivity, guided by two principles:

1. **Speed**: Developers must work in a fast feedback loop,
so CI/CD processes must be fast.
2. **Ease of use**: CI/CD tool needs to support developers in everything they
need to build, at any scale, and shouldn't get in the way.

Configuration files describe to Semaphore the
[CI/CD pipelines](https://semaphoreci.com/blog/cicd-pipeline) which need to run
based on Git repositories. Semaphore executes pipelines on every change in
code. As the configuration changes, Semaphore is able to determine what changed
and adapt the workflow accordingly.

In the background, Semaphore manages the hardware resources needed to run
CI/CD jobs just-in-time. It also maintains the base software environment in
which your code runs in secure isolation. With Semaphore, there is no software
to install or infrastructure to maintain in order to implement continuous
delivery in your organization.

## What sets Semaphore apart?

A combination of features make Semaphore a strong fit for teams that optimize
for getting things done:

- **Pipelines as code**: traditionally associated with tools that require
costly self-hosting and detailed customization, infinitely configurable CD
pipelines are now available in an easy to use package.
- **It's fastest there is**: Semaphore provides the best out of the box CI/CD
performance on the market, which means shorter development cycles and faster
innovation. Moving to Semaphore usually saves hours of precious time per week
per developer.
- **There's nothing to maintain**: with no resources to manage, scale and pay
for separately, developers can focus on building products. Semaphore has a
track record of providing a reliable CI/CD service since 2012.
- **No vendor lock-in**: Semaphore is committed to supporting all major code
hosting and cloud providers, leaving you freedom to choose optimal solutions.

## Semaphore Basics

In this section you can find a short overview of Semaphore and the way it works. 

### Pipelines, Blocks, Jobs

The basic building block is a pipeline:

![Pipelines, Blocks, Jobs](https://storage.googleapis.com/semaphore-public-assets/public/pipelines-blocks-jobs.png)

Pipelines are made of sequential blocks. Each block may contain a single job,
or multiple parallel jobs.

For more advanced use cases, pipelines may also run in parallel and depend on 
each other.

![Complex Pipeline](https://storage.googleapis.com/semaphore-public-assets/public/complex-pipeline.png)

For more details, go to the [Blocks & Tasks](https://docs.semaphoreci.com/guided-tour/concepts/#blocks-tasks) page. 

### Promotions

You can model your continuous delivery process by connecting pipelines with 
promotions.

![Promotions](https://storage.googleapis.com/semaphore-public-assets/public/promotions.png)

Promotions can be triggered manually or automatically on certain conditions, 
like pipeline result, Git branch or tag.

There’s no limit in how many pipelines and promotions your workflow can have.

For more details, visit the [Promotions](https://docs.semaphoreci.com/guided-tour/concepts/#promotions) page.

### Workflow Builder

Semaphore configuration lives in YAML files in the `.semaphore` directory of 
your Git repository. You can find some snippets of YAML for illustrative 
purposes in further text. 

But, we know that writing YAML from scratch is hard. So Semaphore has a visual 
Workflow Builder so that you can easily create and edit configuration files for 
your project:

![Workflow Builder](https://storage.googleapis.com/semaphore-public-assets/public/workflow-builder.png)

You can see how the Workflow Builder works in [this video](https://www.youtube.com/watch?v=5u3NDj0xBm0&feature=emb_title).

### Agents

Agents specify the hardware and software entry point for your commands.

**Hardware**: Most projects will be fine with the default e1-standard-2 Linux 
(2vCPUs, 4GB RAM) and a1-standard-4 Mac (4 vCPUs, 8GB RAM) machine types.

**Software**: You can use Semaphore's Linux or macOS VMs with conveniently preinstalled 
software:

``` yaml
agent:
    machine:
        type: e1-standard-2
        os_image: ubuntu1804
agent:
    machine:
        type: a1-standard-4
        os_image: macos-mojave
```

Or you can run your own environment, defined with one or multiple Docker 
containers:

``` yaml
agent:
    machine:
    type: e1-standard-2
    containers:
        - name: main
          image: semaphoreci/ruby:2.6.1
        - name: cache
          image: redis:5.0
```

For more info, take a look at the [Agents, Machines and Containers](https://docs.semaphoreci.com/guided-tour/concepts/#agents-machines-and-containers) page.

### Caching

Every job runs in a fresh, isolated virtual machine. Caching is a way to reuse 
project dependencies across pipeline stages

``` yaml
cache restore
npm install
bundle install --path .bundle
cache store
```

Cache is scoped per project and can store up to 9GB of files.

You can read more about it on the [Caching](https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/) page.

### Artifacts

Artifacts is permanent storage for files that you want to deliver to users or 
reference yourself later. For example:

- A binary of your app
- A build of your static website
- Screenshots and logs of failed tests

![Artifacts](https://storage.googleapis.com/semaphore-public-assets/public/artifacts.png)

Semaphore also provides a Docker registry that’s private to your organization, 
to save you time and network bandwidth.

You can find out more info on the [Artifacts](https://docs.semaphoreci.com/essentials/artifacts/) page.

### Secrets

Secrets help your CI/CD pipelines talk to the outside world.

It's a secure way of storing private information like API keys, or configuration 
files — things that shouldn't be committed to source control.

![Secrets](https://storage.googleapis.com/semaphore-public-assets/public/secrets.png)

Secrets are scoped to organization. Make them available by listing them within 
a pipeline or block:

``` yaml
blocks:
  - name: Deploy
    task:
    secrets:
      - name: deploy-secrets
    jobs:
        - name: Push to production
        commands:
        - echo "$CLOUD_ACCESS_KEY_ID"
```

For more info, check out the [Secrets](https://docs.semaphoreci.com/guided-tour/concepts/#secrets) page.

### Debugging

Sometimes your pipelines will fail, and at first you won't know why.

In that case debugging via SSH is a lifesaver.

Every job has a "Debug" button with instructions for installing the Semaphore CLI 
and SSH-ing into your job.

![Debugging](https://storage.googleapis.com/semaphore-public-assets/public/debug.png)

You can find more info on the [Debugging with SSH Access](https://docs.semaphoreci.com/essentials/debugging-with-ssh-access/) page.

The CLI can do many more things which you can read more about on the [sem CLI Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/) 
page or explore on your own.

## Next steps

It's time to [create your first project][next] using an example Semaphore
configuration file. You will be able to see Semaphore in action first before
customizing it for your use case.

[next]: https://docs.semaphoreci.com/article/63-your-first-project

If you want to find out more about the product and participate in a live Q&A
session with one of Semaphore's co-founders, you can register for 
Semaphore Class. [More info here](https://semaphoreci.com/learn/class).
