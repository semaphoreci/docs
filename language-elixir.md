* [Supported Versions](#supported-versions)
* [Dependency Caching](#dependency-caching)
* [Environment Variables](#environment-variables)
* [System Dependencies](#system-dependendices)

## Supported Versions

Semaphore uses [kiex](https://github.com/taylor/kiex) to manage
Elixir versions. Any version installable with kiex is supported on
Semaphore. Version 1.7 is pre-installed. You may install new versions
and change them with `sem-version`. Here's an example:

<pre><code class="language-yaml">
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - kiex install 1.6
          - sem-version elixir 1.6
      jobs:
        - name: Tests
          commands:
            - elixir --version
</code></pre>

## Dependency Caching

You can use Semaphores `cache` command to store and load the build and
dependency cache. You'll need one block to warm the cache, then use
the cache in subsequent blocks.

<pre><code class="language-yaml">
version: v1.0
name: Elixir & Pheonix Example
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Warm caches"
    task:
      env_vars:
        - name: MIX_ENV
          value: test
      jobs:
        - name: Dependencies
          commands:
            - checkout
            # Be sure to use --force to skip confirmation prompts
            - mix local.hex --force
            - mix local.rebar --force
            - cache restore v1-mix-deps-$(checksum mix.lock)
            - cache restore v1-mix-build-$(checksum mix.lock)
            - mix do deps.get, compile
            - cache store v1-mix-deps-$(checksum mix.lock) deps
            - cache store v1-mix-build-$(checksum mix.lock) _build
  - name: Tests
    task:
      env_vars:
        - name: MIX_ENV
          value: test
      prologue:
        commands:
          - checkout
          # Restore dependencies and compiled code
          - cache restore v1-mix-deps-$(checksum mix.lock)
          - cache restore v1-mix-build-$(checksum mix.lock)
      jobs:
        - name: Everything
          commands:
            - mix test
</code></pre>

## Environment Variables

Semaphore doesn't set language specific environment variables like
`MIX_ENV`. You need to set these at the task level.

<pre><code class="language-yaml">
blocks:
  - name: Tests
    task:
      env_vars:
        - name: MIX_ENV
          value: test
      jobs:
        - name: Everything
          commands:
            - mix test
</code></pre>

## System Dependencies

Projects may need system packages things like database drivers. You
have full `sudo` access so you may install required packages. Here's
an example of installing the Postgres dependencies.

<pre><code class="language-yaml">
blocks:
  - name: Tests
    task:
      prologue:
        commands:
          - sudo apt-get update && sudo apt-get install -y libpq-dev
          - mix install
      jobs:
        - name: Everything
          commands:
            - mix test
</code></pre>
