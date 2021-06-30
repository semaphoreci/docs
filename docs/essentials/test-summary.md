---
description: This guide shows you how to optimize your Semaphore 2.0 workflow for monorepo projects.
---

# Test Summary

!!! info "Feature in beta"
    Beta features are subject to change.

Working with tests in your projects should be efficient and easy. The bigger your project
becames, the harder it is to track all of the failures in your workflows. Firstly
you have to navigate to specific job, and then search through the logs for failure messages.

Test summary gives you tools essentials for generating report summary based on your test suite results.

![Test Summary Tab](img/test-summary/summary-tab.png)

## What is it?

A new tab on job page that renders the info from your test suite.  You don't have to scroll through job logs.
Allows you to quickly find/filter/search

## How does it work?

JUnit xml format, results exported to the file, pushed to artifacts, rendered on summary

## How to use it?

How to configure (basic outline, you need to have this type of tests exported in this format and you need to add this command at the end). For detailed guide check these sections.
What is supported - these 3 languages, more will be added in future.

## The UI options

You can merge multiple test suites
Show/hide
Filter
Search

## Framework configuration

- [Ruby / RSpec][ruby-test-summary]

[ruby-test-summary]: /programming-languages/ruby/#test-summary
[go-test-summary]: /programming-languages/go/#test-summary
[elixir-test-summary]: /programming-languages/elixir/#test-summary
