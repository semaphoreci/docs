# User Management and Permissions

Semaphore organizations can have unlimited members. Members have different
permissions based on their role.

## Owner

The creator of organization is its owner. There cannot be multiple owners, but
it is possible to [transfer the ownership](https://docs.semaphoreci.com/article/106-user-management-and-permissions#transferring-ownership-of-an-organization).

### Owner project permissions

Owner can:

- See all projects;
- Add projects, if they have admin access to the repository on GitHub;
- Delete projects if they have admin access to the repository on Github;
- Manage people;
- Manage billing;

### Owner's area access

Owner also has access to the Owner's area, which includes:

#### Owner people management permissions

Owners can:

- **Add new members to organization**. Members can be invited by their GitHub
  username. New members will be able to enter the organization the first time
  they sign in with their GitHub accounts. _Note_: If you want someone to have
  access to a project on Semaphore, you first need to give this person access
  to the repository on GitHub, and then add them as a member to Semaphore on
  `ORG.semaphoreci.com/people` page.

- **Remove members from organization**. Upon removal, their access to all
  projects in the organization will be revoked. Please note that this won't
  change their permissions on GitHub.

- **Promote members to admins**.

#### Owner billing management permissions

Owner can see the billing section and perform changes, such as enter credit
card information, and see the current spending.

#### Owner organization settings permissions

Owner can [change the name of the organization and its URL](https://docs.semaphoreci.com/article/106-user-management-and-permissions#changing-the-name-and-the-url-of-an-organization). Note that changing
the name doesn't change the URL so these two actions have to be performed 
separately.

## Admin

Admins have the same rights as the owner, and there can be multiple admins.

### Admin project permissions

Admin can:

- See all projects;
- Add projects, if they have admin access to the repository on GitHub;
- Delete projects if they have admin access to the repository on Github;
- Manage people;
- Manage billing;

### Admin Owner's area access

Admin also has access to the Owner's area, which includes:

#### Admin people management permissions

Admin can:

- **Add new members to organization**. Members can be invited by their GitHub
  username. New members will be able to enter the organization the first time
  they sign in with their GitHub accounts. _Note_: If you want someone to have
  access to a project on Semaphore, you first need to give this person access
  to the repository on GitHub, and then add them as a member to Semaphore on
  `ORG.semaphoreci.com/people` page.

- **Remove members from organization**. Upon removal, their access to all
  projects in the organization will be revoked. Please note that this won't
  change their permissions on GitHub.

- **Promote members to admins**.

#### Admin billing management permissions

Admin can see the billing section and perform changes, such as enter credit
card information, and see the current spending.

#### Admin organization settings permissions

Owner can change the name of the organization. Note that this will not change
the ID and unique URL of the organization.

## Members

Members can't access the Owner’s area.

### Member project permissions

Members can:

- See all projects they can see on GitHub;
- Add projects to Semaphore, if they have admin access to a particular
  repository on GitHub;
- Delete the projects they created.

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

## Removing a user who has created projects in your organization

If you need to remove a user who has added projects to your organization, please 
reach out to [support@semaphoreci.com](mailto:support@semaphoreci.com) and we will transfer the ownership 
of those projects to another member of the organization. Please include GitHub 
username of the user you'd like to remove and GitHub username of the new project 
owner in the email.

## Changing the name and the URL of an organization

If you'd like to change the name of your organization:

1. Go to **General Settings** in **Owner's area**,
2. Enter the new name in the **Name of the Organization** section and
3. Click on **Save Changes** button.

Please note that changing the name doesn't change the organization URL. That has 
to be done separately.

In order to change the URL of your organization:

1. Go to **General Settings** in **Owner's area**,
2. At the bottom of the page click on **Change URL...**
3. Enter the new URL and
4. Click on **Change URL** button.

**Note:** Only an Admin or an Owner of the organization can perform these actions.

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
