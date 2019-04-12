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

### Owner - Owner's area

Owner also has access to the Owner's area, which includes:

#### Owner - People management

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

#### Owner - Billing management

Owner can see the billing section and perform changes, such as enter credit
card information, and see the current spending.

#### Owner - Organization settings

Owner can change the name of the organization. Note that this will not change
the ID and unique URL of the organization.

## Admin

Admins have the same rights as the owner, and there can be multiple admins.

### Admin project permissions

Admin can:

- See all projects;
- Add projects, if they have admin access to the repository on GitHub;
- Delete projects if they have admin access to the repository on Github;
- Manage people;
- Manage billing;

### Admin - Owner's area

Admin also has access to the Owner's area, which includes:

#### Admin - People management

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

#### Admin - Billing management

Admin can see the billing section and perform changes, such as enter credit
card information, and see the current spending.

#### Admin - Organization settings

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

## Deleting organization and account

In order to delete your account and/or organization, please send an email to
[support@semaphoreci.com](mailto:support@semaphoreci.com) from a primary email
address connected to the GitHub account you use to log in to Semaphore 2.0.
In this email, include your GitHub username and the name of the organization
you’d like to delete.
