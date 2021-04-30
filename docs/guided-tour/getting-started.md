# Getting Started with Semaphore

## Welcome

Welcome to Semaphore 👋 We’re proud to be your [continuous integration](https://semaphoreci.com/continuous-integration) platform. In this guide, we’ll help you get up and running.

## Your first project

If you haven’t already, head over to [Semaphore](https://semaphoreci.com) and sign up. Once logged in, you’re ready to try creating your first project.

To start a new project, click on **+ create new** on the top of the page.

<img src="./create-new.png" alt="Create a new project" style="width:90%"/>

The next page will show you two ways of setting up a project: <u>start a real project</u> or <u>try a quick experiment</u>. We’ll use the second option. 

Scroll down to see a list of ready-made examples and select **Ruby (Rails)**.

<img src="./fork-and-run.png" alt="Selecting a fork and run example" style="width:90%"/>

Wait a few seconds while Semaphore prepares your fork. You should see the demonstration pipeline starting up soon.

<img src="./first-run.png" alt="First run" />

👍 that’s it. Let’s see how it works.

## Guided tour

What you see here is a running *pipeline*. A pipeline describes the steps needed to build, test, release, or deploy your code.

<img src="./first-run.png" alt="A continuous integration pipeline starting up" />

The first thing you need to know is that pipelines run from left to right.

<img src="./pipeline-flow.png" alt="Pipeline flow" />

In Semaphore, everything happens in *jobs*. A job implements all the shell commands needed to achieve a task.

Green ✅ indicates that the job successfully ended, while 🔵 shows that the it is currently running.

<img src="./first-run-progress.png" alt="Jobs completed and in-progress" />

Some jobs may run in parallel. Here, for instance, we have two simultaneous unit test jobs.

<img src="./first-run-parallel.png" alt="Unit tests run simultaneously" />

A red ❌ means that the job ended with an error, making the pipeline stop prematurely.

<img src="./first-run-error.png" alt="An error in the pipeline causes it to stop" />

We will cover a few troubleshooting techniques in another section. By now, the pipeline hopefully is all ✅.

<img src="./first-run-complete.png" alt="Pipeline is all green" />

### How pipelines work

Pipelines are composed of jobs and *blocks*. A block, by itself, doesn’t do anything, it’s mostly a way of organizing execution flow.

<img src="./blocks-vs-jobs.png" alt="Blocks and jobs in the pipeline" />

Jobs that share a block run simultaneously. Blocks, on the other hand, run from left to right, one at a time, **following dependency lines**. A block will only start when all the jobs in the previous block end without errors.

<img src="./series-vs-parallel.png" alt="Job execution flow" />

Internally, pipelines are written in [YAML](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/), a format simple to read for both humans and machines. While it’s possible for you to edit the code directly, you don’t need to — **Semaphore features an easy-to-use visual editor**.

Click on **edit workflow** to try the workflow editor.

<img src="./edit-workflow.png" alt="Open the visual editor" />

The editor should open with the first block already selected. You can see its configuration on the right pane.

<img src="./b1.png" alt="Setup block" />

<div class="side-by-side">
    <div class="side-by-side-column">
        <p>Viewing the pane from top to bottom, we see:</p>
        <ol>
        <li>A descriptive name.</li>
        <li>A list of dependencies.</li>
        <li>At least one job.</li>
        </ol>
        <p>We’ll talk about the rest of the settings in a bit.</p>
    </div>
    <div class="class-by-side-column">
        <img src="./right-pane.png" alt="Job in setup block" style="width:95%"/>
    </div>
</div>

### Building your application

The goal of the first block is to download the Ruby gems (dependencies). Here is the job in focus:

``` bash
sem-version ruby 2.7.3
sem-version node 14.16.1
checkout
cache restore
bundle install
cache store
```

The commands we want to show you next are `sem-version`, `checkout`, and `cache`.

**Use sem-version to select language version**

It’s essential to use the same programming language version across all platforms. Semaphore provides native support for several [languages](https://docs.semaphoreci.com/programming-languages/android/). In order to activate a specific version for a language, you should use the built-in [sem-version](https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/).

This tool takes two arguments:

-   Language name.
-   Version string.

``` bash
sem-version LANGUAGE_NAME VERSION_NUMBER
```

For instance, this is how we select JavaScript and Ruby versions in the job:

``` bash
sem-version ruby 2.7.3
sem-version node 14.16.1
```

**Cloning the repository with checkout**

Every job in Semaphore starts from a blank slate. You won’t find your source code anywhere until you use [checkout](https://docs.semaphoreci.com/reference/toolbox-reference/#checkout). This command clones your repository, allowing you to build, test, and deploy your applications. You’ll find yourself using `checkout` in most of your jobs.

**Using cache to persist files**

As said, every job starts in a fresh filesystem. Files created by one job are not available in another, even if the jobs share a block. The [cache](https://docs.semaphoreci.com/reference/toolbox-reference/#cache) is one of the ways that Semaphore provides to pass files around, between jobs and pipelines.

The `cache` script has quite a bit of magic inside. After executing `cache store`, it will detect the layout of your project and automatically save dependencies found in well-known folders like `node_modules`, `bundle/vendor`, or `vendor`. To restore these files, simply call `cache restore`.

One of the most common patterns for making pipelines run fast “restore -&gt; install -&gt; store.” Take a look at how this job manages Ruby gems:

``` bash
cache restore
bundle install
cache store
```

The first command restores the gems from the cache. At first, the cache space is empty, so in the initial run, nothing happens.

The second command, `bundle install`, causes [Bundler](https://bundler.io/), Ruby’s package manager, to download and install the gems in the `vendor/bundle` folder.

Finally, `cache store` saves the downloaded gems. On successive runs, the gems will be directly restored from the cache.

If `cache` doesn't support or detect your project layout, you can always supply the paths you want to save and restore. For additional details, check the [reference page](https://docs.semaphoreci.com/reference/toolbox-reference/#cache).

### Analyzing your code

Blocks may have dependencies. A dependency means that a block will not start until all the other blocks listed as dependencies finished running. The second block, for instance, depends on the first one.

<img src="./dependencies.png" alt="Code scanning depends on the setup block" />

The code scanning block shows an example of how you can use Semaphore to test and analyze your applications. This block runs some static checks on the code to evaluate its quality, catching many bugs and errors before they can do any harm. 

The job in this block repeats the same commands we've seen with two additions:

- **rubocop** is a static code analyser and formatter.
- **brakeman** is a free vulnerability scanner designed for Ruby on Rails applications.

Semaphore will capture the return status of every command in the job to determine if it succeeded or failed.

<img src="./b2.png" alt="Static analysis block" />

### Testing with unit tests

The third block, called Unit tests, runs two jobs using [RSpec](https://rspec.info/), Ruby’s behavior-driven development (BDD) tool.

One job runs unit tests on the Rails models and the other on the Rails controllers.

<img src="./b3.png" alt="Unit tests block" />

Scrolling down past the jobs, you will find the *prologue* and the *epilogue*, valuable for implementing shared setup and clean-up commands. The commands in the prologue are executed **before** all the jobs in the block. And those in the epilogue run **after** the jobs.

<img src="./b3-prologue.png" alt="Prologue in the third block" />

Opening the prologue reveals a new built-in script: [sem-service](https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/). This nifty tool lets you start or stop databases and other popular services. It takes two mandatory arguments:

-   **action**: can be `start`, `stop`, or `status`.
-   **service name**: the system to start, for instance, `postgres`.

Here’s how we use `sem-service` to start a blank PostgreSQL database in background:

``` bash
sem-service start postgres
```

### Adding jobs

<div class="side-by-side">
    <div class="side-by-side-column">

        <p>You can use the workflow editor to add, change, or remove jobs and blocks. Let’s try adding a unit testing job.</p>

        <p>In the jobs section of the third block, press:</p>
        <p><u>+ Add another job</u></p>

        <p>Then, add the following line, which runs the tests cases the features folder. The test will run after the commands in the prologue.</p>

        <div class="codehilite">
        <pre><code>bundle exec rspec spec/features</code></pre>
        </div>

        <p>The block should now have three unit test jobs.</p>
    </div>
    <div class="side-by-side-column">
        <img src="./feature-tests.png" alt="The new unit test" style="width:95%" />
    </div>
</div>

### Performing integration testing

The last block runs the integration tests. It combines everything you’ve learned so far:

- A prologue. 
- `sem-version` to switch between language versions. 
- `checkout` to clone the repository.
- `sem-service` to start a test database.

<img src="./b4.png" alt="Integration tests" />

### Saving the pipeline

To save the changes you did to the pipeline, click on **run the workflow** on the top right corner of the page. You’ll see a confirmation window. Here, you can change the commit message and the Git branch where the new pipeline will be installed.

<img src="./run-workflow.png" alt="Run the workflow to save changes" />

The updated pipeline should start up immediately.

<img src="./ci-final.png" alt="Final pipeline" />

Congrats 🚀 You’ve completed your first steps using Semaphore.

## Next Steps

Now that you know how pipelines are made and how to edit them, you're ready to take the next steps. The following sections will show:

-   How to create a project using any repository in GitHub.
-   How to customize your build environment.
-   How to troubleshoot pipelines.
-   How to perform a deployment.
-   Where to find more documentation.