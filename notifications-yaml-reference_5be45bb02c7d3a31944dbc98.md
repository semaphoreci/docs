
 * [Overview](#overview)
 * [Properties](#properties)
 * [The rules property in more detail](#the-rules-property-in-more-detail)
 * [See Also](#see-also)

## Overview


## Rules of Notifications

Notifications are governed by certain rules:

* Notifications can be sent only when a pipeline is finished. Notifications for
    started pipelines are not yet implemented.
* Currently, notifications can only filter by project name, pipeline filename
    and branch name. Other filters like block filters, state filters and result
    filters are not yet implemented.
* 

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
defines the name of the notification.

### spec

The `spec` property holds a list of properties that hold the full specification
of a notification.

In order to define a notification you will need to have a `rules` item.

#### rules

Each `rules` property holds the definition of a notification. In order to have
multiple notifications, you will need to have multiple `rules` items.


## The rules property in more detail

In this section we are going to explain the properties that are stored in a
`rules` property – the logic of notifications is stored under `rules`
property.

### name

The value of the `name` property, which is a string, in the `metadata` context
defines the name of the notification.


### filter

The `filter` property is used for holding

The `filter` property holds the `filters`, `bracnhes` and `pipelines`
properties.

For a filter to be `true` all of its conditions should be true. If a conditions
such as `branches` has multiple cases, only one of these cases should be a
match.

#### projects

The `projects` property is used for holding

#### pipelines

The `pipelines` property

#### branches

The `branches` property holds a list of strings, which should be GitHub branch
names.


### notify

The `notify` property

The `notify` property holds the `slack` property that is used for defining
information related to the Slack channel or channels related to the defined
notification.

#### slack

The `slack` property

##### endpoint

The `endpoint` property holds the URL of the Incoming WebHook that will be used.
Incoming WebHooks offer a simple way for posting messages from external sources
into Slack.

You can learn more about defining the value of the `endpoint` property by
visiting https://slack.com/apps/A0F7XDUAZ-incoming-webhooks.

Please note that if a notification does not work as expected, you might want to
begin the debugging process by verifying the Slack WebHook used.

##### message

The `message` property allows you to define the message that will be displayed
on the Slack channel by the notification. The `message` property supports
certain keywords that allow you to include specific and dynamic information in
your output.

The list of supported dynamic keywords is the following:

* pipeline.name:
* pipeline.result:
* pipeline.duration:
* project.name:
* commit.message:

##### channels

The `channels` property holds a list of strings. Each string item is the name
of a Slack channel.

## An example

The following YAML code present an example of a notification:


What this notification does is

## See Also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
