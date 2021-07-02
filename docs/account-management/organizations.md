---
description: Organization is an account management framework that lets you grant different permissions to team members and delegate project management under an account.
---

# Organizations

Organizations are Semaphore's account management framework that lets you 
grant different permissions to team members and delegate project management 
under a single account.

## Creating an organization

There are two scenarios in which you can create an organization.

### Creating your first organization

Once you sign up, you will be redirected to the **Create an organization** page. On this page:

1. Enter you full name,
2. Enter your work email,
3. Enter company/organization name which will also create an URL of your organization.

After your organization is created, you’ll need to choose the wanted plan and you are ready to 
[start with your first project][guided-tour]. Happy building!

**Note:** Only one of your organizations can be on a [Free plan](https://docs.semaphoreci.com/account-management/plans/#free-plan) and one on an [Open Source plan](https://docs.semaphoreci.com/account-management/plans/#open-source-plan).

### Creating a new organization when you already have an organization

In order to crate a new organization when you already have an organization, you can:
 
1. Click on the initial of your current organization in the top right corner of the page,
2. At the bottom of the dropdown menu, click on **Change Organization**,
3. Click on **+ Create new**,
4. Choose the URL of the organization and click on **Save & Continue…**,
4. Choose the wanted plan. Please note that you can have one organization on a [Free plan](https://docs.semaphoreci.com/account-management/plans/#free-plan) 
and one organization on an [Open Source plan](https://docs.semaphoreci.com/account-management/plans/#open-source-plan).

Congrats, you are ready to start adding projects to the new organization!

## Adding a user to an organization

In order to add a new user to your organization, you can:

1. Click on the initial of your organization in the top right corner of the page,
2. In the dropdown menu, click on **People**,
2. Enter the GitHub username of the person you want to add in the text box,
3. Click on **Invite**.

All invited users have the [Member permission level](https://docs.semaphoreci.com/account-management/permission-levels/#members) by default. You can promote users to [Admins](https://docs.semaphoreci.com/account-management/permission-levels/#admin) 
by clicking on the **Promote** button next to their username.

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admins) or an [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

**Note:** If you want someone to have access to a project on Semaphore, 
you first need to give this person access to the repository on GitHub, 
and then add them as a member to Semaphore.

## Adding multiple users to an organization

If you want to add more users to your organization at the same time, you can:

1. Click on the initial of your organization in the top right corner of the page,
2. In the dropdown menu, click on **People**,
2. Click on **Not on Semaphore yet**,
3. Select members you'd like to add to Semaphore and enter the emails to which they 
will receive an invite. If you don’t know 
someone’s email, just leave the field empty. We will still add them to your 
organization, just won’t email them,
4. Click on the **Add selected** button.

All invited users have the [Member permission level](https://docs.semaphoreci.com/account-management/permission-levels/#members) by default. You can promote users to [Admins](https://docs.semaphoreci.com/account-management/permission-levels/#admin) 
by clicking on the **Promote** button next to their username.

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admins) or an [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

## Removing a user from an organization

Users can be removed from an organization in the following way:

1. Click on the initial of your organization in the top right corner of the page,
2. In the dropdown menu, click on **People**,
3. Click on the **"X"** button next to the username of the user you want to remove.

Upon removal, their access to all projects in the organization will be revoked. Please 
note that this won't change their permissions on GitHub.

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admins) or an [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

If you want to remove a user who has added projects to your organization, continue reading 
the section below.

## Removing a user who has created projects in your organization

If you need to remove a user who has added projects to your organization, please 
reach out to [support@semaphoreci.com](mailto:support@semaphoreci.com) and we will transfer the ownership 
of those projects to another user in the organization. Please include GitHub 
username of the user you'd like to remove and GitHub username of the new project 
owner in the email.

**Note:** The new project owner needs to ensure that the following conditions are met before 
the project ownership transfer:

1. New project owner needs to have Admin permission level for the repository on GitHub,
2. If you plan to build private projects, the new owner needs to grant access 
for Semaphore to all repositories. They can do that that under [Personal Settings -> GitHub repository access](https://me.semaphoreci.com/account).
3. If you plan to build only public projects, the new owner needs to grant access for 
Semaphore to public repositories. They can do that that under [Personal Settings -> GitHub repository access](https://me.semaphoreci.com/account). 

## Changing the name and the URL of an organization

If you'd like to change the name of your organization:

1. Click on the initial of your organization in the top right corner of the page,
2. In the dropdown menu, click on **Settings**,
3. Enter the new name in the **Name** text box,
3. Click on **Save Changes** button.

Please note that changing the name doesn't change the organization URL. That has 
to be done separately.

In order to change the URL of your organization:

1. Click on the initial of your organization in the top right corner of the page,
2. In the dropdown menu, click on **Settings**,
3. Click on **Change URL...**,
4. Enter the new URL in the text box and
5. Click on **Change URL** button.

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admin) or an [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

## Transferring ownership of an organization

In order to transfer the ownership to a new user, the following conditions need
to be met:

- New owner needs to be a member of the organization;
- New owner needs to log in to Semaphore 2.0 at least once;
- Current owner needs to send a confirmation to [support@semaphoreci.com](mailto:support@semaphoreci.com)
  from a primary email address related to the GitHub account you use to log in
  to Semaphore 2.0. In this email, please include name of the organization and
  GitHub username of the new owner.

After that, we’ll change the ownership on your behalf.

**Note:** Transferring ownership of an organization doesn't automatically transfer 
the projects you own in that organization. If you'd like us to transfer ownership of 
the projects, too, please include that in your message.

## Deleting an organization 

Before you delete the organization, you need to [delete all projects][project-mgmt] in it. 
**Note that once you delete an organization, its content cannot be restored.** 
Only the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can delete the organization.

In order to delete the organization, you should:

1. Click on the initial of your organization in the top right corner of the page,
2. In the dropdown menu, click on **Settings**,
3. Click on **Delete Organization...** at the bottom of the page,
4. Type in "delete" to confirm,
5. Click on **Delete Organization** button.

## Deleting an account

In order to delete your account, please send an email to
[support@semaphoreci.com](mailto:support@semaphoreci.com) from a primary email
address connected to the GitHub account you use to log in to Semaphore 2.0.
In this email, please include your GitHub username.

## See also

- [Permission levels](https://docs.semaphoreci.com/account-management/permission-levels/)
- [Billing](https://docs.semaphoreci.com/account-management/billing/)
- [Plans](https://docs.semaphoreci.com/account-management/plans/)

[guided-tour]: ../guided-tour/getting-started.md
[project-mgmt]: ../faq/managing-projects.md
