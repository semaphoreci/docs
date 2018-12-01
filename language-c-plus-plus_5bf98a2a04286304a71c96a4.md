
* [Supported C++ versions](#supported-compiler-versions)
* [Changing compiler version](#changing-compiler-version)
* [Dependency management](#dependency-management)
* [System dependencies](#system-dependencies)
* [A sample C++ project](#a-sample-project)
* [See also](#see-also)

## Supported compiler versions

Semaphore VM is 64-bit and provides the following versions of the g++ compiler:

* g++ 4.8: found as `/usr/bin/g++-4.8`
* g++ 5: found as `/usr/bin/g++-5`
* g++ 6: found as `/usr/bin/g++-6`
* g++ 7: found as `/usr/bin/g++-7`
* g++ 8: found as `/usr/bin/g++-8`

The default version of the g++ compiler can be found as follows:

	$ g++ --version
	g++ (Ubuntu 4.8.5-4ubuntu8) 4.8.5
	Copyright (C) 2015 Free Software Foundation, Inc.
	This is free software; see the source for copying conditions.  There is NO
	warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

## Changing compiler version

The following Semaphore 2.0 project selects two different versions of g++:

	version: v1.0
	name: Using C++ in Semaphore 2.0
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Change G++ version
	    task:
	      jobs:
	      - name: Select g++ version 6
	        commands:
	          - g++ --version
	          - sem-version cpp 6
	          - g++ --version
    
	      - name: Select g++ version 8
	        commands:
	          - g++ --version
	          - sem-version cpp 8
	          - g++ --version

## Dependency management

You can use Semaphore's [cache tool](https://docs.semaphoreci.com/article/54-toolbox-reference#cache)
to store and load any files or C++ libraries that you want to reuse between jobs.

## System dependencies

C++ projects might need packages like database drivers. As you have full `sudo`
access on each Semaphore 2.0 VM, you are free to install all required packages.

## A sample project

The following `.semaphore/semaphore.yml` file compiles and executes a C++ source
file using two different versions of the g++ C++ compiler:

	version: v1.0
	name: Using C++ in Semaphore 2.0
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Compile C++ code
	    task:
	      jobs:
	      - name: Hello World!
	        commands:
	          - checkout
	          - g++ hw.cpp -o hw_4
	          - ./hw_4
	          - sem-version cpp 8
	          - g++ hw.cpp -o hw_8
	          - ./hw_8
	          - ls -l hw_4 hw_8

The contents of the `hw.cpp` file are as follows:

<pre><code class="language-c++">
#include < iostream >
using namespace std;

int main()
{
    cout << "Hello, World!\n";
    return 0;
}
</code></pre>

## See Also

* [Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [update-alternatives man page](http://manpages.ubuntu.com/manpages/trusty/man8/update-alternatives.8.html)
