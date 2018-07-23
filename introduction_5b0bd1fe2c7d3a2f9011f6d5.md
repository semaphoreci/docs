### An Introduction to YAML files

YAML, which stands for *YAML Ain\'t Markup Language*, is a plain text
format that is commonly used for configuration files and can be easily
read by humans.

Each YAML file is based on a given grammar, which basically means that
it has a structure that depends on the grammar and that you might have
to deal with YAML files that do not follow the grammar you desire.

#### Advantages of YAML files

The advantages of using YAML files include the following:

* They are easy to edit as they are in plain text format.
* YAML files are easy to understand
* YAML configuration files make creating simple configurations easy
  while making creating and editing complex configurations possible.
* Duplicating a YAML configuration is as easy as making a copy of the
  YAML file so no more point and click.
* Using YAML configuration files makes the User Interface of Semaphore
  2.0 much simpler.
* Additionally, you do not have to go through the Semaphore web
  interface all the time.

#### Disadvantages of YAML files

The disadvantages of YAML files are as follows:

* Not all people want to use YAML files for configuring things and still
  prefer a graphical user interface.
* Learning how to create YAML files might be difficult at first for some
  users.
* You have to write the YAML configuration file on your own.
* You need to be extra careful when creating YAML files because even a
  difference by a single white space in the indentation of the elements
  of the same list can make your YAML file invalid. Putting it simply,
  YAML uses *indentation*.
* Editing large YAML files might be difficult.

#### About Semaphore 2.0

In Semaphore 2.0 you will have to use YAML files for configuring your
Semaphore 2.0 projects, which includes the configuration of jobs, the
commands of a job and the name of a job as well as for creating secrets
and projects.

The name of the YAML file used for configuring Semaphore 2.0 projects is
`.semaphore/semaphore.yml` (please notice the `.` character that is part
of the filename). If you are using `git` for your Semaphore projects on
a UNIX machine you should be aware of the fact that files that begin
with the `.` character are hidden and can only be seen when you execute
the `ls(1)` command with the `-a` switch.

#### About Semaphore 2.0 YAML files

The following is a small YAML configuration file used in a simple
Semaphore 2.0 project that has two jobs and uses secrets:

    $ cat .semaphore/semaphore.yml
    version: "v1.0"
    name: Basic YAML configuration file example.
    agent:
      machine:
        type: e1-standard-2
        os_image: ubuntu1804
    blocks:
      - task:
          jobs:
            - name: My Semaphore 2.0 job
              commands:
                - checkout
                - ls -l .semaphore
                - echo $SEMAPHORE_PIPELINE_ID
                - echo "Hello World!"
                - echo $SECRET_ONE
                - echo $SECRET_TWO
            - name: My second Semaphore 2.0 job
              commands:
                - checkout
                - echo $SECRET_TWO
                - ls -l .semaphore
          secrets:
            - name: mySecrets
              env_var_names: []
            - name: more-mihalis-secrets
              env_var_names: []

#### Accessing the files of you repository.

By default, the files of your GitHub repository are not accessible by
Semaphore 2.0. In order to make the files of your GitHub repository
accessible to Semaphore, you will need to execute the `checkout` command
in the list of commands of a job.

#### 

#### Summary

So, the main advantages of YAML are that is human readable and that is
based on grammars.

