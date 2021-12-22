---
Description: This document provides instructions on how to connect your GitHub account to Semaphore 2.0.
---

# Connecting your GitHub account and Semaphore

### Signing up on Semaphore with your GitHub account
To support single sign-on via GitHub, Semaphore uses [OAuth app](https://github.com/settings/connections/applications/328c742132e5407abd7d).

Semaphore requires read access to your GitHub email address during the sign-up process. 

Once you sign up, there are two different ways to give access to your repositories: a _personal access token_ or _GitHub App installation_.

### OAuth Apps vs. GitHub Apps
The difference between OAuth Apps and GitHub Apps is described in [GitHub documentation](https://docs.github.com/en/developers/apps/about-apps):

> By default, only organization owners can manage the settings of GitHub App in an organization. To allow additional users to manage GitHub Apps in an organization, an owner can grant them GitHub App manager permissions.
> 
> By contrast, users authorize OAuth Apps, which gives it the ability to act as an authenticated user. For example, you can authorize an OAuth App that finds all notifications for an authenticated user. You can revoke permissions from an OAuth App at any time.

Connection through an OAuth App relies on your personal access token, while with GitHub Apps the communication goes through GitHub App installation.

It is advised that you use GitHub Apps as the method of connecting your repositories, because of two main advantages:

- **More granular permission** - Using GitHub Apps allows you to give access to each repository individually.
- **No OAuth token owner** - GitHub Apps don't rely on the personal access token of the original Semaphore project owner, making the user offboarding easier. 

### Connecting a repository via GitHub App
To connect a repository via [the Semaphore GitHub App](https://github.com/apps/semaphore-ci-cd), three conditions need to be met:  
1. You are a collaborator on the repository.  
2. You have installed our GitHub App for the GitHub organization/account that the repository belongs to.  
3. You have given our GitHub App access either to all repositories or the ones you want to connect to.  

If any of the above conditions are not met, you will see an empty repository list when trying to create a project:

![GH App - Empty list](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_images/ghapp_zero.png)

**To give access to more repositories, follow these steps:**

1. Click on "Give access to more repositories".  
2. Select the GitHub account/organization for which you want to install the app.  
3. Select "All repositories" or pick individual repositories that you want to give access to.   
4. You will be returned to the repository list in Semaphore and the selected repositories should appear.   

You can always edit and update access permissions for each installed GitHub App. 

!!! info "Installing the Semaphore GitHub App in a GitHub organization"
    You might not be able to install our GitHub App in GitHub organizations that you're not the owner of. In such cases, following the steps above will send a **request** for installation to the organization's owner. 
    
    The repositories will not be available until the organization's owner approves the installation in GitHub. 
    Once you request the installation, the GitHub organization's owner will receive an email request for approval from GitHub.

### Connecting a repository via personal access token
If you want to connect a repository via [the Semaphore OAuth app](https://github.com/settings/connections/applications/328c742132e5407abd7d), the following conditions have to be met:

1. You are a collaborator on the repository.
2. You have given the Semaphore OAuth app access to your repositories (public or public & private).
3. You have approved the Semaphore OAuth app within the GitHub organization (applies only if the repository is in a GitHub organization and not the personal account).

Depending on how many conditions above are met, the repository list can either: 
- Contain all the repositories you have access to.
- Contain only the repositories from your personal account.
- Contain no repositories and prompt you to grant the Semaphore OAuth app access:
![OAuth permissions](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_images/oauth_permissions.png).

**To connect your first project, follow these steps:**  
1. Click on "+ Create new" then "Choose repository".  
2. Select the "GitHub Personal Token" tab in the repository list.  
3. Choose either "Public repositories" or "All repositories" to give Semaphore access.  
4. You will be redirected back to the list, select the repository and continue through the wizard.  

You can always check which access level you have given on the [Profile Settings page](https://me.semaphoreci.com/account).

Please note that you can fully revoke access on the [Semaphore OAuth App page](https://github.com/settings/connections/applications/328c742132e5407abd7d) at any time.

!!! info "Granting access to a GitHub organization's repositories"
    Depending on the organization settings, the owner may need to grant access to a **GitHub organization's** repositories by going to the [OAuth App page](https://github.com/settings/connections/applications/328c742132e5407abd7d) and clicking "Grant" next to the organization's name. 
    
    If you have given full access to Semaphore but you only see your personal repositories, it might mean that the GitHub organization's owner hasn't granted Semaphore access to the organization yet. 

Note that Semaphore usually needs some time to sync with any access updates on GitHub. If you have properly granted access for a repository but still don't see it in the list, click the **"Sync repos"** button to force a refresh. Your repository should appear after the page refreshes. 

![OAuth Refresh](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_images/oauth_refresh.png)

For more information on how to troubleshoot connections between Semaphore and GitHub via OAuth App please check our [GitHub OAuth - connection troubleshooting](https://docs.semaphoreci.com/account-management/checking-the-connection-between-github-and-semaphore-2.0/) guide.

### Transferring projects from personal token connection to a GitHub App
You can easily transfer your old projects connected via personal access token to connect via GitHub App by following these instructions:

1. Open the Semaphore project you want to transfer.  
2. Go to "Project Settings" and select "Repository Settings".  
3. If your project is using a personal token to connect to the repository, you will see the following screen:
![GH App - Transfer project](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_images/transfer_no_access.png).

In this example, the GitHub App does not have access to the repository you want to transfer.

4. Click on the GitHub App link and install it, making sure you give access for the desired repository.  
5. Once GitHub App is installed and access is given, go back to project repository settings and click "Switch to GitHub App"
![GH App - Transfer project](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_images/transfer_access.png). 

6. If your project has been successfully switched, your Repository Settings page should look like this:
![GH App - Transfer success](https://raw.githubusercontent.com/semaphoreci/docs/master/public/gh_images/transfer_success.png).
