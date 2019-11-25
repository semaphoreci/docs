## Overview
In Semaphore every job executes commands in a new interactive shell
which means that all exported variable is available during the build:

```
blocks:
  - name: "Tests"
    task:
      jobs:
        - name: "Test job"
          commands:
            - export VAR1=MyTestVar
            - checkout
            - echo $VAR1
```

The same applies to changing directories. If you change a directory
next command will be executed inside that directory:

```
blocks:
  - name: "Tests"
    task:
      jobs:
        - name: "Test job"
          commands:
            - git clone git@github.com:semaphoreci-demos/semaphore-demo-ruby-rails.git
            - cd semaphore-demo-ruby-rails
            - bundle install --path vendor/bundle
```

Default shell for all semaphore jobs is `bash`:

Bash settings:
```
allexport      	off
braceexpand    	on
emacs          	on
errexit        	off
errtrace       	off
functrace      	off
hashall        	on
histexpand     	on
history        	on
ignoreeof      	off
interactive-comments	on
keyword        	off
monitor        	on
noclobber      	off
noexec         	off
noglob         	off
nolog          	off
notify         	off
nounset        	off
onecmd         	off
physical       	off
pipefail       	off
posix          	off
privileged     	off
verbose        	off
vi             	off
xtrace         	off
```
## What happens if you execute `exit 1`
`exit` implies an exit value of your script. Your script may exit successfully
although it tests for an erroneous condition. In this case, you specifically
want it to exit with the error condition e.g `exit 1`.

## What happens if you set `set -e`
`set -e` stops the execution of a script if any command exits with a non-zero status,
which is the opposite of the default shell behavior to ignore errors in scripts.

Semaphore checks exit value of each executed command so there is no need to include this
options in the command sections.

## The difference between sourcing and running a bash script
Executing a script calling `bash script.sh`, runs it in a separate instance of shell which is invoked to process the script. This means that any environment variables, defined in the script can't be updated in the current shell.

Sourcing a script means that it is parsed and executed by the current shell itself. It's as if you typed the contents of the script.
