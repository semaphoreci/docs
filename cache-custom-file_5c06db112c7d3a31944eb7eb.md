
* [Overview](#overview)
* [A sample Semaphore project](#a-sample-semaphore-project)
* [See also](#see-also)

## Overview

In this page you will learn how to cache one or more files in the Semaphore
Cache server *indefinitely*.

## A sample Semaphore project

The `.semaphore/semaphore.yml` file of the project is as follows:

	version: v1.0
	name: Cache custom file
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Use cache or create
	    task:
	      jobs:
	        - name: .deb from Cache or create cache
	          commands:
	            - checkout
	            - cache restore $SEMAPHORE_PROJECT_NAME
	            - "[ -d 'packages' ] && echo 'Found' || source ./getDeb.sh"
	            - ls -l packages
    
	  - name: Reuse from cache
	    task:
	      prologue:
	        commands:
	          - checkout
	          - cache restore $SEMAPHORE_PROJECT_NAME
	          - sudo dpkg -i ./packages/enscript.deb
    
	      jobs:
	        - name: ps -ax
	          commands:
	            - ps -ax > psList
	            - enscript -pPSlist.ps psList
	            - ls -l
	        - name: 2-col ps -ax
	          commands:
	            - ps -ax > psList
	            - enscript -2rG -pPSlist.ps psList
	            - ls -l

The contents of the `getDeb.sh` shell script are as follows:

	cache delete $SEMAPHORE_PROJECT_NAME
	mkdir packages
	wget http://ge.archive.ubuntu.com/ubuntu/pool/universe/e/enscript/enscript_1.6.5.90-3_amd64.deb -O ./packages/enscript.deb
	cache store $SEMAPHORE_PROJECT_NAME packages

You are free to download as many deb packages as needed by your project as long
as you are putting them inside the same directory, which is this case is named
`packages`.

The tricky point with *deb* packages is that you should also download and store
all the dependencies of the package that you are trying to install.
Fortunately, the used package has no dependencies. Also, note that the current
version of the Semaphore VM uses Ubuntu **bionic**.

Last, remember that the value of the `SEMAPHORE_PROJECT_NAME` environment
variable remains the same during the lifetime of any given project and is
available in all the blocks of a pipeline.

## See also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Toolbox Reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
* [Environment variables](https://docs.semaphoreci.com/article/12-environment-variables)
