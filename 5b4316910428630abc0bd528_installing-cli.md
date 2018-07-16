### Introduction

The `sem` command line tool is used extensively by Semaphore 2.0 for
working with projects, secrets and organizations.

The purpose of this document is to help you installing  `sem` on your
UNIX machine. Please note that currently only Linux and macOS are
supported.

### Installing sem

You can get and install the `sem` command line utility by executing the
following command from your UNIX shell:

    $ curl https://storage.googleapis.com/sem-cli-releases/get.sh | bash

Please notice that the `sem` command line tool is a binary executable,
which means that you should get the version of `sem` that is suitable
for your operating system – this is being handled by the installation
command.

You can find out the version of `sem` you are using by executing `sem
version`.

Last, executing the `sem` command line tool without any parameters will
generate the following kind of output:

    $ sem
    Semaphore 2.0 command line interface
    
    Usage:
      sem [command]
    
    Available Commands:
      config      Get and set configuration options.
      connect     Connect to a Semaphore endpoint
      context     Manage contexts for connecting to Semaphore
      create      Create a resource from a file.
      delete      Delete a resource.
      describe    Describe a resource
      get         List of resources.
      help        Help about any command
      init        Initialize a project
      version     Display the version
    
    Flags:
      -h, --help      help for sem
      -v, --verbose   verbose output
    
    Use "sem [command] --help" for more information about a command.

The  `-v` parameter can be very handy when you have problems with
the `sem` command.


### What if a command does not exist

If you try to execute a `sem` command and this command does not exist, you will get an error message similar to the following:

    $ sem doesNotExist
    Error: unknown command "doesNotExist" for "sem"
    Run 'sem --help' for usage.
    unknown command "doesNotExist" for "sem"

On the other hand, if you try to access a resource type that does not exist, you will gent the following kind of error message:

    $ sem get doesNotExist
    error: Unknown resource kind doesNotExist.


