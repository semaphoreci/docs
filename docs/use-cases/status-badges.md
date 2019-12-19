# Status Badges

This guide shows you how to create a badge that displays your project's current
build status. The build status is determined by the status of the first pipeline
in your newest workflow. You can use this badge in your project's README file or
any web page.

## Badge URL

Badge URLs follow the following format:

```
https://{ORGANIZATION_NAME}.semaphoreci.com/badges/{PROJECT_NAME}.svg
```

For example, the badge URL for [Semaphore's documentation project](https://semaphore.semaphoreci.com/projects/docs) will look like that:

https://semaphore.semaphoreci.com/badges/docs.svg

## Branch

By default, badge will be created based on default branch. You can specify
different branch by adding `/branches/{BRANCH_NAME}` to the URL.

```
https://{ORGANIZATION_NAME}.semaphoreci.com/badges/{PROJECT_NAME}/branches/{BRANCH_NAME}.svg
```

## Styles

You can choose between the default Semaphore style and [Shields style](https://shields.io/).
To use the Shields style, add `style=shields` as the query parameter in the badge
URL:

```
https://{ORGANIZATION_NAME}.semaphoreci.com/badges/{PROJECT_NAME}.svg?style=shields
```

Example badges:

- Semaphore style badge: ![semaphore docs](https://semaphore.semaphoreci.com/badges/docs/branches/master.svg)
- Shields style badge: ![semaphore docs](https://semaphore.semaphoreci.com/badges/docs/branches/master.svg?style=shields)

## Private projects on Semaphore

Build badges for projects that are private on Semaphore require an additional `key` parameter.
The value of this parameter is an ID of the project.

```
https://{ORGANIZATION_NAME}.semaphoreci.com/badges/{PROJECT_NAME}.svg?key={PROJECT_ID}
```

You can find `PROJECT_ID` using [sem command line tool](https://docs.semaphoreci.com/article/53-sem-reference):

``` bash
sem get project {PROJECT_NAME}
```
