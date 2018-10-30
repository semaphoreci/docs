* [Supported Versions](#supported-versions)
* [Dependency Caching](#dependency-caching)
* [Environment Variables](#environment-variables)
* [C-Extensions & Dependencies](#c-extensions-dependendices)

## Supported Versions

Python 2.7 is the default version. This can be switched to 3.7 with
`sem-version`. Here's an example:

<pre><code class="language-yaml">blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sem-version python 3.7
      jobs:
        - name: Tests
          commands:
            - python --version
</code></pre>

## Dependency Caching

You can use Semaphore's `cache` command to store and load `pipenv`'s
virtualenv. This requires setting the `PIPENV_VENV_IN_PROJECT`
environment variable. You'll need one block to warm the cache, then
use the cache in subsequent blocks.

<pre><code class="language-yaml">version: "v1.0"
version: "v1.0"
name: Python Example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Warm caches
    task:
      env_vars:
        - name: PIPENV_VENV_IN_PROJECT
          value: "true"
      prologue:
        commands:
          - sudo pip install pipenv
          - checkout
      jobs:
        - name: Dependencies
          commands:
            - cache restore v1-pipenv-$(checksum Pipfile.lock)
            # --deploy also checks python version requirements
            - pipenv install --dev --deploy
            - cache store v1-pipenv-$(checksum Pipfile.lock) .venv
  - name: Tests
    task:
      env_vars:
        - name: PIPENV_VENV_IN_PROJECT
          value: "true"
      prologue:
        commands:
          - sudo pip install pipenv
          - checkout
          - cache restore v1-pipenv-$(checksum Pipfile.lock)
      jobs:
        - name: Everything
          commands:
            # assuming you have "test" in your Pipfile scripts
            - pipenv run test
</code></pre>

## Environment Variables

Semaphore doesn't set project specific environment variables like
`TESTING` used in flask. You should set these at the task level.

<pre><code class="language-yaml">blocks:
  - name: Tests
    task:
      env_vars:
        - name: TESTING
          value: "1"
      jobs:
        - name: Everything
          commands:
            - python test.py
</code></pre>

## C-Extensions & Dependencies

Projects may need system packages to install pips like `postgres`. You
have full `sudo` access so you may install required packages. Here's
an example of installing the `postgres` pip.

<pre><code class="language-yaml">blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sudo apt-get update && sudo apt-get install -y libpq-dev
          - pip install postgres
      jobs:
        - name: Everything
          commands:
            - python test.py
</code></pre>
