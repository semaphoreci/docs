# Slack Notifications

Semaphore has integrated Slack based chat notifications that are delivered on
the success or failure of a pipeline.

## Setting up Slack notifications for a project

To set up a Slack notification, first you need to configure an [incoming
webhook](https://slack.com/apps/A0F7XDUAZ-incoming-webhooks) in your Slack
workspace.

Use the generated Endpoint URL to set up a notification on Semaphore,
with the following command:

``` bash
$ sem create notification [name] \
    --projects [project_name] \
    --slack-endpoint [slack-webhook-endpoint]
```

For example, if you have a project called `web` and you want to get a Slack
notification on every finished pipeline on the `master` branch, use the
following command:

``` bash
$ sem create notification master-pipelines \
    --projects web \
    --branches master \
    --slack-endpoint [slack-webhook-endpoint]
```

## Setting up Slack notifications for multiple projects and channels

When creating the notification, you can specify multiple projects as source, and
multiple slack channels as the target of your notifications.

For example, if your team manages three projects named `web`, `cli` and `api`
and you want to get notified for every finished pipeline on the master branch,
use the following command:

``` bash
$ sem create notifications teamA-notifications \
    --projects "web,cli,api" \
    --branches "master" \
    --slack-endpoint [slack-webhook-endpoint]
```

If you also want to send these notifications to multiple slack channels, for
example `#dev-team` and `#qa-team`, use the following command:

``` bash
$ sem create notifications new-releases \
    --projects "web,cli,api" \
    --branches "master" \
    --slack-endpoint [slack-webhook-endpoint] \
    --slack-channels "#dev-team,#qa-team"
```

## Filtering by project, branch and pipeline names

When creating the notification, you can specify a filter for project, branch and
pipeline names.

For example to send notifications for the `master` and `staging` branches use
the following:

``` bash
$ sem create notifications example \
    --branches "master,staging" \
    --slack-endpoint [slack-webhook-endpoint] \
```

The branch filter can be a direct match like in the previous example, or a
regular expression match. For example, to get notified about for `master` and
every branch that matches `hotfix/-`, use the following:

``` bash
$ sem create notifications example \
    --branches "master,/hotfix\/.*/" \
    --slack-endpoint [slack-webhook-endpoint] \
```

Regex matches must be wrapped in forward slashes (example: `/.*/`). Specifying a
branch name without slashes (example: `.*`) would execute a direct equality
match.

Matching can be specified for project and pipeline names as well. For example,
if you want to get notified about every notification on a project that matches
`/.*-api$/`, on the master branch, when the `prod.yml` pipeline is executed, use:

``` bash
$ sem create notifications example \
    --projects "/.*api$/" \
    --branches "master" \
    --pipelines "prod.yml" \
    --slack-endpoint [slack-webhook-endpoint] \
```

## Advanced notification setup

In the previous examples we looked at simple use cases where we used the CLI
interface to set up a new notification.

For more complex use cases, defining a notification YAML resource offers full
control over the rules used for dispatching notifications.

### Filtering by pipeline result

You can specify notifications to be sent only on specific pipeline results.

Available values for the results filter are:

- `passed`
- `failed`
- `stopped`
- `canceled`

Example YAML configuration:

``` yaml
# notify-on-fail.yml

apiVersion: v1alpha
kind: Notification
metadata:
  name: notify-on-fail
spec:
  rules:
    - name: "Example"
      filter:
        projects:
          - example-project
        results:
          - failed
      notify:
        slack:
          endpoint: https://hooks.slack.com/services/xxx/yyy/zzz
```

Note that you can list more than one value under `results`.

You can create a notification using the file above with:

``` bash
sem create -f notify-on-fail.yml
```

### Example of notifying multiple teams

In this example example we would like to do the following:

- On every passed pipeline on the staging branch, notify the QA team
- On every pipeline on the master branch, notify the DevOps and Security teams

First specify the notification in a YAML file:

``` yaml
# release-cycle-notifications.yml

apiVersion: v1alpha
kind: Notification
metadata:
  name: release-cycle-notifications
spec:
  rules:
    - name: "On staging branches"
      filter:
        projects:
          - /.*/
        branches:
          - staging
        results:
          - passed
      notify:
        slack:
          endpoint: https://hooks.slack.com/XXXXXXXXXXX/YYYYYYYYYYYY/ZZZZZZZZZZ
          channels:
            - "#qa-team"

    - name: "On master branches"
      filter:
        projects:
          - /.*/
        branches:
          - master
      notify:
        slack:
          endpoint: https://hooks.slack.com/XXXXXXXXXXX/YYYYYYYYYYYY/ZZZZZZZZZZ
          channels:
            - "#devops-team"
            - "#secops-team"
```

Then, apply the resource to your organization:

``` bash
sem create -f release-cycle-notifications.yml
```

## Modifying notification settings

Notification settings can be listed, described, edited and deleted in your
organization by using the [sem command line tool](https://docs.semaphoreci.com/reference/sem-command-line-tool/).

- List notifications with: `sem get notifications`
- Describe a notification with: `sem get notifications [name]`
- Edit a notification with: `sem edit notification [name]`
- Delete a notification with: `sem delete notification [name]`

See the [sem command line tool](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
for further details.

## Setting up, editing and deleting Slack notifications through the UI

In the Configuration part of the sidebar, click on **Notifications** -> **Create New
Notification**. Add the name of the notification and rules, then click on the **Save
Changes** button.

If you’d like to edit or delete an existing notification, click on the name of
the notification and at the top right corner, click on **Edit** or **Delete...** button
and follow the steps from there.

## See also

- [Sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Notifications YAML Reference](https://docs.semaphoreci.com/reference/notifications-yaml-reference/)
