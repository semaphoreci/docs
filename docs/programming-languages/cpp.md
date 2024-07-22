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

- for [Ubuntu 20.04](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/#compilers)
- for [Ubuntu 22.04](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-22.04-image/#compilers)

The default version of the g++ compiler can be found as shown below:

```
$ g++ --version
g++ (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0
Copyright (C) 2019 Free Software Foundation, Inc.
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
      - name: Select g++ version 9
        commands:
          - g++ --version
          - sem-version cpp 9
          - g++ --version

      - name: Select g++ version 10
        commands:
          - g++ --version
          - sem-version cpp 10
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
            values: [ "9", "10" ]
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

- [Ubuntu 20.04 image reference](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-20.04-image/)
- [Ubuntu 22.04 image reference](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-22.04-image/)
- [sem command line tool Reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Toolbox reference page](https://docs.semaphoreci.com/reference/toolbox-reference/)
- [Pipeline YAML reference](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/)
- [update-alternatives man page](http://manpages.ubuntu.com/manpages/trusty/man8/update-alternatives.8.html)
