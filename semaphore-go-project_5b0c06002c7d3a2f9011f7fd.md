#### Introduction

In this document you will learn how to create a simple Semaphore 2.0
project that uses the <a href="https://golang.org/" target="_blank">Go Programming Language</a>.

#### The YAML File used

The contents of the `.semaphore/semaphore.yml` file for a GitHub project
named `goDemo` are as follows:

    $ cat .semaphore/semaphore.yml
    version: v1.0
    name: YAML file example for Go project.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
     - name: Inspect Linux environment
       task:
          jobs:
            - name: Display hw.go
              commands:
                - echo $SEMAPHORE_PIPELINE_ID
                - echo $HOME
                - pwd
                - ls -al
                - cat hw.go
                - echo $VAR1
                - echo $PI
          prologue:
              commands:
                - checkout
                - echo $SEMAPHORE_GIT_DIR
          env_vars:
               - name: VAR1
                 value: Environment Variable 1
               - name: PI
                 value: "3.14159"
    
     - name: Build Go project
       task:
          jobs:
            - name: Build hw.go
              commands:
                - checkout
                - change-go-version 1.10
                - go build hw.go
                - ls -l ./hw
                - file ./hw
                - ./hw
            - name: PATH variable
              commands:
                - echo $PATH
          epilogue:
              commands:
                - echo $SEMAPHORE_JOB_RESULT
                - echo $SEMAPHORE_PIPELINE_ID

#### The steps for creating the project

The steps for creating the project are the following:

* Create a GitHub repository and add a file named `hw.go` in it.
* Add that GitHub repository to Semaphore 2.0 by creating a local copy
  of it using `git clone` and executing `sem init` from the root
  directory of the repository.
* Create a `.semaphore/semaphore.yml` file and execute `git commit ...`
  and `git push`.

The contents of the `hw.go` file that is used are as follows:

    $ cat hw.go
    package main
    
    import ( 
    	"fmt"
    	"os"
    )
    
    func main() {
    	fmt.Println("Hello World!")
    	fmt.Println("SEMAPHORE_PIPELINE_ID:", os.Getenv("SEMAPHORE_PIPELINE_ID"))
    }

As you can see, the `hw.go` program reads `SEMAPHORE_PIPELINE_ID`, which
is an environment variable defined by Semaphore.

This is all that you are going to need for creating the presented
Semaphore 2.0 project. You can see the results of all your projects by
visiting <a href="https://id.semaphoreci.com/" target="_blank">https://id.semaphoreci.com</a>.

#### Explaining the YAML file in full detail

The following three lines in `.semaphore/semaphore.yml` are the preamble
and you can consider them as mandatory:

    version: v1.0
    name: YAML file example for Go project.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804

The `blocks` block contains `task` blocks that embed the jobs of the
project:

    blocks:
     - name: Inspect Linux environment
       task:

In this case, the Semaphore 2.0 project contains the jobs. The first job
is defined as follows:

          jobs:
            - name: Display hw.go
              commands:
                - echo $SEMAPHORE_PIPELINE_ID
                - echo $HOME
                - pwd
                - ls -al
                - cat hw.go
                - echo $VAR1
                - echo $PI

Additionally, this job has a `prologue` property, which is defined as
follows:

          prologue:
              commands:
                - checkout
                - echo $SEMAPHORE_GIT_DIR

The `prologue` of a `task` is the perfect place to put the `checkout`
command, especially when you have multiple jobs defined under the same
`task` property.

Last, the `checkout` command moves you to the root directory of your
GitHub project in a portable way. If you want to move to the root
directory of your GitHub project after visiting other directories of
your repository first, you can use the `cd $SEMAPHORE_GIT_DIR` command
because it is portable.

Last, the particular job defined two environment variables using an
`env_vars` block:

          env_vars:
               - name: VAR1
                 value: Environment Variable 1
               - name: PI
                 value: "3.14159"

As you might imagine, the indentation levels of all environment
variables mush be the same.

The next two jobs are defined in a separate `task` block.

     - name: Build Go project
       task:
          jobs:

The first one of these two jobs is as follows:

            - name: Build hw.go
              commands:
                - checkout
                - change-go-version 1.10
                - go build hw.go
                - ls -l ./hw
                - file ./hw
                - ./hw

The `change-go-version` command is used for selecting the version of Go
you would like to use. As the current machine supports both Go version
1.9 and Go version 1.10, calling the `change-go-version` utility is
required for selecting the version of Go you want to use. What you will
need to do mainly depends on the requirements of your project.

The last job of the project is pretty simple and just prints the value
of the `PATH` environment variable:

            - name: PATH variable
              commands:
                - echo $PATH

Last, this `task` block has an `epilogue` block that is defined as
follows:

          epilogue:
              commands:
                - echo $SEMAPHORE_JOB_RESULT
                - echo $SEMAPHORE_PIPELINE_ID

The commands of the `epilogue` block are execute after each job that
belongs to the same `block` as the `epilogue`. So, in this case, the
commands of the `epilogue` block will get executed two times.


