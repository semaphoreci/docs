* [Supported Python versions](#supported-python-versions)
* [Dependency caching](#dependency-caching)
* [Environment variables](#environment-variables)
* [C-Extensions & system dependencies](#c-extensions-system-dependendices)

This guide covers configuring Python projects on Semaphore.
If you’re new to Semaphore please read our
[Guided tour](https://docs.semaphoreci.com/article/77-getting-started) first.

## Supported Python versions

Semaphore provides major Python versions and tools preinstalled.
You can find information about them in the
[Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image#python).

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

## Dependency caching

You can use Semaphore's `cache` command to store and load `pipenv`'s
virtualenv. This requires setting the `PIPENV_VENV_IN_PROJECT`
environment variable.
In the following configuration example, we install dependencies
and warm the cache in the first block, then use the cache in subsequent blocks.

<pre><code class="language-yaml">version: v1.0
name: Python Example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Install dependencies
    task:
      env_vars:
        - name: PIPENV_VENV_IN_PROJECT
          value: "true"
      prologue:
        commands:
          - sudo pip install pipenv
          - checkout
      jobs:
        - name: Install and cache dependencies
          commands:
            - cache restore pipenv-$(checksum Pipfile.lock)
            # --deploy also checks python version requirements
            - pipenv install --dev --deploy
            - cache store pipenv-$(checksum Pipfile.lock) .venv
  - name: Tests
    task:
      env_vars:
        - name: PIPENV_VENV_IN_PROJECT
          value: "true"
      prologue:
        commands:
          - sudo pip install pipenv
          - checkout
          - cache restore pipenv-$(checksum Pipfile.lock)
      jobs:
        - name: Everything
          commands:
            # assuming you have "test" in your Pipfile scripts
            - pipenv run test
</code></pre>

If you need to clear cache for your project, launch a
[debug session](https://docs.semaphoreci.com/article/75-debugging-with-ssh-access)
and execute `cache clear` or `cache delete <key>`.

## Environment Variables

Semaphore doesn't set project specific environment variables like
`TESTING` used in Flask. You can set these at the task level.

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

## C-Extensions & system dependencies

Projects may need system packages in order to install pips like `postgres`.
Semaphore provides full `sudo` access so you may install all required packages.
Here's an example of installing the `postgres` pip:

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
