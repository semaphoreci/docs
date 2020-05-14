# Customizing Your Pipeline

After [creating your first project][first-project], you've initialized
it with a working demo pipeline. Now we'll see how we can define our own
pipelines on Semaphore.

Let's say that our CI build consists of 4 steps:

1. Compile
2. Run unit tests
3. Run integration tests
4. Run performance tests

Semaphore can run CI jobs in parallel, so we can use that to run integration
and performance tests simultaneously and save us time. We'll keep the unit
tests separate since we want them to finish fast, and halt the build in case
of failure.

Recall what we've covered in [concepts]. Sequential phases maps to blocks.
Parallel stuff maps to jobs within a block's task. Commands within a job run
sequentially.

Let's start with two sequential blocks:

``` yaml
# .semaphore/semaphore.yml
blocks:
  - name: "Set things up"
    task:
      jobs:
        - name: Compile
          commands:
            - checkout
            - echo "Linting code"
            - echo "Compiling code"
  - name: "Unit tests"
    task:
      jobs:
        - name: Unit
          commands:
            - checkout
            - echo "Running unit tests"
```

With this configuration, commands in the "Compile" job run sequentially. If all
of them pass, the "Set things up" block passes, and the pipeline proceeds to
run the "Unit tests" block.

Notice how each job includes the [`checkout` command][checkout]. This is
Semaphore's built-in command which clones the code from the GitHub repository
of the Semaphore 2.0 project to the job's Virtual Machine environment.

## Defining blocks with parallel jobs

Let's add another block with two parallel jobs:

``` yaml
# .semaphore/semaphore.yml
blocks:
  - name: "Set things up"
    task:
      jobs:
        - name: Compile
          commands:
            - checkout
            - echo "Linting code"
            - echo "Compiling code"
  - name: "Unit tests"
    task:
      jobs:
        - name: Unit
          commands:
            - checkout
            - echo "Running unit tests"
  - name: "E2E tests"
    task:
      prologue:
        commands:
          - checkout
      jobs:
        # these two jobs run in parallel, if "Unit tests" block passes:
        # (also, comments are ok ;)
        - name: "Integration tests"
          commands:
            - echo "Running integration tests"
        - name: "Performance tests"
          commands:
            - echo "Running performance tests"
```

In the new "E2E tests" block, commands in `prologue` run before each job,
so that we don't repeat ourselves. Prologue is the right place for setup tasks
like checking out or building the code. Blocks also support a list of commands
that run after each job, called `epilogue`. This is covered in depth in the
[Pipeline YAML reference][pipeline].

## Next steps

Running a CI build in practice usually requires us to install and run
dependencies, set environment variables, etc. Semaphore has several features
which make this very easy. Let's move on to
[customizing the build environment][next].

[first-project]: https://docs.semaphoreci.com/guided-tour/creating-your-first-project/
[concepts]: https://docs.semaphoreci.com/guided-tour/concepts/
[checkout]: https://docs.semaphoreci.com/reference/toolbox-reference/#libcheckout
[pipeline]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/
[next]: https://docs.semaphoreci.com/guided-tour/customizing-the-build-environment/
