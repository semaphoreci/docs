- [Supported Erlang versions](#supported-erlang-versions)
- [Changing Erlang version](#changing-erlang-version)
- [Dependency management](#dependency-management)
- [System dependencies](#system-dependencies)
- [A sample Erlang project](#a-sample-erlang-project)
- [See also](#see-also)

## Supported Erlang versions

The list of supported Erlang versions is the following:

- 20.3
- 21.0

## Changing Erlang version

The [`sem-version` utility][sem-version]
can help you change between the available Erlang versions.

By default Semaphore Virtual Machine uses Erlang version 21.0. You can change
to Erlang version 20.3 by executing the following command:

``` yaml
sem-version erlang 20
```

You can change back to Erlang version 21.0 by executing the following command:

``` yaml
sem-version erlang 21
```

## Dependency management

You can use Semaphore's [cache tool](https://docs.semaphoreci.com/article/54-toolbox-reference#cache)
to store and load any files or Erlang libraries that you want to reuse between jobs.

## System dependencies

Erlang projects might need packages like database drivers. As you have full `sudo`
access on each Semaphore 2.0 VM, you are free to install all required packages.

## A sample Erlang project

The following `.semaphore/semaphore.yml` file compiles and executes an Erlang
source file using two different versions of the Erlang compiler:

``` yaml
version: v1.0
name: Using Erlang
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Change Erlang version
    task:
      jobs:
      - name: Erlang version
        commands:
          - checkout
          - kerl status
          - erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell
          - sem-version erlang 20
          - kerl active
          - erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell
          - sem-version erlang 21
          - kerl active
          - erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell

- name: Compile Erlang code
  task:
    jobs:
    - name: Hello World 21.0
      commands:
        - checkout
        - erlc hello.erl
        - ls -l
        - erl -noshell -s hello helloWorld -s init stop

    - name: Hello World 20.3
      commands:
        - checkout
        - sem-version erlang 20
        - erlc hello.erl
        - ls -l
        - erl -noshell -s hello helloWorld -s init stop
```

The Erlang code of `hello.erl` is as follows:

``` erlang
%% Programmer: Mihalis Tsoukalos
%% Date: Friday 21 December 2018

-module(hello).
-export([helloWorld/0]).

helloWorld() -> io:fwrite("hello, world\n").
```

## See Also

- [Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image)
- [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
- [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)

[sem-version]: https://docs.semaphoreci.com/article/131-sem-version-managing-language-version-on-linux
