---
Description: This document provides instructions on how to check the connection between GitHub and Semaphore 2.0.
---

# Checking the Connection Between GitHub and Semaphore 2.0

To check the status of the connection between Semaphore 2.0 and GitHub, please visit
the [Semaphore 2.0 application page on GitHub](https://github.com/settings/connections/applications/328c742132e5407abd7d).

This web page shows you:

- The account permissions that you have granted to Semaphore 2.0
- The organizations that you are a member of, and the level of access that Semaphore
  2.0 has to these organizations.

If the page is not showing the Semaphore 2.0 application on GitHub, and you
have logged in to Semaphore 2.0 with the GitHub account that you are
using, please check your [account settings](https://me.semaphoreci.com/account/).  
Under the "Repository access" section, click on the greyed-out checkmarks to reauthorize the Semaphore app.

**If the [Semaphore 2.0 application page on GitHub](https://github.com/settings/connections/applications/328c742132e5407abd7d) is still not showing the Semaphore 2.0 application please contact Semaphore support.**


## Granting additional permissions

When you sign up with your GitHub account, Semaphore only asks for your
email. If you want to grant additional permissions, i.e. to let Semaphore
2.0 access public and/or private repositories that you have access to, please
visit the [account settings](https://me.semaphoreci.com/account) page.

To grant Semaphore 2.0 access to public or private repositories, click on the greyed-out checkmark to go through the authorization process.

If Semaphore 2.0 already has access, the checkmark will be green.

## Granting access to an organization's repositories

On the [Semaphore 2.0 application page](https://github.com/settings/connections/applications/328c742132e5407abd7d) you can also request that a GitHub organization admin
grants Semaphore 2.0 access to its repositories. If you are an admin, you can do
this yourself.

## Checking deploy key health
When a Semaphore 2.0 project is created a deploy key is generated on GitHub.  
One deploy key is generated for a GitHub repository per Semaphore 2.0 project connected to it.  

Can't find a deploy key? There could be several reasons why a deploy key might not be available anymore:  

- It was manually removed from the repository
- The original project creator revoked the Semaphore app's GitHub access 
- The original project creator no longer has access to the GitHub repository in question

If a deploy key is broken, Semaphore will not be able to interact with code from that repository and the job log might display following error:
``` yaml
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.
```
To check the status of a deploy key go to project settings on Semaphore 2.0 and find GitHub settings.  
A green check mark next to "Deploy Key" means that Semaphore found a valid deploy key.  
If the deploy key is broken, a red "X" icon will be shown instead. 

To regenerate the deploy key, click the "Repair" button next to the red "X" icon. This should delete the broken deploy key if it still exists and generate a new one.  

## Checking webhook health
Semaphore uses GitHub webhook to detect updates to repositories and trigger builds.  
If a webhook is deleted on GitHub, Semaphore will not be able to detect updates and will not run builds.  

To check the status of a webhook, go to the project settings on Semaphore 2.0 and find GitHub settings.  
A green check mark next to "Webhook" means that Semaphore successfully connected to the GitHub repository.  
If the webhook is broken, a red "X" icon will be shown instead. 

To regenerate a webhook, click the "Repair" button next to the red "X" icon. This should generate a new webhook and repair the connection between Semaphore and GitHub.  

## Re-connecting a Semaphore project to a renamed/moved GitHub repository

If you:

1. change the location of a repository on GitHub
2. rename a repository on GitHub
3. rename your user account on GitHub
4. rename your organization on GitHub

you have to change the URL of the GitHub repository on Semaphore also. 
You can do that via sem CLI. Detailed instructions can be found on [the sem CLI doc page](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-edit_1).

[This project YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/#examples) 
might also be helpful.

After an URL change, please double check your project's [deploy key health](https://docs.semaphoreci.com/account-management/checking-the-connection-between-github-and-semaphore-2.0/#check-deploy-key-health) and [webhook health](https://docs.semaphoreci.com/account-management/checking-the-connection-between-github-and-semaphore-2.0/#check-webhook-health).

## What to do if the '.semaphore/semaphore.yml' file is not available

You might see the following error message when trying to run workflows on Semaphore:

``` yaml
semaphore.yml ERROR:
Error: {"File '.semaphore/semaphore.yml' is not available", "Not Found"}
```

This means that Semaphore can't fetch the `.semaphore/semaphore.yml` file from the
repository. Normally, Semaphore uses the GitHub credentials of the person who added
the project to Semaphore to accomplish this. If that person no longer has access to the repository
on GitHub, please contact Semaphore support.



