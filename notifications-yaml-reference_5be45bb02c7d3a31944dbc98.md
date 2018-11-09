
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

#### rules

The `rules` property holds a list of rule definitions


### version


## See Also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
