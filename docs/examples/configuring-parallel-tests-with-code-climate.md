---
description: The Code Climate test reporter can join parallelized test reports, combining them into one individual test report that can be submitted to Code Climate.
---

# Configuring Parallel Tests with Code Climate

The Code Climate test reporter can join parallelized test reports, combining them into one individual test report that can be submitted to Code Climate.

Configure your CI to store partial results from each parallel run. We recommend syncing and fetching files from S3. Then, use the test reporter's `format-coverage`, `sum-coverage`, and `upload-coverage` commands to combine the results and upload them as one complete test report.

1. Set your repo's test reporter ID as an environment variable to identify your repo. This can be found on your Repo Settings in Code Climate.

2. Fetch the test reporter pre-built binary.

3. Run `before-build` before running your test suite to notify of a pending report.

4. Execute your test suite.

5. Run `format-coverage` on the reports from each parallelized instance.

6. Run `sum-coverage` to combine the parallelized test reports into one unified report.

7. Run `upload-coverage` to upload the combined test report to Code Climate.


Here is a configuration example:

```yaml
blocks:
 - name: Test coverage example
   task:
      jobs:
        - name: Execute tests
          commands:
            - checkout
            - curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
            - chmod +x ./cc-test-reporter
            - ./cc-test-reporter before-build
            - # run your tests here
            - ./cc-test-reporter format-coverage --output "coverage/codeclimate.$SEMAPHORE_JOB_ID.json"
            # uploading partial test Coverage to S3
            - aws s3 cp "coverage/codeclimate.$SEMAPHORE_JOB_ID.json" "s3://my_coverage_bucket/$SEMAPHORE_PROJECT_NAME/$SEMAPHORE_GIT_BRANCH/coverage/$SEMAPHORE_WORKFLOW_ID/"
      
- name: Fetching and merging partial tests
   task:
      jobs:
        - name: Execute tests
          commands:
            - checkout
            # fetching partial tests from S3
            - aws s3 sync "s3://my_coverage_bucket/$SEMAPHORE_PROJECT_NAME/$SEMAPHORE_GIT_BRANCH/coverage/$SEMAPHORE_WORKFLOW_ID/" coverage/
            # merging tests
            - ./cc-test-reporter sum-coverage --output - --parts $(ls -1 coverage/ | wc -l) coverage/codeclimate.*.json > coverage/codeclimate.json
            - ./cc-test-reporter upload-coverage
```
