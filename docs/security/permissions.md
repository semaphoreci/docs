---
Description: Page containing a list of all permissions within the Semaphore.
---

# Permissions

This page lists all permissions within the Semaphore system. It will be 
of use when creating custom roles and defining what they can do. 

As with the roles, permissions are also divided into **organization-level**
and **project-level**.

!!! info "Note"
    Some permissions are not yet part of Semaphore but will be introduced in the near future. Those are marked with **✕**


## Organization permissions

<br />
#### Organization secrets [↗](/essentials/using-secrets/)

`organization.secrets.view`<br />
<span style="font-size:smaller;">Following permissions are related to
[secrets management](/essentials/using-secrets/#creating-and-managing-secrets).</span><br />
`organization.secrets.create`<br />
`organization.secrets.modify`<br />
`organization.secrets.delete`<br />

#### Audit logs [↗](/security/audit-logs/)

`organization.audit_logs.view`<br />
`organization.audit_logs.export` [↗](/security/audit-logs-exporting/)<br />
`organization.audit_logs.streaming.view` [↗](/security/audit-logs-exporting/#streaming)<br />
`organization.audit_logs.streaming.manage`<br />

#### Self-hosted agents [↗](/ci-cd-environment/self-hosted-agents-overview/)

`organization.self_hosted_agents.view`<br />
`organization.self_hosted_agents.create`<br />
`organization.self_hosted_agents.reset_token`<br />
`organization.self_hosted_agents.disable`<br />
`organization.self_hosted_agents.delete`<br />

#### General settings

`organization.general_settings.view`<br />
`organization.general_settings.modify`<br />

#### Organizational notifications [↗](/essentials/webhook-notifications/)

`organization.notifications.view`<br />
`organization.notifications.create`<br />
`organization.notifications.modify`<br />
`organization.notifications.delete`<br />

#### Organizational pre-flight checks [↗](/essentials/configuring-pre-flight-checks/)

`organization.pre_flight_checks.view`<br />
`organization.pre_flight_checks.modify`<br />

#### Billing

`organization.plans_and_billing.view`<br />
`organization.plans_and_billing.modify`<br />

#### Dashboards [↗](/essentials/deployment-dashboards/)

<span style="font-size:smaller;">These permissions don't control whether or not you can see deployment pipelines
defined by the dashboards, but rather if you can access and modify the definition of those
dashboards using `sem` cli tool like it is shown [here](/essentials/deployment-dashboards/#creating-a-dashboard).</span><br />
`organization.dashboards.view`<br />
`organization.dashboards.create`<br />
`organization.dashboards.modify`<br />
`organization.dashboards.delete`<br />

#### Managing people

`organization.people.view`<br />
`organization.people.invite`<br />
`organization.people.remove`<br />
`organization.people.change_role`<br />

#### Role management **✕**

`organization.roles.view`<br />
`organization.roles.create`<br />
`organization.roles.remove`<br />
`organization.roles.modify`<br />

#### Managing how repository access levels map to Semaphore project roles **✕**

`organization.repo_to_role_mappers.view`<br />
`organization.repo_to_role_mappers.create`<br />
`organization.repo_to_role_mappers.delete`<br />
`organization.repo_to_role_mappers.modify`<br />

#### Other permissions

`organization.projects.create`<br />
`organization.activity_monitor.view`<br />

## Project permissions

<br />
#### Managing people

`project.people.change_role`<br />
`project.people.remove`<br />
`project.people.invite`<br />

#### Accessing/running jobs

`project.job.view`<br />
`project.job.rerun`<br />
`project.job.artifacts.view`<br />
`project.job.artifacts.delete`
<span style="font-size:smaller;">(Grants permissions for [job level](/essentials/artifacts/#job-artifacts) artifacts)</span><br />
`project.job.stop`<br />
<span style="font-size:smaller;">Follwing permissions are needed to
access jobs via `sem` [cli tool](/reference/sem-command-line-tool/#operations).</span><br />
`project.job.port_forwarding`<br />
`project.job.attach`<br />
`project.job.debug`<br />
`project.debug`<br />

#### Project level secrets **✕**

`project.secrets.view`<br />
`project.secrets.create`<br />
`project.secrets.modify`<br />
`project.secrets.delete`<br />
`project.authorized_org_secrets.list`<br /> <span style="font-size:smaller;">(List of organization level secrets
that are whitelisted to be used within the given project)</span><br />

#### Project notifications **✕**

`project.notifications.view`<br />
`project.notifications.create`<br />
`project.notifications.modify`<br />
`project.notifications.delete`<br />

#### Schedulers [↗](/essentials/schedule-a-workflow-run/)

`project.scheduler.view`<br />
`project.scheduler.create`<br />
`project.scheduler.delete`<br />
`project.scheduler.modify`<br />
`project.scheduler.run_manually`<br />
`project.scheduler.deactivate`<br />

#### Workflow

`project.workflow.view`<br />
`project.workflow.modify`<br />
`project.workflow.rerun`<br />
`project.workflow.stop`<br />
`project.workflow.artifacts.view `<br />
<span style="font-size:smaller;">(Grants permissions for [workflow level](/essentials/artifacts/#workflow-artifacts) artifacts)</span><br />
`project.workflow.artifacts.delete`<br />

#### Artifacts [↗](/essentials/artifacts/)

`project.artifacts.delete`<br />
`project.artifacts.view`<br />
`project.artifacts.view_settings`
<span style="font-size:smaller;">(Grants permissions for [project level](/essentials/artifacts/#project-artifacts) artifacts)</span><br />
`project.artifacts.modify_settings`<br />

#### Project pre-flight checks [↗](essentials/configuring-pre-flight-checks/#project-pre-flight-checks)

`project.pre_flight_checks.view`<br />
`project.pre_flight_checks.modify`<br />

#### Project insights 

`project.insights.view`<br />
`project.insights.modify`<br />

#### Project settings and other permissions

`project.view`<br />
`project.delete`<br />
`project.general_settings.view`<br />
`project.general_settings.modify`<br />
`project.repository_info.view`<br />
`project.repository_info.modify`<br />
`project.badge.view`<br />
`project.badge.manage`<br />
