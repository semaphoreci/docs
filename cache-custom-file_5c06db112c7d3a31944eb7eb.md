
* [Overview](#overview)
* [A sample Semaphore project](#a-sample-semaphore-project)
* [See also](#see-also)

## Overview

In this page you will learn how to download and cache a custom file in a
Semaphore 2.0 project so that it can be reused from the Cache server.

## A sample Semaphore project

The `.semaphore/semaphore.yml` file of the project is as follows:

	version: v1.0
	name: Download and cache custom file
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Download and Cache
	    task:
	      jobs:
	        - name: Download and Cache .deb
	          commands:
	            - checkout
	            - mkdir debs
	            - wget http://ge.archive.ubuntu.com/ubuntu/pool/universe/e/enscript/enscript_1.6.5.90-3_amd64.deb -O ./debs/enscript.deb
	            - cache store $SEMAPHORE_WORKFLOW_ID debs
    
	  - name: Reuse from cache
	    task:
	      prologue:
	        commands:
	          - checkout
	          - cache restore $SEMAPHORE_WORKFLOW_ID
	          - sudo dpkg -i ./debs/enscript.deb
    
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

The tricky point with deb packages is that you should also download and store
all the dependencies of the package that you are trying to install.
Fortunately, the downloaded package has no dependencies.

Note that the current version of the Semaphore VM uses Ubuntu **bionic**.

## See also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
