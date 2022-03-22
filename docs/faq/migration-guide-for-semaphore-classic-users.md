---
Description: This guide outlines the key differences between Semaphore Classic and Semaphore 2.0, and provides you with instructions for migrating from Semaphore Classic to Semaphore 2.0.
---

# Migration guide for Semaphore Classic users

If you've used Semaphore prior to version to 2.0, this guide will outline the
key differences and show you how to migrate to the new version.

Even if you're a pro Semaphore user, we recommend that you read through the
[Guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) for
hands-on examples.

### Semaphore Classic and Semaphore 2.0 are distinct products

If you have an account on Semaphore Classic, you will need to create a new
account on Semaphore 2.0.

### You don't have to migrate

We know how much you rely on Semaphore to do your work and don't want to impose
an uncomfortable migration timeline. We don't currently have any plans to sunset Semaphore
Classic, and will continue to support it. However it won't receive any major new
features, as our R&D will be focused on Semaphore 2.0.

### Semaphore 2.0 is a superset of Semaphore Classic

Everything that you've been able to do with Semaphore Classic, you'll be
able to do with 2.0 — and much more.

The only features of Classic that are not currently present in 2.0 are Boosters
and Bitbucket support, which will be addressed soon.

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
boxes. Semaphore 2.0 adopts the ["pay only for what you use"](https://semaphoreci.com/pricing)
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

For a full introduction to Semaphore 2.0, we recommend that you read through the
[Guided tour](../guided-tour/getting-started.md).

[sem-service]: https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
