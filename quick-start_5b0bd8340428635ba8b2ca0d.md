#### Introduction

Semaphore 2.0 is a continuous integration tool for every kind of user.

Note that all Semaphore 2.0 projects use a
`.semaphore/semaphore.yml` configuration file. This document will
present you a simple Semaphore 2.0 project.

After reading this document, you will be able to understand the
structure of the YAML configuration files used by Semaphore 2.0 and
start creating your own Semaphore 2.0 projects.

#### The process

The whole process is simple and includes the following steps:

* Create a GitHub repository. If you decide to use an existing GitHub
  repository, then you will not need to create a new one.
* Then you will need to execute `git clone` to have a copy of the GitHub
  repository on your computer.
* After that, execute `sem init` from the root directory of your local
  copy of the GitHub repository to create a new Semaphore 2.0 project.
* Create a `.semaphore/semaphore.yml` file and execute `git push`. Once
  you execute `git push` or insert the `.semaphore/semaphore.yml` file
  directly using the web interface of GitHub, Semaphore 2.0 will
  automatically start a new pipeline.

If the `.semaphore/semaphore.yml` file has no syntax errors, you will
get a green light from Semaphore 2.0 (Passed), which is the desired
result!

After that each change to any of the files of the GitHub project will
make Semaphore 2.0 rerun the pipeline of the project as defined in the
`.semaphore/semaphore.yml` file.

#### The used YAML file

The contents of the `.semaphore/semaphore.yml` file that will be used
for this project are as follows:

    version: v1.0
    name: Basic, 1 block YAML file example.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
    # Is this a valid comment?
    # Yes it is!
     - name: This is Block
       task:
          jobs:
            - name: Job 1 from 1st task block
              commands:
                - echo $SEMAPHORE_PIPELINE_ID
            - name: Job 2 from 1st task block
              commands:
                - echo "This is from the 2nd job of 1st task block"
                - echo $SEMAPHORE_PIPELINE_ID

This is a simple yet complete and autonomous project that uses shell
commands only without including any external utilities or files, which
makes it the simplest kind of a Semaphore 2.0 project.

#### The Web interface part

The web interface of Semaphore 2.0 is simple, mainly because you now
have to define most of the things of a project using the
`.semaphore/semaphore.yml` file. You can find it
at [https://id.semaphoreci.com/][1].

#### Explaining the YAML file in full detail

In this section the `.semaphore/semaphore.yml` file used for this simple
project will be explained in full detail. The following lines are the
preamble of `.semaphore/semaphore.yml` and you can consider them as
mandatory:

    version: v1.0
    name: Basic, 1 block YAML file example.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804


The `blocks` block is used for embedding the jobs of the project and is
also mandatory:


    blocks:
    # Is this a valid comment?
    # Yes it is!


The previous code also shows how you can include comment in a
`.semaphore/semaphore.yml` file.


The `task` keyword is used for defining the jobs of a Semaphore 2.0
project. Please notice that a Semaphore 2.0 project can contain multiple
`task` blocks.


     - name: This is Block
       task:

The line that begins with `- name` is used for assigning a name to
the `task` block that follows. 

After that you can start defining the jobs of a `task` block using the
`jobs` keyword:


          jobs:

That particular `task` block contains two jobs. The first one is defined
as follows:

            - name: Job 1 from 1st task block
              commands:
                - echo $SEMAPHORE_PIPELINE_ID

So, the name of that particular job is "Job 1 from 1st task block" and
contains a single command. The `SEMAPHORE_PIPELINE_ID` environment
variable is automatically defined by Semaphore 2.0 and is guaranteed to
be unique for each pipeline.

The second job from the first `task` block is defined as follows:


             - name: Job 2 from 1st task block
              commands:
                - echo "This is from the 2nd job of 1st task block"
                - echo $SEMAPHORE_PIPELINE_ID

This particular job contains just two `echo` commands. As before, the
`SEMAPHORE_PIPELINE_ID` environment variable is defined by Semaphore
2.0.

Feel free to make changes to the `.semaphore/semaphore.yml` file of the
presented project and maybe try to break it by inserting an unknown
keyword or a command that fails!


[1]: https://id.semaphoreci.com/
