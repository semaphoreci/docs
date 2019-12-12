This page shows how to store and access sensitive data such as API keys,
passwords, certificates, SSH keys other sensitive data.

## Overview

Secret is a organization level object that contains collection of environment
variables and files. Content of secret can be accessed in jobs that are part of
blocks or pipelines to which secret has be connected.


## Creating and managing secrets

### Web UI

1. Open dashboard of your organization.

2. Click *Secrets* in the sidebar. Find it in the *Configuration* section.

3. Click *Create New Secret* button.

4. Enter your secret information:

   * Specify *Name*
   * Enter environment variable name and value
   * Enter destination file path and upload file

5. Click *Save Changes*

### CLI

Use the [sem create
secret](https://docs.semaphoreci.com/article/53-sem-reference#sem-create)
command:

```
sem create secret blue-secret -e AWS_KEY=a1b2 -e AWS_SECRET=r2d2
```

To create secret that also contains a file use:

```
sem create secret red-secrets -e AWS_KEY=a1b2 -f /Users/john/key.pem:/home/semaphore/key.pem
```

To view secret use:

```
sem get secret blue-secret
```

To edit secret use:

```
sem edit secret blue-secret
```

For more information about managing secrets check [sem CLI Reference](https://docs.semaphoreci.com/article/53-sem-reference).

## Using secrets in jobs

### Web UI

### CLI


## See also
