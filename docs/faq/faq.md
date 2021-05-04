---
description: Frequently asked questions are the common situations we stumble upon regularly, across all parts of Semaphore 2.0.
---

# Frequently asked questions

<p>Issues we stumble upon regularly, across all parts of Semaphore 2.0</p>

### Troubleshooting

<details>
  <summary id="how-to-solve-fail-could-not-parse-object-during-bundle-install">How to solve "Fail: Could not parse object" during bundle install?</summary>
  <p>

If the <code>bundle install</code> output looks like this:
```bash
Fetching gem metadata from http://rubygems.org/.......
Fetching gem metadata from http://rubygems.org/..
Updating git://github.com/some/gem.git
fatal: Could not parse object 'a84dd3407eaf064064cca9650c354cb163384467'.
Git error: command <code>git reset --hard a84dd3407eaf064064cca9650c354cb163384467</code> in directory /home/runner/somehash/vendor/bundle/ruby/1.9.1/bundler/gems/gem-a84dd3407eaf has failed.
If this error persists you could try removing the cache directory '/home/runner/somehash/vendor/bundle/ruby/1.9.1/cache/bundler/git/gem-cbe2ee16ed53098079007f06cd77ed0890d0d752'
```

This problem occurs when there have been changes like
force-pushes to a git repo which is referenced in a Gemfile.
You can solve it by following these steps:
</p>
<p>

- Comment that gem line in the Gemfile
<br>- Run <code>bundle install</code>
<br>- Uncomment the gem line in the Gemfile
<br>- Run <code>bundle install</code> again
</p>
<p>
  
The Gemfile.lock will now reference a valid git revision.
  </p>
</details>

<details>
  <summary id="how-to-change-the-timezone">How to change the timezone?</summary>
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

<details>
  <summary id="how-to-build-with-git-submodules">How to build a project with git submodules?</summary>
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
In our <a href="https://docs.semaphoreci.com/essentials/using-private-dependencies/">private dependencies</a> page you can find more
information about setting permissions for private repositories.
  </p>
</details>

<details>
  <summary id="how-to-use-a-self-signed-certificate-with-private-docker-registry">How to use a self-signed certificate with private Docker registry?</summary>
  <p>

If you have a private Docker registry that uses a self-signed SSL certificate
and pulling the Docker images does not work. The solution is to:
</p>
<p>
  
- Add a self-signed certificate as a <a href="https://docs.semaphoreci.com/essentials/using-secrets/">secret</a> on Semaphore
<br>- Save it under the name of domain.crt
<br>- Add the following command to your pipeline:
```bash
sudo mv $SEMAPHORE_GIT_DIR/domain.crt /etc/docker/certs.d/myregistrydomain.com:5000/ca.crt
```
</p>  
<p>
  
This will allow the connection to a private remote registry using the self-signed certificate.
  </p>
</details>

<details>
  <summary id="is-it-possible-to-attach-to-an-ongoing-ssh-session">Is it possible to attach to an ongoing SSH session?</summary>
  <p>

It's possible to use <a href="https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-attach">sem attach</a> to an ongoing SSH session but you'd need to attach to the job ID of the SSH session.
To get the job ID you can use <code>sem get jobs</code> to get the list of all running jobs.
 </p>
</details>

<details>
  <summary id="how-to-change-the-postgres-locale">How to change the Postgres locale?</summary>
  <p>
    
Semaphore uses <code>sem-service</code> to provide different versions of databases. The <code>sem-service</code> tool uses Docker containers
instead of traditional Linux services. 
So, the traditional way of changing locales no longer works since it does not affect containers.
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
3. Start the newly created image:
```
docker run --rm --net host -d -e POSTGRES_PASSWORD=semaphore --name postgres -v /var/run/postgresql:/var/run/postgresql postgres:[lang]
```
</p>
</details>
<details>
  <summary id="how-can-i-remove-semaphore-status-checks-on-pull-requests">How can I remove Semaphore Status checks on pull requests?</summary>
  <p>
    
 You can disable Semaphore as a required status check through the <a href="https://docs.github.com/en/github/administering-a-repository/enabling-required-status-checks">repository settings page</a> in your GitHub account.
  
  </p>  
