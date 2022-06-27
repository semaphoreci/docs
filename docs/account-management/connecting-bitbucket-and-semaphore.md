---
Description: This document provides instructions on how to connect your Bitbucket account to Semaphore.
---

# Connecting your Bitbucket account and Semaphore

Semaphore integrates with multiple Git providers. You can connect your Bitbucket account with Semaphore by:

- Creating a new Semaphore account with Bitbucket.
- Connect it to an existing Semaphore account, previously created with another Git provider like GitHub.


### Creating a new Semaphore account with Bitbucket


1. Make sure you are logged into your Bitbucket account that you want to connect.
2. Go to the Semaphore **[signup page](https://id.semaphoreci.com/signup)** and select **Log in with Bitbucket**
3. To support single sign-on via Bitbucket, Semaphore uses [OAuth App](https://support.atlassian.com/bitbucket-cloud/docs/use-oauth-on-bitbucket-cloud/). Grant access to the Semaphore OAuth App (you can always [revoke it later](#disconnecting-your-bitbucket-account)).
4. Create a new Semaphore organization if you are not already part of one. 


!!! info "Using the same email address on GitHub and Bitbucket"
    Semaphore uses an email address as a unique user identifier. If you use the same email on your GitHub and Bitbucket accounts, and you have previously connected the Semaphore account with GitHub, you will not be able to create a new user account with Bitbucket. 

    Instead, you have to connect your BitBucket account to your existing Semaphore profile. 

### Connecting your Bitbucket account to an existing Semaphore account
If you have both GitHub and Bitbucket accounts you can attach them both to a single Semaphore profile. 

1. **[Log in](https://id.semaphoreci.com/login)** to your existing Semaphore profile.  
2. Go to your Semaphore **[account page](https://me.semaphoreci.com/account)**.
3. Under the **Repository setting**, click on the **Grant access** link next to Bitbucket.
4. Grant access to the Semaphore OAuth App (you can always [revoke it later](#disconnecting-your-bitbucket-account)).

<img style="box-shadow: 0px 0px 5px #ccc" src="/account-management/img/bb-connect-acc.png" alt="Example of connecting Bitbucket account">

### Disconnecting your Bitbucket account
To disconnect your Bitbucket account:

1. On your Bitbucket account, go to the list of [authorized Oauth apps](https://bitbucket.org/account/settings/app-authorizations/)
2. Find the **Semaphore 2.0** App on the list. 
3. Click on the **Revoke** link. 

<<<<<<< HEAD
## Verifying the Connection Between Bitbucket and Semaphore
=======
## Checking the connection between Bitbucket and Semaphore
>>>>>>> f3e39fb523dc79ecd52d6f631f733ebc04c8dbc9

To verify the status of the connection between your Semaphore profile and Bitbucket, please review your **[Account settings](https://me.semaphoreci.com/account/)**.  

Your Bitbucket profile connection on this page can be in one of these states: 

- **Not Connected** - Your account is not connected. Next time you attempt to log in, you will need to grant access to Semaphore again. 
- **Connected** - You can connect both private and public repositories via OAuth App. 

You can also verify if the Semaphore OAuth App is installed by reviewing the list of [authorized Oauth apps](https://bitbucket.org/account/settings/app-authorizations/) on your Bitbucket account. 

**If you can see the Semaphore OAuth App in the list, but you still cannot access your Semaphore account please contact our support team.**

### Verifying deploy key health
Creating a project in Semaphore generates a deploy key. Semaphore generates a deploy key for each Bitbucket repository with a project connected to it.  

Can't find a deploy key? There could be several reasons why a deploy key might not be available anymore:  

- It was manually removed from the repository
- The original project creator revoked the Semaphore OAuth App's access on Bitbucket
- The original project creator may no longer have access to the Bitbucket repository in question

If a deploy key is broken, Semaphore will not be able to interact with code from that repository and the job log might display the following error:
``` yaml
git@bitbucket.org: Permission denied (publickey).00:02
fatal: Could not read from remote repository.
```
To verify the status of a deploy key go to project settings on Semaphore and find the **Repository** settings.  

A green check mark next to **Deploy Key** means that Semaphore found a valid deploy key.  
If the deploy key is broken, a red "X" icon will be shown instead. 

To regenerate the deploy key, click the **Repair** button next to the red "X" icon. This should delete the broken deploy key if it still exists and generate a new one.  

### Verifying webhook health
Semaphore uses Bitbucket webhooks to detect updates to repositories and trigger builds. Deleting a webhook on Bitbucket renders Semaphore unable to detect updates and run builds.  

To verify the status of a webhook, go to the project settings on Semaphore and find the **Repository** settings. A green check mark next to **Webhook** means that Semaphore successfully connected to the Bitbucket repository. If the webhook is broken, a red "X" icon will be shown instead. 

To regenerate a webhook, click the **Repair** button next to the red "X" icon. This should generate a new webhook and repair the connection between Semaphore and Bitbucket.  

### Re-connecting a Semaphore project to a renamed or moved Bitbucket repository

If you:

1. Change the location of a repository on Bitbucket
2. Rename a repository on Bitbucket
3. Rename your user account on Bitbucket


you have to change the URL of the Bitbucket repository on Semaphore also. 

To update the URL to the repository:
1. Go to the **Settings** tab of your project
2. Select the **Repository** tab
3. Update the repository URL 

You can also do it via sem CLI. Detailed instructions can be found on [the sem CLI doc page](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-edit_1).

[This project YAML reference](https://docs.semaphoreci.com/reference/projects-yaml-reference/#examples) 
might also be helpful.

After an URL change, please double-check your project's [deploy key health](#verifying-deploy-key-health) and [webhook health](#verifying-webhook-health).

### What to do if the '.semaphore/semaphore.yml' file is not available

You might see the following error message when trying to run workflows on Semaphore:

``` yaml
semaphore.yml ERROR:
Error: {"File '.semaphore/semaphore.yml' is not available", "Not Found"}
```

This means that Semaphore can't fetch the `.semaphore/semaphore.yml` file from the repository. There are two reasons why this might happen:

1. **The file doesn't exist on your repository** - double-check to make sure that the Semaphore YAML file exists. 
2. **Repository is disconnected from Semaphore** - Follow the steps [previously described](#verifying-the-connection-between-bitbucket-and-semaphore).
