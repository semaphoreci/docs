---
description: We continuously deploy changes that improve the product for you. This page is updated on a weekly basis.
---

# Semaphore Changelog

Thank you for using Semaphore!
We continuously deploy changes that improve the product for you.
This page is updated on a weekly basis.

### Week of December 21, 2020

### Week of December 14, 2020
**(Improved) Ubuntu 18.04 image update**  
**(New)** Language versions:  

- Go 1.14.13
- Go 1.15.6
- Php 7.3.25
- Php 7.4.13

To learn more about this image, check our [ubuntu 18.04 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).

### Week of December 7, 2020

**(Improved) macOS Xcode 11 and 12 image update**  
**(Fix)** Fixed the missing Safari browser issue.  
**(Updated)** Updated packages:
 
- Fastalne 2.167.0 ->  2.169.0

To learn more about our image macOS images, check our [macOS Xcode 12](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/) and [macOS Xcode 11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/) documentation pages. 

### Week of November 23, 2020

**(Improved) Ubuntu 18.04 image update**  
**(New)** Language versions:  

- Added elixir 1.11.2 

**(Updated)** Language versions:

- Aws-cli 1.18.272 -> 1.18.183
- Azure-cli 2.14.0 -> 2.15.1
- Chromedriver 86 -> 87
- Dockercompose 1.27.2 -> 1.27.4
- Erlang 23.1.1 -> 23.1.4
- Google Chrome 86 -> 87
- Heroku 7.47.0 -> 7.47.3
- Java 8u272 -> 8u275
- Php 7.4.11 -> 7.4.12

To learn more about this image, check our [ubuntu 18.04 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).

### Week of November 16, 2020
**(New) Added ability to overwrite branch whitelist rule**  
On the project page click on the three dots icon in the top right corner of the workflow list to build a branch that is otherwise blocked by the whitelist rule. 
 
