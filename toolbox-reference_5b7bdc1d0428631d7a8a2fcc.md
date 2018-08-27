# Toolbox Reference

- [Overview](#overview)
- [Essentials](#essentials)
  * [libcheckout](#libcheckout)
  * [sem-service](#sem-service)
  * [retry](#retry)
- [See also](#see-also)
  
  
## Overview


## Essentials

This section contains the most useful entries of Semaphore 2.0 toolbox

### libcheckout


#### Description

The `libcheckout` script includes the implementation of a single function
named `checkout()` that is used for 

#### Command Line Parameters

#### Dependencies

The `checkout()` function of the `libcheckout` script depends on the following
three environment variables:

   - `SEMAPHORE_GIT_URL`:
   - `SEMAPHORE_GIT_DIR`:
   - `SEMAPHORE_GIT_SHA`:
   
Both these environment variables are defined by Semaphore 2.0.

#### Examples

### sem-service

#### Description

The `sem-service` script is a utility for starting, stopping and restarting background services with Docker that listen on 0.0.0.0, which includes all the available network interfaces.

#### Command Line Parameters

The general form of a sem-service command is as follows

    sem-service [start|stop|status] image_name

Therefore, each `sem-service` command requires two parameters: the first one is the task you want to perform and the second parameter is the Docker image that will be used for the task.

#### Dependencies

The `sem-service` utility

#### Examples

If the first command line argument is invalid, `sem-service` will print its help screen.

	sem-service abc an_image
	#####################################################################################################
	service 0.5 | Utility for starting background services, listening on 0.0.0.0, using Docker
	service [start|stop|status] image_name
	#####################################################################################################



### retry


#### Description

The `retry` script

#### Command Line Parameters

#### Dependencies

#### Examples

	$ retry lsa -l
	/usr/bin/retry: line 46: lsa: command not found
	[1/3] Execution Failed with exit status 127. Retrying.
	/usr/bin/retry: line 46: lsa: command not found
	[2/3] Execution Failed with exit status 127. Retrying.
	/usr/bin/retry: line 46: lsa: command not found
	[3/3] Execution Failed with exit status 127. No more retries.

In the previous example the `retry` command will never be successful because the `lsa` command is invalid.

## See also

