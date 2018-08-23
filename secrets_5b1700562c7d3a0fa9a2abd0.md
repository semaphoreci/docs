##  Introduction

This document will explain how you can work with secrets in Semaphore
2.0. Semaphore 2.0 stores confidential information in secrets using
environment variables. Expect to see support for configuration files In
the near future.

You can think of a `secrets` as a bucket in which you can place your
confidential information in the form of environment variables and
configuration files. Although you cannot have an environment variable
name to appear more than once in the same `secrets`, you can have
multiple `secrets` lists that contain the same environment variable
name.

Last `secrets` are connected to organizations, which means that if you
create a `secrets` under an orginization you will be able to use it in
all the Semaphore 2.0 projects of that organization.

# How you can put secrets in Semaphore 2.0

In this section you will learn how you can add your confidential
information in a Semaphore 2.0 `secrets`. Semaphore 2.0 supports two
ways for including confidential information: environment variables and
configuration files.

It is really important to understand that you are responsible for
putting the desired data using the desired format into a configuration
file.

So, the first thing to do is connecting to an organization as explained
in the [Changing Organizations][1]{: target="_blank"} documentation
page.

### Creating a secret

In this section you will learn how to create a secret for storing
confidential information in the form of environment variables and
configuration files.

The following YAML file create a new `secrets` item that is called
`more-mihalis-secrets` with two environment variables, named
`SECRET_ONE` and `SECRET_TWO`\:

    $ cat createSecret.yml
    apiVersion: v1alpha
    kind: Secret
    metadata:
      name: more-mihalis-secrets
    data:
      env_vars:
        - name: SECRET_ONE
          value: "Ca c'est un petite secret"
        - name: SECRET_TWO
          value: "Secret deux"

The you will have to execute the  `sem` command line tool as follows:

    $ sem create -f createSecret.yml
    apiVersion: v1alpha
    data:
      env_vars:
      - name: SECRET_ONE
        value: Ca c'est un petite secret
      - name: SECRET_TWO
        value: Secret deux
    kind: Secret
    metadata:
      id: 3e0938ac-b752-46ae-982f-c63ce817d847
      name: more-mihalis-secrets

Now, you can verify that a new  `secret` item has been created as
follows:

    $ sem get secrets
    NAME
    mihalis-secrets
    more-mihalis-secrets

### Listing the contents of a secrets property

You can list of the values of an existing  `secrets` as follows:

    $ sem describe secrets more-mihalis-secrets
    apiVersion: v1alpha
    data:
      env_vars:
      - name: SECRET_ONE
        value: Ca c'est un petite secret
      - name: SECRET_TWO
        value: Secret deux
    kind: Secret
    metadata:
      id: e6092e1d-a3c3-43b9-a209-5370f3835a9e
      name: more-mihalis-secrets

The next section will show how to list all the existing `secrets` of an
organization.

### Listing all the contents of all the secrets of an organization

The following script will help you list all the contents of all
the `secrets` of an organization:

    $ sem get secrets | grep -v NAME | xargs -n1 sem describe secrets

Its output will look as follows:

    apiVersion: v1alpha
    data:
      env_vars:
      - name: SECRET_ONE
        value: Ca c'est un petite secret
      - name: SECRET_TWO
        value: Secret deux
    kind: Secret
    metadata:
      id: a7c4d405-3344-4b88-9303-6827ad38f701
      name: mySecrets
    
    apiVersion: v1alpha
    data:
      env_vars:
      - name: SECRET_ONE
        value: Ca c'est un petite secret
      - name: SECRET_TWO
        value: Secret deux
    kind: Secret
    metadata:
      id: e6092e1d-a3c3-43b9-a209-5370f3835a9e
      name: more-mihalis-secrets
    
    apiVersion: v1alpha
    data:
      env_vars:
      - name: SECRET_ONE
        value: Ca c'est un petite secret
    kind: Secret
    metadata:
      id: b7bc03c0-2c0c-4317-b8fa-fa57d671f417
      name: mihalis-secrets

### Listing the available secrets

As you already saw, in order to list all the available `secrets` values,
you should execute the next command:

    $ sem get secrets
    NAME
    mihalis-secrets
    more-mihalis-secrets
    even-more-mihalis-secrets

### Deleting a secret

You can delete an existing `secrets` by executing the following command:

    $ sem delete secret mihalis-secrets

You can now verify that the desired `secrets` has been deleted as
follows:

    $ sem get secrets
    NAME
    more-mihalis-secrets
    even-more-mihalis-secrets

If the  `secrets` you want to delete does not exist, you will get the
following kind of error message:

    $ sem delete secret mihalis-secrets
    {"message":"Bad Request"}

# How you can use secrets in Semaphore 2.0

In the previous section, you learned how you can add confidential
information into a `secrets` and add that `secrets` to your Semaphore
2.0 organization. In this section, you will learn how to use your
confidential data, either as environment variables or as files.

Notice that you should select the `secrets` you want using the `name`
property.

### A complete example

The Semaphore 2.0 pipeline that will be used for the example project is
defined as follows:

    $ cat .semaphore/semaphore.yml
    version: v1.0
    name: Basic YAML configuration file example.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
      - task:
          jobs:
            - name: My Semaphore 2.0 job
              commands:
                - checkout
                - ls -l .semaphore
                - echo $SEMAPHORE_PIPELINE_ID
                - echo "Hello World!"
                - echo $SECRET_ONE
                - echo $SECRET_TWO
          secrets:
            - name: mySecrets
            - name: more-mihalis-secrets

Please notice that when the names of the environment variables of two
more more `secrets` are the same, then the environment variable will
have the value that can be found in the `secrets` property that was
imported last.

## What if you try to use a secret that does not exist?

Now, it is time to learn what will happen when you try to use a
`secrets` in your `.semaphore/semaphore.yml` file that does not exist.

The `.semaphore/semaphore.yml` file that will be used is the following:

    version: v1.0
    name: Using secrets in Semaphore 2.0
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
    - task:
          jobs:
            - name: My Semaphore 2.0 job
              commands:
                - echo "Hello World!"
                - echo $SECRET_ONE
                - echo $SEMAPHORE_PIPELINE_ID
          secrets:
            - name: does-not-exist

In that case the pipeline will fail to run.

## Errors

Errors happen all the time. So if there is something wrong and you
cannot get any data from the servers, you are going to see an error
message similar to the following:

    $ sem get secrets
    error: http status 502 received from upstream

Another kind of error you can get when dealing with  `secrets` is the
following:

    $ sem -v get secrets
    2018/07/05 00:22:09 https://semaphore.semaphoreci.com/api/v1alpha/secrets
    2018/07/05 00:22:13 response Status: 504 Gateway Timeout
    2018/07/05 00:22:13 response Headers: map[Alt-Svc:[clear] Content-Length:[24] Content-Type:[text/plain] Date:[Wed, 04 Jul 2018 21:22:12 GMT] Server:[envoy] Via:[1.1 google]]
    2018/07/05 00:22:13 upstream request timeout
    error: http status 504 received from upstream

Generally speaking using the `-v` switch when things go wrong might help
you or Rendered Text reveal the root of problem and correct it.



[1]: https://docs.semaphoreci.com/article/29-changing-organizations