</details>

<details>
  <summary id="how-to-troubleshoot-a-stalling-job">How to troubleshoot a stalling job?</summary>
  <p>

The most common reason for stalled builds is a process that refuses to shut down properly.
Either a debug statement or a cleanup procedure in the catch procedure. 
Reproducing this can be hard sometimes. These are the steps we recommend:
</p>
1. Start a build on a branch and let it get stale.
<br>2. <a href="https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-attach">Attach</a> to a running job: <code>sem attach [job-id]</code>.
<br>3. Now, you should be in the instance of the job's virtual machine.
<p>
  
In the running instance, you can:
</p>
<p>
- List the running processes with <code>ps aux</code> or <code>top</code>. Is there any suspicious process running?
<br>- Run a <code>strace</code> on the running process: <code>sudo strace -p <process-id></code> 
  to see the last kernel instruction that it is waiting for. 
For example, <code>select(1, ...</code> can mean the process is waiting for user's input.
<br>- Look into the system metrics at <code>/tmp/system-metrics</code>. This tracks memory and disk usage. 
Lack of disk space or free memory can introduce unwanted stalling into jobs.
<br>- Look into the Agent logs at <code>/tmp/agent_logs</code>. The logs could indicate waiting for some conditions.
<br>- Look into the Job logs at <code>/tmp/job_logs.json</code>. The logs could also indicate waiting for some conditions.
<br>- Check the syslog as it can be also a valuable source of information: <code>tail /var/log/syslog</code>. It can indicate 'Out of memory' conditions.
</p>
<p>
While this issue is ongoing, you might consider using a shorter <code>execution_time_limit</code> in your pipelines. 
This will prevent stale builds to run for a full hour, and fail sooner.

  </p>  
</details>

<details>
  <summary id="why-is-my-test-suite-failing-if-all-the-tests-pass">Why is my test suite failing if all the tests pass?</summary>
  <p>
    
 This usually happens because code coverage tools, for instance <a href="https://github.com/simplecov-ruby/simplecov">simplecov</a>, can be set to fail the test
 suite if a <a href="https://github.com/simplecov-ruby/simplecov#minimum-coverage">minimum coverage is not achieved</a>.
 <br>
 Besides the above, some dependencies can configure an <a href="https://relishapp.com/rspec/rspec-core/v/2-99/docs/command-line/exit-status#exit-with-rspec's-exit-code-when-an-at-exit-hook-is-added-upstream">at_exit hook</a> and will change the final exit code of the suite.
  
  </p>  
</details>

<details>
  <summary id="how-to-solve-the-fatal-expected-flush-after-ref-listing-error">How to solve the "fatal: expected flush after ref listing" error?</summary>
    <p>
      
If a commands fails with this:
```
error: RPC failed; curl 18 transfer closed with outstanding read data remaining
fatal: expected flush after ref listing
```
It means the communication between Semaphore and Github was interrupted. 
As a workaround, you may add <code>retry</code> to the failed command:
```bash
retry -t 5 <command>
```
You may find more information about the <code>retry</code> tool <a href="https://docs.semaphoreci.com/reference/toolbox-reference/#retry">here</a>. 
    </p>
</details>
<details>
  <summary id="why-are-tests-passing-locally-but-not-on-semaphore">Why are tests passing locally but not on Semaphore?</summary>
  <p>

The main reason for this behavior is differences in the stacks. As a first step, ensure the same versions of languages, services, tools and frameworks
such as Selenium, browser drivers, Capybara, Cypress are used both locally and in the CI environment.
To achieve this make use of <a href="https://docs.semaphoreci.com/ci-cd-environment/sem-service-managing-databases-and-services-on-linux/">sem-service</a>
, <a href="https://docs.semaphoreci.com/ci-cd-environment/sem-version-managing-language-versions-on-linux/">sem-version</a> and also the operating systems' package manager.
Environment variables can also lead to unexpected behaviors, for instance, Semaphore 2.0 will set <code>CI=true</code> by default.

  </p>

<p>
If you are using Docker containers when performing the tests, in some cases it's possible that while the command itself runs instantly
the process will not be completely started, leading to certain endpoints not being available. Using <code>sleep 10</code> or a larger value
can help in this scenario.
Cypress has the <a href="https://docs.cypress.io/guides/continuous-integration/introduction.html#Boot-your-server">wait-on module</a> that provides a similar functionality.

</p>
Finally, when tests have different outcomes between reruns using the same commit or in an <a href="https://docs.semaphoreci.com/essentials/debugging-with-ssh-access/">SSH session</a>
then this is a case of flaky tests. The following articles should help in this regard:
<br>
<a href="https://semaphoreci.com/community/tutorials/how-to-deal-with-and-eliminate-flaky-tests">https://semaphoreci.com/community/tutorials/how-to-deal-with-and-eliminate-flaky-tests</a>
<br>
<a href="https://semaphoreci.com/blog/2017/08/03/tips-on-treating-flakiness-in-your-test-suite.html">https://semaphoreci.com/blog/2017/08/03/tips-on-treating-flakiness-in-your-test-suite.html</a>
<p>

</p>
</details>

<details>
  <summary id="how-can-i-insert-multiline-commands">How can I insert multiline commands?</summary>
    <p>
You can divide a command in several lines by writing the line in the folded 
style <code>></code> and by stripping the line break in the yaml file
<code>-</code>. To do this, we can start the command with line containing only
<code>>-</code> and write the command in more lines below it:
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
should behave. If you want to keep them as new lines, use the literal style, 
indicated by a pipe <code>|</code>. If instead you want them to be replaced by 
spaces, use the folded style, indicated by a right angle bracket <code>></code>.
    </p>
    <p>
Block Chomping Indicator: The chomping indicator controls what should happen 
with new lines at the end of the string. The default, clip, puts a single new 
line at the end of the string. To remove all new lines, strip them by putting a 
minus sign <code>-</code> after the style indicator. Both clip and strip ignore how many new 
lines are actually at the end of the block; to keep them all put a plus sign <code>+</code>
after the style indicator.
    </p>

</details>

### Jobs & Workflows

 <details>
 <summary id="why-my-jobs-dont-start">Why my jobs don't start?</summary>
  <p>

You might be hitting the quota limitation. Check your organization's quota
in the <code>Activity Monitor</code> by clicking on the initial of your organization 
in the top right corner of the page. More information about quota and how to ask for 
an increase <a href="https://docs.semaphoreci.com/reference/quotas-and-limits/">here</a>.

You may also run <code>sem get jobs</code> to display all running jobs
so you may confirm how much quota is being used.
More information about <code>sem get</code> <a href="https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-get-examples">here</a>.
  </p>
</details>

<details>
  <summary id="why-does-my-job-break-after-changing-the-shell-configuration">Why does my job break after changing the shell configuration?</summary>
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

<details>
  <summary id="why-are-my-workflows-not-running-in-parallel">Why are my workflows not running in parallel?</summary>
  <p>

When pushing several commits into the same branch, Semaphore won't run parallel workflows. This means that pushing several times into a branch won't create parallel workflows, instead, Semaphore assigns the new workflows to the queue and run one workflow at a time. However, it's possible to push commits to different branches and they will be run in parallel.
</p>
<p>
  
The only way to push several commits to a single branch and not wait for the workflows to finish one by one is to enable the <a href="https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/">auto_cancel</a> feature.
</p>
</details>

<details>
  <summary id="how-to-redeliver-webhooks-from-github-to-semaphore">How to redeliver webhooks from Github to Semaphore?</summary>
  <p>

Even if this is not a common problem, it might happen that Semaphore does not receive a webhook from Github.
This results in a workflow not being triggered. You can redeliver the webhook and this should trigger the workflow.
These are the steps to redeliver webhooks from Github:
</p>
<p>

1. Go to your repository on GitHub
<br>2. Click <code>Settings</code>
<br>3. Click <code>Webhooks</code>
<br>4. Click <code>Edit</code> for the webhook you want to redeliver
<br>5. Scroll down to <code>Recent Deliveries</code> and search for the failed one
<br>6. Click the <code>...</code> symbol, then click <code>Redeliver</code>
</p>
</details>

<details>
  <summary id="why-does-my-workflow-stop-without-explanation">Why does my workflow stop without explanation?</summary>
  <p>

The workflow might have been stopped by the <a href="https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/">auto_cancel</a> feature. There are two <code>auto-cancel</code> strategies: <i>running</i> and <i>queued</i>.
<br>
<br>The <i>running</i> strategy stops all pipelines in the queue as soon as a new one appears.
<br>
<br>The <i>queued</i> strategy will only cancel pipelines that are waiting in the queue and have not yet started to run.
</p>
</details>

<details>
  <summary id="what-can-i-use-to-split-my-parallel-tests">What can I use to split my parallel tests?</summary>
  <p>

The recommended way is by using the <a href="https://docs.semaphoreci.com/programming-languages/ruby/#running-rspec-and-cucumber-in-parallel">semaphore_test_boosters gem</a>. Other options are also supported, for instance <a href="https://knapsackpro.com/">Knapsack</a>, both free and pro versions.
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

<details>
  <summary id="why-workflows-dont-trigger-on-pull-requests">Why workflows don't trigger on pull requests?</summary>
  <p>
Make sure to <a href="https://docs.semaphoreci.com/essentials/project-workflow-trigger-options/#build-pull-requests">enable pull requests</a> in the project <code>Settings</code>.
</p><p>
If the configuration is correct, check if the pull request can be merged, or if there are conflicts.<br>
Semaphore uses the merge commit to run the workflows and there is no merge commit if there is a conflict on the pull request.<br>
  </p>
</details>

### Billing

<details>
  <summary id="why-are-you-still-charging-my-old-credit-card-when-i-added-a-new-default-credit-card">Why are you still charging my old credit card when I added a new default credit card?</summary>
  <p>

If you’ve added a new credit card to the subscription, but the old one is still being charged,
it means that the new credit card wasn't marked for usage. Here’s how to do that:
</p>
<p>
  
1. Click on the initial of your organization in the top right corner of the page, 
<br>2. In the dropdown menu, choose <code>Plans & Billing</code>,
<br>3. Next to the Payment details, click on <code>Credit card info</code>,
<br>4. Go to <code>Subscription</code> tab
<br>5. Click on <code>Manage</code>
<br>6. Go to <code>Update Payment Method</code>
<br>7. Click on the <code>Use this</code> button next to the credit card you'd like to use
</p>
<p>
After that, you can also remove the old credit card if you don't need it anymore.
</p>
</details>

<details>
  <summary id="why-cant-i-remove-the-old-credit-card-after-adding-a-new-one">Why can't I remove the old credit card after adding a new one?</summary>
  <p>

If you run into this situation, it means that the old credit card is still in use.
In order to mark the new credit card for usage, you can:
</p>
<p>
  
1. Click on the initial of your organization in the top right corner of the page, 
<br>2. In the dropdown menu, choose <code>Plans & Billing</code>
<br>3. Next to the Payment details, click on <code>Credit card info</code>,
<br>4. Go to <code>Subscription</code> tab
<br>5. Click on <code>Manage</code> 
<br>6. Go to <code>Update Payment Method</code> 
<br>7. Click on the <code>Use this</code> button next to the credit card you'd like to use
</p>
<p>
  
After that, you’ll be able to remove the old credit card.
</p>
</details>

### Account management

<details>
  <summary id="how-can-i-add-repositories-that-belong-to-my-github-organization">How can I add repositories that belong to my GitHub organization?</summary>
  <p>

In order to be able to do that, the access for Semaphore 2.0 needs to be granted within your GitHub organization.
You can grant the access <a href="https://github.com/settings/applications">here</a>. If it has already been granted, there should be a green checkmark next to the name of your organization.
</p>
<p>
If not, you should either grant access or request it from the organization's owner.
</p>
</details>

[prologue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-prologue-property
[epilogue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-epilogue-property
[private-dependencies]: https://docs.semaphoreci.com/essentials/using-private-dependencies/
[secret]: https://docs.semaphoreci.com/essentials/using-secrets/
[auto-cancel]: https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/
[sem-attach]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-attach
[test-boosters]: https://docs.semaphoreci.com/programming-languages/ruby/#running-rspec-and-cucumber-in-parallel
