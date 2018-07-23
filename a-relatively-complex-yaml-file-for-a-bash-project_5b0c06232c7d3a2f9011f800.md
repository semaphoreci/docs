#### Introduction

In this document you will learn how to create a relatively complex YAML
file for a bash project.

#### The YAML File used

The entire .semaphore.yml file used for the presented Semaphore 2.0
project is as follows:

#### The steps for creating the project

The following commands show how you can create the fileproject that will
be used for this scenario

    $ git clone git@github.com:mactsouk/S3.git
    $ cd S3
    $ vi .semaphore.yml
    $ git add .semaphore.yml
    $ vi README.md
    $ git add README.md
    $ git commit -a -m "Initial version" 
    [master (root-commit) b0864f5] Initial version
     2 files changed, 1 insertion(+)
     create mode 100644 .semaphore.yml
     create mode 100644 README.md
    $ git push
    $ vi contents.txt
    $ git add contents.txt
    $ git commit -a -m "Added contents.txt"
    $ git push

Now that

#### The Web interface part

#### Project results

If

#### Explaining the YAML file in full detail

The following three lines in *.semaphore.yml* are the preamble and you
can consider them as mandatory:

    version: "v3.0"
    name: A complex Bash project.
    semaphore_image: standard

