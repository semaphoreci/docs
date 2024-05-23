# Contributing

We love your input! We want to make contributing to Semaphore documentation as easy and transparent as possible.

This guide describes the process for making changes to the documentation whether 
you are an internal or external contributor.

## Ways to contribute

### Contribute by providing feedback

We consider any feedback received a valuable contribution. Before opening a new [issue](./) or [discussion](./), 
please check and review the existing ones first to avoid duplication. 

If you want to contribute by providing feedback you can:

1. Report an innacuracy, lack of clarity, or missing information: [new issue template](./)
2. Discuss the current state of the content, or ask for clarification on any topic: [new discussion](./)
3. Propose a new topic, page, or section: [new content proposal template](./)

### Contribute by updating docs content

If you are interested updating the docs content, there are a few paths that you can consider:

1. Read through the rest of this guide to learn how to contribute through PRs
2. Pick the right topic:
   1. Go through our list of [ready for work](./) issues and pick one
   2. Already have an improvement in mind? Feel free to move to the next step.
3. Create your first pull request following this guide

## Prerequisites

Before you begin, verify that your environment meets the following prerequisites:

- You have a code editor, a GitHub account, and experience using command-line 
  programs, including `git` commands and command line options.
- You have Node.js, version 18.x or newer, installed. 
   Run `node --version` to check whether Node is installed.
   If you need to install or update Node, see 
   [Installing Node.js](https://nodejs.org/en/download/package-manager) 
   for instructions to download and install Node.js using a package manager.

## Step 1/5. Set up your local environment

To set up a local environment for contributing to Semaphore documentation:

1. Open a terminal shell on your computer.

2. Clone the `semaphoreci/docs` repository by running the following command:

   ```bash
   git clone https://github.com/semaphoreci/docs 
   ```

3. Change to the root of the `docs` directory:
   
   ```bash
   cd docs
   ```

4. Update the documentation to the latest version from the master branch:
   
   ```bash
   git pull
   ```

5. Install dependencies:
   
   ```bash
   npm install
   ```
