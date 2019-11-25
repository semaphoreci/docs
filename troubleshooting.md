## Modifying Shell Behavior

- `exit` implies an exit value of your script. Your script may exit successfully
although it tests for an erroneous condition. In this case, you specifically
want it to exit with the error condition e.g `exit 1`.

 - `set -e` stops the execution of a script if any command exits with a non-zero status,
 which is the opposite of the default shell behavior to ignore errors in scripts.

## Difference between executing a Bash script vs sourcing it.

Executing a script e.g `bash script.sh` runs it in a separate instance of shell which is invoked to process the script. This means that any environment variables, defined in the script can't be updated in the current shell.

Sourcing a script means that it is parsed and executed by the current shell itself. It's as if you typed the contents of the script.

## Updating /etc/hosts

In some scenarios a hosts entry `/etc/hosts` has to be update using bash. This can be achieved
using the following command:

`echo '<IP ADDRES> <DOMAIN>' | sudo tee -a /etc/hosts` e.g
`echo '127.0.0.1 myapp.com' | sudo tee -a /etc/hosts`
