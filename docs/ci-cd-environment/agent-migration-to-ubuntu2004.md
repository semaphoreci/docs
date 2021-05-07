---
description: This guide specifies the steps to change Semaphore 2.0 agent OS from Ubuntu 18.04 to Ubuntu 20.04
---

# Migration from Ubuntu 18.04 image to Ubuntu 20.04 image 

If you've used Semaphore Ubuntu 18.04 image, this guide will outline the
key differences and provide you with a direction to migrate to the Ubuntu 20.04 image.

### You don't have to migrate

We know how much you rely on Semaphore to do your work and don't want to impose
migration timeline. The Ubuntu 18.04 image will be available too, there are no current plans to depricate it.

### Benefits of using the Ubuntu 20.04 image

Ubuntu 20.04 LTS (Focal Fossa) is the latest lts release for the Ubuntu linux
server operating system. 
Compared to the previous LTS version, this release has enhanced resource usage and includes a newer kernel.
Canonical will support Ubuntu 20.04 until April 2025. 
If you want to read more about Ubuntu 20.04 check out [Ubuntu Blog](https://ubuntu.com/blog/ubuntu-server-20-04).

### Ubuntu 20.04 image on Semaphore 2.0

The Ubuntu 20.04 image on Semaphore 2.0 is the successor of the Ubuntu 18.04 image.
Its preinstalled stack includes the most recent versions for many languages and frameworks. 
For the exact list please consult [Ubuntu 20.04](ubuntu-20.04-image.md)

We will release the new image gradually. In the first step it will be available for the 
`e1-standard-2` agent type only, then `e1-standard-4` and lastly `e1-standard-8` 
agent types will follow.

### Using the Ubuntu 20.04 image

As a first step please check your software version requirements and the versions available
in the Ubuntu 20.04 image.
If the available software stack matches your requirements, changing the image type is as simple
as changing in you semaphore.yml file the `os_image:` line to use `ubuntu2004` instead of `ubuntu1804`.




