Semaphore has integrated Webhook based notifications that are delivered on
the success or failure of a pipeline.

- [Setting up Webhook notification for a project](#setting-up-webhook-notifications-for-a-project)
- [Setting up Webhook notification for multiple projects and channels](#setting-up-webhook-notifications-for-multiple-projects-and-channels)
- [Filtering by project, branch and pipeline names](#filtering-by-project-branch-and-pipeline-names)
- [Advanced notification setup](#advanced-notification-setup)
  - [Filtering by pipeline result](#filtering-by-pipeline-result)
- [Modifying notification settings](#modifying-notification-settings)
- [Setting up, editing and deleting Webhook notifications through the UI](#setting-up-editing-and-deleting-webhook-notifications-through-the-ui)
- [See also](#see-also)

## Setting up Webhook notifications for a project

Use your Endpoint URL to set up a notification on Semaphore,
with the following command:

``` bash
$ sem create notification [name] \
    --projects [project_name] \
    --webhook-endpoint [webhook-webhook-endpoint]
```

For example, if you have a project called `web` and you want to get a Webhook
notification on every finished pipeline on the `master` branch, use the
following command:

``` bash
$ sem create notification master-pipelines \
    --projects web \
    --branches master \
    --webhook-endpoint [webhook-webhook-endpoint]
```

## Setting up Webhook notifications for multiple projects and channels

When creating the notification, you can specify multiple projects as source,
of your notifications.

For example, if your team manages three projects named `web`, `cli` and `api`
and you want to get notified for every finished pipeline on the master branch,
use the following command:

``` bash
$ sem create notifications teamA-notifications \
    --projects "web,cli,api" \
    --branches "master" \
    --webhook-endpoint [webhook-webhook-endpoint]
```

## Filtering by project, branch and pipeline names

When creating the notification, you can specify a filter for project, branch and
pipeline names.

For example to send notifications for the `master` and `staging` branches use
the following:

``` bash
$ sem create notifications example \
    --branches "master,staging" \
    --webhook-endpoint [webhook-webhook-endpoint] \
```

The branch filter can be a direct match like in the previous example, or a
regular expression match. For example, to get notified about for `master` and
every branch that matches `hotfix/-`, use the following:

``` bash
$ sem create notifications example \
    --branches "master,/hotfix\/.*/" \
    --webhook-endpoint [webhook-webhook-endpoint] \
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
    --webhook-endpoint [webhook-webhook-endpoint] \
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
        webhook:
          endpoint: https://example.org/postreceiver
```

Note that you can list more than value under `results`.

You can create a notification using the file above with:

``` bash
sem create -f notify-on-fail.yml
```

## Modifying notification settings

Notification settings can be listed, described, edited and deleted in your
organization by using the [sem command line tool](https://docs.semaphoreci.com/article/53-sem-reference).

- List notifications with: `sem get notifications`
- Describe a notification with: `sem get notifications [name]`
- Edit a notification with: `sem edit notification [name]`
- Delete a notification with: `sem delete notification [name]`

See the [sem command line tool](https://docs.semaphoreci.com/article/53-sem-reference)
for further details.

## Setting up, editing and deleting Webhook notifications through the UI

In the Configuration part of the sidebar, click on **Notifications** -> **Create New
Notification**. Add the name of the notification and rules and click on the **Save
Changes** button.

If you’d like to edit or delete an existing notification, click on the name of
the notification and at the top right corner, click on **Edit** or **Delete...** button
and follow the steps from there.

## See also

- [Sem command line tool reference](https://docs.semaphoreci.com/article/53-sem-reference)
- [Webhook Notification](https://docs.semaphoreci.com/article/170-webhook-notifications)
