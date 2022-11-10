---
Description: This page describes how access to a remote repository grants you access to its corresponding Semaphore project.
---

# Repository-to-role mappings

On Semaphore, each project has to stem from a code base in a remote repository, like GitHub
or Bitbucket. Semaphore keeps track of all accounts that have access to these remote
repositories (collaborators), and if any of them are associated with a Semaphore account, those
Semaphore users are automatically given access to the associated project
(if they are a member of the organization which owns it).

## Rules for assigning project roles

Depending on user's premissions within the remote repository, a different role
is assigned to them in the Semaphore project.

#### GitHub:

<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>Repository permission level</td>
  <td>Semaphore project role</td>
</tr>
</thead>
<tbody>
<tr>
  <td>
    Admin
  </td>
  <td>
    Maintainer
  </td>
</tr>
<tr>
  <td>
    Push
  </td>
  <td>
    Contributor
  </td>
</tr>
<tr>
  <td>
    Pull
  </td>
  <td>
    Reader
  </td>
</tr>
</tbody>
</table>

#### Bitbucket:

<table style="background-color: rgb(255, 255, 255);">
<thead>
<tr>
  <td>Repository permission level</td>
  <td>Semaphore project role</td>
</tr>
</thead>
<tbody>
<tr>
  <td>
    Admin
  </td>
  <td>
    Maintainer
  </td>
</tr>
<tr>
  <td>
    Write
  </td>
  <td>
    Contributor
  </td>
</tr>
<tr>
  <td>
    Read
  </td>
  <td>
    Reader
  </td>
</tr>
</tbody>
</table>
