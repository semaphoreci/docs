---
description: This guide demonstrates how to use Semaphore to set up deployment to Elastic Beanstalk and covers the necessary steps of the process.
---

# Deployment to AWS Elastic Beanstalk

This guide shows you how to use Semaphore to set up deployment to Elastic Beanstalk.

For this guide you will need:

- A working Semaphore project with a basic CI pipeline. You can use one of the documented use cases or language guides as a starting point.

### Store AWS keys in a Semaphore secret

You need to create a secret which contains `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_DEFAULT_REGION`


### Pipeline example:

```yaml
version: v1.0
name: Test pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Run tests"
    task: 
      jobs:
        - name: "Test 1"
          commands:
            - checkout
            - echo "Your commands go here"
          
promotions:
  - name: EB deploy
    pipeline_file: eb-deployment.yml
    auto_promote_on:
      - result: passed
```

### Define the deployment pipeline

Finally let's define what happens in our `eb-deployment.yml` pipeline:

```yaml
version: v1.0
name: EB-Deploy
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: "Deploy to ElasticBeanstalk"
    task:
      secrets:
        # contains AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
        - name: aws-credentials
      env_vars:
        - name: S3_BUCKET_NAME
          value: bucket-name
        - name: EB_APP_NAME
          value: app-name
        - name: EB_ENV_NAME
          value: env-name
          
      jobs:
        - name: "Deployment"
          commands:
            - checkout
            - echo "Zipping your newest code from git"; git archive -o "$EB_APP_NAME".zip HEAD
            - export EB_VERSION=`git rev-parse --short HEAD`-`date +%s`
            - aws s3 cp "$EB_APP_NAME".zip s3://$S3_BUCKET_NAME/"$EB_APP_NAME"/"$EB_VERSION".zip
            - aws elasticbeanstalk create-application-version --application-name "$EB_APP_NAME" --version-label "$EB_VERSION" --source-bundle S3Bucket=$S3_BUCKET_NAME,S3Key="$EB_APP_NAME/$EB_VERSION.zip" --description "`git show -s --format=%s HEAD | cut -c -200`"
            - aws elasticbeanstalk update-environment --environment-name "$EB_ENV_NAME" --version-label "$EB_VERSION"
            - echo "Environment status':' `aws elasticbeanstalk describe-environments --environment-names "$EB_ENV_NAME" | grep '"Status"' | cut -d':' -f2  | sed -e 's/^[^"]*"//' -e 's/".*$//'`"
            - echo "Your environment is currently updating"; while [[ `aws elasticbeanstalk describe-environments --environment-names "$EB_ENV_NAME" | grep '"Status"' | cut -d':' -f2  | sed -e 's/^[^"]*"//' -e 's/".*$//'` = "Updating" ]]; do sleep 2; printf "."; done
            - if [[ `aws elasticbeanstalk describe-environments --environment-names "$EB_ENV_NAME" | grep VersionLabel | cut -d':' -f2 | sed -e 's/^[^"]*"//' -e 's/".*$//'` = "$EB_VERSION" ]]; then echo "The version of application code on Elastic Beanstalk matches the version that Semaphore sent in this deployment."; echo "Your environment info':'"; aws elasticbeanstalk describe-environments --environment-names "$EB_ENV_NAME"; else echo "The version of application code on Elastic Beanstalk does not match the version that Semaphore sent in this deployment. Please check your AWS Elastic Beanstalk Console for more information."; echo "Your environment info':'"; aws elasticbeanstalk describe-environments --environment-names "$EB_ENV_NAME"; false; fi
            - sleep 5; a="0"; echo "Waiting for environment health to turn Green"; while [[ `aws elasticbeanstalk describe-environments --environment-names "$EB_ENV_NAME" | grep '"Health"' | cut -d':' -f2  | sed -e 's/^[^"]*"//' -e 's/".*$//'` != "Green" && $a -le 30 ]]; do sleep 2; a=$[$a+1]; printf "."; done; if [[ `aws elasticbeanstalk describe-environments --environment-names "$EB_ENV_NAME" | grep '"Health"' | cut -d':' -f2 | sed -e 's/^[^"]*"//' -e 's/".*$//'` = "Green" ]]; then echo "Your environment status is Green, congrats!"; else echo "Your environment status is not Green, sorry."; false; fi;
            - echo "Your environment info':'"; aws elasticbeanstalk describe-environments --environment-names "$EB_ENV_NAME"
```
