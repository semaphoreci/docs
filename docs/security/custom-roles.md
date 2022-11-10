---
Description: Custom roles for the Semaphore platform.
---

# Custom Roles

If your organization needs more roles where permissions can be assigned with 
higher granularity, you can define custom roles.

### Creating a new role

When defining a custom role, you need to give it a unique name (that is different from the default roles)
and select which [permissions](/security/permissions/) 
its users will have. Role inheritance is also allowed, so you can create a new role, e.g.
**Sys Admin**, that would have all the same permissions as **Developer**,
plus access to self-hosted agents (`organization.self_hosted.create`). Permissions
for this hypothetical Sys Admin role are determined "dynamically", so if you later modify the Developer role
and add/remove permissions, the Sys Admin role will also reflect those
changes.

**TODO** Picture of UI for creating new role, when the ui gets made

### Organization role to project role mapping

If there is a role within the organization that needs to have access to all
projects, you can define an "*org-role to project-role mapping*" for it. If you want your
Sys Admins to have Admin level access to all projects, you can dictate that the Sys Admin role
maps to the project Admin role.

!!! warning "Note"
    Custom roles are currently only available on our [enterprise plan](pricing).

!!! info "Default Roles"
    As an organization that has Custom Roles enabled, you will still have access to the default roles as well.

Do you need Custom roles in order to use Semaphore? Contact us via this [form](/contact)

