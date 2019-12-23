# C

This guide covers configuring C projects on Semaphore.
If you’re new to Semaphore we recommend reading the
[Guided tour](https://docs.semaphoreci.com/article/77-getting-started) first.


## Hello world

```yaml
# .semaphore/semaphore.yml
version: v1.0
name: Hello Semaphore
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: C example
    task:
      jobs:
      - name: Compile and run C code
        commands:
          - printf "#include <stdio.h>\n int main() { printf(\"Hello world\"); return 0; }" > hello.c
          - gcc hello.c -o hello
          - ./hello
```

## Supported C versions

Semaphore VM is 64-bit and provides the following versions of the
GCC compiler:

- gcc 4.8: found as `/usr/bin/gcc-4.8`
- gcc 5: found as `/usr/bin/gcc-5`
- gcc 6: found as `/usr/bin/gcc-6`
- gcc 7: found as `/usr/bin/gcc-7`
- gcc 8: found as `/usr/bin/gcc-8`

The default version of the GCC compiler can be found as follows:

``` yaml
$ gcc --version
gcc (Ubuntu 4.8.5-4ubuntu8) 4.8.5
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

## Changing gcc version

The following Semaphore 2.0 project uses two different versions of gcc:

``` yaml
version: v1.0
name: Using C in Semaphore 2.0
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: Change GCC version
    task:
      jobs:
      - name: Select gcc version 6
        commands:
          - gcc --version
          - sem-version c 6
          - gcc --version

      - name: Select gcc version 8
        commands:
          - gcc --version
          - sem-version c 8
          - gcc --version
```

## Dependency management

You can use Semaphore's [cache tool](https://docs.semaphoreci.com/article/54-toolbox-reference#cache)
to store and load any files or C libraries that you want to reuse between jobs.

## System dependencies

C projects might need packages like database drivers. As you have full `sudo`
access on each Semaphore 2.0 VM, you are free to install all required packages.

## A sample C project

The following `.semaphore/semaphore.yml` file compiles and executes a C source
file using two different versions of GCC in parallel:

``` yaml
version: v1.0
name: Using C in Semaphore 2.0
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
- name: Compile and run C code
  task:
    jobs:
    - name: Hello World!
      matrix:
        - env_var: GCC_VERSION
          values: [ "7", "8" ]
      commands:
        - checkout
        - sem-version c $GCC_VERSION
        - gcc hw.c -o hw
        - ./hw
```

The contents of the `hw.c` file are as follows:

``` c
#include < stdio.h >

int main(int argc, char **argv) {
    printf("Hello World!\n");
    return 0;
}
```

## See Also

- [Ubuntu image reference](https://docs.semaphoreci.com/article/32-ubuntu-1804-image)
- [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Toolbox reference page](https://docs.semaphoreci.com/article/54-toolbox-reference)
- [Pipeline YAML reference](https://docs.semaphoreci.com/article/50-pipeline-yaml)
- [update-alternatives man page](http://manpages.ubuntu.com/manpages/trusty/man8/update-alternatives.8.html)
