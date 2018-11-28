
* [Supported C++ versions](#supported-c++-versions)
* [Changing gcc version](#changing-gcc-version)
* [Dependency Management](#dependency-management)
* [Environment variables](#environment-variables)
* [System dependencies](#system-dependencies)
* [A sample C project](#a-sample-c-project)
* [See also](#see-also)

## Supported C++ versions

Currently the Semaphore Virtual Machines support the following versions of the
`g++` C++ compiler:

* g++ 4.8: found as `/usr/bin/`
* g++ 5: found as `/usr/bin/`
* g++ 6: found as `/usr/bin/`
* g++ 7: found as `/usr/bin/`
* g++ 8: found as `/usr/bin/`

The default version of the G++ compiler can be found as follows:

	$ g++ --version
	

## Changing g++ version

The following Semaphore 2.0 project selects two different `g++` versions:


## Dependency Management

As there is no standard way to perform dependency management in C++, we will
skip that in this guide.

You can use the `cache` Semaphore 2.0 utility to store and load any files or
C++ libraries that you want to reuse in other jobs.

## Environment variables

Semaphore 2.0 does not set environment variables related to C++ so you will
have to define them on your own at the task level.

## System dependencies

C++ projects might need packages like database drivers. As you have full `sudo`
access on each Semaphore 2.0 VM, you are free to install all required packages.

## A sample C++ project

The following `.semaphore/semaphore.yml` file compiles and executes a C++ source
file using two different versions of the `g++` C++ compiler:


The contents of the `hw.cpp` file are as follows:


## See Also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
