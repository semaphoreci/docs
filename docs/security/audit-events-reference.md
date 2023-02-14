# Audited events reference

!!! plans "Available on: <span class="plans-box">[Scaleup](/account-management/scaleup-plan/)</span>"

Each audit log entry shows applicable information about an event, such as:

- Action that was performed
- The user (actor) who performed the action
- Resource affected by the action
- Date and time of the action
- IP address and medium of the interface used to perform the action

## Audit log entry fields
**All** audited events contain following fields:

- [Resource](#resource-field)
- [Operation](#operation-field)
- User ID (The user who initiated this action.)
- [Medium](#medium-field)
- Timestamp

**Some** events contain following fields:

- Resource ID
- Resource name
- IP address
- Username
- Description
- Metadata (some metadata regarding the event, **must** be valid **JSON**)

### Resource field
Possible values of **Resource** field:

- Project
- User
- Workflow
- Pipeline
- DebugSession
- PeriodicScheduler
- Secret
- Notification
- Dashboard
- Job
- Artifact
- Organization

### Operation field
Values of **Operation** field:

- Added
- Removed
- Modified
- Started
- Stopped
- Promoted
- Demoted
- Rebuild
- Download

### Medium field
Operation can be done from one of the follwoing Mediums:

- Web
- API
- CLI
