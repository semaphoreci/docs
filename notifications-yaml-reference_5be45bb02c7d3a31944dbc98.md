
 * [Overview](#overview)
 * [Properties](#properties)
 * [version](#version)

## Overview


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


## The properties of the rules property


### name

The value of the `name` property, which is a string, in the `metadata` context
defines the name of the notification.


### filter

The `filter` property is used for holding

The `filter` property holds the `filters` and the `pipelines` properties.

#### projects

The `projects` property

#### pipelines

The `pipelines` property

### notify

The `notify` property

The `notify` property holds the `slack` property that is used for defining
information related to the Slack channel or channels related to the defined
notification.

#### slack

The `slack` property

##### endpoint

The `endpoint` property

You can learn more about defining the value of the `endpoint` property by

##### message

The `message` property

##### channels

The `channels` property holds a list of strings. Each string value is the name
of a Slack channel.

    - name: "On QA cluster creation"
      filter:
        projects:
          - cluster-creator
        pipelines:
          - .semaphore/qa-*.yml
      notify:
        slack:
          endpoint: "https://slack.com/api/8742d286-e067-4dc9-a5f7-7e2009635485"
          message: "QA cluster {{ pipeline.name }} created"
          channels:
            - "#qa"



## An example

The following YAML code present an example of a notification:


What this notification does is

## See Also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
