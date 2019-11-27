# Migration guide for Semaphore Classic users

If you've used Semaphore prior to version to 2.0, this guide will outline the
key differences and provide you with a direction to migrate to the new product.

Even if you're a pro Semaphore user, we recommend that you read through the
[Guided tour](https://docs.semaphoreci.com/article/77-getting-started) for
hands-on examples.

### Semaphore Classic and Semaphore 2.0 are distinct products

If you have an account on Semaphore Classic, you will need to create a new
account on Semaphore 2.0.

### You don't have to migrate

We know how much you rely on Semaphore to do your work and don't want to impose
an uncomfortable migration timeline. We don't have any plans to sunset Semaphore
Classic, and will continue to support it. However it won't receive any major new
features, as our R&D will be focused on Semaphore 2.0.

### Semaphore 2.0 is a superset of Semaphore Classic

Everything that you've been able to do with Semaphore as you know it, you'll be
able to do with 2.0 — and much more.

The only features of Classic that are currently not present in 2.0 are Boosters
and Bitbucket support, which will be addressed soon.

### Pipelines can orchestrate any workflow

Semaphore 2.0 gives you unlimited flexibility in automating CI/CD workflows. You
can still run simple builds easily. You can also run multi-stage builds, each
stage with its' own configuration.

Servers on Semaphore Classic are superseded by
[promotions](https://docs.semaphoreci.com/article/67-deploying-with-promotions).
Promotions connect different pipelines together, with optional conditions.
For example, you could set up an auto-promotion on master branch that triggers
deployment to production and runs smoke tests, and a manual promotion for any
branch which deploys to staging environment.

### All configuration is in YML and executed in command line

You'll primarily interact with Semaphore 2.0 as you do your other development
tools and platforms, through command line.

In most cases, you'll migrate your projects from Semaphore Classic by copying
your build and deploy commands to [YAML files](https://docs.semaphoreci.com/article/64-customizing-your-pipeline)
and moving your environment variables and configuration files to
[secrets](https://docs.semaphoreci.com/article/66-environment-variables-and-secrets).

As you explore the [sem command line tool](https://docs.semaphoreci.com/article/53-sem-reference),
you'll discover how you can do much more in Semaphore 2.0. Things like running
one-off jobs and attaching to live-running jobs is one command away.

### Pay only for what you use with autoscaling

In Semaphore Classic, your CI/CD capacity was fixed to a certain number of
boxes. Semaphore 2.0 adopts the ["pay only what you use"](https://semaphoreci.com/pricing)
cloud model, in which CI/CD resources scale automatically to support your
team’s actual needs.

S2 also introduces several machine types with different CPU/memory capacity
which you use in your pipelines.

### Less assumptions, more transparency

Because you can use Semaphore 2.0 to automate just about anything with code, it
doesn't make assumptions about what you might want to do in each stage of your
pipelines. Specifically this does not happen automatically:

- S2 doesn't check out code: use [`checkout` command](https://docs.semaphoreci.com/article/54-toolbox-reference#libcheckout);

- Databases and other services are stopped by default: use [`sem-service`
  tool][sem-service]
  to start them;

- Dependencies are not cached by default: see
  [caching guide](https://docs.semaphoreci.com/article/68-caching-dependencies)
  and examples for your
  [programming language](https://docs.semaphoreci.com/category/58-programming-languages)

S2 job logs provide much more information about your CI/CD environment in an
easy to use full-page format. For example, you will see exactly how long it
takes Semaphore to start your job and all the details of environment
preparation.

For a full introduction to Semaphore 2.0, we recommend that you read through the
[Guided tour](https://docs.semaphoreci.com/article/77-getting-started).

[sem-service]: https://docs.semaphoreci.com/article/132-sem-service-managing-databases-and-services-on-linux
