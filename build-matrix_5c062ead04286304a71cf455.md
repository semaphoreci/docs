
* [Overview](#overview)
* [A sample Semaphore project](#a-sample-semaphore-project)
* [See also](#see-also)

## Overview

This document illustrates the use of the `matrix` property using the C compiler
and C code as an example.

## A sample Semaphore project

	version: v1.0
	name: Using the matrix property
	agent:
	  machine:
	    type: e1-standard-2
	    os_image: ubuntu1804
    
	blocks:
	  - name: Compile C files
	    task:
	        jobs:
	        - name: Compile
	          commands:
	            - checkout
	            - echo $CVERSION
	            - echo $FILENAME
	            - sem-version c $CVERSION
	            - gcc $FILENAME.c -o $FILENAME_$CVERSION
	            - ./$FILENAME_$CVERSION
	          matrix:
	            - env_var: CVERSION
	              values: ["5", "6", "7", "8"]
	            - env_var: FILENAME
	              values: ["f1", "f2", "f3"]

This above pipeline will create 12 jobs because the Cartesian product of the
values of `CVERSION` and `FILENAME` is a set with 12 elements.

What the Semaphore project does is testing whether a set of three C files are
compiled with 4 different versions of the C compiler or not.

## See also

* [Pipeline YAML Reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
