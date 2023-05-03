---
Description: This guide shows you how to use Semaphore to estimate cloud costs for Terraform projects with Infracost.
---

# Estimating Cloud Costs with Infracost

The Infracost CLI tool parses Terraform files and estimates cloud costs. This guide will show you how to:

- Run the Infracost CLI in CI/CD.
- Comment Git commits with cost changes.
- Comment pull requests with cost changes.
- Fail the CI/CD if costs exceed a custom-defined policy.

For this guide, you will need the following:

- [A working Semaphore project][create-project] with a basic CI pipeline.
- At least one [Terraform][terraform] file in your project.
- An [Infracost][infracost] API key. You must sign up with a free account to obtain it.
- A GitHub or Bitbucket API key with permission to write comments in the repository.

!!! note

    For a more in-depth guide to Infracost, check out this post in the Semaphore blog: [Taming Cloud Costs with Infracost][taming-costs]


## Adding a baseline to the repository

In order to estimate deviations from the expected cost, you must store a baseline file in your repository. The following command will generate `baseline.json` based on all the Terraform files found in your project folder:

```bash
$ infracost breakdown --path . --format json --out-file baseline.json
```

Now you can push `baseline.json` into your repository.

## Storing the API keys in secrets

Follow the [Infracost getting started guide][infracost-started] to install the CLI tool on your machine and obtain an API key. Create a [secret][secrets-guide] in Semaphore to store it:

```bash
$ sem create secret infracost -e INFRACOST_API_KEY=YOUR_API_KEY
```

Create a [GitHub Access Token][gh-token] with write permissions on your repository. If you are using Bitbucket, you must create [Bitbucket app password][bb-token].

Store the GitHub or Bitbucket access token in Semaphore:

```bash
# GitHub
sem create secret github -e GITHUB_API_KEY=YOUR_API_KEY

# Bitbucket
sem create secret github -e BITBUCKET_API_KEY=YOUR_API_KEY
```

## Adding cost estimates to commits with CI/CD

When Infracost runs in your CI/CD workflow, it can post comments in commits and pull requests with the estimated cost difference from the baseline or between branches.

### Estimates on GitHub

Before you can calculate cost differences in commits or peer reviews, you need to establish a baseline. If you have any usage-based resources such as serverless functions, you need to first create an [usage file][usage-resources].

```bash
$ infracost breakdown --sync-usage-file --usage-file usage.yml --path .
```

Now, edit `usage.yml` to add your usage estimates for the moth.

Next, you're ready to create a baseline file. Skip `--usage-file` if you're not using any usage-based cloud resources:

```bash
$ infracost breakdown --path . --format json --usage-file usage.yml --out-file baseline.json
```

After checking in all the new files into the repository, edit the pipeline to run the cost analysis. Use the following snippet to define a job that comments on GitHub the difference in cost between the current commit and the baseline:

```yaml
version: v1.0
name: Initial Pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: "Estimate cloud costs"
    task:
      secrets:
        - name: infracost
        - name: github
      jobs:
        - name: Comment Git commits
          commands:
            - 'curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | INFRACOST_VERSION=v0.10 sh'
            - checkout
            - infracost diff --path . --format json --compare-to baseline.json --out-file /tmp/infracost-diff-commit.json
            - infracost comment github --path=/tmp/infracost-diff-commit.json --repo=$SEMAPHORE_GIT_REPO_SLUG --commit=$SEMAPHORE_GIT_SHA --github-token=$GITHUB_API_KEY --behavior=update
```

### Commenting on Bitbucket

Use the following snippet to define a job that comments on Bitbucket the difference in cost between the current commit and the baseline:

```yaml
version: v1.0
name: Initial Pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: "Estimate cloud costs"
    task:
      secrets:
        - name: infracost
        - name: bitbucket
      jobs:
        - name: Comment Git commits
          commands:
            - 'curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh'
            - checkout
            - infracost diff --path . --format json --compare-to baseline.json --out-file /tmp/infracost-diff-commit.json
            - infracost comment bitbucket --path=/tmp/infracost-diff-commit.json --repo=$SEMAPHORE_GIT_REPO_SLUG --commit=$SEMAPHORE_GIT_SHA --bitbucket-token=$BITBUCKET_API_KEY --behavior=update
```

## Adding cost estimate to pull requests with CI/CD

A separate job can also be created to post comment on pull requests. This allows the reviewer to quickly assess the cost changes between branches.



### Estimates for pull requests on GitHub

The following example calculates the cost change between the master and the branch that triggered the workflow in GitHub:

```yaml
version: v1.0
name: Initial Pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: "Comment on Pull Requests"
    task:
      secrets:
        - name: infracost
        - name: github
      jobs:
        - name: Cost diff between branches
          commands:
            - 'curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh'
            - checkout
            - git checkout master
            - infracost breakdown --path . --format json --out-file /tmp/infracost-master.json
            - git checkout FETCH_HEAD
            - infracost diff --path . --format json --compare-to /tmp/infracost-master.json --out-file /tmp/infracost-diff-master.json
            - infracost comment github --path=/tmp/infracost-diff-master.json --repo=$SEMAPHORE_GIT_REPO_SLUG --pull-request=$SEMAPHORE_GIT_PR_NUMBER --github-token=$GITHUB_API_KEY --behavior=update
```

