# Customizing Your Pipeline

You'll need to customize the pipeline after connecting a project to
Semaphore 2.0. Pipelines are composed of one or more blocks. Blocks are executed
in sequence. Each Block has a single task and one or more jobs. Jobs are executed in parallel.
Let's start out with a single block that runs various tests in
parallel.

```yml
# .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      jobs:
        - name: Lint
          commands:
            - echo 'Linting code'
        - name: Unit
          commands:
            - echo 'Unit tests'
        - name: Integration
          commands:
            - echo 'Integration tests'
```

Next, you should configure the pipeline to checkout the code,
which means downloading the contents of the GitHub repository to
the Virtual Machine that will be used. You'll need to add the
`checkout` command to each job that needs to access any of the contents of the GitHub repository.
You could do that by adding that to each command, but there's no need to do that. Blocks support a list of
`prologue` commands that run before each job. That's the right place
for setup commands like `checkout`. Here's the updated version:

```yml
# .semaphore/semaphore.yml
blocks:
  - name: "Test"
    task:
      prologue:
        commands:
          - checkout
          - echo 'Building code'
      jobs:
        - name: Lint
          commands:
            - echo 'Linting code'
        - name: Unit
          commands:
            - echo 'Unit tests'
        - name: Integration
          commands:
            - echo 'Integration tests'
```

Blocks, Tasks, and Jobs are covered in the [concepts][]. Learn more
about pipelines in the [reference docs][pipeline]. Next onto
customizing the [build environment][next].

[concepts]: http://placeholder.com
[pipeline]: https://docs.semaphoreci.com/article/50-pipeline-yaml
[next]: http://placeholder.com
