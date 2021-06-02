---
description: This guide specifies the steps to change Semaphore 2.0 agent OS from Ubuntu 18.04 to Ubuntu 20.04
---

# Migration from Ubuntu 18.04 to Ubuntu 20.04 
If you've used Semaphore Ubuntu 18.04 image, this guide will outline the
key differences and provide you with a direction to migrate to the Ubuntu 20.04 image.

### You don't have to migrate
The Ubuntu 18.04 image will continue to be supported and updated. There are no current plans to depricate it.
Please note though that the Ubuntu 18.04 is comming out of LTS in 2023 so it's advised that you try out the Ubuntu 20.04 image and migrate when possible.

### Benefits of using the Ubuntu 20.04 image
Ubuntu 20.04 LTS (Focal Fossa) is the latest LTS release for the Ubuntu Linux
server operating system. There are many good reasons to keep your development environment up to date. These are only some of the benefits of switching to Ubuntu 20.04:
- **Speed** - This release has enhanced resource usage and includes a newer kernel.
- **Longer support** - Canonical will support Ubuntu 20.04 until April 2025.
- **Latest language versions** - In the future, some packages may not be supported for Ubuntu 18.04 by upstream providers.
- **Expanded software stack** - 20.04 software stack will continue expanding with new packages, while new ones will not be added in 18.04.
- **Containers** - Newest utilities can be installed (podman, skopeo, buildah).

If you want to read more about Ubuntu 20.04 check out [Ubuntu Blog](https://ubuntu.com/blog/ubuntu-server-20-04).

### Ubuntu 20.04 image on Semaphore
The Ubuntu 20.04 image on Semaphore is the successor of the Ubuntu 18.04 image.
Its preinstalled stack includes the most recent versions for many languages and frameworks. 
For the exact list please consult [Ubuntu 20.04](ubuntu-20.04-image.md)

### Ubuntu 20.04 image rollout on Semaphore
The new image will be released gradually. In the first step, it will be available for the `e1-standard-2` agent type only. We will introduce `e1-standard-4` in the near future and then lastly the `e1-standard-8` agent type. 

Please follow the [Semaphore Changelog](https://docs.semaphoreci.com/reference/semaphore-changelog/) to be up to date with the available agent types.

### Using the Ubuntu 20.04 image
As a first step please check your software version requirements in the software availability matrix below.
If the available software stack matches your requirements, changing the image type is as simple
as changing in your semaphore.yml file the `os_image:` line to use `ubuntu2004` instead of `ubuntu1804`.

!!! warning
    As stated in the previous section - the `ubuntu2004` image will only work on `e1-standard-2` agents for now. 
    
    When switching the `os_image` to `ubuntu2004` make sure that the `e1-standard-2` machine type is selected.

***Software stack availability matrix***

| Software | Ubuntu 18.04 image | Ubuntu 20.04 image |
| :--- | :---: | :---: |
| AWS CLI | :heavy_check_mark: | :heavy_check_mark: |
| Azure CLI | :heavy_check_mark: | :heavy_check_mark: |
| Bazel | :heavy_check_mark: | :heavy_check_mark: |
| Gcc | :heavy_check_mark: | :heavy_check_mark: |
| Google Chrome | :heavy_check_mark: | :heavy_check_mark: | 
| ChromeDriver | :heavy_check_mark: | :heavy_check_mark: |
| Closure | :heavy_check_mark: | :heavy_check_mark: |
| Docker | :heavy_check_mark: | :heavy_check_mark: |
| Dockercompose | :heavy_check_mark: | :heavy_check_mark: | 
| DigitalOcean CLI | :heavy_check_mark:  | :heavy_check_mark: |
| Elixir 1.7.4 | :heavy_check_mark: | :x: |
| Elixir 1.8.x | :heavy_check_mark: | :x: |
| Elixir 1.9.4 | :heavy_check_mark: | :x: |
| Elixir 1.10.x | :heavy_check_mark: | :x: |
| Elixir 1.11.x | :heavy_check_mark: | :x: |
| Elixir 1.11.4 | :heavy_check_mark: | :heavy_check_mark: |
| Elixir 1.12.x | :heavy_check_mark: | :heavy_check_mark: |
| Erlang 21 | :heavy_check_mark: | :x: |
| Erlang 22 | :heavy_check_mark: | :x: |
| Erlang 23 | :heavy_check_mark: | :x: |
| Erlang 24 | :heavy_check_mark: | :heavy_check_mark: |
| Firefox | :heavy_check_mark: | :heavy_check_mark: |
| Google Cloud CLI | :heavy_check_mark: | :heavy_check_mark: |
| Git | :heavy_check_mark: | :heavy_check_mark: |
| Go | :heavy_check_mark: | :heavy_check_mark: |
| Heroku | :heavy_check_mark: | :heavy_check_mark: |
| Helm | :heavy_check_mark: | :heavy_check_mark: | 
| Maven | :heavy_check_mark: | :heavy_check_mark: | 
| NodeJS | :heavy_check_mark: | :heavy_check_mark: |
| PhantomJS| :heavy_check_mark: | :heavy_check_mark: |
| PHP 7.1.x | :heavy_check_mark: | :x: |
| PHP 7.2.x | :heavy_check_mark: | :x: |
| PHP 7.3.x | :heavy_check_mark: | :x: |
| PHP 7.4.x | :heavy_check_mark: | :heavy_check_mark: |
| PHP 8.0.x | :heavy_check_mark: | :heavy_check_mark: |
| Python 2.7| :heavy_check_mark: | :x: | 
| Python 3.6| :heavy_check_mark: | :x: | 
| Python 3.7| :heavy_check_mark: | :x: | 
| Python 3.8| :heavy_check_mark: | :heavy_check_mark: | 
| Python 3.9| :heavy_check_mark: | :heavy_check_mark: | 
| Ruby 1.9.x | :heavy_check_mark: | :x: |
| Ruby 2.0.x | :heavy_check_mark: | :x: |
| Ruby 2.1.x | :heavy_check_mark: | :x: |
| Ruby 2.2.x | :heavy_check_mark: | :x: |
| Ruby 2.3.x | :heavy_check_mark: | :x: |
| Ruby 2.4.x | :heavy_check_mark: | :x: |
| Ruby 2.5.x | :heavy_check_mark: | :x: |
| Ruby 2.6.x | :heavy_check_mark: | :heavy_check_mark: |
| Ruby 2.7.x | :heavy_check_mark: | :heavy_check_mark: |
| Ruby 3.0.x | :heavy_check_mark: | :heavy_check_mark: |
| Scala  | :heavy_check_mark: | :heavy_check_mark: |
| Terraform | :heavy_check_mark: | :heavy_check_mark: | 
