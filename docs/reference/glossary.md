---
description: Glossary of commonly used terminology on Semaphore 2.0.
---

# Glossary

## Tests

This section describes commonly used terms relating to running, inspecting and
reporting about tests.

#### Test case

A single test within a test suite. Contains assertions that the system under
test can either pass or fail.

#### Test file

A file that contains several test cases. In dynamic languages, like Ruby,
filtering and grouping can be done by test files.

#### Test case tag

A tag or a label added to the test case, for example the "wip" tag.
Usually used for filtering tests.

#### Test suite

A collection of test cases.

#### Test run

A single execution of the test suite or test case.
Usually, a single run of pipeline executes one test run or the test suite.

#### Test runner

The tool used for running tests. Example: RSpec, GoTestSum, ExUnit.

Usually, tests are written for a specific test runner in mind. For example,
RSpec tests are written for RSpec test runner, and Cucumber tests are
written for Cucumber test runner.

In some cases, multiple runners exists for the same test format. For example,
in go you can run tests with `go test` or with `gotestsum`, and alternative runner.

#### Test filtering

A mechanism in test runners to filter and run test cases based on files, tags,
etc...

#### Test result

The result of a single test case with one of the following outcomes:

- Passed - The test passed the assertions in the test case
- Failed - The test failed the assertions in the test case
- Error - The test case failed to execute. Assertion was not tested.
- Timeout - The test case failed to execute in preset interval. Assertion was not tested.
- Skipped - The test case was skipped, and has no result.

#### Test results

The result of a test suite.

#### Test output formatter

The formatter used for outputting test results. Common formatter are:

- "dot" output
- "documentation" output
- "junit" output

The formatters are usually built-in the test runner, and usually test runners
can be extended with additional formatters.

#### XML test result

Test results output that follows the JUnit XML specification.

#### Test results CLI

A tool from the Semaphore toolbox used to generate and publish test reports.

#### Test report

A report generated based on test results. The report is available on
the Workflow Page and Job Page under the Tests tab.

A single report is usually based on one test suite.

#### Test reports

Multiple test reports available on the Workflow Page or the Job Page.
For example: "RSpec" report, "Cucumber" report.
