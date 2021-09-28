---
description: This document
---

# Tests

Semaphore collects XML test reports and uses them to provide insight into your
pipelines.

With test reports, you enable your team to get an effective and consistent view
of your CI/CD test suite across different test frameworks. You get a clear
failure report for each executed pipeline. Failures are extracted and
highlighted, while the rest of the suite is available for analysis.

Published test results are available on under the **Tests** tab.

<img style="box-shadow: 0px 0px 5px #ccc" src="/essentials/img/test-summary/tests-tab.png" alt="Tests Tab on Workflow Page">


## Setting up test reports

Semaphore collects JUnit XML reports from your jobs. Any test runner that can
generate JUnit XML reports is supported by Semaphore.

To collect test results in your pipelines, follow these three steps.

### Step 1 &mdash; Export XML results from your test suite

Most test runners are able to export JUnit XML test results. In the following
list, you can find the most popular test runners and their formatters.

| Language   | Test Runner  | Formatter                                                                                                             | Example                                                                                                  |
|------------|--------------|-----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| JavaScript | Mocha        | [mocha-junit-reporter&nbsp;↗](https://www.npmjs.com/package/mocha-junit-reporter){target="_blank"}                    | [Exporting XML reports with Mocha]()
| JavaScript | Karma        | [karma-junit-reporter&nbsp;↗](https://www.npmjs.com/package/karma-junit-reporter){target="_blank"}                    | [Exporting XML reports with Karma]()
| JavaScript | ESLint       | [built-in&nbsp;↗](https://eslint.org/docs/user-guide/formatters/#junit){target="_blank"}                              | [Exporting XML reports with ESLint]()
| JavaScript | Jest         | [jest-junit&nbsp;↗](https://www.npmjs.com/package/jest-junit){target="_blank"}                                        | [Exporting XML reports with Jest]()
| Ruby       | RSpec        | [rspec_junit_formatter&nbsp;↗](https://github.com/victorolinasc/junit-formatter){target="_blank"}                     | [Exporting XML reports with RSpec]()
| Ruby       | Cucumber     | [built-in&nbsp;↗](https://relishapp.com/cucumber/cucumber/docs/formatters/junit-output-formatter){target="_blank"}    | [Exporting XML reports with Cucumber]()
| Elixir     | ExUnit       | [junit-formatter&nbsp;↗](https://github.com/victorolinasc/junit-formatter){target="_blank"}                           | [Exporting XML reports from ExUnit]()
| Go         | GoTestSum    | [built-in&nbsp;↗](https://github.com/gotestyourself/gotestsum#junit-xml-output){target="_blank"}                      | [Exporting XML reports with GoTestSum]()
| PHP        | PHPUnit      | [built-in&nbsp;↗](https://phpunit.readthedocs.io/en/9.5/textui.html?highlight=junit){target="_blank"}                 | [Exporting XML reports with PHPUnit]()
| Python     | PyTest       | [built-in&nbsp;↗](https://docs.pytest.org/en/6.2.x/usage.html#creating-junitxml-format-files){target="_blank"}        | [Exporting XML reports with PyTest]()
| Bash       | Bats         | [built-in&nbsp;↗](https://bats-core.readthedocs.io/en/latest/usage.html){target="_blank"}                             | &mdash;
| Rust       | Cargo Test   | [junit-report&nbsp;↗](https://crates.io/crates/junit-report){target="_blank"}                                         | &mdash;
| Java       | Maven        | [maven-surefire&nbsp;↗](https://maven.apache.org/surefire/maven-surefire-plugin/examples/junit.html){target="_blank"} | &mdash;

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
         - [[ -f report.xml ]] && test-results publish report.xml
```

The `test-results` tool is part of [Semaphore's Toolbox]() and it is available
in every Semaphore job.

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

...

### Filter failed tests on the Tests dashboard

### Find the slowest test in your test suite

### Filter executed tests based on their names

### Find skipped tests



Test summary relies on [JUnit xml format&nbsp;↗][junit-schema]{target="_blank"} report files generated by your test runner.
JUnit XML report is compiled by [Test Results CLI&nbsp;↗][github-test-results-cli]{target="_blank"} and sent to your artifact store.
See Test Results CLI [documentation page&nbsp;↗][test-results-cli]{target="_blank"} for more details about the compiler.

## Advanced configuration

- [merging test results using CLI&nbsp;↗](/reference/test-results-cli-reference/#merging-test-results){target="_blank"}.
- [working with docker&nbsp;↗](/reference/test-results-cli-reference/#working-with-docker){target="_blank"}.

[ruby-test-summary]: /programming-languages/ruby/#test-summary
[go-test-summary]: /programming-languages/go/#test-summary
[elixir-test-summary]: /programming-languages/elixir/#test-summary
[junit-schema]: https://www.ibm.com/docs/en/adfz/developer-for-zos/9.1.1?topic=formats-junit-xml-format
[github-test-results-cli]: https://github.com/semaphoreci/test-results
[test-results-cli]: /reference/test-results-cli-reference/
