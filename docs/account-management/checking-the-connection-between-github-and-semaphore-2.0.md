---
description: This document provides instructions on how to check the connection between GitHub and Semaphore 2.0.
---

# Checking the Connection Between GitHub and Semaphore 2.0

To check the status of the connection between Semaphore 2.0 and GitHub, please visit
the [Semaphore 2.0 application page on GitHub](https://github.com/settings/connections/applications/328c742132e5407abd7d).

This web page shows you:

- Account permissions you have granted to Semaphore 2.0
- Organizations that you are a member of, and the level of access that Semaphore
  2.0 has to these organizations.

If the page is not showing Semaphore 2.0 application on GitHub, and you
previously logged in to Semaphore 2.0 with the GitHub account that you are
currently using, please check your [account settings](https://me.semaphoreci.com/account/) page.  
Under the "Repository access" section, click on grayed out checkmarks to reauthorize the Semaphore app.

**If [Semaphore 2.0 application page on GitHub](https://github.com/settings/connections/applications/328c742132e5407abd7d) is still not showing the Semaphore 2.0 application
please contact Semaphore support.**


## Grant additional permissions

When you sign up with your GitHub account, Semaphore is asking only for your
email. If you want to grant additional permissions, that is to let Semaphore
2.0 access public and/or private repositories that you have access to, please
visit [account settings](https://me.semaphoreci.com/account) page.

To grant Semaphore 2.0 access to public or private repositories, click on the grayed out checkmark to go through the authorization process.

If Semaphore 2.0 already has access, the checkmark will be green.

## Grant access to organization repositories

On the [Semaphore 2.0 application page](https://github.com/settings/connections/applications/328c742132e5407abd7d) you can also request from a GitHub organization admin
to grant Semaphore 2.0 access to its repositories. If you are an admin, then you can do
that yourself.

## Check deploy key health
When a Semaphore 2.0 project is created a deploy key is generated on GitHub.  
One deploy key is generated on GitHub repository per each Semaphore 2.0 project connected to that repository.  
There could be several reasons why deploy key is not available anymore:  

- It was manually removed from the repository;
- Original project creator revoked GitHub access to Semaphore app;
- Original project creator does not have access to that GitHub repository anymore.

If a deploy key is broken Semaphore will not be able to check out code from that repository and job log might display following error:
``` yaml
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.
```
To check the status of deploy key go to the project settings on Semaphore 2.0 and find GitHub settings.  
Green check mark next to "Deploy Key" means that Semaphore found a valid deploy key.  
If the deploy key is broken a red "X" icon will be shown instead. 

To regenerate the deploy key, click "Repair" next to the red "X" icon. This should delete the broken deploy key if it still exists and generate a new one.  

## Check webhook health
Semaphore uses GitHub webhook to detect updates to repository and trigger builds.  
If a webhook is deleted on GitHub, Semaphore will not be able to detect updates and will not run builds.  

To check the status of a webhook go to the project settings on Semaphore 2.0 and find GitHub settings.  
Green check mark next to "Webhook" means that Semaphore managed to connect to the GitHub repository.  
If the webhook is broken a red "X" icon will be shown instead. 

To regenerate the webhook, click "Repair" next to the red "X" icon. This should generate a new webhook and repair connection between Semaphore and GitHub.  

## Re-connecting Semaphore project to the renamed GitHub repository

If you:

1. change the location of the repository on GitHub,
2. rename the repository on GitHub,
3. rename your user account on GitHub or
4. rename your organization on GitHub,

it is needed to change the URL of the GitHub repository on Semaphore, too, in order to match this change. 
You can do that through the sem CLI. Detailed instructions can be found on [the sem CLI doc page](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-edit_1).

[This project YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/#examples) 
might also help.

After the URL change, please double check [the deploy key health](https://docs.semaphoreci.com/account-management/checking-the-connection-between-github-and-semaphore-2.0/#check-deploy-key-health) and [webhook health](https://docs.semaphoreci.com/account-management/checking-the-connection-between-github-and-semaphore-2.0/#check-webhook-health) of your project.

## File '.semaphore/semaphore.yml' is not available

You might see the following error message when trying to run workflows on Semaphore:

``` yaml
semaphore.yml ERROR:
Error: {"File '.semaphore/semaphore.yml' is not available", "Not Found"}
```

This means that Semaphore can't fetch `.semaphore/semaphore.yml` file from the
repository. To do that, Semaphore is using GitHub credentials of the person who added
the project to Semaphore. If this person no longer has access to the repository
on GitHub, please contact Semaphore support, with information who should be the
new owner of the project.



