---
Description: This page explains the RBAC model that Semaphore 2.0 uses for user authorization. Here, you will find information about existing permissions, roles, and role management.
---

# Rbac model

Semaphore 2.0 uses a role-based access control model for user authorization. This page will document all existing permissions, roles,
and how to manage them.

## Roles on Semaphore

All of the roles (and permissions) within the Semaphore are devided into <i>organization-level</i> and <i>project-level</i>.
<i>Organization-level</i> roles define access to functionalities and assets that apply to the entire organization (Audit Logs, Billing, 
Organization Members, Projects, etc.).
On the other hand, <i>project-level</i> roles are assigned within a single project, and grant access to information scoped only to that one
project (Schedulers, Insights, Workflows, Artifacts). To get any project-level role, you have to be a part of the organization
which owns that project (you must have a role within the organization).


### Organization roles
<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>
    Role name
  </td>
  <td>
    Permissions
  </td>
  <td>
    Notes
  </td>
</tr>
</thead>
<tbody>
<tr>
  <td>
    <b>Guest</b>
  </td>
  <td>
    <ul>
      <li>Does not have any permissions within the organization, and can't see any information.</li>
    </ul>
  </td>
  <td>
    This role is intended for users that need access to some projects, but should not see
    any information regarding the organization.
  </td>
</tr>
<tr>
  <td>
    <b>Member</b>
  </td>
  <td>
    <ul>
      <li>Can create new projects.</li>
      <li>Can view existing notifications.</li>
    </ul>
  </td>
  <td>
  </td>
</tr>
<tr>
  <td>
    <b>Admin</b>
  </td>
  <td>
    <ul>
      <li>Can do everything a member can.</li>
      <li>Can view, manage, and modify everything within the organization 
      (people, secrets, pre-flight checks,
      notifications etc), except general settings and financial information.</li>
    </ul>
  </td>
  <td>
    Each of organization's Admins is also Admin within every project owned by the given organizationi automatically.
  </td>
</tr>
<tr>
  <td>
    <b>Owner</b>
  </td>
  <td>
    <ul>
      <li>Can do everything within the organization, including changing general
      settings and deleting it.</li>
    </ul>
  </td>
  <td>
    By default, this role is assigned to the user that creates the organization.
    <br/>
    Each of organization's Owners is also Admin within every project owned by the given organization.
  </td>
</tr>
<tr>
  <td>
    <b>Accountant</b>
  </td>
  <td>
    <ul>
      <li>Manages billing</li>
    </ul>
  </td>
  <td>
    This role cant access any part of the Semaphore except for pages regarding
    spending and financial information.
  </td>
</tr>
</tbody>
</table>

### Project roles
<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>
    Role name
  </td>
  <td>
    Permissions
  </td>
  <td>
    Notes
  </td>
</tr>
</thead>
<tbody>
<tr>
  <td>
    <b>Reader</b>
  </td>
  <td>
    <ul>
      <li>Can view project activity, workflows, and jobs executed within those workflows.</li>
    </ul>
  </td>
  <td>
    Intended for someone who should monitor what is being done, but isn't a developer and shouldn't
    modify anything. Perhaps an Engineering Project Manager.
  </td>
</tr>
<tr>
  <td>
    <b>Contributor</b>
  </td>
  <td>
    <ul>
      <li>Can manually run, modify and stop workflows/jobs.</li>
      <li>Can view project-level secrets and organization-wide secrets scoped for the given project.</li>
      <li>Can attach to running jobs or debug jobs and projects.</li>
      <li>Can view schedulers, project insights, and repository info.</li>
      <li>Can manually run schedulers.</li>
      <li>Can view, modify and delete artifacts for that project.</li>
    </ul>
  </td>
  <td>
    For developers who are currently working on the project, but aren't responsible for maintaining it
    and setting up/modifying the environment in which the project exists.
  </td>
</tr>
<tr>
  <td>
    <b>Maintainer</b>
  </td>
  <td>
    <ul>
      <li>Can do everything a contributor can.</li>
      <li>Can view and manage people within the project.</li>
      <li>Can view modify and manage project-level secrets, schedulers and 
      project level pre-flight checks.</li>
      <li>Can view and manage project settings.</li>
    </ul>
  </td>
  <td>
    Usually developers who own the project.
  </td>
</tr>
<tr>
  <td>
    <b>Admin</b>
  </td>
  <td>
    <ul>
      <li>Can do everything within the project, including deleting it.</li>
    </ul>
  </td>
  <td>
    By default, this role is assigned to the user that created the project, and
    this user is a primary repository token holder.
  </td>
</tr>
</tbody>
</table>

## Role Management

Users can get roles in a few different ways (from different sources):
<ul>
<li>Each user can get one organization role assigned to them directly (from the organization's Admin or Owner).</li>
<li>User can get an organization-level role from membership within one (or more) organization groups.</li>
</ul>

Within each project user can be assigned a role:
<ul>
<li>Directly form projects Admin or Maintainer.</li>
<li>From membership within one (or more) organization groups.</li>
<li>From access rights within [project's repository](#repository-to-role-mappings) (GitHub or BitBucket).</li>
<li>From the role that user has [within the organization](#organization-role-to-project-role-mappings).</li>
</ul>

TODO Picture from UI for assigning roles/viewing role assignments

### Repository to role mappings

If an organization member (someone who has any role within the organization) also has access to the projects
remote repository on GitHub or BitBucket, that member will be assigned a role within the project automatically.

<b>Pull</b> access within the repository -> Project <b>Reader</b> role
<br/>
<b>Push</b> access within the repository -> Project <b>Contributor</b> role
<br/>
<b>Admin</b> access within the repository -> Project <b>Maintainer</b> role
<br/>

### Organization role to project role mappings
Having specific roles within the organization can grant you a role within all of the projects automatically.

Organization <b>Owner</b> -> Project <b>Admin</b>
<br/>
Organization <b>Admin</b> -> Project <b>Admin</b>
<br/>

# Custom roles

If your organization has a need for more roles with permissions defined with higher granularity, you can define
custom roles that will be visible only within your organization. For each of those roles you can define permissions,
if the role is organizational you can define whether it will map to some project-level role, and if the role is
project scoped, you can also define if access to the project's repository will mean automatic assignment of the role.

TODO Picutre from UI for creating/managing roles

!!! warning "Custom roles are only available on our [enterprise plan](https://semaphoreci.com/pricing)."

Do you need Custom roles in order to use Semaphore? Contact us via this [form][form], and we’ll get back to you shortly.
[form]: https://semaphoreci.com/contact
