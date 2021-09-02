---
description: This guide gives a brief overview of self hosted agents and how they work.
---

# Overview

Semaphore allows you to run your jobs in an environment which is controlled by your team. That is achieved through the use of self hosted agents. In addition to that, compared to the hosted platform, self hosted agents offer more control over hardware, operating system versions and the available software, since you can run the agents anywhere you want: physical or virtual machines, containers or in the cloud.

## Agent communication with Semaphore

All communication between the agent and Semaphore is unidirectional, from the agent to Semaphore, secured via HTTPS TLS 1.3.

When booting, the agent attempts to register with the Semaphore 2.0 API. If it succeeds, it enters sync mode, sending periodic requests to Semaphore's API to tell it what it is doing and be told what to do next. If it fails to register, the agent does not start and does not receive any jobs. If it fails to sync, it also does not receive any more jobs and will eventually shutdown.

## Tokens used for communication

Three different types of tokens are used by the agent to communicate with Semaphore:

- **Agent type registration token**: this is the token that is used to start up the agent. It has only one purpose: register the agent on Semaphore. After registration, every agent gets an unique access token for further communication.
- **Agent access token**: this is the token used to coordinate the agent state with Semaphore. It allows the agent to execute `POST /sync` and `GET /job` requests. When an agent fetches a job from Semaphore, it uses the log stream token to stream logs back to Semaphore.
- **Job logs stream token**: each job gets a unique log stream token to send back logs to Semaphore. This token is generated for each job and its lifetime is limited to the job's execution lifecycle.

## Available toolbox features

The Semaphore Toolbox offers a set of tools to navigate language versions, databases, cache, artifacts and checking out your code. Some of these features are tied to our hosted system, and will not be available on self hosted agents.

| Feature                                     | Available | Notes                                  |
|---------------------------------------------|-----------|----------------------------------------|
| Changing language versions with sem-version | No        |                                        |
| Managing databases with sem-service         | No        |                                        |
| Accessing the cache                         | No        | This will be available at a later date |
| Artifact storage                            | Yes       |                                        |
| Publishing test results                     | Yes       |                                        |
| Checking out code with checkout command     | No        |                                        |

Debug sessions and the ability to attach to running jobs will also not be available, since Semaphore has no access to machines that are running in your infrastructure.