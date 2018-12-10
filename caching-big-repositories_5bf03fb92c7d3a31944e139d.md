
* [Overview](#overview)
* [The logic behind the recipe](#the-logic-behind-the-recipe)
* [An example project](#an-example-project)
* [What to expect from this optimization](#what-to-expect-from-this-optimization)
* [See Also](#see-also)

## Overview

This guide shows you how to cache a large Git repository and avoid cloning it
from scratch in every block.

## The logic behind the recipe

The example project that follows is getting all the files of the GitHub
repository in the first job using `checkout` and then is storing them into the
Semaphore 2.0 Cache server using `cache store`. The remaining jobs of the
project will use these files from the Cache server using `cache restore`
without calling `checkout` again.

Please note that any changes you make to the files that are stored in Semaphore
Cache servers during the execution of the pipeline will not get automatically
propagated to GitHub servers.

## An example project

The example project of this section will use 10 large files. Each one of these
10 files is around 100MB in size.

Each one file was generated using the following command:

    dd if=/dev/random of=filename bs=1024 count=100000

The Semaphore 2.0 environment variables that will be used are the following:

* `SEMAPHORE_PROJECT_NAME`: This environment variable holds the name of the
    current Semaphore 2.0 project.
* `SEMAPHORE_GIT_SHA`: This environment variable holds the current revision of
    the GitHub code that the pipeline is using.

Note that the combination of `SEMAPHORE_PROJECT_NAME` and `SEMAPHORE_GIT_SHA`
gets updated each time you make changes to the GitHub repository.

The `semaphore.yml` file for the example project will be the following:

	version: v1.0
	name: Recipe of Caching Big Repositories
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	promotions:
	- name: Cleanup
	  pipeline_file: cleanup.yml
	  auto_promote_on:
	    - result: passed
	    - result: failed
    
	blocks:
	  - name: Reuse GitHub repository
	    task:
	      jobs:
	      - name: Cache GitHub repository
	        commands:
	          - checkout
	          - cd ..
	          - cache store "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA" $SEMAPHORE_PROJECT_NAME
    
	  - name: Block item 2 - Two Jobs
	    task:
	      jobs:
	      - name: Use Cache - Job 1
	        commands:
	          - ls -al "$SEMAPHORE_PROJECT_NAME"/FILES
	      - name: Use Cache - Job 2
	        commands:
	          - du -k -s
	      prologue:
	        commands:
	          - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
    
	  - name: Block item 3 - Single Job
	    task:
	      jobs:
	      - name: Use Cache - Job 2
	        commands:
	          - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	          - ls -al "$SEMAPHORE_PROJECT_NAME"
	          - du -k -s

The contents of `.semaphore/cleanup.yml` are as follows:

	version: v1.0
	name: Cleanup cache
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Cache delete
	    task:
	      jobs:
	      - name: Delete key from cache
	        commands:
	          - cache delete "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"

The main reason for using a promotion to clean up the Cache server is that
promotions can get executed even if one or more `jobs` of a pipeline fail.

## What to expect from this optimization

* Using the Semaphore Cache server instead of GitHub servers will improve
    stability.
* Using the Semaphore Cache server instead of GitHub servers via `checkout`
    will reduce the total number of seconds all jobs in a pipeline combined
	spent, which will also reduce the price.

## See Also

* [Installing sem](https://docs.semaphoreci.com/article/63-your-first-project)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
