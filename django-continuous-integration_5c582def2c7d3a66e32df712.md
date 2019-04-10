This guide shows you how to use Semaphore to set up a continuous integration
(CI) pipeline for a Python Django web application.
Before starting, [create a new Semaphore project][create-project].

## Define the pipeline

Our Django CI pipeline will perform the following tasks:

- Lint code style with Pylint
- Run tests for each application using the built in framework

Mature applications usually have many tests and optimizing their runtime saves
a lot of valuable time for development. So for demonstration we'll run
tests for each application in the project in parallel.

We want fast feedback through the test pipeline, so we'll fail fast if
the linting fails. This prevents running time consuming tests for
semantically incorrect code.

Consider a sample Django `blog` project with two applications: `posts`
and `comments`. For these reasons our pipeline is composed of three
blocks, one for setup and two for tests:

``` yaml
# .semaphore/semaphore.yml
version: v1.0
name: Example Django Application
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Setup
    task:
      jobs:
        - name: Cache pip downloads
          commands:
            - sem-version python 3.7
            - checkout
            # Partial cache key matching ensures that new branches reuse gems
            # from the last build of master.
            - cache restore requirements-$SEMAPHORE_GIT_BRANCH-$(checksum requirements.txt),requirements-$SEMAPHORE_GIT_BRANCH-,requirements-master-
            - pip download --cache-dir .pip_cache -r requirements.txt
            - cache store requirements-$SEMAPHORE_GIT_BRANCH-$(checksum requirements.txt) .pip_cache

  - name: Lint
    task:
      prologue:
        commands:
          - sem-version python 3.7
          - checkout
          - cache restore requirements-$SEMAPHORE_GIT_BRANCH-$(checksum requirements.txt)
          - pip install -r requirements.txt --cache-dir .pip_cache
      jobs:
        - name: Project
          commands:
            # NOTE: The oddss are you'll need to rework the file selection to fit your project
            - git ls-files | grep -v 'migrations' | grep -v 'settings.py' | grep -v 'manage.py' | grep -E '.py$' | xargs pylint

  - name: Test
    task:
      env_vars:
        - name: DJANGO_SETTINGS_MODULE
          value: blog.ci
      prologue:
        commands:
          - sem-service start postgres
          - sem-version python 3.7
          - checkout
          - cache restore requirements-$SEMAPHORE_GIT_BRANCH-$(checksum requirements.txt)
          - pip install -r requirements.txt --cache-dir .pip_cache
      jobs:
        # Create parallel jobs for each application in the project
        - name: Posts App
          commands:
            - coverage run manage.py test posts
            - coverage report
        - name: Comments Apps
          commands:
            - coverage run manage.py test comments
            - coverage report
```

This example assumes a separate settings module to configure the
database. The settings are applied by setting the
`DJANGO_SETTINGS_MODULE` environemnt variable. Here's an example for
configuring PostreSQL:

``` yaml
# blog/ci.py
from .settings import *

DATABASES['default'] = {
    'ENGINE': 'django.db.backends.postgresql',
    'USER': 'postgres',
    'NAME': 'postgres',
    'HOST': 'localhost'
}
```

PostgreSQL instances run inside each job and can be accessed with a
blank password. For more information on configuring database access,
including tips for Python, see the [Python language guide][python-guide].

Firefox, Chrome, and Chrome Headless drivers for Capybara work out of the box,
so you will not need to make any adjustment for browser tests to work on
Semaphore.

This example configures coverage.py and and pylint. Be sure to exclude
the relevant files from coverage by creating a `.coveragerc`:

<pre><code class="language-conf"># .coveragerc
[run]
source = .
omit =
  venv/*
  manage.py
  */wsgi.py
  */migrations/*
  */__init__.py
```

Finally, you'll want to install `pylint-django` and add to the default
plugin list. Here's a snippet for `.pylintrc`:

<pre><code class="language-conf"># .pylintrc
load-plugins=pylint_django
```

## Next steps

Congratulations! You have set up your first Django continuous integration
project on Semaphore. Here’s some recommended reading:

- [Heroku deployment guide][heroku-guide] shows you how to set up continuous
deployment to Heroku.

## See also

- [Semaphore guided tour][guided-tour]
- [Pipelines reference][pipelines-ref]
- [Caching reference][cache-ref]
- [sem-service reference][sem-service]

[create-project]: https://docs.semaphoreci.com/article/63-your-first-project
[python-guide]: https://docs.semaphoreci.com/article/83-language-python
[guided-tour]: https://docs.semaphoreci.com/category/56-guided-tour
[pipelines-ref]: https://docs.semaphoreci.com/article/50-pipeline-yaml
[cache-ref]: https://docs.semaphoreci.com/article/54-toolbox-reference#cache
[sem-service]: https://docs.semaphoreci.com/article/54-toolbox-reference#sem-service
[heroku-guide]: https://docs.semaphoreci.com/article/100-heroku-deployment
