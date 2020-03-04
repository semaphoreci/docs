# Permission levels

Semaphore organizations can have unlimited members. Members have different
permissions based on their role.

## Owner

The creator of organization is its owner. There cannot be multiple owners, but
it is possible to [transfer the ownership](https://docs.semaphoreci.com/account-management/organizations/#transferring-ownership-of-an-organization).

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

Owner can [change the name of the organization and its URL](https://docs.semaphoreci.com/account-management/organizations/#changing-the-name-and-the-url-of-an-organization). Note that changing
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

## Changing the permission level

Every user in the organization can be promoted from the [Member permission 
level](https://docs.semaphoreci.com/account-management/permission-levels/#members) to the [Admin permission level](https://docs.semaphoreci.com/account-management/permission-levels/#admin). This can be done by following these steps:

1. Go to the **People** page of your organization,
2. Click on the **Promote** button next to the username of the user you’d like to promote.

The same steps should be followed if you want to change the user's permission level from 
Admin to Member. In that case, click on the **Demote** button next to the username.

Only an Admin or an Owner of the organization can perform these steps.

**Note:** There can only be one [Owner](https://docs.semaphoreci.com/account-management/permission-levels/#owner) of the organization. If you’d like to change the 
ownership, please visit [this page](https://docs.semaphoreci.com/account-management/organizations/#transferring-ownership-of-an-organization).
