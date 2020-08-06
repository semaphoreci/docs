---
description: This guide lists and describes the available Linux and Apple machine types available in Semaphore 2.0.
---

# Machine Types

A **machine type** specifies a particular collection of virtualized
hardware resources available to a virtual machine (VM) instance,
including the memory size, virtual CPU count, and disk.

This guide describes the available machine types. For instructions about using
the supported machine types in pipelines see pipeline
[agent documentation][agent].

## Linux machine types

Linux machine types can be paired with the [Ubuntu1804 image][ubuntu1804].

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
    e1-standard-2
  </td>
  <td>
     2
  </td>
  <td>
     4
  </td>
  <td>
     25
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
     8
  </td>
  <td>
     35
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
     16
  </td>
  <td>
     45
  </td>
</tr>
</tbody>
</table>

Implementation of `e1` series of machine types:

1. Virtual CPU is implemented as a single hardware hyper-thread on a
   3.4GHz, Max Turbo 4.0GHz Intel® Core™ i7.
2. Memory is implemented as DDR4 RAM.
3. Disk is implemented as RAM drive backed by DDR4 RAM.

## Apple machine type

Apple machine types can be paired with the [MacOS image][macos-xcode11].

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

`*` - available on request

[agent]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent
[ubuntu1804]: https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/
[macos-xcode11]: https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/
