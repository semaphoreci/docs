---
description: Every project on Semaphore 2.0 has access to test results compiler. See this page for more information.
---

# Test results CLI Reference

!!! beta "Feature in beta"
    Beta features are subject to change.

The `test-results` command line interface (CLI), is a tool that helps you compile and
process JUnit test result XML files for [Test Summary&nbsp;↗][test-summary-essentials]{target="_blank"} pages.

`test-results` have built-in help command that can be accessed by running:

```
$ test-results

Semaphore 2.0 Test results CLI v0.4.5

Usage:
  test-results [command]

Available Commands:
  combine             combines multiples json summary files into one
  compile             parses xml files to well defined json schema
  gen-pipeline-report fetches workflow level junit reports and combines them together
  help                Help about any command
  publish             parses xml file to well defined json schema and publishes results to artifacts storage

Flags:
      --config string         config file (default is $HOME/.test-results.yaml)
  -h, --help                  help for test-results
  -N, --name string           name of the suite
  -p, --parser string         override parser to be used (default "auto")
  -S, --suite-prefix string   prefix for each suite
  -t, --toggle                Help message for toggle
      --trace                 trace output
  -v, --verbose               verbose output
      --version               version for test-results

Use "test-results [command] --help" for more information about a command.
```

## Merging test results

Let's say your job generates multiple JUnit xml files:

```shell
$ tree /tmp/test-results
/tmp/test-results
├── benchmark.xml
├── integration.xml
├── ui.xml
└── unit.xml

0 directories, 4 files
```

If you want to have one report for the job you can use:

```shell
test-results publish /tmp/test-results
```

This will combine all `.xml` files into one report and then publish it to your artifacts storage.

## Working with docker

If you are running your test suites from docker container you have you might run into problems with publishing generated XML reports.
By default those files will be generated only on container, so host (Semaphore Agent) will not have access to those files.
In order to make it work you have to use [docker bind mounts&nbsp;↗][docker-bind-mounts]:

```yaml
# .semaphore/semaphore.yaml
- name: Run tests
  task:
    prologue:
      commands:
        - checkout
        # Creates `test-runner` image
        - bin/setup.sh
    jobs:
    - name: go test
      commands:
        # `run-specs` creates `junit.xml` file in container's /app directory
        - docker run -v $(pwd):/app test-runner run-specs

    epilogue:
      always:
        commands:
          - test-results publish junit.xml
```

[test-summary-essentials]: /essentials/test-summary/
[docker-bind-mounts]: https://docs.docker.com/storage/bind-mounts/
