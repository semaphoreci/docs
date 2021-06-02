---
description: This document provides instructions on how to connect your GitHub and Semaphore 2.0.
---

# Connecting your GitHub account and Semaphore

### Signing up on Semaphore with GitHub account
In order to support single sign-on via GitHub Semaphore uses [OAuth app](https://github.com/settings/connections/applications/328c742132e5407abd7d).

Semaphore requires read access to your GitHub email address during the sign up process. 

Once you sign up, there are two different ways to give access to your repositories - through your _personal access token_ or the _GitHub App instalation_.

### OAuth App vs. GitHub App
The difference between OAuth Apps and GitHub Apps is described in [GitHub documentation](https://docs.github.com/en/developers/apps/about-apps):

> By default, only organization owners can manage the settings of GitHub Apps in an organization. To allow additional users to manage GitHub Apps in an organization, an owner can grant them GitHub App manager permissions.
> 
> By contrast, users authorize OAuth Apps, which gives the app the ability to act as the authenticated user. For example, you can authorize an OAuth App that finds all notifications for the authenticated user. You can always revoke permissions from an OAuth App.

Connection through OAuth app relies on users personal access token while with GitHub App the communication goes through GitHub App instalation.

Using GitHub App is the advised method of connecting your repositories because of the two main advantages:

- **More granular permission** - Using GitHub App allows you to give access to each repository individually.
- **No OAuth token owner** - GitHub app doesn't rely on the personal token of the original Semaphore project owner, making the user offboarding easier. 

### Connecting a repository via GitHub App
In order to connect the repository via [Semaphore GitHub App](https://github.com/apps/semaphore-ci-cd) three conditions need to be met:
1. You are a collaborator on the repository.
2. The GitHub App is installed on the GitHub organization/account that repository belongs to.
3. The GitHub App is given access either to All repositories or the one you want to connect to.

If the conditions above are not met, you will see the empty repository list when trying to create the project:

![GH App - Empty list](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_connection/ghapp_zero.png)

**To give access to more repositories:**

**Step 1.** Click on the "Give access to more repositories"  
**Step 2.** Select GitHub account/organization on which you want to install the app  
**Step 3.** Select "All repositories" or pick individual ones you want to give access to.   
**Step 4.** You will be returned to the repository list in the Semaphore and repositories should appear.   

You can always edit and update the access permissions of each installed GitHub App. 

!!! info "Installing the GitHub App on GitHub organization"
    You might not be able to install the GitHub app on the GitHub organizations that you're not the owner of. In such cases following the steps above will only **request** the installation from organization owner. 
    The repositories will not be available until installation is approved by the organization owner in the GitHub. 
    Once you request the installation, GitHub organization owner will receive the email request for approval from GitHub.

### Connecting a repository via personal access token
In order to connect the repository via [Semaphore OAuth app](https://github.com/settings/connections/applications/328c742132e5407abd7d) following conditions have to be met:

1. You are a collaborator on the repository.
2. You gave Semaphore OAuth app access to your repositories (public or public & private).
3. The Semaphore OAuth app is approved for GitHub organization (applies only if repository is in GitHub organization and not personal account).

Depending on how many conditions above are met, the repository list can either: 
- Contain all the repositories you have access to.
- Contain only the repositories from your personal account.
- Contain no repositories and prompting you to give Semaphore OAuth app access:
![OAuth permissions](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_connection/oauth_permissions.png)

**To connect your first project:**  
**Step 1.** Click on the "+ Create new" > "Choose repository".  
**Step 2.** On the repository list select the "GitHub Personal Token" tab.  
**Step 3.** Choose either "Public repositories" or "All repositories" to give Semaphore access.  
**Step 4.** You will be redirected back to the list, select the repository and continue through the wizzard.  

You can always check which access level you gave on [Profile Settings page](https://me.semaphoreci.com/account).

Please note that the access can always be fully revoked on the [Semaphore OAuth App page](https://github.com/settings/connections/applications/328c742132e5407abd7d).

!!! info "Granting access to the GitHub organization repositories"
    Depending on the organization settings, access to the **GitHub organization** repositories may need to be granted by the organization owner by going to the [OAuth App page](https://github.com/settings/connections/applications/328c742132e5407abd7d) and clicking "Grant" next to the organization name. 
    If you gave full access to Semaphore but you only see your personal repositories it might mean that the GitHub organization owner hasn't granted Semaphore access to the organization yet. 

Note that Semaphore usually needs some time to sync with any access rights updates on GitHub. If all the access has been properly given but you still don't see the repository in the list click the **"Sync repos"** button to force a refresh. Your repository should appear after a few seconds and a page refresh. 

![OAuth Refresh](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_connection/oauth_refresh.png)

For more information on how to troubleshoot connections between Semaphore and GitHub via the OAuth app please check our [GitHub OAuth - connection troubleshooting](https://docs.semaphoreci.com/account-management/checking-the-connection-between-github-and-semaphore-2.0/) guide.

### Transferring projects from personal token connection to GitHub App
You can easily transfer your old projects connected via personal access token to GitHub App connection by following these instructions:

**Step 1.** Open the Semaphore project you want to transfer  
**Step 2.** Go to project Settings and select Repository settings  
**Step 3.** If your project is using personal token to connect to repository you will see the following screen:
![GH App - Transfer project](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_connection/transfer_no_access.png)

In this example, the GitHub App does not have access to the repository you want to transfer.

**Step 4.** Click on the GitHub app link and install the app making sure you give access to the repository you want to connect.  
**Step 5.** Once the GitHub App is installed an access given, go back to project repository settings and click "Switch to GitHub Apps"
![GH App - Transfer project](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_connection/transfer_access.png)  

**Step 6.** If your project is switched successfully your Repository Settings page should look like this:
![GH App - Transfer success](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_connection/transfer_success.png)
