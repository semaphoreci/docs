---
Description: This guide shows how to configure C++ projects on Semaphore 2.0 with an example project.
---

# C++

This guide covers configuring C++ projects on Semaphore.
If you’re new to Semaphore, we recommend reading the
[guided tour](https://docs.semaphoreci.com/guided-tour/getting-started/) first.

## Hello world

```yaml
# .semaphore/semaphore.yml
version: v1.0
name: Hello Semaphore
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: C++ example
    task:
      jobs:
      - name: Compile and run C++ code
        commands:
          - printf "#include <iostream>\n int main() { std::cout << \"Hello world\"; return 0; }" > hello.cc
          - g++ hello.cc -o hello
          - ./hello
```

## Supported compiler versions

Semaphore VM is 64-bit and provides the following versions of the g++ compiler:

- g++ 4.8: found in `/usr/bin/g++-4.8`
- g++ 5: found in `/usr/bin/g++-5`
- g++ 6: found in `/usr/bin/g++-6`
- g++ 7: found in `/usr/bin/g++-7`
- g++ 8: found in `/usr/bin/g++-8`

The default version of the g++ compiler can be found as shown below:

```
$ g++ --version
g++ (Ubuntu 4.8.5-4ubuntu8) 4.8.5
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

## Changing compiler version

The following Semaphore 2.0 project selects two different versions of g++:

```yaml
version: v1.0
name: Using C++ in Semaphore 2.0
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Change g++ version
    task:
      jobs:
      - name: Select g++ version 6
        commands:
          - g++ --version
          - sem-version cpp 6
          - g++ --version

      - name: Select g++ version 8
        commands:
          - g++ --version
          - sem-version cpp 8
          - g++ --version
```

## Dependency management

You can use Semaphore's [cache tool](https://docs.semaphoreci.com/reference/toolbox-reference/#cache)
to store and load any files or C++ libraries that you want to reuse between jobs.

## System dependencies

C++ projects might need packages like database drivers. You have full `sudo`
access on each Semaphore 2.0 VM, so you can install all required packages.

## A sample project

The following `.semaphore/semaphore.yml` file compiles and executes a C++ source
file using two different versions of the g++ compiler in parallel:

```yaml
version: v1.0
name: Using C++ in Semaphore 2.0
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004

blocks:
  - name: Compile and run C++ code
    task:
      jobs:
      - name: Hello World!
        matrix:
          - env_var: GPP_VERSION
            values: [ "7", "8" ]
        commands:
          - checkout
          - sem-version cpp $GPP_VERSION
          - g++ hw.cpp -o hw
          - ./hw
```

The contents of the `hw.cpp` file are as follows:

```cpp
#include <iostream>

int main()
{
    std::cout << "Hello, World!\n";
    return 0;
}
```

## See Also

- [Ubuntu image reference](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/)
- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [update-alternatives man page](http://manpages.ubuntu.com/manpages/trusty/man8/update-alternatives.8.html)
