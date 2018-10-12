* [Overview](#overview)

* [See also](see-also)

## Overview

This document is the reference to the YAML grammar used for describing jobs.

## An example

This reference page will begin with an YAML example as returned by the
`sem get jobs [JOB ID]` command:

    $ sem get jobs 33cbe5af-fafb-424b-b06f-12006929cb08
    apiVersion: v1alpha
    kind: Job
    metadata:
      name: Deploy
      id: 33cbe5af-fafb-424b-b06f-12006929cb08
      create_time: "1539327331"
      update_time: "1539327332"
      start_time: "1539327334"
      finish_time: "1539327340"
    spec:
      agent:
        machine:
          type: e1-standard-2
          os_image: ubuntu1804
      files: []
      envvars:
      - name: SEMAPHORE_GIT_SHA
        value: f7da446084515d25db52b4fe6146db6e81ded482
      - name: SEMAPHORE_GIT_BRANCH
        value: mt/sem-0.7.4
      - name: SEMAPHORE_WORKFLOW_ID
        value: 0137eba3-fb19-41f8-87ac-77e040d437f6
      - name: SEMAPHORE_PIPELINE_ARTEFACT_ID
        value: b6452489-3bd7-4a09-a73d-a834b6cad1ac
      - name: SEMAPHORE_PIPELINE_ID
        value: b6452489-3bd7-4a09-a73d-a834b6cad1ac
      - name: SEMAPHORE_PIPELINE_0_ARTEFACT_ID
        value: b6452489-3bd7-4a09-a73d-a834b6cad1ac
      secrets:
      - name: helpscout-docs
      commands:
      - checkout
      - gem install redcarpet
      - if [ $SEMAPHORE_GIT_BRANCH == "master" ]; then ./deploy_docs.rb; fi
      project_id: 0dd982e8-32f5-4037-983e-4de01ac7fb1e
    status:
      state: FINISHED
      result: PASSED
      agent:
        ip: 94.130.207.151
        ports:
        - name: ssh
          number: 57693



## See also