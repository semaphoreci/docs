## Overview

Dependency mangagers like bundler, yarn, and Go's module system allow
specifying dependencies from private git repositories. This makes it
easier for teams to share code without requiring separate package
hosting. Authentication typically happens over SSH. It's possible
manage SSH keys using Semaphore's [secrets][] to authenticate to
private git repos. This article walks you through the process.

### Create the SSH Key

You'll need to generate an SSH key and associate that directly with
the project or a user who has access to that project. First, generate
a new public/private key pair on your local machine:

    $ ssh-keygen -t rsa -f id_rsa_semaphoreci

### Add the SSH Key

Next, connect the SSH key to the project or user. Github [Deploy
Keys][] are the easiest way to grant access to a single project. The
trade-off is that you'll need to add a deploy key for all private
projects. However you may re-use same key. Another solution is to
create a dedicated "ci" user, grant the "ci" user access to the
relevant projects, and add the key to the user. Regardless of what you
use, paste in the contents of `id_rsa.semaphoreci.pub` into relevant
SSH key configuration.

### Create the Secret

Now GitHub is configured with the public key. The next step is
configure your Semaphore pipline to use the private key. We'll use
[secret files][secrets] for this. Use the `sem` CLI to create a new
secret from the existing private key in `id_rsa_semaphoreci`:

    $ sem secret create private-repo --file id_rsa_semaphoreci:/home/semaphore/.keys/private-repo

This will create the file `~/.keys/private-repo` in your builds.

### Configure Build Steps

The last step is to add the `private-repo` to the relevant build
steps. This will expose the private key for use with `ssh-add`. Here's
an example.

<pre><code class="language-yaml">
blocks:
  - name: "Test"
    task:
      secrets:
        # Add the secret
        - name: private-repo
      prologue:
        commands:
          # correct premissions since they are too open by default
          - chmod 0600 ~/.keys/*
          # Add the key to the ssh agent
          - ssh-add ~/.keys/*
          - checkout
          # Install dependencies with bundler/yarn/etc
          - bundle install
      jobs:
        - name: Test
          commands:
            - rake test
</code></pre>

That's all there is to it. You can use the approach to add more deploy
keys to the `private-repo` secret to cover more projects and reuse the
secret across other projects.

[secrets]: https://docs.semaphoreci.com/article/66-environment-variables-and-secrets#storing-files-in-secrets
[deploy keys]: https://developer.github.com/v3/guides/managing-deploy-keys/