### Estimates for pull requests on Bitbucket

The following example calculates the cost change between the master and the branch that triggered the workflow in Bitbucket:

```yaml
version: v1.0
name: Initial Pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: "Comment on Pull Requests"
    task:
      secrets:
        - name: infracost
        - name: bitbucket
      jobs:
        - name: Cost diff betwen branches
          commands:
            - 'curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh'
            - checkout
            - git checkout master
            - infracost breakdown --path . --format json --out-file /tmp/infracost-master.json
            - git checkout FETCH_HEAD
            - infracost diff --path . --format json --compare-to /tmp/infracost-master.json --out-file /tmp/infracost-diff-master.json
            - infracost comment bitbucket --path=/tmp/infracost-diff-master.json --repo=$SEMAPHORE_GIT_REPO_SLUG --pull-request=$SEMAPHORE_GIT_PR_NUMBER --bitbucket-token=$BITBUCKET_API_KEY --behavior=update
```

## Enforcing policies with CI/CD

Infracost can be used to enforce cost policies with continuous integration. When a policy is used, the Infracost CLI will return a non-zero exit status, stopping the pipeline and preventing a deployment that would run over the budget.

First, we must create a policy file and push it into the repository. To learn about the policy syntax, read the [cost policies docs][infracost-policies] on Infracost.

The following example sets a maximum budget of USD 1000 per month:

```rego
# policy.rego

package infracost

deny[out] {

    # define a variable
  maxMonthlyCost = 1000.0

  msg := sprintf(
    "Total monthly cost must be less than $%.2f (actual cost is $%.2f)",
    [maxMonthlyCost, to_number(input.totalMonthlyCost)],
  )

    out := {
      "msg": msg,
      "failed": to_number(input.totalMonthlyCost) >= maxMonthlyCost
    }
}
```

To evaluate the policy file, you must add the `--policy-path POLICY_FILENAME` option to any of the comment commands. For example:

```bash
# calculate difference between commit and baseline
infracost diff --path . --format json --compare-to baseline.json --out-file /tmp/infracost-diff-commit.json

# enforce policy
infracost comment github --path=/tmp/infracost-diff-commit.json --repo=$SEMAPHORE_GIT_REPO_SLUG --commit=$SEMAPHORE_GIT_SHA --github-token=$GITHUB_API_KEY --behavior=update
```

## Tips for using Infracost in your pipeline

- You can use [change-based execution][change-based-execution] with a condition such as `change_in('/**/*.tf') or change_in('/**/*.tfvars')` to run Infracost only when Terraform files change. 
- You can create a [config file][infracost-config] to manage [monorepo workflows][monorepo-workflow] and provide utilization forecast for per-usage services such as AWS lambda.
- You can add a [badge][infracost-badge] to your repository with the estimated monthly cost.

## Next steps

Congratulations! You have created a successful pipeline that
communicates with Terraform and Google Cloud.
Here’s some recommended reading:

- [Explore the promotions reference][promotions-ref] to learn more about what
options are available when designing delivery pipelines on Semaphore.
- [Set up a deployment dashboard][deployment-dashboards] to keep track of
your team's activities.
- Check out our in-depth blog post about Infracost: [Taming Cloud Costs with Infracost][taming-costs].

[create-project]: ../guided-tour/getting-started.md
[use-cases]: https://docs.semaphoreci.com/examples/tutorials-and-example-projects/
[language-guides]: https://docs.semaphoreci.com/programming-languages/android/
[infracost]: https://infracost.io
[terraform]: ../examples/using-terraform-with-google-cloud.md
[taming-costs]: https://semaphoreci.com/blog/infracost
[promotions-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
[promotions-intro]: https://docs.semaphoreci.com/essentials/deploying-with-promotions/
[secrets-guide]: https://docs.semaphoreci.com/essentials/using-secrets/
[sem-create-ref]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-create
[deployment-dashboards]: https://docs.semaphoreci.com/essentials/deployment-dashboards/
[infracost-badge]: https://www.infracost.io/docs/infracost_cloud/readme_badge/
[infracost-config]: https://www.infracost.io/docs/features/config_file/
[monorepo-workflow]: https://docs.semaphoreci.com/essentials/building-monorepo-projects/
[change-based-execution]: https://docs.semaphoreci.com/essentials/building-monorepo-projects/#change-based-block-execution
[infracost-policies]:https://www.infracost.io/docs/features/cost_policies/
[gh-token]: https://github.com/settings/tokens
[bb-token]: https://support.atlassian.com/bitbucket-cloud/docs/app-passwords/
[infracost-started]: https://www.infracost.io/docs/
[usage-resources]: https://www.infracost.io/docs/features/usage_based_resources/