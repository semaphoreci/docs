---
Description: This page explains the RBAC model that Semaphore 2.0 uses for user authorization. Here, you will find information about existing permissions, roles, and role management.
---

# Rbac model

Semaphore 2.0 uses a **Role-Based Access Control** model for user authorization.
This page will give a brief overview of permissions, roles, and how to manage them.

## Roles on Semaphore

All of the roles (and permissions) within the Semaphore are divided into __organization-level__ and __project-level__.<br />
Organization-level roles define access to functionalities and assets that apply to the entire organization (Audit Logs, Billing, 
Organization Members, Projects, etc.).<br/>
On the other hand, project-level roles are assigned within a single project, and grant access
to information scoped only to that one project (Schedulers, Insights, Workflows, Artifacts).
To get any project-level role, you have to be a part of the organization
which owns that project (you must have a role within the organization).

There is a set of pre-defined [default roles](/security/default-roles) that are available to all users.

## Role Management

#### Organization roles

To be considered a part of the organization, the user must have a role within that organization.
Each user can have up to one role assigned to them directly. Other than that
users can have one role within the organization assigned to them indirectly through each of the groups
they are a part of.<br/>
If the user has more than one role, all permissions those roles grant are combined to
make a full set of permissions the user has within the given organization.

#### Organization role to project role mappings

Some organization roles can grant you automatically a project-level role on each project
that the organization owns. For example, the Organization Admin role makes you an Admin on all
of the organization's projects. To see which organization roles grant you project-level
access, see the "*Notes*" column of [this table](/security/default-roles/#organization-roles).

#### Project roles

By default, users get a project-level role assigned to them based on the access level they have
within the repository from which the project was created. If the user has access to the project's
remote repository, that automatically grants them a role within the Semaphore project according
to these ["*repo-to-role mapping*" rules](/security/repository-to-role-mappings/).<br/>
Next, each organization-level role can grant access to the organization's projects, as mentioned
[above](organization-role-to-project-role-mappings).

Finally, the user can be assigned a role within the project directly, through the UI (from project's Admin).
This last user management option is available only to organizations on the [__ScaleUp__](https://docs.semaphoreci.com/account-management/scaleup-plan/#scaleup-plan) plan. If you need
this feature, please contact our support team.

**Example**:<br/> *Owen* has access to the project's GitHub repository, which automatically makes him
a Contributor to that project on Semaphore. He is the organization's Admin, which makes him Admin on
all of the organization's projects, and someone assigned him directly the role of Reader.
So, *Owen* has three roles within this project: Contributor, Admin, and Reader, and
same as with organization roles, the sum of permissions that those roles grant make a total set
of permission *Owen* has within this project. 

#### Retracting roles

Only roles that were assigned to a user directly can be retracted. If the user has a role
through a membership in some group, he either has to be removed from the group, or
the role has to be retracted from the entire group.

If a project role was assigned through access to the remote repository, the only way to remove that
role is to remove the user from the repository, and if it was assigned through an organization-level
role, that role has to be retracted.

