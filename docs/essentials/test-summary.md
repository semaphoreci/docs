---
description: Semaphore collects XML test reports and uses them to provide insight into your pipelines.
---

# Tests

Semaphore collects XML test reports and uses them to provide insight into your
pipelines.

With test reports, you enable your team to get an effective and consistent view
of your CI/CD test suite across different test frameworks and stages in a
CI/CD workflow. You get a clear failure report for each executed pipeline.
Failures are extracted and highlighted, while the rest of the suite is
available for analysis.

Published test results are available under the **Tests** tab.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/test-summary/tests-tab.png" alt="Tests Tab on Workflow Page">

## Setting up test reports

Semaphore supports any test runner that generates JUnit XML reports.

To collect test results in your pipelines, follow these three steps.

### Step 1 &mdash; Export XML results from your test suite

Most test runners can export JUnit XML test results. In the following list, you
can find popular test runners and their formatters.

| Language   | Test Runner  | Formatter                                                                                                             | Example                                                                                                  |
|------------|--------------|-----------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| JavaScript | Mocha        | [mocha-junit-reporter](https://www.npmjs.com/package/mocha-junit-reporter){target="_blank"}                           | &mdash;
| JavaScript | Karma        | [karma-junit-reporter](https://www.npmjs.com/package/karma-junit-reporter){target="_blank"}                           | &mdash;
| JavaScript | ESLint       | [built-in](https://eslint.org/docs/user-guide/formatters/#junit){target="_blank"}                                     | &mdash;
| JavaScript | Jest         | [jest-junit](https://www.npmjs.com/package/jest-junit){target="_blank"}                                               | &mdash;
| Ruby       | RSpec        | [rspec_junit_formatter](https://github.com/victorolinasc/junit-formatter){target="_blank"}                            | [Exporting XML reports with RSpec][test-results-example-rspec]{target="_blank"}
| Ruby       | Cucumber     | [built-in](https://relishapp.com/cucumber/cucumber/docs/formatters/junit-output-formatter){target="_blank"}           | &mdash;
| Elixir     | ExUnit       | [junit-formatter](https://github.com/victorolinasc/junit-formatter){target="_blank"}                                  | [Exporting XML reports from ExUnit][test-results-example-exunit]{target="_blank"}
| Go         | GoTestSum    | [built-in](https://github.com/gotestyourself/gotestsum#junit-xml-output){target="_blank"}                             | [Exporting XML reports with GoTestSum][test-results-example-go]{target="_blank"}
| PHP        | PHPUnit      | [built-in](https://phpunit.readthedocs.io/en/9.5/textui.html?highlight=junit){target="_blank"}                        | &mdash;
| Python     | PyTest       | [built-in](https://docs.pytest.org/en/6.2.x/usage.html#creating-junitxml-format-files){target="_blank"}               | &mdash;
| Bash       | Bats         | [built-in](https://bats-core.readthedocs.io/en/latest/usage.html){target="_blank"}                                    | &mdash;
| Rust       | Cargo Test   | [junit-report](https://crates.io/crates/junit-report){target="_blank"}                                                | &mdash;
| Java       | Maven        | [maven-surefire](https://maven.apache.org/surefire/maven-surefire-plugin/examples/junit.html){target="_blank"}        | &mdash;

If your test runner is not the above list, you can still collect Tests. Find a
test formatter for your test runner that can export JUnit XML results.

### Step 2 &mdash; Publish XML results from your jobs

Given that your test suite is exporting an XML test result named `report.xml`,
publish it from your jobs with the `test-results` CLI tool.

Add the following snippet to your pipeline YAML file:

``` yaml
global_job_config:
  epilogue:
    always:
      commands:
         - '[[ -f report.xml ]] && test-results publish report.xml'
```

The `test-results` tool is part of [Semaphore's Toolbox][toolbox]{target="_blank"}
and it is available in every Semaphore job.

If you are running tests inside of a Docker container, see
[how to use test-results CLI with Docker][working-with-docker]{target=_blank}
to extract and publish the result file.

### Step 3 &mdash; Collect and Merge all XML results in a pipeline

Finally, to collect and merge XML reports from all jobs in a pipeline, add the
following snippet to your pipeline YAML file:

``` yaml
after_pipeline:
  task:
    jobs:
      - name: Publish Results
        commands:
          - test-results gen-pipeline-report
```

## Inspecting executed tests on the Tests dashboard

After each executed pipeline run, your team will get access to a report under
the **Tests** tab on the Workflow Page. What follows is a list of most common
use cases.

### Filter failed tests on the Tests dashboard

By default, the Tests dashboards display only the failed tests, as they are the
most useful during a typical red-green-refactor cycle.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/test-summary/failed-tests.png" alt="Displaying only failed tests">

### Find the slowest test in your test suite

While developing a new feature, you can introduce unwanted performance
degradation. If you notice that your test suite has performance problems,
finding the slowest tests can help you narrow down source of the problem.

On the Tests dashboard, select the **Slowest First** option to get a list of
your slowest tests.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/test-summary/slowest-first.png" alt="Displaying the slowest tests first">

### Find skipped tests

Skipping a test is a common strategy to isolate problematic tests in your test
suite. This is a good short-term strategy. In the long term however, if the
number of skipped tests accumulates, your team is risking by shipping untested
features.

Visiting the Tests dashboard can give you a good overview of how many tests are
skipped in your test suite. Select View, and uncheck **Hide skipped tests**.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/test-summary/skipped-tests.png" alt="Displaying skipped tests">

## See also

- [Test Results CLI](/reference/test-results-cli-reference/)
- [After Pipeline](/reference/pipeline-yaml-reference/#after_pipeline)
- [Epilogue](/reference/pipeline-yaml-reference/#the-epilogue-property)

[toolbox]: /reference/toolbox-reference/
[working-with-docker]: /reference/test-results-cli-reference/#working-with-docker
[test-results-example-rspec]: /programming-languages/ruby/#test-summary
[test-results-example-exunit]: /programming-languages/elixir/#test-summary
[test-results-example-go]: /programming-languages/go/#test-summary
