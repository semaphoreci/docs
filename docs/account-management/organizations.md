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
[start with your first project](https://docs.semaphoreci.com/guided-tour/creating-your-first-project/). Happy building!

**Note:** Only one of your organizations can be on a free plan and one on an open source plan.

### Creating a new organization when you already have an organization

In order to crate a new organization when you already have an organization, you can:
 
1. Click on the name of your current organization in the top left corner of the page,
2. At the bottom of the dropdown menu, click on **New…**,
3. Choose the URL of the organization and click on **Save & Continue…**,
4. Choose the wanted plan. Please note that you can have one organization on a free plan 
and one organization on an open source plan.

Congrats, you are ready to start [adding projects](https://docs.semaphoreci.com/guided-tour/creating-your-first-project/) to the new organization!

## Adding a user to an organization

If you want to add a new user to your organization, you can:

1. Go to the **People** page of your organization,
2. Enter the GitHub username of the person you want to add in the text box,
3. Click on **Invite**.

**Note:** If you don’t immediately see the new user on the People page, please 
click on the **Refresh list** button at the bottom of the page.

All invited users have the [Member permission level](https://docs.semaphoreci.com/account-management/permission-levels/#members) by default. You can promote users to [Admins](https://docs.semaphoreci.com/account-management/permission-levels/#admin) 
by clicking on the **Promote** button next to their username.

## Removing a user from an organization

Users can be removed from an organization in the following way:

1. Go to the **People** page of your organization,
2. Click on the **Remove** button next to the username of the user you want to remove.

If you want to remove a user who has added projects to your organization, continue reading 
the section below.

## Removing a user who has created projects in your organization

If you need to remove a user who has added projects to your organization, please 
reach out to [support@semaphoreci.com](mailto:support@semaphoreci.com) and we will transfer the ownership 
of those projects to another user in the organization. Please include GitHub 
username of the user you'd like to remove and GitHub username of the new project 
owner in the email.

## Changing the name and the URL of an organization

If you'd like to change the name of your organization:

1. Go to **General Settings** in **Owner's area**,
2. Enter the new name in the **Name of the Organization** text box,
3. Click on **Save Changes** button.

Please note that changing the name doesn't change the organization URL. That has 
to be done separately.

In order to change the URL of your organization:

1. Go to **General Settings** in **Owner's area**,
2. Click on **Change URL...**,
3. Enter the new URL in the text box and
4. Click on **Change URL** button.

**Note:** Only an [Admin](https://docs.semaphoreci.com/account-management/permission-levels/#admin) or an [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization can perform these actions.

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

## Deleting an organization 

Before you delete the organization, you need to [delete all projects](https://docs.semaphoreci.com/article/63-your-first-project#deleting-a-project) in it. 
Note that once you delete an organization, its content cannot be restored. 
Only the onwer of the organization can delete the organization.

In order to delete the organization, you should:

1. Go to **General Settings** at the bottom of the sidebar,
2. Click on **Delete organization-name** at the bottom of the page,
3. Type in the organization name to confirm and
4. Click on **Delete organization-name organization** button.

## Deleting an account

In order to delete your account, please send an email to
[support@semaphoreci.com](mailto:support@semaphoreci.com) from a primary email
address connected to the GitHub account you use to log in to Semaphore 2.0.
In this email, please include your GitHub username.
