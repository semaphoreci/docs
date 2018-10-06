# Customizing Your Pipeline

You'll need to customize the pipeline after connecting a project to
Semaphore. Pipelines are composed of multiple blocks. Blocks execute
in sequence. Blocks have a task and jobs. Jobs execute in parallel.
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

Next, configure pipeline to checkout the code. You'll need to add the
`checkout` command to each job. You could do that by adding that to
each command, but there's no need to do that. Blocks support a list of
`prologue` commands that run before each job. That's the right place
for setup like checkout or building the code. Here's the updated
version:

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
