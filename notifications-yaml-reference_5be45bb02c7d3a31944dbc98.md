
 * [Overview](#overview)
 * [Properties](#properties)
 * [The rules property in more detail](#the-rules-property-in-more-detail)
 * [See Also](#see-also)

## Overview

You can find out how to create new notifications by visiting the
[Slack Notification](https://docs.semaphoreci.com/article/91-slack-notifications)
and the [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
pages of the Semaphore 2.0 documentation.

## Rules of Notifications

Notifications are governed by certain rules:

* Notifications can be sent only when a pipeline is finished. Notifications for
    started pipelines are not yet implemented.
* Currently, notifications can only filter by project name, pipeline filename
    and branch name. Other filters like block filters, state filters and result
    filters are not yet implemented.
* When creating a notification, you can specify multiple projects as source
    and multiple slack channels as the target of your notifications.
* You need the `sem` command line tool in order to work with notifications.

## Properties

### kind

The `kind` property defines the purpose of the YAML file. For a YAML file that
will be used for defining notifications, the value of the `kind` property should
be `Notification`.

### metadata

The `metadata` property defines the metadata of a Notifications YAML file and
supports the `name` property only.

#### name

The value of the `name` property, which is a string, in the `metadata` context
defines the name of the notification. This is what will appear when you execute
a `sem get notifications` command.

### spec

The `spec` property holds a list of properties that hold the full specification
of a notification.

In order to define a notification you will need to have a `rules` item.

#### rules

Each `rules` property holds the definition of a notification. In order to have
multiple notifications, you will need to have multiple `rules` items.

## The rules property in more detail

In this section we are going to explain the properties that are stored in a
`rules` property – the logic of each notification is stored under a `rules`
property.

### name

The value of the `name` property, which is a string, in the `metadata` context
defines the name of the rule of the notification.

### filter

The `filter` property holds the `filters`, `bracnhes` and `pipelines`
properties.

The values of `--branches`, `--projects` and `--pipelines` can contain regular
expressions. Regex matches must be wrapped in forward slashes (`/.*/`).
Specifying a branch name without slashes (example: `.*`) would execute a direct
equality match.

For a filter to be `true` all of its conditions should be true. If a condition
such as `branches` has multiple cases, only one of these cases should be a
match.

#### projects

The `projects` property is used for holding a list of Semaphore 2.0 projects
that interest us.

#### pipelines

The `pipelines` property is used for holding a list of pipeline filenames that
interest us.

#### branches

The `branches` property holds a list of strings, which should be GitHub branch
names, that interest us.

### notify

The `notify` property holds the `slack` property that is used for defining
information related to the Slack channel or channels related to the defined
notification.

#### slack

The `slack` property holds information related to Slack such as the URL of the
Incoming WebHook, the message that will be displayed, etc.

##### endpoint

The `endpoint` property holds the URL of the Incoming WebHook that will be used.
Incoming WebHooks offer a simple way for posting messages from external sources
into Slack.

You can learn more about defining the value of the `endpoint` property by
visiting https://slack.com/apps/A0F7XDUAZ-incoming-webhooks.

Please note that if a notification does not work as expected, you might want to
begin the debugging process by verifying the Slack WebHook used.

Tip: you can use just a single Incoming WebHook from Slack for all your
notifications as this Incoming WebHook has access to all the channels of a
Slack Workspace.

##### message

The `message` property allows you to define the message that will be displayed
on the Slack channel or the Slack user by the rule of the notification.

##### channels

The `channels` property holds a list of strings. Each string item is the name
of a Slack channel or the name of a Slack user.

A notification can send a message to multiple Slack channels and multiple users.

## An example

The following YAML code present an example of a notification as returned by the
`sem get notification [name]` command:

     sem get notifs docs
    apiVersion: v1alpha
    kind: Notification
    metadata:
      name: docs
      id: 2222f08c-93f9-459b-8825-ab8be49c9d19
      create_time: "1542024088"
      update_time: "1542280192"
    spec:
      rules:
      - name: Send notifications for docs
        filter:
          projects:
          - docs
        notify:
          slack:
            endpoint: https://hooks.slack.com/services/XXTXXSSA/ABCDDAS/XZYZWAFDFD
            channels:
            - '#dev-null'
            - '@mtsoukalos'
      - name: Send notifications for S1
        filter:
          projects:
          - S1
          - /.*-api$/
          - docs
          branches:
          - /.*mt/
          - master
          pipelines:
          - semaphore.yml
        notify:
          slack:
            endpoint: https://hooks.slack.com/services/XXTXXSSA/ABCDDAS/XZYZWAFDFD
            channels:
            - '#dev-null'
    status: {}

This notification has two rules, one named `Send notifications for docs` and
another named `Send notifications for S1`.

The first rule of then notification specifies a single project name that is
called `docs`. The notification will go to the `#dev-null` **channel** and to the
`mtsoukalos` **user** using the specified Incoming WebHook of Slack.

The second rule is more complex than the first one. The values of the `projects`
property specify two exact project names named `S1` and `docs` as well as a
regular expression that will be evaluated against all the project names of the
current organization.

Similarly, the `branches` property has two items. The first one

## See Also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
* [Slack Notifications](https://docs.semaphoreci.com/article/91-slack-notifications)
