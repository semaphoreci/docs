
* [Supported Erlang versions](#supported-erlang-versions)
* [Changing Erlang version](#changing-erlang-version)
* [Dependency management](#dependency-management)
* [System dependencies](#system-dependencies)
* [A sample Erlang project](#a-sample-erlang-project)
* [See also](#see-also)

## Supported Erlang versions


## Changing Erlang version

## Dependency management

You can use Semaphore's [cache tool](https://docs.semaphoreci.com/article/54-toolbox-reference#cache)
to store and load any files or Erlang libraries that you want to reuse between jobs.

## System dependencies

Erlang projects might need packages like database drivers. As you have full `sudo`
access on each Semaphore 2.0 VM, you are free to install all required packages.

## A sample Erlang project

The following `.semaphore/semaphore.yml` file compiles and executes an Erlang
source file using two different versions of the Erlang compiler:

## See Also

* [Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
