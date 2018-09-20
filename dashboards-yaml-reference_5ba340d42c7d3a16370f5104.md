
* [Overview](#overview)
* [Properties](#properties)
   * [apiVersion](#apiversion)
   * [kind](#kind)
   * [metadata](#metadata)
      * [name](#name-in-metadata)
      * [title](#title-in-metadata)
      * [id](#id)
      * [create_time](#create_time)
      * [update_time](#update_time)
   * [spec](#spec)
      * [widgets](#widgets)
         * [name](#name-in-widgets)
         * [type](#type)
         * [filters](#filters)
            - [project_id](#project_id)
            - [branch](#branch)
            - [github_uid](#github_uid)
            - [pipeline_file](#pipeline_file)
* [Example](#example)
* [See also](#see-also)

## Overview


## Properties

### apiVersion

### kind

### metadata


#### name in metadata

#### title in metadata

#### id

#### create_time

#### update_time


### spec


#### widgets

##### name in widgets

##### type

##### filters

###### project_id

###### branch

###### github_uid

###### pipeline_file

## Example

    apiVersion: v1alpha
    kind: Dashboard
    metadata:
      name: my-dashboard
      title: My Dashboard
      id: eb0cc2c7-bbc9-41e4-9e3d-2eb622a673fb
      create_time: "1537445699"
      update_time: "1537445713"
    spec:
      widgets:
      - name: Workflows
        type: list_pipelines
        filters:
          project_id: 7384612f-e22f-4710-9f0f-5dcce85ba44b
      - name: docs projects
        type: list_pipelines
        filters:
          project_id: 0dd982e8-32f5-4037-983e-4de01ac7fb1e
      - name: Using list_workflows
        type: list_workflows
        filters: {}
      - name: All projects on branch mt/sem-init
        type: list_workflows
        filters:
          branch: mt/sem-init

## See also

* [sem command line tool Reference](https://docs.semaphoreci.com/article/53-sem-reference)
