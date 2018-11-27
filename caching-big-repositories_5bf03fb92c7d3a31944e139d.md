
* [Overview](#overview)
* [The scenario](#the-scenario)
* [The logic behind the recipe](#the-logic-behind-the-recipe)
* [An example project](#an-example-project)
* [See Also](#see-also)

## Overview

The purpose of this document is to provide a recipe for caching big
repositories in order to reuse them faster.

## The scenario

Imagine that you have one or more large files on a GitHub repository and that
you want to make the downloading of them as fast as possible.

## The logic behind the recipe

Using the Cache server provided by Semaphore 2.0 for getting the files of your
GitHub repository is much faster than using the GitHub server machines for the
same task because the Semaphore 2.0 Cache server in on the same network as the
Virtual Machines used for executing the jobs of the Semaphore 2.0 pipeline.
Therefore using the Semaphore 2.0 Cache server is faster than downloading files
from the GitHub servers.

What the example project that follows will do is getting all the files of the
GitHub repository using `checkout` in the first job and the storing them into
the Semaphore 2.0 Cache server. The remaining jobs of the project will use
these files from the Cache server without calling `checkout` again.

Note that for this recipe to work, the files of the GitHub repository should
remain intact during the lifetime of the Semaphore 2.0 project.

## An example project

The example project of this section will use multiple large files. Each one of
the 10 files is around 100MB in size.

Each file was generated using the following command:

    dd if=/dev/random of=filename bs=1024 count=100000

The Semaphore 2.0 environment variables that will be used are the following:

* `SEMAPHORE_PROJECT_NAME`: This environment variable holds the name of the
    current Semaphore 2.0 project.
* `SEMAPHORE_GIT_SHA`: This variable holds the current revision of the GitHub
    code that the pipeline is using.

The combination of `SEMAPHORE_PROJECT_NAME` and `SEMAPHORE_GIT_SHA` gets
updated each time you make changes to the GitHub repository.

The `semaphore.yml` file for the example project will be the following:

	version: v1.0
	name: Recipe of Caching Big Repositories
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Reuse GitHub repository
	    task:
	      jobs:
	      - name: Cache GitHub repository
	        commands:
	          - checkout
	          - cd ..
	          - cache store "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA" $SEMAPHORE_PROJECT_NAME
    
	  - name: Task 2 - Single Job
	    task:
	      jobs:
	      - name: Use Cache - Job 1
	        commands:
	          - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	          - ls -al "$SEMAPHORE_PROJECT_NAME"/FILES
    
	  - name: Task 3 - Single Job
	    task:
	      jobs:
	      - name: Use Cache - Job 2
	        commands:
	          - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	          - ls -al "$SEMAPHORE_PROJECT_NAME"
	          - du -k -s
    
	  - name: Task 4 - Two jobs
	    task:
	      jobs:
	      - name: Use Cache - Job 3
	        commands:
	          - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	          - ls -al "$SEMAPHORE_PROJECT_NAME"/FILES
    
	      - name: Use Cache - Job 4
	        commands:
	          - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	          - du -k -s
    
	  - name: Task 5 - Single Job
	    task:
	      jobs:
	      - name: Use Cache - Job 5
	        commands:
	          - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	          - ls -al "$SEMAPHORE_PROJECT_NAME"
	          - du -k -s

## Evaluating the results

The same project was executed with and without using the Semaphore 2.0 Cache
server.

The output of the `diff` command shows the differences between the two
versions:

	diff .semaphore/semaphore.yml.cache .semaphore/semaphore.yml.nocache
	16d15
	<           - cache store "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA" $SEMAPHORE_PROJECT_NAME
	23,24c22,23
	<           - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	<           - ls -al "$SEMAPHORE_PROJECT_NAME"/FILES
	---
	>           - checkout
	>           - ls -al
	31c30,31
	<           - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	---
	>           - checkout
	>           - cd ..
	40,41c40,41
	<           - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	<           - ls -al "$SEMAPHORE_PROJECT_NAME"/FILES
	---
	>           - checkout
	>           - ls -al
	45c45,46
	<           - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	---
	>           - checkout
	>           - cd ..
	53c54,55
	<           - cache restore "$SEMAPHORE_PROJECT_NAME-$SEMAPHORE_GIT_SHA"
	---
	>           - checkout
	>           - cd ..

The total time it took the version that **uses** `cache` to finish the
Semaphore 2.0 project was 332 seconds.

The total time it took the version that uses `checkout` instead of `cache` to
finish the Semaphore 2.0 project was 348 seconds.

The improvement from using Semaphore 2.0 cache server was not that big due to
the overhead introduced by the `cache store` command, which was 129 seconds.

Nevertheless, there was still a 16 seconds improvement!

## See Also

* [Installing sem](https://docs.semaphoreci.com/article/63-your-first-project)
* [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
