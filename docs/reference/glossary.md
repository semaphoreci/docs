---
description: Glossary of commonly used terminology on Semaphore 2.0.
---

# Glossary

## Tests

This section describes commonly used terms relating to running, inspecting,
and reporting about tests.

#### Test case

A single test within a test suite. Contains assertions that the system under
test can either pass or fail.

#### Test file

A file that contains several test cases. In dynamic languages, like Ruby,
filtering and grouping can be done by test files.

#### Test tag

A tag or a label that is added to the test case, for example the "wip" tag,
usually used for filtering tests.

#### Test suite

A collection of test cases.

#### Test run

A single execution of the test suite or test case.

#### Test runner

The tool used for running tests. Example: RSpec, GoTestSum, ExUnit.

Usually, tests are written for a specific test runner in mind. For example,
RSpec tests are written for RSpec test runners, and Cucumber tests are written
for Cucumber test runners.

In some cases, multiple runners exist for the same test format. For example,
in the Golang ecosystem you can run tests with `go test` or with
`gotestsum`.

#### Test filtering

A mechanism in test runners for filtering which test cases are executed.
Filtering can be based on file paths, tags, or other properties associated with
test cases.

#### Test results

The results of test execution.

A single test case can have the following result:

| Result   | Description                                                                       |
|----------|-----------------------------------------------------------------------------------|
| Passed   | The test passed the assertions in the test case.                                  |
| Failed   | The test failed the assertions in the test case.                                  |
| Error    | The test case failed to execute. Assertions were not tested.                      |
| Timeout  | The test case failed to execute in a preset interval. Assertions were not tested. |
| Skipped  | The test case was skipped and has no result.                                      |

Test results (plural) refer to the aggregate result of all executed test cases
in a test suite. It can be one of the following:

| Result   | Description                                                                                          |
|----------|------------------------------------------------------------------------------------------------------|
| Failed   | At least one test case has the result failed, error, or timeout.                                     |
| Passed   | No test case has is the result failed, error, or timeout. Acceptable results are passed and skipped. |

#### Test output formatter

The formatter used for formatting test results. Common formatters are:

- "dot" format
- "documentation" format
- "junit" format

Test runners come with several built-in formatters, and usually, they can be
extended with additional formatters via plugging.

#### Test results CLI

A CLI tool included in the [Semaphore Toolbox][toolbox] used to generate and
publish test reports.

Learn more about this CLI tool on the
[Test Results CLI reference][test-results-cli-ref] documentation page.

#### Test report

A report that was generated and published with the test-results CLI tool.
Published reports are available on the workflow page and job page under the
Tests tab.

The Tests tab contains multiple test reports, usually one for each test suite.

[toolbox]: /reference/toolbox-reference/
[test-results-cli-ref]: /reference/test-results-cli-reference/
