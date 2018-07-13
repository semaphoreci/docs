#### Introduction

Note that all Semaphore 2.0 projects should use a .semaphore.yml file as
a configuration file.

#### The used YAML file

The contents of the *.semaphore.yml* file used for this project are as
follows:

    <br>

#### 

#### The steps for creating the project

Before continuing with the remaining of this section, you should create
a new GitHub repository. In this case, the name of the repository
is *DocsV2projects* but you can use any name you want! Please notice
that *DocsV2projects *will initially be an empty project but this will
change in a moment.

After having a repository named S4, the project will be created in
GitHub by executing the next *git* commands on a UNIX shell (the output
of a command in not shown unless it is important):

    $ git clone git@github.com:mactsouk/S4.git
    $ cd S4
    $ vi .semaphore.yml
    $ git add .semaphore.yml
    $ $ vi README.md
    $ git add README.md
    $ git commit -a -m "Initial version"
    [master (root-commit) 87dc627] Initial version
     2 files changed, 1 insertion(+)
     create mode 100644 .semaphore.yml
     create mode 100644 README.md
    $ git push

However this is not enough as you will have to create more files in a
while.

#### The Web interface part

The new version of Semaphore web interface is much simpler than before,
mainly because you now have to define most of the things of a project
using the *.semaphore.yml* file. The good news is that the PASSED and
FAILED badges are still here!

As before, you will need to add your GitHub project to Semaphore. After
that, if the *.semaphore.yml* file is correct, Semaphore 2.0 will build
your project.

#### Project results

If you have followed all the steps described in this document, then the
project will have no problems working with Semaphore 2.0.

#### Explaining the YAML file in full detail

In this section the *.semaphore.yml* file used for this simple project
will be explained in full detail.

The following three lines in *.semaphore.yml* are the preamble and you
can consider them as mandatory:

    version: "v3.0"
    name: A C project.
    semaphore_image: standard

<div>
The  *blocks* block contains build blocks that embed the jobs of the
project:
</div>

    blocks:

