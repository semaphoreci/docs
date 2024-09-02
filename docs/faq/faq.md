---
Description: The following questions regard common issues that Semaphore users encounter.
---

# FAQ: Frequently asked questions

<p>Issues we stumble upon regularly, in all areas of Semaphore</p>

### How can I solve "Fail: Could not parse object" during bundle install?

<details>
  <summary>Click for details</summary>
  <p>

If the <code>bundle install</code> output looks like this:
```bash
Fetching gem metadata from http://rubygems.org/.......
Fetching gem metadata from http://rubygems.org/..
Updating git://github.com/some/gem.git
fatal: Could not parse object 'a84dd3407eaf064064cca9650c354cb163384467'.
Git error: command <code>git reset --hard a84dd3407eaf064064cca9650c354cb163384467</code> in directory /home/runner/somehash/vendor/bundle/ruby/1.9.1/bundler/gems/gem-a84dd3407eaf has failed.
If this error persists you should try removing the cache directory '/home/runner/somehash/vendor/bundle/ruby/1.9.1/cache/bundler/git/gem-cbe2ee16ed53098079007f06cd77ed0890d0d752'
```

This problem occurs when there have been changes like
force-pushes to a git repo which is referenced in a Gemfile.
You can solve it by following these steps:
</p>
<p>

- Comment the gem line in the Gemfile
<br>- Run <code>bundle install</code>
<br>- Uncomment the gem line in the Gemfile
<br>- Run <code>bundle install</code> again
</p>
<p>
  
The Gemfile.lock will now reference a valid git revision.
  </p>
</details>

### I get "Revision: COMMIT_SHA not found .... Exiting" error. What is the cause?

<details>
  <summary>Click for details</summary>
  <p>

The reason for that error are changes to repository tree structure in git VCS,
which become effective in remote when your pipeline is still running. 
It usually happens when you modify or remove commits (for example, with 
<code>git rebase</code> or <code>git commit --amend</code> commands)
and then push with <code>--force</code> flag shortly after the previous push.

  </p>
  <p>

If you want to avoid executing previous pipelines after new pushes, check out how to set up
<a href="/essentials/auto-cancel-previous-pipelines-on-a-new-push/">auto-cancel strategy</a>.
If pipeline hasn't started after you pushed changes, you may also want to check out if GitHub 
delivered <a href="#how-can-i-redeliver-webhooks-from-github-to-semaphore">webhooks</a>
to Semaphore.

  </p>
</details>

### How can I change timezone?

<details>
  <summary>Click for details</summary>
  <p>

The default timezone in the virtual machine is set to UTC.
The timezone can be changed in 2 ways:

- Assign a different value to <code>TZ</code> environment variable:
```bash
export TZ=Europe/Belgrade
```
- Create a symlink in <code>/etc/localtime</code> to one of the available timezones:
```bash
sudo ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
```
  </p>
</details>

### How can I build a project with git submodules?

<details>
  <summary>Click for details</summary>
  <p>

- Add the following commands as a <a href="https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-prologue-property">prologue</a>:
```bash
git submodule init
git submodule update
```
- Add the following command as an <a href="https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-epilogue-property">epilogue</a>:
```bash
git submodule deinit --force .
```
Make sure that Semaphore has permissions to clone your submodules repository.
You can find more information about setting permissions for private repositories on our <a href="https://docs.semaphoreci.com/essentials/using-private-dependencies/">private dependencies</a> page.
  </p>
</details>

### How can I use a self-signed certificate with a private Docker registry?

<details>
  <summary>Click for details</summary>
  <p>

If you have a private Docker registry that uses a self-signed SSL certificate
and pulling the Docker images does not work, the solution is to:
</p>
<p>
  
- Add a self-signed certificate as a <a href="https://docs.semaphoreci.com/essentials/using-secrets/">secret</a> on Semaphore
<br>- Save it under the name domain.crt
<br>- Add the following command to your pipeline:
```bash
sudo mv $SEMAPHORE_GIT_DIR/domain.crt /etc/docker/certs.d/myregistrydomain.com:5000/ca.crt
```
</p>  
<p>
  
This will allow a connection to a private remote registry using the self-signed certificate.
  </p>
</details>

### Is it possible to attach to an ongoing SSH session?

<details>
  <summary>Click for details</summary>
  <p>

It's possible to use <a href="https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-attach">sem attach</a> to an ongoing SSH session, but you need to attach to the job ID of the SSH session.
To get the job ID, you can use <code>sem get jobs</code> to get a list of all running jobs.
 </p>
</details>

### Why are my secrets empty?

<details>
  <summary>Click for details</summary>
  <p>

We have discontinued exposing secret content via the CLI, API, and web interface to ensure enhanced security measures. Retrieval of secret values is now exclusively available through the job mechanism.

 </p>
</details>

### How can I change the Postgres locale?

<details>
  <summary>Click for details</summary>
  <p>
    
Semaphore uses <code>sem-service</code> to provide different versions of databases. The <code>sem-service</code> tool uses Docker containers instead of traditional Linux services. 
So, the traditional way of changing locales no longer works, as it does not affect containers.
<br>
<br>The following recipe provides an altered version of the container to <code>sem-service</code>. 
The database should be available as before, without modifying your application in any way:
</p>
<p>
  
1. Create a Dockerfile with the following:
```
FROM postgres:9.6
RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8
ENV LANG pt_BR.UTF-8
```
2. Rebuild the Postgres image using the locale:
```
docker build - -t postgres:[lang] < Dockerfile
```
3. Start the newly-created image:
```
docker run --rm --net host -d -e POSTGRES_PASSWORD=semaphore --name postgres -v /var/run/postgresql:/var/run/postgresql postgres:[lang]
```
</p>
</details>

### How can I remove Semaphore Status checks on pull requests?

<details>
  <summary>Click for details</summary>
  <p>
    
You can disable Semaphore as a required status check on the <a href="https://docs.github.com/en/github/administering-a-repository/enabling-required-status-checks">repository settings page</a> of your GitHub account.
  
  </p>  
</details>

### How can I troubleshoot a stalling job?

<details>
  <summary>Click for details</summary>
  <p>

The most common reason for stalled builds is a process that refuses to shut down properly.
This is most likely a debug statement or a cleanup procedure in the catch procedure. 
Reproducing this can be hard sometimes. These are the steps we recommend:
</p>
1. Start a build on a branch and let it become stale.
<br>2. <a href="https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-attach">Attach</a> the following to a running job: <code>sem attach [job-id]</code>.
<br>3. Now, you should be in the instance of the job's virtual machine.
<p>
  
In the running instance, you can:
</p>
<p>
- List the running processes with <code>ps aux</code> or <code>top</code>. Are there any suspicious processes running?
<br>- Run a <code>strace</code> on the running process: <code>sudo strace -p <process-id></code> 
  to see the last kernel instruction that it is waiting for. 
For example, <code>select(1, ...</code> can mean that the process is waiting for user input.
<br>- Check the system metrics at <code>/tmp/system-metrics</code>. This tracks memory and disk usage. 
Lack of disk space or free memory can result in stalling.
<br>- Check the Agent logs at <code>/tmp/agent_logs</code>. The logs could indicate that an agent is waiting for certain conditions.
<br>- Check the Job logs at <code>/tmp/job_logs.json</code>. The logs could indicate that a job is waiting for certain conditions.
<br>- Check the syslog as it can be also a valuable source of information: <code>tail /var/log/syslog</code>. It can indicate 'Out of memory' conditions.
</p>
<p>
While an issue is ongoing, you might consider using a shorter <code>execution_time_limit</code> in your pipelines. 
This will prevent stale builds from running for a full hour.

  </p>  
</details>

### Why is my test suite failing if all the tests passed?

<details>
  <summary>Click for details</summary>
  <p>
    
 This usually happens because of code coverage tools, e.g. <a href="https://github.com/simplecov-ruby/simplecov">simplecov</a>, which can be set to fail the test suite if a <a href="https://github.com/simplecov-ruby/simplecov#minimum-coverage">minimum coverage level is not achieved</a>.
 <br>
 Furthermore, some dependencies can configure an <a href="https://relishapp.com/rspec/rspec-core/v/2-99/docs/command-line/exit-status#exit-with-rspec's-exit-code-when-an-at-exit-hook-is-added-upstream">at_exit hook</a> that will change the final exit code of the suite.
  
  </p>  
</details>

### How can I avoid a "fatal: expected flush after ref listing" error?

<details>
  <summary>Click for details</summary>
    <p>
      
If a commands fails with this:
```
error: RPC failed; curl 18 transfer closed with outstanding read data remaining
fatal: expected flush after ref listing
```
It means that communication between Semaphore and Github was interrupted. 
As a workaround, you can add <code>retry</code> to the failed command:
```bash
retry -t 5 <command>
```
You can find more information about the <code>retry</code> tool <a href="https://docs.semaphoreci.com/reference/toolbox-reference/#retry">here</a>. 
    </p>
</details>

### Why are tests passing locally but not on Semaphore?

<details>
  <summary>Click for details</summary>
  <p>

The main reason for this behavior is differences in the stacks. As a first step, ensure that the same versions of languages, services, tools, and frameworks such as Selenium, browser drivers, Capybara, Cypress are used both locally and in the CI environment.
To achieve this, use <a href="https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/">sem-service</a>, <a href="https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/">sem-version</a>, and the operating systems' package manager.
Environment variables can also lead to unexpected behaviors, for instance, Semaphore will set <code>CI=true</code> by default.

  </p>

<p>
If you are using Docker containers when performing tests, it's possible that, while the command itself runs instantly,
the process will not be completely started, leading to certain endpoints not being available. Using a minimum <code>sleep 10</code> can help in this scenario.
Cypress has a <a href="https://docs.cypress.io/guides/continuous-integration/introduction.html#Boot-your-server">wait-on module</a> that provides similar functionality.

</p>
Finally, when tests have different outcomes between reruns, using the same commit or in an <a href="https://docs.semaphoreci.com/essentials/debugging-with-ssh-access/">SSH session</a>,
then this is a case of flaky tests. The following articles should be of help:
<br>
<a href="https://semaphoreci.com/community/tutorials/how-to-deal-with-and-eliminate-flaky-tests">https://semaphoreci.com/community/tutorials/how-to-deal-with-and-eliminate-flaky-tests</a>
<br>
<a href="https://semaphoreci.com/blog/2017/08/03/tips-on-treating-flakiness-in-your-test-suite.html">https://semaphoreci.com/blog/2017/08/03/tips-on-treating-flakiness-in-your-test-suite.html</a>
<p>

</p>
</details>

### How can I insert multiline commands?

<details>
  <summary>Click for details</summary>
    <p>
You can divide a command into several lines by writing them in the folded 
style <code>></code> and by stripping the line break in the yaml file
<code>-</code>. To do this, we can start the command with a line containing only
<code>>-</code> and write the command in multiple lines below it:
```bash
commands:
  - >-
    if [ "foo" = "foo" ];
    then commands...;
    else commands...;
    fi;
```

    </p>
    <p>
Block Style Indicator: The block style indicates how new lines inside the block 
should behave. If you want to keep each line as a new line, use the literal style, 
indicated by a pipe <code>|</code>. If you want them to be replaced by 
spaces instead, use the folded style, indicated by a right angle bracket <code>></code>.
    </p>
    <p>
Block Chomping Indicator: The chomping indicator controls what should happen 
with new lines at the end of the string. The default, clip, puts a single new 
line at the end of the string. To remove all new lines, strip them by putting a 
minus sign <code>-</code> after the style indicator. Both clip and strip ignore how many new 
lines are actually at the end of the block; to keep them all, put a plus sign <code>+</code>
after the style indicator.
    </p>

</details>

### Why won't my jobs start?

 <details>
 <summary>Click for details</summary>
  <p>

You might be hitting the quota limitation. Check your organization's quota
in the <code>Activity Monitor</code> by clicking on your organization's initials 
in the top right corner of the page. Find more information about the quota and how to ask for 
an increase <a href="https://docs.semaphoreci.com/reference/quotas-and-limits/">here</a>.

You can also run <code>sem get jobs</code> to display all running jobs
to confirm how much of the quota is being used.
More information about <code>sem get</code> can be found <a href="https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-get-examples">here</a>.
  </p>
</details>

### Why did my job break after changing the shell configuration?

<details>
  <summary>Click for details</summary>
  <p>

Adding any of the following to your shell is not supported and will cause the jobs to immediately fail:
```bash
set -e
set -o pipefail
set -euxo pipefail
```
  </p>
  <p>

This also applies when sourcing a script that contains the previous settings:
```bash
source ~/my_script
. ~/my_script
```
  </p>
</details>

### Why does my job fail when I specify "exit 0"  in commands?

<details>
  <summary>Click for details</summary>
  <p>

Using the <code>exit</code> command closes the PTY and causes the job to fail. If this isn't the desired behavior, you can use the <code>return 130</code> command with different <code>SEMAPHORE_JOB_RESULT</code> environmental variables to specify the desired behaviour:
</p>
<p>
<br>- Stopped job: <code>return 130</code>
<br>- Stopped job, but marked as successful: <code>export SEMAPHORE_JOB_RESULT=passed</code> then <code>return 130</code>
<br>- Stopped job, but marked as failed: <code>export SEMAPHORE_JOB_RESULT=failed</code> then <code>return 130</code>
</p>
Please note that some commands like <code>bash -e</code> or <code>set -x otrace</code> may override this behavior and make it not function correctly.

</details>

### Why are my workflows not running in parallel?

<details>
  <summary>Click for details</summary>
  <p>

When pushing several commits into the same branch, Semaphore won't run parallel workflows. This means that pushing multiple times into a branch won't create parallel workflows, rather Semaphore will assign the new workflows into the queue and run them one at a time. However, it's possible to push commits to different branches and they will be run in parallel.
</p>
<p>
  
The only way to push several commits to a single branch and not wait for the workflows to finish one by one is to enable the <a href="https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/">auto_cancel</a> feature.
</p>
</details>

### How can I redeliver webhooks from Github to Semaphore?

<details>
  <summary>Click for details</summary>
  <p>

This is not the most common problem, but occasionally Semaphore does not receive a webhook from Github for some reason.
This results in a workflow not being triggered. You can redeliver the webhook, however, and this should trigger the workflow.
These are the steps to redeliver webhooks from Github:
</p>
<p>

1. Go to your repository on GitHub
<br>2. Click <code>Settings</code>
<br>3. Click <code>Webhooks</code>
<br>4. Click <code>Edit</code> for the webhook you want to redeliver
<br>5. Scroll down to <code>Recent Deliveries</code> and search for the one that failed
<br>6. Click the <code>...</code> symbol, then click <code>Redeliver</code>
</p>
</details>

### Why did my workflow stop without explanation?

<details>
  <summary>Click for details</summary>
  <p>

The workflow might have been stopped by the <a href="https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/">auto_cancel</a> feature. There are two <code>auto-cancel</code> strategies: <i>running</i> and <i>queued</i>.
<br>
<br>The <i>running</i> strategy stops all pipelines in the queue as soon as a new one appears.
<br>
<br>The <i>queued</i> strategy will only cancel pipelines that are waiting in the queue and have not yet started.
</p>
</details>

### What can I use to split my parallel tests?

<details>
  <summary>Click for details</summary>
  <p>

We recommend using <a href="https://docs.semaphoreci.com/programming-languages/ruby/#running-rspec-and-cucumber-in-parallel">semaphore_test_boosters gem</a>. This gem spreads tests across parallel jobs based on a configuration file or uniform file distribution (default behavior). Execution time-based distribution is not supported yet. 
  </p>
  <p>
Other options are also supported, e.g. <a href="https://knapsackpro.com/">Knapsack</a> (both free and pro versions).
  </p>
  <p>
Knapsack Rspec example:
  
```yml
jobs:
  - name: Knapsack RSpec
    parallelism: 5
    commands:
      - CI_NODE_TOTAL=$SEMAPHORE_JOB_COUNT CI_NODE_INDEX=$((SEMAPHORE_JOB_INDEX-1)) bundle exec rake 'knapsack:rspec'
```
  </p>
  <p>
Knapsack Pro Rspec example:
  
```yml
jobs:
  - name: Knapsack Pro RSpec
    parallelism: 5
    commands:
      - bundle exec rake 'knapsack_pro:queue:rspec'
```
  </p>
  <p>
  <br>
  You can find a more detailed example in the <a href="https://github.com/KnapsackPro/knapsack_pro-ruby#semaphore-20">official documentation</a>.
  </p>
</details>

### Why aren't workflows triggering on pull requests?

<details>
  <summary>Click for details</summary>
  <p>
Make sure to <a href="https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/#build-pull-requests">enable pull requests</a> in the project <code>Settings</code>.
</p><p>
If the configuration is correct, check if the pull request can be merged or if there are conflicts.<br>
Semaphore uses the merge commit to run the workflows, so there will be no merge commit if there is a conflict in the pull request.<br>
  </p>
</details>

### How can I use different machines in the same pipeline?

<details>
  <summary>Click for details</summary>
  <p>
In certain scenarios, it's advantageous to use different machine types for different jobs in a pipeline. 
For instance, some operations require fewer resources and it would be wasteful to use a bigger machine 
or a test suite that has to run in multiple environments.
  </p>
  <p>
Semaphore provides the <a href="https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#agent-in-task">agent in task feature</a> that allows mixing and matching of various machine types and even 
<a href="https://docs.semaphoreci.com/ci-cd-environment/custom-ci-cd-environment-with-docker/#using-a-docker-container-as-your-pipelines-cicd-environment">Docker-based CI/CD</a>:
<br>
```yml
version: v1.0
name: Tests
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: 'MacOS tests'
    task:
      agent:
        machine:
          type: a1-standard-4
          os_image: macos-xcode14
      jobs:
        - name: 'MacOS test'
          commands:
            - echo 'Testing MacOS'

  - name: Docker tests
    task:
      agent:
        machine:
          type: e1-standard-4
        containers:
          - name: main
            image: 'registry.semaphoreci.com/ruby:2.6'
      jobs:
        - name: Docker test
          commands:
            - echo 'Testing Docker'
  - name: Ubuntu tests
    task:
      jobs:
        - name: Ubuntu test
          commands:
            - echo 'Testing Ubuntu'
```
  </p>
</details>
### Why does my code contain tags that have already been deleted?

<details>
  <summary>Click for details</summary>
  <p>
When using <code>checkout</code> with the 
<a href="https://docs.semaphoreci.com/reference/toolbox-reference/#the-use-cache-flag">--use-cache parameter</a>
the code will contain older changes that have not yet been propagated, because this particular update only happens every 3 days by default.

  </p>
  <p>
Reducing the value of <code>SEMAPHORE_GIT_CACHE_AGE</code> before performing the
<code>checkout</code> ensures that changes are brought into the cache more 
often and should help mitigate this behavior:
```bash
export SEMAPHORE_GIT_CACHE_AGE=43200
```

The previous value is for 12 hours and is a good baseline but, depending on 
your development workflow, it might need to be lowered more.
  </p>
</details>

### Why is my Heroku deployment timing out?

<details>
  <summary>Click for details</summary>
  <p>
    Deploying to Heroku might timeout at the authentication step. 
    If this occurs, the <code>.netrc</code> file might have expired.
  </p>
  <p> 
  In this case, we recommend to regenerate the file and recreate the <a href="https://docs.semaphoreci.com/essentials/using-secrets/">secret</a>. 
  </p>
  </details>
  
### How to comment on Github's pull requests from a workflow?

<details>
  <summary>Click for details</summary>
  <p>
    You can use the <a href="https://docs.github.com/en/rest/reference/issues#create-an-issue-comment">Github API</a> to comment on pull requests. 
    An example is shown below:

```bash
curl -X POST -H "Authorization: token <OAUTH_TOKEN>" https://api.github.com/repos/<owner>/<repo-name>/issues/<number>/comments -d '{"body":"body"}'
```
  </p>  
</details>

### Why are you still charging my old credit card when I added a new default credit card?

<details>
  <summary>Click for details</summary>
  <p>

If you’ve added a new credit card to the subscription, but the old one is still being charged,
it means that the new credit card wasn't properly marked for usage. Here’s how to do that:
</p>
<p>
  
1. Click on the initials of your organization in the top right corner of the page, 
<br>2. In the dropdown menu, choose <code>Plans & Billing</code>,
<br>3. Next to Payment details, click on <code>Credit card info</code>,
<br>4. Go to the <code>Subscription</code> tab
<br>5. Click on <code>Manage</code>
<br>6. Go to <code>Update Payment Method</code>
<br>7. Click the <code>Use this</code> button next to the credit card you'd like to use
</p>
<p>
After that, you can also remove the old credit card if you don't need it anymore.
</p>
</details>

### Why can't I remove my old credit card after adding a new one?

<details>
  <summary>Click for details</summary>
  <p>

If you run into this situation, it means that the old credit card is still in use.
In order to mark the new credit card for usage, you can:
</p>
<p>
  
1. Click on the initial of your organization in the top right corner of the page, 
<br>2. In the dropdown menu, choose <code>Plans & Billing</code>
<br>3. Next to the Payment details, click on <code>Credit card info</code>,
<br>4. Go to the <code>Subscription</code> tab
<br>5. Click on <code>Manage</code> 
<br>6. Go to <code>Update Payment Method</code> 
<br>7. Click on the <code>Use this</code> button next to the credit card you'd like to use
</p>
<p>
  
After that, you’ll be able to remove the old credit card.
</p>
</details>

### How can I add repositories that belong to my GitHub organization?

<details>
  <summary>Click for details</summary>
  <p>

In order to be able to do that, Semaphore needs to be granted access within your GitHub organization.
You can grant access <a href="https://github.com/settings/applications">here</a>. If it has already been granted, there should be a green checkmark next to the name of your organization.
</p>
<p>
If not, you should either grant access or request it from the organization's owner.
</p>
</details>

### Can I use YAML anchors in Semaphore?

<details>
  <summary>Click for details</summary>
  <p>

Yes, Semaphore's YAML processing system works with [YAML version 1.2](https://yaml.org/) and it accepts all official YAML features. 
Below, a working code example of using anchors and aliases:

```
version: v1.0
name: Aliases test
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu2004
blocks:
  - name: Block 1
    task:
      prologue: &common_prologue
        commands:
          - echo hello
      jobs:
        - name: Job 1
          commands:
            - echo hello1
  - name: Block 2
    task:
      prologue: *common_prologue
      jobs:
        - name: Job 2
          commands:
            - echo hello2
  - name: Block 3
    task:
      jobs:
        - name: Job 3
          commands:
            - echo hello3
```    

The [global_job_config](https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#global_job_config) property can work as a complement. It enables you to choose a set of configurations that are shared across the whole pipeline and define it in one place instead of having to repeat it in every task separately.

</p>
</details>


[prologue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-prologue-property
[epilogue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-epilogue-property
[private-dependencies]: https://docs.semaphoreci.com/essentials/using-private-dependencies/
[secret]: https://docs.semaphoreci.com/essentials/using-secrets/
[auto-cancel]: https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/
[sem-attach]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-attach
[test-boosters]: https://docs.semaphoreci.com/programming-languages/ruby/#running-rspec-and-cucumber-in-parallel
