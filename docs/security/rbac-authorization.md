---
Description: This page explains the RBAC model that Semaphore 2.0 uses for user authorization. Here you will find information about existing permissions, roles, and role management.
---

# Rbac model

Semaphore 2.0 uses a **Role-Based Access Control** model for user authorization.
This page gives a brief overview of permissions and roles, and how to manage them.

## Roles on Semaphore

All of the roles (and permissions) within Semaphore are divided into __organization-level__ and __project-level__.<br />
Organization-level roles define access to functionalities and assets that apply to the entire organization (Audit Logs, Billing, 
Organization Members, Projects, etc.).<br/>
Project-level roles are assigned within a single project, and grant access
to information scoped only to that project (Schedulers, Insights, Workflows, Artifacts).
To be assigned a project-level role, you have to be a part of the organization
which owns the project (i.e. you must have a role within the organization).

There is a set of pre-defined [default roles](/security/default-roles) that are available to all users, but you may also define your own [custom roles](/security/custom-roles).

## Role Management

#### Organization roles

To be considered a part of the organization, the user must have a role within that organization.
Each user can have up to one role assigned to them directly. Additionally,
users can have additional roles within the organization assigned to them indirectly from each of the groups
they are a part of.<br/>
If a user has more than one role, all permissions that those roles grant combine to
make the full set of permissions that the user has within their organization.

#### Organization role to project role mappings

Some organization roles can automatically grant you a project-level role in each project
that the organization owns. For example, the Organization Admin role makes you an Admin for all
of the organization's projects. To see which organization roles grant you project-level
access, see the "*Notes*" column of [this table](/security/default-roles/#organization-roles).

#### Project roles

Project role assignment works similarly to organization role assignment, but there
are two additional ways that a user can get a role within a project.<br/>
If a user has access to the project's remote repository, this automatically grants them
a role within the corresponding Semaphore project according to these ["*repo-to-role mapping*"
rules](/security/repository-to-role-mappings/).<br/>
Furthermore, each organization-level role can grant access to the organization's projects, as mentioned
[above](organization-role-to-project-role-mappings). Finally, a user can be assigned a role
within the project directly (from the project's Admin or Maintainer), and can also get a role via
membership in a group which was assigned a role within the given project.

**Example**:<br/> *Owen* has access to a project's GitHub repository, which automatically makes him
a Contributor to that project on Semaphore. He is the organization's Admin, which makes him Admin for
all of the organization's projects, and someone also directly assigned him the role of Maintainer.
So, *Owen* has three roles within this project: Contributor, Admin, and Maintainer; and,
as with organization roles, the sum of permissions that these roles grant make up the total set
of permission that *Owen* has within this project. 

#### Retracting roles

Only roles that have been assigned to a user directly can be retracted. If the user has a role
via membership in a group, they either have to be removed from the group or
the role has to be retracted from the entire group.

If a project role was assigned via access to a remote repository, the only way to remove that
role is to remove the user from the repository, and if it was assigned through an organization-level
role, that role has to be retracted.

