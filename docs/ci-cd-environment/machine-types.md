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

<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>
    Machine name
  </td>
  <td>
    Virtual CPUs <sup>1</sup>
  </td>
  <td>
    Memory <sup>2</sup>
  </td>
  <td>
    Disk <sup>3</sup>
  </td>
</tr>
</thead>
<tbody>
<tr>
  <td>
    e1-standard-2
  </td>
  <td>
     2
  </td>
  <td>
     4 GB
  </td>
  <td>
     25 GB
  </td>
</tr>
<tr>
  <td>
    e1-standard-4
  </td>
  <td>
     4
  </td>
  <td>
     8 GB
  </td>
  <td>
     35 GB
  </td>
</tr>
<tr>
  <td>
     e1-standard-8
  </td>
  <td>
     8
  </td>
  <td>
     16 GB
  </td>
  <td>
     45 GB
  </td>
</tr>
</tbody>
</table>

Implementation details:

1. `Virtual CPU` hyperthreaded on a 3.4GHz Max Turbo 4.0GHz Intel® Core™ i7.
2. `Memory` is implemented as DDR4 RAM.
3. `Disk` is implemented as RAM drive backed by DDR4 RAM.

### E2 Generation

The `e2` series machines offer a balance of compute, memory, and cost. It is a good choice for most applications.

<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>
    Machine name
  </td>
  <td>
    Virtual CPUs <sup>1</sup>
  </td>
  <td>
    Memory <sup>2</sup>
  </td>
  <td>
    Disk <sup>3</sup>
  </td>
</tr>
</thead>
<tbody>
<tr>
  <td>
    e2-standard-2
  </td>
  <td>
     2
  </td>
  <td>
     8 GB
  </td>
  <td>
     55 GB
  </td>
</tr>
<tr>
  <td>
    e2-standard-4
  </td>
  <td>
     4
  </td>
  <td>
     16 GB
  </td>
  <td>
     75 GB
  </td>
</tr>
</tbody>
</table>

Implementation details:

1. `Virtual CPU` hyperthreaded on a 3.6GHZ [AMD Ryzen 5 3600](https://www.amd.com/en/product/8456).
2. `Memory` is implemented as DDR4 RAM.
3. `Disk` is implemented using NvME storage.

### F1 Generation

The `f1` series machines are built for compute-intensive jobs. These machines deliver the highest performance.

<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>
    Machine name
  </td>
  <td>
    Virtual CPUs <sup>1</sup>
  </td>
  <td>
    Memory <sup>2</sup>
  </td>
  <td>
    Disk <sup>3</sup>
  </td>
</tr>
</thead>
<tbody>
<tr>
  <td>
    f1-standard-2
  </td>
  <td>
     2
  </td>
  <td>
     8 GB
  </td>
  <td>
     55 GB
  </td>
</tr>
<tr>
  <td>
    f1-standard-4
  </td>
  <td>
     4
  </td>
  <td>
     16 GB
  </td>
  <td>
     75 GB
  </td>
</tr>
</tbody>
</table>

Implementation details:

1. `Virtual CPU` hyperthreaded on a 4.6GHz 12th generation [Intel i5 125000](https://ark.intel.com/content/www/us/en/ark/products/96144/intel-core-i512500-processor-18m-cache-up-to-4-60-ghz.html).
2. `Memory` is implemented as DDR4 RAM.
3. `Disk` is implemented using NvME storage.

## Apple machine type

Apple machine types can be paired with [MacOS Xcode13 image][macos-xcode13] or [MacOS Xcode14 image][macos-xcode14].

<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>
     Machine name
  </td>
  <td>
     Virtual CPUs <sup>1</sup>
  </td>
  <td>
     Memory (GB) <sup>2</sup>
  </td>
  <td>
     Disk (GB) <sup>3</sup>
  </td>
</tr>
</thead>
<tbody>
<tr>
  <td>
     a1-standard-4
  </td>
  <td>
     4
  </td>
  <td>
     8
  </td>
  <td>
     50
  </td>
</tr>
  <tr>
  <td>
     a1-standard-8 *
  </td>
  <td>
     8
  </td>
  <td>
     16
  </td>
  <td>
     50
  </td>
</tr>
</tbody>
</table>

`*` - only available on our [enterprise plan](https://semaphoreci.com/pricing).

## Self-hosted agent types

Semaphore also allows you to run jobs on your own infrastructure, using [self-hosted agents][self-hosted].

[agent]: ../reference/pipeline-yaml-reference.md#agent
[ubuntu1804]: ../ci-cd-environment/ubuntu-18.04-image.md
[ubuntu2004]: ../ci-cd-environment/ubuntu-20.04-image.md
[macos-xcode14]: ../ci-cd-environment/macos-xcode-14-image.md
[macos-xcode13]: ../ci-cd-environment/macos-xcode-13-image.md
[docker-env]: ../ci-cd-environment/custom-ci-cd-environment-with-docker.md
[self-hosted]: ../ci-cd-environment/self-hosted-agents-overview.md
