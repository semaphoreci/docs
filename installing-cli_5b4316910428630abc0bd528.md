## Overview

The `sem` command line tool is used extensively in Semaphore 2.0 for
working with projects, secrets and organizations.

The purpose of this document is to help you install `sem` on your UNIX machine.

Please note that currently only Linux and macOS binary files of `sem` are
provided.

### Installing sem

You can get and install the `sem` command line utility by executing the
following command from your UNIX shell:

    $ curl https://storage.googleapis.com/sem-cli-releases/get.sh | bash

Please notice that the `sem` command line tool is a binary executable,
which means that you should get the version of `sem` that is suitable
for your operating system – this is being handled by the installation
command.

After a successful installation, you can find out the version of `sem` you are
using by executing `sem version`.

Last, executing the `sem` command line tool without any parameters will
generate a help screen.

## See also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Changing Organizations](https://docs.semaphoreci.com/article/29-changing-organizations)
