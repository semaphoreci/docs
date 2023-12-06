---
Description: This guide specifies the steps to change your Semaphore 2.0 agent OS from Ubuntu 18.04 to Ubuntu 20.04
---

# Migrating from Ubuntu 18.04 to Ubuntu 20.04 
If you've used the Semaphore Ubuntu 18.04 image, this guide will help you migrate to the Ubuntu 20.04 image.

### You have to migrate

!!! warning "Due to the end of standard support for Ubuntu 18.04 on 31 May 2023, we will no longer provide updates for the `ubuntu1804` image. However, the image will remain available until 31 March 2024. We encourage you to consider migrating to either the `ubuntu2004` or `ubuntu2204` image."

### Benefits of using the Ubuntu 20.04 image
Ubuntu 20.04 LTS (Focal Fossa) is the newer LTS release for the Ubuntu Linux server operating system. 
There are many good reasons to keep your development environment up to date. 
Here are only some of the benefits of switching to Ubuntu 20.04:

- **Speed** - this release has enhanced resource usage and includes a newer kernel.
- **Longer support** - Canonical will support Ubuntu 20.04 until April 2025.
- **Latest language versions** - in the future, some packages may not be supported by upstream providers for Ubuntu 18.04.
- **Expanded software stack** - the 20.04 software stack will continue expanding with new packages, while new packages will not be added for 18.04.
- **Containers** - the newest utilities can be installed (podman, skopeo, buildah).

If you want to read more about Ubuntu 20.04, check out the [Ubuntu Blog](https://ubuntu.com/blog/ubuntu-server-20-04).

### Ubuntu 20.04 image on Semaphore
The Ubuntu 20.04 image on Semaphore is the successor of the Ubuntu 18.04 image.
Its pre-installed stack includes the most recent versions for many languages and frameworks. 
For the exact list, please consult the [Ubuntu 20.04](ubuntu-20.04-image.md) image documentation.

### Using the Ubuntu 20.04 image
As a first step, please check your software version requirements in the software availability matrix below.
If the available software stack matches your requirements, changing the image type is as simple
as changing the `os_image:` line to use `ubuntu2004` instead of `ubuntu1804` in your semaphore.yml file.


***Software stack availability matrix***

| Software | Ubuntu 18.04 image | Ubuntu 20.04 image |
| :--- | :---: | :---: |
| AWS CLI | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Azure CLI | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Bazel | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Buildah | <span style="color:red;">&#10007;</span> | <span style="color:green;">&#10004;</span> |
| Gcc | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Google Chrome | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> | 
| ChromeDriver | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Closure | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Docker | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Dockercompose | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> | 
| DigitalOcean CLI | <span style="color:green;">&#10004;</span>  | <span style="color:green;">&#10004;</span> |
| Elixir 1.7.4 | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Elixir 1.8.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Elixir 1.9.4 | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Elixir 1.10.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Elixir 1.11.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Elixir 1.11.4 | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Elixir 1.12.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Elixir 1.13.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Elixir 1.14.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Elixir 1.15.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Erlang 21 | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Erlang 22 | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Erlang 23 | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Erlang 24 | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Erlang 25 | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Erlang 26 | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Firefox | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Google Cloud CLI | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Git | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Go | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Heroku | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Helm | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> | 
| Maven | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> | 
| NodeJS | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| PhantomJS| <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| PHP 7.1.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| PHP 7.2.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| PHP 7.3.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| PHP 7.4.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| PHP 8.0.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| PHP 8.1.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| PHP 8.2.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Podman | <span style="color:red;">&#10007;</span> | <span style="color:green;">&#10004;</span> |
| Python 2.7| <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> | 
| Python 3.6| <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> | 
| Python 3.7| <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> | 
| Python 3.8| <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> | 
| Python 3.9| <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> | 
| Python 3.10| <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Python 3.11| <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Ruby 1.9.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Ruby 2.0.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Ruby 2.1.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Ruby 2.2.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Ruby 2.3.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Ruby 2.4.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Ruby 2.5.x | <span style="color:green;">&#10004;</span> | <span style="color:red;">&#10007;</span> |
| Ruby 2.6.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Ruby 2.7.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Ruby 3.0.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Ruby 3.1.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Ruby 3.2.x | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Scala  | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> |
| Skopeo  | <span style="color:red;">&#10007;</span> | <span style="color:green;">&#10004;</span> |
| Terraform | <span style="color:green;">&#10004;</span> | <span style="color:green;">&#10004;</span> | 
