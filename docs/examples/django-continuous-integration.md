---
Description: This guide shows you how to use Semaphore 2.0 to set up a continuous integration (CI) pipeline for a Python Django web application. 
---

# Django Continuous Integration

This guide shows you how to use Semaphore to set up a continuous
integration (CI) pipeline for a Python Django web application. The first thing 
you need to do is to create a new [Semaphore
project](https://docs.semaphoreci.com/guided-tour/creating-your-first-project/).

Demo project
------------

Semaphore maintains an example Django project that you can use to learn:

-   [Demo Python Django project on GitHub](https://github.com/semaphoreci-demos/semaphore-demo-python-django)

The Semaphore annotated configuration file can be found in the
`.semaphore/semaphore.yml` repository file.

The demo application is a simple task manager. We can create, edit, and
delete tasks. It also features an admin site to manage users, groups, and
permissions. The project uses the Django framework, unittest and nose
for unit testing, pylint for code analysis, selenium for browser tests,
and MySQL as a database.

Overview of the CI pipeline
---------------------------

Our Django CI pipeline contains the following tasks:

-   Install dependencies
    -   Install python packages with `pip`
-   Code Analysis
    -   Run static code analysis with `pylint`
-   Unit tests
    -   Run unit tests for views and models
-   Browser tests
    -   Run browser tests with python selenium webdriver
-   Security tests
    -   Run security tests with Django deployment checklist

The example pipeline has 5 blocks:

![Project pipeline](https://github.com/semaphoreci-demos/semaphore-demo-python-django/raw/master/pydjango_ci_integration/pipepline.png "Django CI pipeline")

We want prompt feedback from the test pipeline, so we'll fail fast if the linting fails. This prevents losing time on account of semantically incorrect code.

Sample configuration
--------------------

``` yaml
# Use the latest stable version of Semaphore 2.0 YML syntax:
version: v1.0

# Name your pipeline. In the event that you connect multiple pipelines with promotions,
# the name will help you differentiate between, for example, a CI build phase
# and delivery phases.
name: Semaphore Python / Django Example Pipeline

# An agent defines the environment in which your code runs.
# It is a combination of one of available machine types and operating
# system images.
# See https://docs.semaphoreci.com/ci-cd-environment/machine-types/
# and https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

# Blocks are the heart of a pipeline and are executed sequentially.
# Each block has a task that defines one or more jobs. Jobs define the
# commands to execute.
# See https://docs.semaphoreci.com/essentials/concepts/
blocks:
  - name: "Install Dependencies"
    task:
      # This block installs all the python dependencies,
      # as well as all the required Linux packages.
      # The prologue section is always executed before each job in
      # the block.
      # See https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#prologue
      prologue:
        commands:
          # Set the python version.
          # See https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/
          - sem-version python 3.7
          # Install Linux dependencies.
          - sudo apt-get update && sudo apt-get install -y python3-dev && sudo apt-get install default-libmysqlclient-dev
      jobs:
        - name: pip
          commands:
            # Get the latest version of our source code from GitHub:
            # See https://docs.semaphoreci.com/reference/toolbox-reference/#checkout
            - checkout
            # Restore dependencies from the cache. This command will not fail in
            # the event of a cache miss. In the event of a cache hit, pip can use it
            # to speed up the installation.
            # For more info on caching, see https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/
            - cache restore
            # Install python dependencies.
            # If not found in the cache, pip will download them.
            - pip download --cache-dir .pip_cache -r requirements.txt
            # Persist downloaded packages for future jobs.
            - cache store

  - name: "Run Code Analysis"
    task:
      # This block executes code analysis tests with pylint.
      prologue:
        commands:
          - sem-version python 3.7
          - checkout
          # At this point, the cache contains the downloaded packages ...
          - cache restore
          # ... so pip does the installation much faster.
          - pip install -r requirements.txt --cache-dir .pip_cache
      jobs:
        - name: Pylint
          commands:
            # list files that are in the directory and working tree
            # grep -v will exclude the files being considered for pylint
            # grep -E will matches files having .py extension
            # This command will help to pass required python files to pylint along with the pylint_djanog plugin
            # Pylint with -E option will display only if there is an error
            - git ls-files | grep -v 'migrations' | grep -v 'settings.py' | grep -v 'manage.py' | grep -E '.py$' |
              xargs pylint -E --load-plugins=pylint_django

  - name: "Run Unit Tests"
    task:
      # This block runs the unit tests.
      # Since the test requires a database, we start the database here.
      # Django automatically creates a test database schema.
      prologue:
        commands:
          - sem-version python 3.7
          # Start a MySQL database. On Semaphore, databases run in the same
          # environment as your code.
          # See https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/#databases-and-services
          # Also https://docs.semaphoreci.com/reference/toolbox-reference/#sem-service
          - sem-service start mysql
          - checkout
          - cache restore
          - pip install -r requirements.txt --cache-dir .pip_cache
      # Two parallel test jobs are executed.
      jobs:
        - name: Model Test
          commands:
            # Test the application's database models.
            - python manage.py test tasks.tests.test_models
        - name: View Test
          commands:
            # Test the application's views.
            - python manage.py test tasks.tests.test_views

  - name: "Run Browser Tests"
    task:
      # This block runs browser-based tests.
      # We need to set environment variables.
      # See https://docs.semaphoreci.com/essentials/environment-variables/
      env_vars:
        - name: DB_NAME
          value: 'pydjango'
      # This test requires the application to be running.
      # We start the application server here.
      prologue:
        commands:
          - sem-version python 3.7
          # Start MySQL database.
          - sem-service start mysql
          # Install mysql client
          - sudo apt-get install -y -qq mysql-client
          # Create an empty database.
          # We can connect to the db with root and a blank password.
          - mysql --host=0.0.0.0 -uroot -e "create database $DB_NAME"
          - checkout
          - cache restore
          - pip install -r requirements.txt --cache-dir .pip_cache
          # Application is started.
          - nohup python manage.py runserver &
      jobs:
        - name: Browser Test
          commands:
            # Run browser tests on Google Chrome.
            # On Semaphore, browsers are already installed.
            - python manage.py test tasks.tests.test_browser


  - name: "Run Security Tests"
    task:
      # This block runs through the security checklist for the project.
      jobs:
        - name: Deployment Checklist
          commands:
           - checkout
           - sem-version python 3.7
           - cache restore
           - pip install -r requirements.txt --cache-dir .pip_cache
           # Test if project can be deployed securely.
           - python manage.py check --deploy --fail-level ERROR
```

### Python

Semaphore provides [python 2 &
3](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/#python)
stable versions, as well as pip, pypy, and virtualvenv.

### Database access

In Semaphore, databases run in the same environment as jobs, and can
be accessed with a blank password. For more information on using
databases see [databases and
services](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/#databases-and-services)
and
[sem-service](https://docs.semaphoreci.com/reference/toolbox-reference/#sem-service).

### Browser testing

Semaphore provides [Chrome
preinstalled](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/#browsers-and-headless-browser-testing),
so no installation steps are required for doing browser tests.

Run the demo yourself
---------------------

A great way of getting started with Semaphore is to take a demo project
and run it yourself. Here's how to run the demo project with your own
account:

1.  [Fork the project on
    GitHub](https://github.com/semaphoreci-demos/semaphore-demo-python-django)
    with your account.
2.  Clone the repository to your local machine.
3.  In Semaphore, follow the link in the sidebar to create a new
    project.
4.  Edit any file and do a push to GitHub, Semaphore will automatically
    start the CI pipeline.

Next steps
----------

Congratulations! You have set up your first Django integration project
on Semaphore. The next step is to configure deployment. For further
information, please check the following tutorials:

-   [Deploying with
    promotions](https://docs.semaphoreci.com/essentials/deploying-with-promotions/).
-   [Deployment tutorials and example
    projects](https://docs.semaphoreci.com/examples/tutorials-and-example-projects/#deployment).

See also
--------

-   [Semaphore guided
    tour](../guided-tour/getting-started.md)
-   [Pipelines
    reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
-   [Toolbox
    reference](https://docs.semaphoreci.com/reference/toolbox-reference/)
-   [Environment variables and
    secrets](../essentials/environment-variables.md)
