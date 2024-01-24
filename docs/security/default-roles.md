Default roles are available to all Semaphore users, regardless of the plan they are on.

If you or your organization need more roles with different permissions, there is an option
to create your own [custom roles](/security/custom-roles).

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
    **Member**
  </td>
  <td>
    <ul>
      <li>Can create new projects.</li>
      <li>Can view existing notifications and settings.</li>
    </ul>
  </td>
  <td>
  </td>
</tr>
<tr>
  <td>
    **Admin**
  </td>
  <td>
    <ul>
      <li>Can do everything a member can.</li>
      <li>Can view, manage, and modify everything within the organization 
      (people, secrets, pre-flight checks,
      notifications, etc), except general settings and financial information.</li>
    </ul>
  </td>
  <td>
    Each of the organization's Admins is also Admin within every project owned by the given organization automatically.
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
    Each of the organization's Owners is also Admin within every project owned by the given organization.
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
    Intended for someone who should monitor what is being done, but isn't a developer and shouldn't
    modify anything. Perhaps an Engineering Project Manager.
  </td>
</tr>
<tr>
  <td>
    **Contributor**
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

