Default roles are available to all Semaphore users, regardless of the plan they are on.

If you or your organization need more roles with different permissions, you can
create your own [custom roles](/security/custom-roles).

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
    **Guest**
  </td>
  <td>
    <ul>
      <li>Does not have any permissions within the organization, and can't see any information.</li>
    </ul>
  </td>
  <td>
    This role is intended for users that need access to certain projects, but should not see
    any information regarding the organization.
  </td>
</tr>
<tr>
  <td>
    **Member**
  </td>
  <td>
    <ul>
      <li>Can create new projects.</li>
      <li>Can view existing notifications.</li>
    </ul>
  </td>
  <td>
    This role is intended for developers who are responsible 
    for maintaining project environments as well as contributing.
  </td>
</tr>
<tr>
  <td>
    **Admin**
  </td>
  <td>
    <ul>
      <li>Can do everything that a member can.</li>
      <li>Can view, manage, and modify everything within the organization 
      (people, secrets, pre-flight checks,
      notifications, etc), except general settings and financial information.</li>
    </ul>
  </td>
  <td>
    This role is intended for developers who are managing projects.
    Each of the organization's Admins is also automatically an Admin within every project owned by the organization.
  </td>
</tr>
<tr>
  <td>
    **Owner**
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
    Each of the organization's Owners is also an Admin within every project owned by the organization.
  </td>
</tr>
<tr>
  <td>
    **Accountant**
  </td>
  <td>
    <ul>
      <li>Manages billing</li>
    </ul>
  </td>
  <td>
    This role is intended for an accountant, and doesn't have access to any part of Semaphore except for pages regarding
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
    **Reader**
  </td>
  <td>
    <ul>
      <li>Can view project activity, workflows, and jobs executed within those workflows.</li>
    </ul>
  </td>
  <td>
    This role is intended for someone who is monitoring projects, but isn't a developer and shouldn't
    be able to modify anything, e.g. an engineering project manager.
  </td>
</tr>
<tr>
  <td>
    **Contributor**
  </td>
  <td>
    <ul>
      <li>Can manually run, modify and stop workflows/jobs.</li>
      <li>Can view project-level secrets and organization-wide secrets scoped for a project.</li>
      <li>Can attach to running jobs or debug jobs and projects.</li>
      <li>Can view schedulers, project insights, and repository info.</li>
      <li>Can manually run schedulers.</li>
      <li>Can view, modify and delete artifacts for a project.</li>
    </ul>
  </td>
  <td>
    This role is for developers who are currently working on the project, but aren't responsible for maintaining it
    or setting up/modifying the project's environment.
  </td>
</tr>
<tr>
  <td>
    **Maintainer**
  </td>
  <td>
    <ul>
      <li>Can do everything a contributor can.</li>
      <li>Can view and manage people within a project.</li>
      <li>Can view modify and manage project-level secrets, schedulers and, 
      project-level pre-flight checks.</li>
      <li>Can view and manage project settings.</li>
    </ul>
  </td>
  <td>
    This role is usually for developers who own a project.
  </td>
</tr>
<tr>
  <td>
    **Admin**
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

