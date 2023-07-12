---
Description: This guide lists and describes the Linux and Apple machine types that are compatible with Semaphore 2.0.
---

# Machine Types

A **machine type** specifies a particular collection of virtualized
hardware resources available to a virtual machine (VM) instance,
including memory size, virtual CPU count, and disk.

This guide describes the machine types that are compatible with Semaphore 2.0. For instructions for using
the supported machine types in your pipelines, refer to our [agent documentation][agent].

## Linux machine types

Linux machine types can be paired with [Ubuntu 18.04 image][ubuntu1804], [Ubuntu 20.04 image][ubuntu2004], and [Docker-based environment][docker-env].

### E1 Generation

The `e1` series machines are our first generation, cost-effective with medium performance. They are a good choice for less compute and memory-intensive jobs. 

| Machine name  | Virtual CPUs <sup>1</sup> | Memory <sup>2</sup> | Disk <sup>3</sup> |
| ------------- | :-----------------------: | :-----------------: | :---------------: |
| e1-standard-2 |             2             |        4 GB         |       25 GB       |
| e1-standard-4 |             4             |        8 GB         |       35 GB       |
| e1-standard-8 |             8             |        16 GB        |       45 GB       |

Implementation details:

1. `Virtual CPU` hyperthreaded on a 3.4GHz Max Turbo 4.0GHz Intel® Core™ i7.
2. `Memory` is implemented as DDR4 RAM.
3. `Disk` is implemented as RAM drive backed by DDR4 RAM.

### E2 Generation

!!! plans "Available on: <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

The `e2` series machines offer a balance of compute, memory, and cost. It is a good choice for most applications.

| Machine name  | Virtual CPUs <sup>1</sup> | Memory <sup>2</sup> | Disk <sup>3</sup> |
| ------------- | :-----------------------: | :-----------------: | :---------------: |
| e2-standard-2 |             2             |        8 GB         |       45 GB       |
| e2-standard-4 |             4             |        16 GB        |       65 GB       |

Implementation details:

1. `Virtual CPU` hyperthreaded on a 3.6GHZ [AMD Ryzen 5 3600](https://www.amd.com/en/product/8456).
2. `Memory` is implemented as DDR4 RAM.
3. `Disk` is implemented using NvME storage.

### F1 Generation

!!! plans "Available on: <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

The `f1` series machines are built for compute-intensive jobs. These machines deliver the highest performance.

| Machine name  | Virtual CPUs <sup>1</sup> | Memory <sup>2</sup> | Disk <sup>3</sup> |
| ------------- | :-----------------------: | :-----------------: | :---------------: |
| f1-standard-2 |             2             |        8 GB         |       45 GB       |
| f1-standard-4 |             4             |        16 GB        |       65 GB       |

Implementation details:

1. `Virtual CPU` hyperthreaded on a 4.6GHz 12th generation [Intel i5 125000](https://ark.intel.com/content/www/us/en/ark/products/96144/intel-core-i512500-processor-18m-cache-up-to-4-60-ghz.html).
2. `Memory` is implemented as DDR4 RAM.
3. `Disk` is implemented using NvME storage.

### R1 Generation

!!! plans "Available on: <span class="plans-box">Startup</span> <span class="plans-box">Scaleup</span>"

!!! warning "`r1` machines are in Technical Preview stage, please contact support if you are interested to try them."

The `r1` series machines are built on ARM architecture.

| Machine name  | Virtual CPUs <sup>1</sup> | Memory <sup>2</sup> | Disk <sup>3</sup> |
| ------------- | :-----------------------: | :-----------------: | :---------------: |
| r1-standard-4 |             4             |        10 GB        |       65 GB       |

Implementation details:

1. `Virtual CPU` is emulated ARM on [Ampere Altra Q80-30](https://amperecomputing.com/briefs/ampere-altra-family-product-brief).
2. `Memory` is implemented as DDR4 RAM.
3. `Disk` is implemented using NvME storage.

## Apple machine type

Apple machine types can be paired with the [MacOS Xcode13 image][macos-xcode13] or [MacOS Xcode14 image][macos-xcode14].

| Machine name    | Virtual CPUs <sup>1</sup> | Memory <sup>2</sup> | Disk <sup>3</sup> |
| --------------- | :-----------------------: | :-----------------: | :---------------: |
| a1-standard-4   |             4             |          8          |        50         |

## Self-hosted agent types

Semaphore also allows you to run jobs on your own infrastructure, using [self-hosted agents][self-hosted].

[agent]: ../reference/pipeline-yaml-reference.md#agent
[ubuntu1804]: ../ci-cd-environment/ubuntu-18.04-image.md
[ubuntu2004]: ../ci-cd-environment/ubuntu-20.04-image.md
[macos-xcode14]: ../ci-cd-environment/macos-xcode-14-image.md
[macos-xcode13]: ../ci-cd-environment/macos-xcode-13-image.md
[docker-env]: ../ci-cd-environment/custom-ci-cd-environment-with-docker.md
[self-hosted]: ../ci-cd-environment/self-hosted-agents-overview.md
