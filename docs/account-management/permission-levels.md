---
description: Semaphore 2.0 organizations can have an unlimited number of users. Users in the organization have different permissions based on their role.
---

# Permission levels

Semaphore organizations can have an unlimited number of users. Users in the organization
have different permissions based on their role.

## Owner

The creator of an organization is its owner. There cannot be multiple owners, but
it is possible to [transfer the ownership](https://docs.semaphoreci.com/account-management/organizations/#transferring-ownership-of-an-organization).

The Owner can:

- See all projects;
- Add projects to the organization if they have Admin access to the repository on GitHub;
- Delete projects if they have Admin access to the repository on Github;
- Manage people;
- Manage billing;
- Transfer ownership of an organization;
- Delete an organization.

## Admins

Users with Admin permission level can:

- See all projects;
- Add projects to the organization if they have Admin access to the 
repository on GitHub;
- Delete projects if they have Admin access to the repository on Github;
- Manage people;
- Manage billing.

## Members

Users with Member permission level can:

- See all projects;
- Add projects to the organization if they have Admin access to the 
repository on GitHub;
- Delete projects if they have Admin access to the repository on Github;

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

## See also

- [Organizations](https://docs.semaphoreci.com/account-management/organizations/)
- [Billing](https://docs.semaphoreci.com/account-management/billing/)
- [Plans](https://docs.semaphoreci.com/account-management/plans/)
