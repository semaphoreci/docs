---
description: This guide shows you how to optimize your Semaphore 2.0 workflow for monorepo projects.
---

# Test Summary

Working with tests in your projects should be efficient and easy. The bigger your project
becames, the harder it is to track all of the failures in your workflows. Firstly
you have to navigate to specific job, and then search through the logs for failure messages.

Test summary gives you tools essentials for generating report summary based on your test suite results.

![Monorepo
Pipeline](img/test-summary/summary-tab.png)

## Framework configuration

### Ruby / RSpec

Add [rspec_junit_formatter ↗](https://github.com/victorolinasc/junit-formatter) to your Gemfile

```ruby
gem "rspec_junit_formatter"
```

Run following commands

```shell
bundle install
```

Add following to your `.rspec` configuration file

```plain
--format RspecJunitFormatter
--out /tmp/junit.xml
```

OR

Run RSpec with following arguments to generate JUnit XML report

```shell
bundle exec rspec --format RspecJunitFormatter --out /tmp/junit.xml
```

Add epilogue block to your test running job in `.semaphore/semaphore.yml`

```yaml
epilogue:
  always:
    commands:
      - test-results publish /tmp/junit.xml
```

### Go / gotestsum

Make sure your GOPATH is exported. If not add this to your prologue

```yaml
prologue:
  commands:
    - export GOPATH="/home/semaphore/go"
    - export PATH="$PATH:$GOPATH/bin"
```

Install [gotestsum ↗](https://github.com/gotestyourself/gotestsum) globally

```shell
GO111MODULE=off go get gotest.tools/gotestsum
```

Run your tests with

```shell
gotestsum --junitfile /tmp/junit.xml
```

Add epilogue block to your test running job

```yaml
epilogue:
  always:
    commands:
      - test-results publish /tmp/junit.xml
```

### Elixir / ExUnit

Add [junit formatter ↗](https://github.com/victorolinasc/junit-formatter) to your `mix.exs`

```elixir
{:junit_formatter, "~> 3.1", only: [:test]}
```

Run following commands

```shell
mix deps.get
```

Configure the junit_formatter in `config/config.exs`

```elixir
config :junit_formatter,
  report_file: "junit.xml",
  report_dir: "/tmp",
  print_report_file: true,
  include_filename?: true,
  include_file_line?: true
```

Add formatter to your `test/test_helper.ex`

```elixir
ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])
ExUnit.start()
```

Add epilogue block to your test running job

```yaml
epilogue:
  always:
    commands:
      - test-results publish /tmp/junit.xml
```

## Support for other frameworks

- generic parser
- general instructions for generating junit xml file
- customization via CLI
