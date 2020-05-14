# Webhook Notifications

Semaphore has webhook based notifications that are delivered on the success or
failure of a pipeline. When criteria for notifications are met, Semaphore will
send a HTTP POST payload to the webhook's configured URL. You can use them,
for example, to implement alerts through [Hubot](https://github.com/hubotio/hubot),
or keep track of your projects on a company dashboard.

## Setting up webhook notifications for a project

Use your Endpoint URL to set up a notification on Semaphore,
with the following command:

``` bash
$ sem create notification [name] \
    --projects [project_name] \
    --webhook-endpoint [webhook-endpoint]
```

For example, if you have a project called `web` and you want to get a webhook
notification on every finished pipeline on the `master` branch, use the
following command:

``` bash
$ sem create notification master-pipelines \
    --projects web \
    --branches master \
    --webhook-endpoint [webhook-endpoint]
```

## Setting up webhook notifications for multiple projects

When creating a notification, you can specify multiple projects as a source,
of your notifications.

For example, if your team manages three projects named `web`, `cli` and `api`
and you want to get notified of every finished pipeline on the master branch,
use the following command:

``` bash
$ sem create notifications teamA-notifications \
    --projects "web,cli,api" \
    --branches "master" \
    --webhook-endpoint [webhook-endpoint]
```

## Filtering by project, branch and pipeline names

When creating a notification, you can specify a filter for project, branch and
pipeline names.

For example, to send notifications for the `master` and `staging` branches, use
the following:

``` bash
$ sem create notifications example \
    --branches "master,staging" \
    --webhook-endpoint [webhook-endpoint] \
```

A filter can either be a regex match or a direct match. Specifying a filter with
forward slashes (e.g. `/hotfix-.*/`) defines a regex match, while a filter without
forward slashes (e.g. `master`) defines a direct match.

``` bash
$ sem create notifications example \
    --branches "master,/hotfix\/.*/" \
    --webhook-endpoint [webhook-endpoint] \
```

Matching can be specified for project and pipeline files as well. For example,
if you want to get notified after every pipeline on a project that matches
`/.*-api$/`, on the master branch, when the `prod.yml` pipeline is executed, use:

``` bash
$ sem create notifications example \
    --projects "/.*api$/" \
    --branches "master" \
    --pipelines "prod.yml" \
    --webhook-endpoint [webhook-endpoint] \
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

Note that you can list more than one value under `results`.

You can create a notification using the file above with:

``` bash
sem create -f notify-on-fail.yml
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

## Setting up, editing and deleting webhook notifications through the UI

In the Configuration part of the sidebar, click on **Notifications** -> **Create New
Notification**. Add the name of the notification and rules and click on the **Save
Changes** button.

If you’d like to edit or delete an existing notification, click on the name of
the notification and at the top right corner, click on **Edit** or **Delete...** button
and follow the steps from there.

## Notification payload

The payload contains all the information related to a pipeline.

```json
{
    "version": "1.0.0",
    "organization": {
        "name": "semaphore",
        "id": "36360e31-fee6-42b2-9f6c-999d4c06ce81"
    },
    "project": {
        "name": "notifications",
        "id": "91e34570-bebe-42b6-b47a-ca710b2b8927"
    },
    "repository": {
        "url": "https://github.com/renderedtext/notifications",
        "slug": "renderedtext/notifications"
    },
    "revision": {
        "tag": null,
        "sender": {
            "login": "radwo",
            "email": "184065+radwo@users.noreply.github.com",
            "avatar_url": "https://avatars2.githubusercontent.com/u/184065?v=4"
        },
        "reference_type": "branch",
        "reference": "refs/heads/rw/webhook_impl",
        "pull_request": null,
        "commit_sha": "2d9f5fcec1ca7c68fa7bd44dd58ec4ff65814563",
        "commit_message": "empty",
        "branch": {
            "name": "rw/webhook_impl",
            "commit_range": "36ebdf6e906cf3491391442d2f779b512ca49485...2d9f5fcec1ca7c68fa7bd44dd58ec4ff65814563"
        }
    },
    "workflow": {
        "initial_pipeline_id": "fa02c7bd-7a8b-42e0-8d6e-aa0d8a194e19",
        "id": "acabe58e-4bcc-4d39-be06-e98d71917703",
        "created_at": "2019-12-10T13:09:54Z"
    },
    "pipeline": {
        "yaml_file_name": "semaphore.yml",
        "working_directory": ".semaphore",
        "stopping_at": "2019-12-10T13:10:22Z",
        "state": "done",
        "running_at": "2019-12-10T13:09:58Z",
        "result_reason": "user",
        "result": "stopped",
        "queuing_at": "2019-12-10T13:09:55Z",
        "pending_at": "2019-12-10T13:09:55Z",
        "name": "Notificaitons",
        "id": "fa02c7bd-7a8b-42e0-8d6e-aa0d8a194e19",
        "error_description": "",
        "done_at": "2019-12-10T13:10:28Z",
        "created_at": "2019-12-10T13:09:54Z"
    },
    "blocks": [
        {
            "state": "done",
            "result_reason": "user",
            "result": "stopped",
            "name": "List & Test & Build",
            "jobs": [
                {
                    "status": "finished",
                    "result": "stopped",
                    "name": "Test",
                    "index": 1,
                    "id": "21df03d2-c4e0-4e0a-acd7-5ff60dc0727e"
                },
                {
                    "status": "finished",
                    "result": "stopped",
                    "name": "Build",
                    "index": 2,
                    "id": "84190263-362c-4051-8260-e43637f148de"
                },
                {
                    "status": "finished",
                    "result": "passed",
                    "name": "Lint",
                    "index": 0,
                    "id": "d4b93a5b-69a5-43e6-ab24-06b095fc49bf"
                }
            ]
        }
    ]
}
```

In this example `revision.pull_request` and `revision.tag` are null because
payload is related to the pipeline run started from a push to the branch.
Information about this is kept in `revision.reference_type`.

Sample `pull_request` object:

```json
"pull_request": {
  "head_repo_slug": "renderedtext/notifications",
  "number": 2,
  "name": "Add docs for webhook notifications",
  "head_sha": "9872252e00ac5a6b5870cdf94efe0e04770ad104",
  "branch_name": "webhook_notifications",
  "commit_range": "9872252e00ac5a6b5870cdf94efe0e04770ad104^..9872252e00ac5a6b5870cdf94efe0e04770ad104"
}
```

Sample `tag` object:

```json
"tag": {
  "name": "v1.0.1",
}
```

## See also

- [Sem command line tool reference](https://docs.semaphoreci.com/reference/sem-command-line-tool/)
- [Notifications YAML Reference](https://docs.semaphoreci.com/reference/notifications-yaml-reference/)
