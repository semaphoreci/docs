Semaphore 2.0 is "mirroring" your GitHub organization and permissions access to the projects is in sync with your GitHub permissions.

## Owners
On Semaphore 2.0, only the creator of the organization can be its Owner. There cannot be multiple owners, but it is possible to transfer the ownership if it's needed. In order to do that, please contact us at [support@semaphoreci.com](mailto:support@semaphoreci.com).

Projects:

The Owner can:
- See all projects
- Add projects to Semaphore 2.0, if they have admin access for a particular repository on GitHub
- Delete their own projects
- Delete other members’ projects, if they have admin access for a particular repository on GitHub

The Owner has the access to the Owner's area, which includes:
1. _People_

- **Add new members to the organization**. Members can be invited by their GitHub username. New members will be able to enter the organization the first time they sign in with their GitHub accounts. Note: If you want someone to have access to a project on Semaphore you need to add this person to project on Github, and then add him as a member to a Semaphore on `ORG.semaphoreci.com/people` page.
- **Remove members from the organization**. Upon removal, their access to all projects in this organization will be revoked. Please note that this won't change their permissions on GitHub.

2. _Billing_

Owner can see the billing section and perform changes, such as enter credit card information, see the current spending, edit invoice related information etc. For more info on billing, here. (link to billing docs)

3. _Settings_

Owner can change the name of the organization. However, organization's ID (unique URL) can be set up only upon the creation of org, and cannot be changed later.

## Members

Members cannot see the Owner’s area.

Projects:
- Can see projects they can see on GitHub
- Add projects to Semaphore 2.0, if they have admin access for a particular repository on GitHub
- Delete their own projects
