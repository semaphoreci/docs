The Code Climate test reporter can join parallelized test reports, combining them into one individual test report that can be submitted to Code Climate.

Configure your CI to store partial results from each parallel run. We recommend syncing and fetching files from S3 as one approach. Alternately, you can use a temporary folder in your CI build. Then, use the test reporter's `format-coverage`, `sum-coverage`, and `upload-coverage` commands to combine the results and upload them as one complete test report.

Set your repo's test reporter ID as an environment variable to identify your repo. This can be found on your Repo Settings in Code Climate. More information here: https://docs.codeclimate.com/docs/configuring-test-coverage#section-parallel-tests

1. Fetch the test reporter pre-built binary.

2. Run `before-build` before running your test suite to notify of a pending report.

3. Execute your test suite.

4. Run `format-coverage` on the reports from each parallelized instance.

5. Run `sum-coverage` to combine the parallelized test reports into one unified report.

6. Run `upload-coverage` to upload the combined test report to Code Climate.


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
            - ./cc-test-reporter format-coverage --output "coverage/codeclimate.$N.json"
            # uploading partial test Coverage to S3
            - aws s3 cp "coverage/codeclimate.$N.json" "${S3_FOLDER}"
      
- name: Fetching and merging partial tests
   task:
      jobs:
        - name: Execute tests
          commands:
            - checkout
            # fetching partial tests from S3
            - aws s3 sync coverage/ "s3://my-bucket/coverage/$CI_BUILD_NUMBER"
            # merging tests
            - ./cc-test-reporter sum-coverage --output - --parts $PARTS coverage/codeclimate.*.json 
            - ./cc-test-reporter upload-coverage
```
