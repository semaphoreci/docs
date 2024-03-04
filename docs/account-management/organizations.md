---
Description: On Semaphore, an "organization" is an account management framework that lets you grant different permissions to team members and delegate project management within your account.
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

### Creating a new organization when you already have an organization

In order to crate a new organization when you already have an organization, you can:
 
1. Click on the initials of your current organization in the top right corner of the page
2. Click on **Change Organization** at the bottom of the dropdown menu
3. Click on **+ Create new**
4. Choose the URL for the organization and click on **Save & Continue…**
4. Choose a plan.

Congratulations, you are ready to start adding projects to your new organization!

## Adding a user to an organization

Note that the following conditions apply when adding users: 

- All added users have the [Member permission level](https://docs.semaphoreci.com/account-management/permission-levels/#members) by default. You can promote users to [Admins](https://docs.semaphoreci.com/account-management/permission-levels/#admins) by clicking on the Promote button next to their username.
- Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admins) or the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform this action.

In order to add a new user to your organization, you can:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **People** in the dropdown menu
3. Click on **Add People** and choose the best option from the ones listed below:

### Adding a user to an organization with their GitHub username

This option will allow you to add GitHub users to your organization, one user at a time, without sending an email notification. 

1. Enter the person’s GitHub username inside the first field.
2. And click on **Invite**. Make sure to refresh the page to see the applied changes. 

**Note:** If you want someone to have access to a project on Semaphore, you first need to give this person access to the repository, and then add them as a member on Semaphore.

### Adding a user to an organization from the repository’s collaborator list

This option is great for adding multiple users to your organization all at once, and it also gives you the choice to send respective invitation emails. Users will need to be added on GitHub first.

1. Select the user(s) from your repository’s collaborator list. 
2. As an optional step, if you want the new users to receive an invitation email, you can enter their email addresses next to their respective usernames.
3. And click on **Add selected**. Make sure to refresh the page to see the applied changes. 

**Note:** We recommend using the **Refresh** button after adding a new collaborator to your GitHub or Bitbucket repository. Please not that it can take some time for your repository to sync with your Semaphore account. 

## Removing a user from an organization

Users can be removed from an organization in the following way:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **People** in the dropdown menu
3. Click on the **"X"** button next to the username of the user you want to remove

Upon removal, access to all projects in the organization will be revoked.

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admins) or the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform this action.

If you want to remove a user who has added projects to your organization, continue reading the section below.

## Removing a user who has created projects in your organization
To remove a user that has created projects in your organization, you must first have the user in question transfer ownership of those projects to a different user in the organization. In order to transfer project ownership to a different user, the following 
conditions need to be met:

1. The new project owner needs to have Admin permission level for the repository
2. If you plan to build private projects, the new owner needs to grant Semaphore access to all repositories -- they can do that that under [Personal Settings -> Repository access](https://me.semaphoreci.com/account)
3. If you plan to build only public projects, the new owner needs to grant Semaphore access to public repositories -- they can do that that under [Personal Settings -> Repository access](https://me.semaphoreci.com/account)

After that, go to _Project Settings -> General_ in the _Project Owner_ section, find the user you want to become the new owner, and click _Change_.

If you encounter any issues, please reach out to our support team
and include the name of the project and the GitHub or Bitbucket username of the new owner in your message.

**Note:** After project ownership has been transferred, you need to push a new commit. 
Re-running old builds no longer works if ownership of a project has changed.

## Changing the name and URL of an organization

If you'd like to change the name of your organization, follow these steps:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **Settings** in the dropdown menu
3. Enter a new name in the **Name** text box
3. Click on the **Save Changes** button

Please note that changing the name doesn't change the organization's URL. This has 
to be done separately.

In order to change the URL of your organization, follow these steps:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **Settings** in the dropdown menu
3. Click on **Change URL...**
4. Enter a new URL in the text box
5. Click on the **Change URL** button

Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admin) or the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

## Managing ownership of an organization

To update the ownership of an organization, the following conditions need to be met:

- The new owner needs to be a member of the organization.
- The new owner needs to have logged into Semaphore at least once.
- Only an owner can assign the owner role to a user (add a new owner).

### How to add a new Owner

In order to promote a member of an organization to an Owner, please follow the steps below:

1. Click on the initials of your current organization in the top right corner of the page, and select “People”. You will see the full list of members of your organization, each with a distinctive badge according to their current role.
2. Click on the “Change Role” button at the user's right, and select “Owner”.
3. After the change, you will get a notification saying “Role successfully assigned”. Please note that it might take several minutes for the update to be completed.

**Note:** Updating the ownership of an organization doesn't automatically transfer the project ownership. If you'd like to transfer the ownership of a project, please refer to the "[How to transfer project ownership](https://docs.semaphoreci.com/faq/managing-projects/#how-to-transfer-project-ownership)" documentation.

### How to remove an Owner

If you need to demote/remove an owner from the organization, any user with the Owner permission level needs to send an email to support@semaphoreci.com from the primary email address associated with their GitHub or Bitbucket account used to log into Semaphore.


## Deleting an organization 

Before you delete an organization, you need to [delete all projects][project-mgmt] in it. 
**Once you delete an organization, its content cannot be restored.** 
Only the [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of an organization can delete it.

In order to delete an organization, follow these steps:

1. Click on the initials of your organization in the top right corner of the page
2. Click on **Settings** in the dropdown menu
3. Click on **Delete Organization...** at the bottom of the page
4. Type "delete" to confirm
5. Click on the **Delete Organization** button

## Deleting an account

In order to delete your account, please send an email to
[support@semaphoreci.com](mailto:support@semaphoreci.com) from the primary email
address associated with the account used to log in to Semaphore 2.0.
In this email, please include your GitHub or Bitbucket username.

## See also

- [Permission levels](https://docs.semaphoreci.com/account-management/permission-levels/)
- [Billing FAQ](https://docs.semaphoreci.com/account-management/billing-faq/)

[guided-tour]: ../guided-tour/getting-started.md
[project-mgmt]: ../faq/managing-projects.md