Read our [Workflow triggers](https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/#whitelist-branches) page to find out how branch whitelist works.
 
**(Improved) macOS Xcode 11 image update**  
**(Updated)** Updated packages:  
 
- Cocoapods 1.9.3 -> 1.10.0
- Fastlane 2.162.0 -> 2.167  
- Flutter v1.22.1  -> 1.22.4
 
To learn more about this image, check our [macOS Xcode 11 page](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/).

### Week of November 9, 2020
**(Updated) New UI available to everyone**  
New UI is available to all users. Minor performance updates and fixes have been implemented:
 
- **(Fixed)** issue with job logs auto-scrolling to top of the failed command output instead of the bottom. 
- **(Fixed)** issue with manual promotions being triggered based on promotion name.
 
You can read more about the new UI in our [blog post](https://semaphoreci.com/blog/refreshed-new-ui-for-a-greater-experience).
We appreciate your feedback and encourage you to send any suggestions to [our feedback inbox](mailto:feedback@semaphoreci.com?subject=Beta%20Feedback).
 
**(Improved) macOS Xcode 12 image update**  
**(Updated)** Xcode 12.2 installed, to switch version simply use `xcversion select 12.2`  
**(Deprecated)** Xcode 12.0 will be removed from the images with the next release.  
  
**(Updated)** Updated packages:  
 
- Cocoapods 1.9.3 -> 1.10.0
  
To learn more about this image, check our [macOS Xcode 12 page](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/).

### Week of November 2, 2020

**(Updated) UI updates and improvements**  
UI was updated to address the most common points received as feedback in the beta phase. Some of the improvements made include:  

- Added the "Projects" menu in the header for easier navigation.
- Added more visual structure to emphasize individual elements.
- Redesigned workflow item in workflow list to make branches more prominent.
- Added "My starred items" tab on the home page.
- Added icons to make it easier to differentiate Branch/PR/Tag triggers in the workflow list.
- Nicer UI for manual promotions.

We appreciate your feedback and encourage you to send any suggestions to [our feedback inbox](mailto:feedback@semaphoreci.com?subject=Beta%20Feedback).

**(New) Semaphore Container Registry**  
For your convenience we have introduced Semaphore Container Registry. Inside the Semaphore environment, you can pull these Docker images without any restrictions or limitations.

You can find the list of supported images in [our documentation](/ci-cd-environment/semaphore-registry-images/).

**(Improved) macOS Xcode 12 image update**  
**(Updated)** Xcode 12.1 installed, to switch version simply use `xcversion select 12.1`  
  
**(Updated)** Updated packages:  

- Fastlane 2.162.0 -> 2.166  
- Flutter v1.22.1  -> 1.22.3
  
To learn more about this image, check our [macOS Xcode 12 page](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/).

**(Improved) Ubuntu 18.04 image update**  
**(Updated)** Language versions:

- Aws-cli 1.18.159 -> 1.18.272
- Azure-cli 2.13.0 -> 2.14.0
- Git 2.28 -> 2.29
- Heroku 7.46.0 -> 7.47.0
- OpenJDK 8u265 -> 8u272
- Openjdk 11.0.8 -> 11.0.9
- PHP 7.3.23 -> 7.3.24

To learn more about this image, check our [ubuntu 18.04 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).

### Week of October 19, 2020
**(Updated) New UI - Everyone's latest work page**  
Updated the behavior on the main page (Everyone's latest work) to exclude the workflows of the projects user doesn't have access to.  
If the user doesn't have access to the project, or the project was deleted, the workflows of that project won't appear in the workflow list.  

**(Improved) Ubuntu 18.04 image update**  
**(Updated)** Language versions:

- Aws-cli 1.18.151 -> 1.18.159
- Azure-cli 2.12.1 -> 2.13.0
- Chrome 85 -> 86
- Chromedriver 85 -> 86
- Go 1.14.9 -> 1.14.10
- Go 1.15.2 ->1.15.3
- Heroku 7.44.0 -> 7.46.0

To learn more about this image, check our [ubuntu 18.04 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).

### Week of October 12, 2020

**(Updated)** Xcode 12.0.1 installed, to switch version simply use `xcversion select 12.0.1`  
  
**(Updated)** Updated packages:  
  - Fastlane 2.158.0 -> 2.162.0  
  - Flutter v1.20.2 -> v1.22.1  
  
To learn more about this image, check our [macOS Xcode 12 page](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/).

### Week of October 5, 2020
**(Improved) Ubuntu 18.04 image update**  
**(New)** Language versions:  

- Added ruby 2.7.2, 3.0.0-preview1 (preview version will be replaced by first `release` version)  
- Added elixir 1.11  

**(Updated)** Language versions:

- Aws-cli 1.18.142 -> 1.18.151
- Azure-cli 2.11.1 -> 2.12.1
- Erlang 21.3 -> 21.3.8.17
- Erlang 22.3 -> 22.3.4.10
- Erlang 23.0.3 -> 23.1
- Heroku 7.43.0 -> 7.44.0
- PHP 7.2.33 -> 7.2.34
- PHP 7.3.22 -> 7.3.23
- PHP 7.4.10 -> 7.4.11
- Pypy 7.3.1 -> 7.3.2

To learn more about this image, check our [ubuntu 18.04 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).  

**(New) New os_image - macOS Xcode 12**  
New MacOS image is now available - `macos-xcode12`.  
The default Xcode version on this image is Xcode 12.0 and will be updated in the future.  
If you are using `macos-xcode11` you can switch to the latest image by changing `os_image` value in your YAML file.  

To learn more about this image, check our [macOS Xcode 12 page](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-12-image/).

**(New) Fork&Run example projects**  
Semaphore provides several different examples of projects that showcase the basic features of our product.  
You can now easily fork these repositories in-app and run the example workflow provided.  
You can access this feature by clicking on a _New project_ button in the top right corner.  

Find more tutorials and examples [in our documentation](https://docs.semaphoreci.com/examples/tutorials-and-example-projects/).

**(Improved) New UI fixes and upgrades**  
**(Fixed)** - issue causing some branches to be missing in search in various locations.  
**(Stability)** - Reduced the number of errors and improved the stability of key pages in the new UI.  
**(Stability)** - Load time has been improved on several key pages in the new UI.  

### Week of September 21, 2020
**(New) Ubuntu 18.04 image additions** 

- Added the possibility to change `kubectl` version with the sem-version tool: `sem-version kubectl [version]`
- Added elixir versions: 1.10.0, 1.10.2, 1.10.3

**(Improved) Ubuntu 18.04 image update**  
**(Updated)** Language versions:

- Aws cli 1.18.129 -> 1.18.142
- Docker-compose 1.26.2 -> 1.27.2
- Heroku 7.42.13 -> 7.43.0
- Php 7.2.31 -> 7.2.33
- Php 7.3.21 -> 7.3.22
- Php 7.4.9 -> 7.4.10

To learn more about this image, check our [ubuntu 18.04 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).

### Week of September 7, 2020  
**(Improved) New UI improvements and fixes**  
**(New)** Timestamps - in job logs you can now enable timestamps for command output lines.  
**(Improved)** In the workflow page it is now clearly specified if the pipeline was stopped by branch deletion.  
**(Fixed)** Automated scrolling to the selected pipeline was removed in the workflow page.  
**(Fixed)** Fixed the issue where `exit_code` of the last executed command in the job log was missing.  
**(Fixed)** Fixed several performance and stability issues that were causing 500s on multiple pages.  

If you want to try out the new UI but it's not yet rolled out to your organization, please reach out to [our support team](mailto:support@semaphoreci.com).

**(Improved) macOS Xcode11 image update**  
**(Updated)** Xcode 11.7 installed, to switch version simply use `xcversion select 11.7`  
**(Removed)** Xcode 11.2.1 removed from the images.  
  
**(Updated)** Updated packages:  
  - Fastlane 2.149.1 -> 2.158.0  
  - Flutter v1.20.2 -> v1.20.3  
  
To learn more about this image, check our [macOS Xcode 11 page](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/).

**(New) Ubuntu 18.04 image additions** 
- Added Go 1.15
- Added azure-cli, version 2.11.1

**(Improved) Ubuntu 18.04 image update**  
**(Updated)** Language versions:

- Aws cli 1.18.124 -> 1.18.129
- Chrome 84 -> 85
- Chromedriver 84 -> 85
- Go 1.13.14 -> 1.13.15
- Go 1.14.6 -> 1.14.7
- Heroku 7.42.8 -> 7.42.13
- Yarn 1.22.4 -> 1.22.5

To learn more about this image, check our [ubuntu 18.04 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).

### Week of August 31, 2020
**(Improved) New Semaphore UI public beta release**  
After a successful private beta, the new Semaphore UI has been rolled out to a larger number of users.  
The new UI brings several improvements:  

- Easier navigation through better breadcrumbs and a new "Jump to" element.
- Additional information in workflow lists allows you to quickly see the status of deployments.
- Enhanced Workflow builder - new options like fail-fast and auto-cancel have been added to the Workflow builder.
- Improved job logs with collapsable command lines and dark theme.
- Activity Monitor page that provides a handy overview of your running pipelines and quota limits.

You can read more about new UI in our [latest blog post](https://semaphoreci.com/blog/refreshed-new-ui-for-a-greater-experience).  
If you want to try out the new UI but it's not yet rolled out to your organization, please reach out to [our support team](mailto:support@semaphoreci.com).

**(Improved) macOS Xcode11 image update**  
**(Updated)** Xcode 11.6 installed, to switch version simply use `xcversion select 11.6`  
**(Deprecated)** Xcode 11.2.1 will be removed from the images with the next release.  
  
To learn more about this image, check our [macOS Xcode 11 page](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/).

### Week of August 24, 2020
**(New) Information on promoter is stored in enviroment variable**  
Inside a Semaphore job you can now see who initiated the promotion by checking the value of `SEMAPHORE_PIPELINE_PROMOTED_BY` environment variable.

Information on all available enviroment variables can be found in our [documentation](https://docs.semaphoreci.com/ci-cd-environment/environment-variables/#semaphore_pipeline_promoted_by).
  
**(Improved) Ubuntu 18.04 image update**  
**(Updated)** Language versions:
  
  - Aws-cli 1.18.112 ->1.18.124
  - Elixir 1.10.4 now uses Erlang 23.0.3
  - Heroku 7.42.6 -> 7.42.8
  - Java 8u252 -> 8u265
  - Php 7.3.20 -> 7.3.21
  - Php 7.4.8 -> 7.4.9
  - Pypy 5.8.0 -> 7.3.1
  
 To learn more about this image, check our [ubuntu 18.04 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).  
  
**(Improved) macOS Xcode11 image update**  
**(Updated)** Updated packages:  
  
  - Fastlane 2.149.1 -> 2.156.1
  - Flutter v1.17.3 -> v1.20.2
  
To learn more about this image, check our [macOS Xcode 11 page](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/).
  
 **Minor improvements and fixes:**  
 - **(Fixed)** Fixed an issue where `[skip ci]` was ignored for pull request triggers.  
 - **(Improved)** Deleting a git branch will now stop any queued or running pipeline started on that branch.
 
### Week of August 17, 2020
**(New) Install-package command**  
"Toolbox" command line tools have been extended to include the `install-package` utility.  
The `install-package` command can help with package installations by automatically caching the desired packages and their dependencies.  

To find out more, please check the [install-package](https://docs.semaphoreci.com/reference/toolbox-reference/#install-package) documentation page.

### Week of August 10, 2020
**(New) Configurable pipeline queues**  
We added the option to override the default queue and create custom queues for pipelines.  
Pipelines can be configured to run sequentially or in parallel based on various conditions.

For example, you can now configure a pipeline to run in parallel on the same branch or create a single queue across the whole organization for all pipelines that deploy to production.  

To learn how to use this feature check [pipeline queues](https://docs.semaphoreci.com/essentials/pipeline-queues/) documentation page.

**(Improved) Ubuntu 18.04 image update**  

**(New)** Added Firefox version 78.1.0esr.   
Added possibility to change firefox version with the `sem-version` tool: `sem-version firefox [52|68|78]`

**(Updated)** Language versions:
  
  - Aws-cli 1.18.104 ->1.18.112
  - Heroku 7.42.5 -> 7.42.6
  - Google-cloud-sdk downgraded 300 -> 297
  
  To learn more about this image check our [ubuntu 18.04 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).

### Week of July 27, 2020
**(Improved) Ubuntu 18.04 image update**  

**(New)** Parallel version [20161222](https://ubuntu.pkgs.org/18.04/ubuntu-universe-amd64/parallel_20161222-1_all.deb.html) was added to the image.

**(Updated)** Language versions:
  
  - Aws-cli 1.18.96 -> 1.18.104
  - Go 1.13.12 -> 1.13.14
  - Go 1.14.4 -> 1.14.6
  - Heroku 7.42.2 -> 7.42.5
  - OpenJDK 11.0.7 -> 11.0.8
  - PHP 7.2.31 -> 7.2.32
  - PHP 7.3.19 -> 7.3.20
  - PHP 7.4.7 -> 7.4.8
  - Chrome_driver 83 > 84

To learn more check our [ubuntu1804 page](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/).

### Week of July 20, 2020
**(New) Job prioritization**  
The job `priority`  allows you to manage the order in which the enqueued jobs are
starting to run when the [quota](https://docs.semaphoreci.com/reference/quotas-and-limits/) of maximum parallel jobs for your
organization is reached.  

For more details on setting job priorities check [prioritization page](https://docs.semaphoreci.com/essentials/prioritization/) in our documentation.

**(Improved) GitHub Settings**  
Option to check the health of GitHub deploy key and webhook have been added in project settings UI.  
New settings also allow you to quickly repair connection between the Semaphore project and GitHub repository.

Read more about troubleshooting connection between Semaphore and GitHub in our [docs](https://docs.semaphoreci.com/account-management/checking-the-connection-between-github-and-semaphore-2.0/#check-deploy-key-health).

**(Improved) Cached Android docker images**  
From now on, Android docker images for two latest stable SDK versions will always be cached, meaning that the jobs using these images will now start up even faster.

For more details see our documentation on [Android docker images](https://docs.semaphoreci.com/ci-cd-environment/android-images/).  
For getting started with an Android project on Semaphore please see our [guide](https://docs.semaphoreci.com/programming-languages/android/).

### Week of July 13, 2020

- Updates to the ubuntu1804 image:
    - Aws-cli 1.18.90 -> 1.18.96
    - Elixir 1.8.1 -> 1.8.2
    - Elixir 1.9.3 -> 1.9.4
    - Elixir 1.10.3 -> 1.10.4
    - Heroku 7.42.1 -> 7.42.2
    - PHP 7.3.18 -> 7.3.19
    - PHP 7.4.6 -> 7.4.7

### Week of June 30, 2020

- Additions to the ubuntu1804 image
    - Sysstat

- Updates to the ubuntu1804 image:
    - Aws-cli 1.18.77 -> 1.18.90
    - Docker-compose 1.24.1 -> 1.26.0

- The [macos-xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/) image update.
The following packages were updated:
    - Fastlane 1.50.1
    - Flutter 1.17.5
- New convenience Docker image available in Semaphore's [dockerhub](https://hub.docker.com/u/semaphoreci).
A detailed list can be found in [Docker images changelog](https://github.com/semaphoreci/docker-images/blob/master/CHANGELOG#L2939).

### Week of June 15, 2020

- Updates to macos-xcode11 image:
    - flutter v1.17.3
    - cocoapods 1.9.3
    - nodejs v13.12.0
    - yarn v1.22.4
    - fastlane 2.149.1

- Updates to the ubuntu1804 image:
    - Aws-cli 1.18.68 -> 1.18.77
    - Firefox 68.4esr -> 68.9.0esr
    - Git 2.26 -> 2.27
    - Go 1.13.10 -> 1.13.12
    - Go 1.14.2 -> 1.14.4
    - Heroku 7.41.1 -> 7.42.1
    
### Week of June 8, 2020
- macOS Mojave image (macos-mojave-xcode11) has been deprecated. 

### Week of June 1, 2020

- Additions to the ubuntu1804 image
    - Erlang 23.0

- Updates to the ubuntu1804 image:
    - Aws-cli 1.18.59 -> 1.18.68
    - Chromedriver 81 -> 83
    - Google Chrome 81 -> 83
    - Php 7.2.29 -> 7.2.31
    - Php 7.3.16 -> 7.3.18
    - Php 7.4.4 -> 7.4.6

### Week of May 18, 2020
- New convenience Docker images available in Semaphore's DockerHub Account.
A detailed list can be found in [Docker images changelog](https://github.com/semaphoreci/docker-images/blob/master/CHANGELOG#L2421)
- Updates to the [macOS Catalina Xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/):
    - Xcode 11.5 installed
    - Flutter version update to 1.17.1
    - Fastlane gem version update to 2.148.1

- Additions to the ubuntu1804 image:
    - Doctl 1.43.0

- Updates to the ubuntu1804 image:
    - Aws-cli 1.18.42 -> 1.18.59
    - Git-lfs 2.10.0 -> 2.11.0
    - Go 1.13.9 -> 1.13.10
    - Go 1.14.1 -> 1.14.2
    - Heroku 7.39.3 -> 7.41.1
    - Php 7.2.28 -> 7.2.29
    - Php 7.3.15 -> 7.3.16
    - Php 7.4.3 -> 7.4.4
    - Sbt 0.13.17 -> 1.3.10

### Week of May 11, 2020

- Fixed: Secrets API was returning HTTP 404 for all Secrets with colon in the name (example: `a:b:c`).
- Semaphore will now log you out less often.
- New: Run Pull Requests from outside contributors with [sem-approve](https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/#approve-forked-pull-requests).

### Week of May 03, 2020

- Names of Semaphore Secrets are now restricted to alphanumeric characters, dashed, dots and `@`.
  Regex: `^[@: -._a-zA-Z0-9]+$`).
- Updates to the macOS image:
    - Flutter version update to 1.17.0, image spec [macOS Catalina Xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
- New convenience Docker images available in Semaphore's DockerHub Account.
A detailed list can be found in [Docker images changelog](https://github.com/semaphoreci/docker-images/blob/master/CHANGELOG#L2164).

### Week of April 27, 2020
- New macOS image available - [macOS Catalina Xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
- Updates to the ubuntu1804 image:
    - Aws-cli 1.18.39 -> 1.18.42
    - Jruby 9.1.17.0 -> 9.2.11.1
    - Heroku 7.39.1 -> 7.39.3

### Week of April 20, 2020

- Updates to the macOS image:
    - `macos-mojave-xcode11` Xcode 11.4.1 installed, to switch version, use
    `xcversion select 11.4.1`, image spec [macOS Mojave Xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
    - `macos-mojave-xcode11` Xcode 11.1 and Xcode 11.4 removed from the image.
- Updates to the ubuntu1804 image:
    - TCP port 8000 is no longer occupied.

### Week of April 13, 2020

- Updates to the ubuntu1804 image:
    - Aws-cli 1.18.32 -> 1.18.39
    - Google Chrome 80 -> 81
    - Chromedriver 80 -> 81
    - Erlang 22.2 -> 22.3
    - Go 1.13.8 -> 1.13.9
    - Go 1.14.0 -> 1.14.1
    - Ruby 2.4.9 -> 2.4.10
    - Ruby 2.5.7 -> 2.5.8
    - Ruby 2.6.5 -> 2.6.6
    - Ruby 2.7.0 -> 2.7.1

### Week of April 6, 2020

- Updates to the macOS image:
    - `macos-mojave-xcode11` Xcode 11.4 installed, to switch version, use
    `xcversion select 11.4`, image spec [macOS Mojave Xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
    - `macos-mojave-xcode11` Xcode 11.0 removed from the image.
    - installed packages:
      - google-chrome
      - firefox
      - microsoft-edge
- New convenience Docker image available in Semaphore's [dockerhub](https://hub.docker.com/u/semaphoreci).
A detailed list can be found in [Docker images changelog](https://github.com/semaphoreci/docker-images/blob/master/CHANGELOG#L1345).

### Week of March 30, 2020

- Updates to the ubuntu1804 image:
    - Aws-cli 1.18.21 -> 1.18.28
    - Git        2.25 -> 2.26
    - Heroku   7.39.0 -> 7.39.1
- Semaphore Toolbox:
    - [autocache](https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/#basic-usage) support for Golang (>= 1.11)

### Week of March 16, 2020

- Additions to the ubuntu1804 image:
    - Elixir 1.10.2
    - Go 1.14
- Updates to the ubuntu1804 image:
    - Aws-cli 1.18.7 -> 1.18.21
    - Heroku  7.38.2 -> 7.39.0
    - Yarn    1.21.1 -> 1.22.4

### Week of March 02, 2020

- Additions to the ubuntu1804 image:
    - Elixir 1.10.1
    - Php    7.4.3
- Updates to the ubuntu1804 image:
    - Aws-cli 1.17.17 -> 1.18.7
    - Erlang     22.1 -> 22.2
    - Go      1.12.10 -> 1.12.17
    - Go       1.13.1 -> 1.13.8
    - Heroku   7.38.1 -> 7.38.2
    - Maven     3.5.4 -> 3.6.3
    - Php      7.1.32 -> 7.1.33
    - Php      7.2.27 -> 7.2.28
    - Php      7.3.11 -> 7.3.15
    - Scala    2.12.7 -> 2.12.10

### Week of February 24, 2020

- The values of secrets are hidden in the UI.

### Week of February 17, 2020

- Android Docker images load in 2 seconds or less.
- Workflow page: Clicking on the list of pipeline runs will open and focus on
  that part of the workflow.
- Updates to the ubuntu1804 image:
    - Aws-cli  1.17.9 -> 1.17.17
    - Chrome       79 -> 80
    - Chromedriver 79 -> 80
    - Heroku   7.37.0 -> 7.38.1
    - Nvm      8.16.2 -> 8.17.0
    - Nvm     10.17.0 -> 10.19.0
    - Nvm     12.13.0 -> 12.16.0
    - Npm       6.4.1 -> 6.13.4

### Week of February 10, 2020

- New: [Alpha version of Semaphore 2.0 API](https://docs.semaphoreci.com/reference/api-v1alpha/)
  is now available. Initial release focuses on ability to control workflows.
- Jobs export `SEMAPHORE_WORKFLOW_TRIGGERED_BY_*` [environment
  variables](https://docs.semaphoreci.com/ci-cd-environment/environment-variables/).
- In monorepo scenario, when a block is skipped, Semaphore now shows a “skipped” badge.
- You can now specify MySQL and PostgreSQL username, password and database when using
  [sem-service](https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/).
- In monorepo scenario, when a block is skipped, Semaphore now shows a “skipped” badge.
- Jobs export `SEMAPHORE_WORKFLOW_TRIGGERED_BY_HOOK`, `SEMAPHORE_WORKFLOW_TRIGGERED_BY_SCHEDULE`, and
  `SEMAPHORE_WORKFLOW_TRIGGERED_BY_API` [environment variables](https://docs.semaphoreci.com/ci-cd-environment/environment-variables/#semaphore_workflow_triggered_by_hook).
- Environment setup commands in jobs now have descriptive names. The new command names are:
    - `Exporting environment variables`
    - `Injecting Files`
    - `Setting up the Semaphore Toolbox`
    - `Starting an ssh-agent`
    - `Connecting to cache`
 - You can now override the default Docker command and entrypoint in attached containers.

### Week of February 3, 2020

- Additions to the ubuntu1804 image:
    - libmaxminddb0
    - libmaxminddb-dev
- ubuntu1804 kernel settings changes:
    - vm.max_map_count=262144
    - fs.inotify.max_user_instances=524288
    - fs.inotify.max_user_watches=524288
    - fs.inotify.max_queued_events=524288
- Updates to the ubuntu1804 image:
    - Heroku  7.35.1 -> 7.37.0
    - Java8     u232 -> u242
    - Java11  11.0.5 -> 11.0.6
    - Git-lfs  2.9.2 -> 2.10.0
    - Aws-cli 1.17.2 -> 1.17.9

### Week of January 27, 2020
- Updates to the macOS image:
    - installed packages:
        - `usbmuxd`
        - `libimobiledevice`
        - `ideviceinstaller`
        - `ios-deploy`
- New convenience Docker image available in Semaphore's
DockerHub Account - android with `flutter` preinstalled.
A detailed list can be found in [Docker images changelog](https://github.com/semaphoreci/docker-images/blob/master/CHANGELOG#L792).

### Week of January 13, 2020

- New: "Jump to a branch or pull request" quick search modal dialog,
  available on the project page.
- Additions to ubuntu1804 image:
    - Python 3.8
    - Snapd
- Updates to the ubuntu1804 image :
    - Awc-cli       1.16 -> 1.17.1
    - Firefox esr 68.2.0 -> 68.4.1
    - Geckodriver 0.21.0 -> 0.26.0
    - Java 8        u201 -> u232
    - Java        11.0.2 -> 11.0.5
    - Heroku      7.35.0 -> 7.35.1
    - Git           2.24 -> 2.25
    - Git-LFS      2.9.1 -> 2.9.2
    - Phpunit     7.5.18 -> 7.5.20

- Updates to the macOS image:
    - `macos-mojave-xcode11` Xcode 11.3.1 installed, to switch version use
    `xcversion select 11.3.1`, image spec [macOS Mojave Xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
    - installed packages:
      - carthage
    - updated gems:
      - fastlane (2.140.0)
      - cocoapods (1.8.4)
- New convenience Docker images available in Semaphore's DockerHub Account.
A detailed list can be found in [Docker images changelog](https://github.com/semaphoreci/docker-images/blob/master/CHANGELOG#L528).
- Retroactively updated the changelog to mention new features and improvements
  (scroll down a few weeks).

### Week of January 6, 2020

- New: Workflow Builder can model deployment. You can now configure promotions
  and multiple pipelines in a point-and-click interface, without writing YAML.
- New: When you go to create a new project, Semaphore now begins by analyzing your
  code repository. It then suggest a YML configuration that you can use as a
  starting point. There's also a gallery of starter workflows that you can
  choose from.

### Week of December 30, 2019

- Log page improvements: continuously live stream logs on a per-character basis,
  not just on every new line. Plus a few bugs fixed like when dealing with very
  large lines and low baud rate.
- Additions to ubuntu1804 image
    - Ruby 2.7.0

### Week of December 16, 2019

- Android: [documentation](https://docs.semaphoreci.com/programming-languages/android/) for
  getting started is available.
- [A React Native example
  project](https://github.com/semaphoreci-demos/semaphore-demo-react-native) is
  available.
- Updates to the ubuntu1804 image
    - Git-lfs  2.9.1  -> 2.9.2
    - Yarn     1.19.2 -> 1.21.1
    - Chrome       78 -> 79
    - Chromedriver 78 -> 79
    - PhpUnit  7.5.17 -> 7.5.18
    - Phpbrew  1.23.1 -> 1.24.1
    - APT: removed ppa jonathonf/python-2.7

### Week of December 9, 2019

- New:
  [Webhooks](https://docs.semaphoreci.com/essentials/webhook-notifications/) on
  success or failure of a pipeline.

### Week of December 2, 2019

- New: [Open source organizations are
  available](https://semaphoreci.com/blog/free-open-source-cicd).
  Each open source organization receives unlimited CI/CD minutes for building
  public repositories, including Linux, Docker and macOS-based environments.
- New: [Status badges](https://docs.semaphoreci.com/essentials/status-badges/).
- Updates to ubuntu1804 image
    - Git-lfs 2.9.0  -> 2.9.1
    - Yarn    1.19.1 -> 1.19.2
- Additions to ubuntu1804 image
    - Elixir versions 1.9.2, 1.9.3, 1.9.4

### Week of November 18, 2019

- New: [Monorepo support](https://docs.semaphoreci.com/essentials/building-monorepo-projects/).
- Updates to the ubuntu1804 image
    - Git      2.23   -> 2.24
    - Heroku   7.33   -> 7.35
- Additions to the ubuntu1804 image
    - ImageMagick 8:6.9.7.4

### Week of November 11, 2019
- macOS image updates:
    - `macos-mojave-xcode11` Xcode 11.2.1 installed, to switch version use
    `xcversion select 11.2.1`, image spec [macOS Mojave Xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
    - nvm pre-installed in `macos-mojave-xcode11` and `macos-mojave-xcode10`, image spec: [macOS Mojave Xcode10](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
    - packages:
          - fastlane 2.135.2
          - cocoapods 1.8.4

### Week of November 4, 2019

 - [Status badges](https://docs.semaphoreci.com/essentials/status-badges/) are available.
 - Semaphore toolbox:
   - Fix issue with cache corruption during parallel uploads.
 - New [environment variables available in Semaphore
   jobs](https://docs.semaphoreci.com/ci-cd-environment/environment-variables/):
   - `SEMAPHORE_AGENT_MACHINE_TYPE`
   - `SEMAPHORE_AGENT_MACHINE_OS_IMAGE`
   - `SEMAPHORE_AGENT_MACHINE_ENVIRONMENT_TYPE`
 - When creating a project, you can select from a collection of ready-made
   configuration recipes.

### Week of October 21, 2019

- Updates to the ubuntu1804 image
    - Pip      19.2   -> 19.3.1
    - Nvm      8.11.3 -> 8.16.2
    - Npm       5.6.0 -> 6.4.1
    - Chrome       77 -> 78
    - Chromedriver 77 -> 78
    - Git-lfs   2.8.0 -> 2.9.0
    - Phpunit  7.15.6 -> 7.15.7
    - Firefox-esr 60  -> 68
    - Ruby      2.3.7 -> 2.3.8
    - Ruby      2.4.4 -> 2.4.9
    - Ruby      2.5.1 -> 2.5.7
    - Ruby      2.6.4 -> 2.6.5
- Additions
    - Nvm 10.17
    - Nvm 12.3

### Week of October 14, 2019

- Updates to the ubuntu1804 image
    - Heroku 7.30.0 -> 7.33.3
    - Elixir 1.8.1  -> 1.8.2
    - Elixir 1.9.0  -> 1.9.1
    - Erlang 22.0   -> 22.1
    - Yarn   1.17.3 -> 1.19.1
    - Kerl   1.3.4  -> 1.8.4
    - Rebar3 3.6.1  -> 3.12.0

### Week of October 7, 2019

- Updates to the macOS image:
    - `macos-mojave-xcode11` Xcode 11.1 installed, to switch version use
    `xcversion select 11.1`, image spec [macOS Mojave Xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
- You can change which blocks and pipelines send status checks to pull requests
  on GitHub. [See how](https://docs.semaphoreci.com/reference/sem-command-line-tool/#changing-github-status-check-notifications).

### Week of September 30, 2019

- [The latest release of the Semaphore Agent](https://github.com/semaphoreci/agent/pull/72),
  v0.10.1, checks if Bash is available before starting jobs in a custom
  Docker container. Previously, without this check, the first step in a job
  that exports environment variables would fail without a real indication of
  the root problem.
- From now on, outdated version of the CLI will be rejected from accessing
  your organization. Compatibility of the CLI will be uphold at least up to the
  last 3 minor releases. Only in case of security issues will this
  compatibility policy be broken.
- Jobs generated with [parallelism](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#parallelism)
  are using a new naming scheme `<job-name> - <index>/<job-count>`.
  Example: `RSpec - 1/4`.
- We introduced a new syntax for configuring [auto-promotions](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#auto_promote)
  which leverages our [Conditions DSL](https://docs.semaphoreci.com/reference/conditions-reference/)
  to allow you to express conditions for pipeline auto-promotion in a lot less
  complicated way than before.

### Week of September 23, 2019

- New macOS `os_image` types:
    - `macos-mojave-xcode10` with Xcode 10.3 and 10.2.1 installed, [macOS Mojave Xcode10](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/) image spec.
    - `macos-mojave-xcode11` with Xcode 11.0 installed, [macOS Mojave Xcode11](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/) image spec.
    - `macos-mojave` no longer available.
- Mojave system update:
    - ProductVersion: 10.14.6
    - BuildVersion: 18G95
    - Kernel Version: Darwin 18.7.0
- You can now change the initial pipeline file of your project,
  from `.semaphore/semaphore.yml` to a custom path. This allows
  you to create multiple Semaphore projects based on the same GitHub
  repository. The new option is available on the project settings
  page, or [by editing pipeline_file property of a project](https://docs.semaphoreci.com/reference/sem-command-line-tool/#changing-the-initial-pipeline-file)
  via the release v0.15.0 of the CLI.
- Workflow Builder now supports setting [job parallelism](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#parallelism).
  The new option is available by clicking on a block and expanding the advanced
  configuration section for the job you want to replicate with the parallelism
  feature.
- New version of CLI v0.16.0 has beed released.
   - You can change the initial pipeline file of your project.
   - Fix for debug jobs from Pull Request/Tags has been released. This bug
     caused differences in Environments Variable between job and debug session.
- Visual Workflow Builder is now part of the project setup.

### Week of September 16, 2019

- New feature: Artifacts. Persistent storage of final CI/CD deliverables,
  intermediary assets and files for debugging. Now in public beta.
    - [Learn more about use cases](hhttps://docs.semaphoreci.com/essentials/artifacts/) and
  [how to use the artifacts CLI](https://docs.semaphoreci.com/reference/artifact-cli-reference/).

### Week of September 9, 2019

- Semaphore remembers the URL you wanted to go to after logging in.
- Fixed various small bugs in the Workflow Builder.
- Fixed a bug where some free organizations could be blocked after switching from free trial.

### Week of September 2, 2019

- New feature: Visual Workflow Builder, now in public beta. Build your Semaphore
  pipeline with a point-and-click interface.
- New users can choose between giving access to only public, or both public and
  private GitHub repositories.
- Organization admins can change their organization URL.

### Week of August 19, 2019

- New feature: [`parallelism`
  property](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#parallelism)
  to easily generate parallel jobs.
- Docker-based agents can now [use private container images from any
  registry](https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/#pulling-private-docker-images-from-generic-docker-registries).

### Week of August 12, 2019

- Updates to the [Ubuntu 18.04 VM
  image](https://docs.semaphoreci.com/ci-cd-environment/ubuntu-18.04-image/):
    - Chrome and ChromeDriver updated to version 76
    - docker-ce updated to 19.03.1
    - git-lfs updated to 2.8.0
    - heroku updated to 7.27.1
    - java 8 updated to u222
    - java 11 updated to 11.0.4
    - phpunit updated to 7.5.14
    - pip updated to 19.2.1
    - yarn updated to 1.17.3

### Week of August 5, 2019

- New feature: [Global job
  configuration](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#global_job_config).
  Define common configuration and apply it across all blocks in a pipeline.
- You can now whitelist contributors for which your organization will run
  Semaphore workflows when they submit a pull request from a fork.
  You can also whitelist secrets to be exposed. See your project's Settings in
  web UI.
- Docker-based agents can now use [private container images from Google
  Container
  Registry](https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/#pulling-private-docker-images-from-google-gcr).
- [Dependency caching](https://docs.semaphoreci.com/essentials/caching-dependencies-and-directories/) is now
  much simpler. Just write `cache restore` and `cache store` and Semaphore will
  do the right thing for common language dependencies.
- macOS platform:
    - Flutter version update to v1.8.3
    - New image spec - [macOS Mojave](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)

### Week of July 29, 2019

- New features: [Pull request and Git tag
  support](https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/).
  Have full control over which GitHub trigger new workflows.
  Choose from default branch only, any push to any branch, push to pull
  requests, and push to pull requests from forked repositories.
    - As a bonus, you can turn off exposure of secrets in forked pull requests.
    - The project page can now show activity from branches, pull requests and
      tags separately.
- New feature: [Auto-cancel pipeline
  strategies](https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/).  Stop
  running a pipelines when there are newer commits in the repo.  Use the new
  [`auto_cancel`
  property](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#auto_cancel)
  in your pipeline configuration.
- macOS platform:
    - Xcode 11 Beta version update 5 (11M382q).
    - Xcode 10.3 with default simulators preinstalled on Mojave image.
    - Flutter version update to v1.7.8+hotfix.4.
    - Fastlane version update to 2.128.1.
    - Cocoapods version update to 1.7.5.
    - New image spec - [macOS Mojave](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
- New [environment variables available in Semaphore
  jobs](https://docs.semaphoreci.com/ci-cd-environment/environment-variables/):
    - `SEMAPHORE_GIT_REPO_SLUG`
    - `SEMAPHORE_GIT_REF_TYPE`
    - `SEMAPHORE_GIT_REF`
    - `SEMAPHORE_GIT_COMMIT_RANGE`
    - `SEMAPHORE_GIT_TAG_NAME`
    - `SEMAPHORE_GIT_PR_SLUG`
    - `SEMAPHORE_GIT_PR_SHA`
    - `SEMAPHORE_GIT_PR_NUMBER`
    - `SEMAPHORE_GIT_PR_NAME`
    - `SEMAPHORE_ORGANIZATION_URL`

### Week of July 22, 2019

- New feature: model complex workflows with pipeline dependencies. Learn more
  about what you can do in the
  [blog post](https://semaphoreci.com/blog/introducing-cicd-pipeline-dependencies).
- New feature: [fail-fast on the first
  failure](https://docs.semaphoreci.com/essentials/fail-fast-stop-running-tests-on-the-first-failure/).
  Now you can stop everything in your pipeline as soon as a failure is detected,
  or stops only the jobs and blocks in your pipeline that haven't yet started.
- A new global sidebar. It uses less screen real estate and you can star
  projects and dashboards to appear on top of the list. Also, it loads really
  fast.
- New version of CLI v0.14.1 has beed released.
   - You can now configure pull-request related setting by editing the project
   - A fix for the race condition between toolbox installation and debug session
     initialization has been released. This bug manifested as
     "unknown command checkout" if the debug session entry happened before the
     toolbox installation finished in the machine.

### Week of July 15, 2019

- New feature: Scheduled CI/CD workflows, aka cron jobs.
  Open your project, and find the new "Project Settings" button at the top-right.
  From there you can create and edit your scheduled workflows using
  the standard cron syntax.
- Also on the new Project Settings screen, you can rename and delete your
  project.

### Week of July 1, 2019

- AWS ECR support for Docker-based environment: Host your private Docker images
  on AWS and use them to define your
  [custom CI/CD environment](https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/)
  on Semaphore.
- [Skip CI](https://docs.semaphoreci.com/essentials/skip-building-some-commits-with-ci-skip/):
  If you add `[skip ci]` or `[ci skip]` to your Git commit message,
  Semaphore will not trigger a new workflow.
- Context of a [Github Status checks](https://developer.github.com/v3/repos/statuses/)
  has been changed to include information about a build source, which
  can be one of the following:
    - `ci/semaphoreci/push`
    - `ci/semaphoreci/pr`
    - `ci/semaphoreci/tag`

[Please update your settings on GitHub](https://help.github.com/en/articles/enabling-required-status-checks)
if you are using protected branches with required status checks.

### Week of June 24, 2019

- macOS platform:
    - Xcode 11 Beta with default simulators preinstalled on Mojave image.
    - [macOS Mojave](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/) updated to 10.14.5.

### Week of June 10, 2019

- The workflow page got a fresh new look. It shows the elapsed time
  of each job, letting you spot inefficiencies easily.
  It also prepares the ground for some new features we'll announce
  soon.
- Reduced the time it takes a task to complete after the last job.

### Week of May 27, 2019

- [Custom Docker-based CI/CD environments are in GA](https://semaphoreci.com/blog/define-your-cicd-with-docker)
  Semaphore now supports custom CI/CD environments based on Docker containers.
  Get started with [Custom CI/CD environment with Docker](https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/).

- Launched support for skipping blocks based on conditions, e.g. `branch != 'master'`.
  Read more about [skipping blocks](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#skip-in-blocks)
  and the introduction of [Conditions domain specific language](https://docs.semaphoreci.com/reference/conditions-reference/)
  that allows the expression of complex conditional rules in your pipelines.

- Owners and admins can now set [Budget Alerts](https://docs.semaphoreci.com/account-management/billing/#budget-alert).

- New Semaphore approved convenience Docker images released:
    - [Alpine](https://hub.docker.com/r/semaphoreci/alpine)
    - [Android](https://hub.docker.com/r/semaphoreci/android)
    - [Clojure](https://hub.docker.com/r/semaphoreci/clojure)
    - [Elixir](https://hub.docker.com/r/semaphoreci/elixir)
    - [Golang](https://hub.docker.com/r/semaphoreci/golang)
    - [Haskell](https://hub.docker.com/r/semaphoreci/haskell)
    - [Node](https://hub.docker.com/r/semaphoreci/node)
    - [Openjdk](https://hub.docker.com/r/semaphoreci/openjdk)
    - [Php](https://hub.docker.com/r/semaphoreci/php)
    - [Python](https://hub.docker.com/r/semaphoreci/python)
    - [Ruby](https://hub.docker.com/r/semaphoreci/ruby)
    - [Rust](https://hub.docker.com/r/semaphoreci/rust)
    - [Ubuntu](https://hub.docker.com/r/semaphoreci/ubuntu)

- Version `v0.13.0` of the Semaphore CLI has been released.
    - `sem debug job` works without configuring the CLI with an SSH key.
    Keys are now generated server side.
    - `sem attach` can attach to any running job without the need to inject
    public SSH keys as part of your Pipeline configuration.
    - Debugging and attaching to jobs works for Docker based CI/CD environments
    - Read the updated documentation about [Debugging with SSH Access](https://docs.semaphoreci.com/essentials/debugging-with-ssh-access/).

Upgrade to the latest CLI version:

``` bash
curl https://storage.googleapis.com/sem-cli-releases/get.sh | bash
```

### Week of May 13, 2019

- [iOS support is in GA](https://semaphoreci.com/blog/introducing-ios-cicd):
  Semaphore now supports building, testing and deploying applications for any
  Apple device.
  Get started with [Xcode tutorial](https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/)
  and [example Swift project](https://github.com/semaphoreci-demos/semaphore-demo-ios-swift-xcode).
- macOS platform:
    - Xcode upgraded to 10.2.1
- New feature: [schedule CI/CD workflows](https://docs.semaphoreci.com/reference/projects-yaml-reference/#schedulers)
  using standard Cron syntax.

### Week of Apr 22, 2019

- [Fastlane plugin](https://github.com/semaphoreci/fastlane-plugin-semaphore) is
  now available.
- Platform updates:
    - Chrome 74, ChromeDriver 74
    - Heroku 7.24.1
    - Git-lfs 2.7.2
    - Pip 19.1
    - Phpunit 7.5.9
    - Removed Oracle Java 7,9,10; Java 8 and 11 are now based on OpenJDK.

### Week of Apr 15, 2019

- Docker-based environment is now available to all organizations as a public beta.
- New feature: [epilogue has `on_pass` and `on_fail`
  properties](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-epilogue-property)
  which run commands based on the job's result.
- sem CLI v0.10.0 released, with an option to [create a secret based on
  environment variables](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-create-secret-with-environment-variables-and-files)
  in a single command.
- Jobs now export `TERM=xterm`. This allows running tools that depend on
  exported `TERM` settings, such as psql.
- Jobs now export `PAGER=cat`. This prevents some commands from infinitely
  waiting for user input, such as `git log`.
- Job logs are now fully UTF-8 compliant.


### Week of Apr 8, 2019

- New feature: [Run jobs inside a custom Docker
  container](https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/) (beta).
- Organization owners can promote members to an [Admin
  role](https://docs.semaphoreci.com/account-management/permission-levels/),
  to delegate billing, people and project management.
  See the `/people` page within your organization.
- Slack notifications can be created and managed in the UI.

### Week of Mar 25, 2019

- Platform updates:
    - Chrome 73
    - Elixir 1.8.1
    - Go 1.12.1
    - Ruby versions >=2.6.0 have bundler 2.0.1 and rubygems>3 preinstalled
    - Scala 2.12.7

### Week of Mar 18, 2019

- macOS, iOS support is in open beta: see
  [tutorial](https://docs.semaphoreci.com/examples/ios-continuous-integration-with-xcode/).

### Week of Mar 12, 2019

- Platform updates:
    - Heroku 7.22.4
    - Libvirt, qemu, virsh are now part of the Ubuntu VM image with virtual network `192.168.123.0/24`

### Week of Feb 25, 2019

- You can now create and manage secrets in the UI.
- You can create multiple projects from the same screen by selecting any number
  of Git repositories.
- The screen should be a little more pleasant while your dashboard is loading.
- In case of misconfigured YAML file, the error message is now nicely wrapped in
  a red box.
- Fixed an issue with sliders on Linux/Chrome.
- Platform additions:
    - Go 1.12
    - libvirt-bin, qemu-kvm and virtinst
- Platform updates:
    - git 2.21
    - git-lfs 2.7.1
    - gradle 5.2
    - heroku to 7.22.2
    - sbt 0.13.17
- Introduced [Tutorials and example projects](https://docs.semaphoreci.com/examples/tutorials-and-example-projects/),
  a handy portal to practical examples of CI/CD pipelines, with links to open
  source repositories that you can copy.

### Week of Feb 18, 2019

- Added contextual CLI widgets to the top-right corner of all pages. The `>_`
  widget shows CLI commands that you can run to perform the same actions that
  you see in the UI.
- Slack notifications can be [filtered by pipeline result](https://docs.semaphoreci.com/essentials/slack-notifications/#filtering-by-pipeline-result).
- [macOS Mojave](https://docs.semaphoreci.com/ci-cd-environment/macos-xcode-11-image/)
  image introduced, as iOS / macOS support enters
  [closed beta](https://semaphoreci.com/product/ios).
- Syntax highlighting in docs.

### Week of Feb 11, 2019

- New feature: Add project from UI. The much-loved feature of Semaphore Classic
  is now available in Semaphore 2.0 as well. Using the command-line interface
  remains an option, of course.
- Platform:
    - Added new APT mirrors for faster apt-get installations in Ubuntu1804 image.
    - Chrome updated to 72.
    - Heroku CLI updated to 7.21.

### Week of Feb 4, 2019

- Platform:
    - ChromeDriver updated to 2.46.
    - Added Ruby 2.6.0, 2.6.1.
    - If repository contains `.ruby-version` file, Semaphore automatically fetches
    a pre-built version of the specified Ruby.

### Week of Jan 28, 2019

- Platform:
    - Added Java 11.

### Week of Jan 7, 2019

- New feature: Billing insights. Organization owners can now see
  the top spending projects and daily spending charts which contain
  spending per machine type. Data is available for any selected period.
- Launching a promotion manually now shows a confirmation dialog.
- Fixed: checkout command doesn't fail on git reference tags.

### Week of Dec 17, 2018

- New feature: Restart workflow.
  Available via “Restart" button on the workflow page,
  or `sem rebuild workflow <id>` in CLI.
- [checkout](https://docs.semaphoreci.com/reference/toolbox-reference/#libcheckout)
  runs faster by doing a shallow git clone.
- We improved the speed and stability of the UI, most notably on pages
  that load workflows and jobs.
- Changelog initiated. 🚀
