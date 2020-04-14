# GitHub Status Checks

GitHub status checks are an excellent way to track and control the CI/CD status
of your projects.

Semaphore by default reports GitHub statuses for your initial
`.semaphore/semaphore.yml` pipelines. Optionally you can configure status
checks for multiple pipelines, or even blocks.

The name of the GitHub status is derived from the name of your pipeline or
block.

## Configuring pipeline level status checks

By default, Semaphore reports a GitHub status for your initial
`.semaphore/semaphore.yml` pipeline.

To change the pipeline for which you want to create a check status, edit your
projects configuration:

``` bash
sem edit project <project-name>
```

``` yaml
apiVersion: v1alpha
kind: Project
metadata:
  name: example

spec:
  repository:
    url: "git@github.com:renderedtext/example.git"
    run: true
    run_on:
      - branches
      - tags
    pipeline_file: ".semaphore/semaphore.yml"

    status:
      pipeline_files:
        - path: ".semaphore/scheduled-runs.yml"
          level: "pipeline"
```

Adjust the `status` property to modify your GitHub check configuration. In the
above YAML, the status checks will be sent only for the
`.semaphore/scheduled-runs.yml` pipeline.

## Configuring pipeline level status checks for multiple pipelines

To set up status checks for multiple pipelines in your projects, edit your
project's configuration:

``` bash
sem edit project <project-name>
```

``` yaml
apiVersion: v1alpha
kind: Project
metadata:
  name: example

spec:
  repository:
    url: "git@github.com:renderedtext/example.git"
    run: true
    run_on:
      - branches
      - tags
    pipeline_file: ".semaphore/semaphore.yml"

    status:
      pipeline_files:
        - path: ".semaphore/semaphore.yml"
          level: "pipeline"

        - path: ".semaphore/scheduled-runs.yml"
          level: "pipeline"
```

Adjust the `status` property to modify your GitHub check configuration. In the
above YAML, the status checks will be sent for both the
`.semaphore/semaphore.yml` and `.semaphore/scheduled-runs.yml` pipelines.

## Configuring block level status checks

By default, Semaphore creates status checks for your pipelines. However, you
can adjust this configuration and create status checks for each of your blocks
in the pipeline.

To sends blocks level statuses, instead of pipeline level statuses, edit your
project configuration:

``` bash
sem edit project <project-name>
```

``` yaml
apiVersion: v1alpha
kind: Project
metadata:
  name: example
spec:
  repository:
    url: "git@github.com:renderedtext/goDemo.git"
    run: true
    run_on:
      - branches
      - tags
    pipeline_file: ".semaphore/semaphore.yml"

    status:
      pipeline_files:
        - path: ".semaphore/semaphore.yml"
          level: "block"
```

Adjust the `status` > `level` property to send `block` instead of `pipeline`
level status checks.
