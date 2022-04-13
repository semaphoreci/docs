---
Description: On Semaphore, an "organization" is an account management framework that lets you grant different permissions to team members and delegate project management within an account.
---

# Organizations

Organizations are Semaphore's account management framework that lets you 
grant different permissions to team members and delegate project management 
responsibilities within a single account.

## Creating an organization

There are two scenarios in which you can create an organization.

### Creating your first organization

Once you sign up, you will be redirected to the **Create an organization** page. On this page:

1. Enter your full name
2. Enter your work email
3. Enter the company/organization name -- this will also create a URL for your organization

After your organization has been created, you just need to choose a plan and then you are ready to 
[start with your first project][guided-tour]. Happy building!

**Note:** Only one of your organizations can be on a [Free plan](https://docs.semaphoreci.com/account-management/plans/#free-plan) and one can be on an [Open Source plan](https://docs.semaphoreci.com/account-management/plans/#open-source-plan).

### Creating a new organization when you already have an organization

In order to crate a new organization when you already have an organization, you can:
 
1. Click on the initials of your current organization in the top right corner of the page
2. Click on **Change Organization** at the bottom of the dropdown menu
3. Click on **+ Create new**
4. Choose the URL for the organization and click on **Save & Continue…**
4. Choose a plan -- please note that you can only have one organization on a [Free plan](https://docs.semaphoreci.com/account-management/plans/#free-plan) 
and one organization on an [Open Source plan](https://docs.semaphoreci.com/account-management/plans/#open-source-plan)

Congratulations, you are ready to start adding projects to your new organization!

## Adding a user to an organization

In order to add a new user to your organization, you can:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **People** in the dropdown menu
2. Enter the GitHub username of the person you want to add in the text box
3. Click on **Invite**

All invited users have the [Member permission level](https://docs.semaphoreci.com/account-management/permission-levels/#members) by default. You can promote users to [Admins](https://docs.semaphoreci.com/account-management/permission-levels/#admin) 
by clicking on the **Promote** button next to their username.

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admins) or the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

**Note:** If you want someone to have access to a project on Semaphore, 
you first need to give this person access to the repository on GitHub, 
and then add them as a member on Semaphore.

## Adding multiple users to an organization

If you want to add multiple users to your organization at the same time, you can:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **People** in the dropdown menu
2. Click on the **repository collaborators** link
3. Select members you'd like to add to Semaphore and enter their emails (If you don’t know 
someone’s email, just leave the field empty. We will still add them to your 
organization, but we won’t email them an invitation.)
4. Click on the **Add selected** button

All invited users have the [Member permission level](https://docs.semaphoreci.com/account-management/permission-levels/#members) by default. You can promote users to [Admins](https://docs.semaphoreci.com/account-management/permission-levels/#admin) 
by clicking on the **Promote** button next to their username.

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admins) or the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

## Removing a user from an organization

Users can be removed from an organization in the following way:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **People** in the dropdown menu
3. Click on the **"X"** button next to the username of the user you want to remove

Upon removal, access to all projects in the organization will be revoked. Please 
note that this won't change permissions on GitHub.

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admins) or the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

If you want to remove a user who has added projects to your organization, continue reading 
the section below.

## Removing a user who has created projects in your organization

To remove a user that has created projects in your organization, you must transfer ownership of those projects to a different user in the organization. In order to transfer project ownership to a different user, the following 
conditions need to be met:

1. New project owner needs to have Admin permission level for the repository on GitHub
2. If you plan to build private projects, the new owner needs to grant Semaphore access to all repositories -- they can do that that under [Personal Settings -> GitHub repository access](https://me.semaphoreci.com/account)
3. If you plan to build only public projects, the new owner needs to grant Semaphore access to public repositories -- they can do that that under [Personal Settings -> GitHub repository access](https://me.semaphoreci.com/account)

After that, go to _Project Settings -> General_, in the _Project Owner_ section, find the user you want to become the new owner, and click _Change_.

If you come accross any issues, please reach out to [support@semaphoreci.com](mailto:support@semaphoreci.com)
and include the name of the project and the GitHub username of the new owner in your message.

**Note:** After project ownership has been transferred, you need to push a new commit. 
Re-running old builds no longer works if ownership of a project has changed.

## Changing the name and the URL of an organization

If you'd like to change the name of your organization:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **Settings** in the dropdown menu
3. Enter a new name in the **Name** text box
3. Click on the **Save Changes** button

Please note that changing the name doesn't change the organization's URL. This has 
to be done separately.

In order to change the URL of your organization:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **Settings** in the dropdown menu
3. Click on **Change URL...**
4. Enter a new URL in the text box
5. Click on the **Change URL** button

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admin) or the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

## Transferring ownership of an organization

In order to transfer ownership of an organization to a different user, the following conditions need
to be met:

- The new owner needs to be a member of the organization
- The new owner needs to have logged into Semaphore 2.0 at least once
- The current owner needs to send a confirmation email to [support@semaphoreci.com](mailto:support@semaphoreci.com)
  from the primary email address associated with the GitHub account used to log into
  Semaphore 2.0 -- in this email, please include name of the organization and
  GitHub username of the new owner

After that, we’ll transfer ownership on your behalf.

**Note:** Transferring ownership of an organization doesn't automatically transfer 
the projects you own in that organization. If you'd like us to transfer the ownership of 
projects, please refer to the "[How to transfer project ownership](https://docs.semaphoreci.com/faq/managing-projects/#how-to-transfer-project-ownership)" page.

## Deleting an organization 

Before you delete an organization, you need to [delete all projects][project-mgmt] in it. 
**Note that once you delete an organization, its content cannot be restored.** 
Only the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of an organization can delete it.

In order to delete an organization, you should:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **Settings** in the dropdown menu
3. Click on **Delete Organization...** at the bottom of the page
4. Type "delete" to confirm
5. Click on the **Delete Organization** button

## Deleting an account

In order to delete your account, please send an email to
[support@semaphoreci.com](mailto:support@semaphoreci.com) from the primary email
address associated with the GitHub account used to log in to Semaphore 2.0.
In this email, please include your GitHub username.

## See also

- [Permission levels](https://docs.semaphoreci.com/account-management/permission-levels/)
- [Billing](https://docs.semaphoreci.com/account-management/billing/)
- [Plans](https://docs.semaphoreci.com/account-management/plans/)

[guided-tour]: ../guided-tour/getting-started.md
[project-mgmt]: ../faq/managing-projects.md
