Following instructions to set up CC on Parallel Tests given on Code Climate website ( https://docs.codeclimate.com/docs/configuring-test-coverage#section-parallel-tests), you can add another block after running test jobs, fetch there reports from S3 and run format-coverage, sum-coverage and upload-coverage to send reports to CC.

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
