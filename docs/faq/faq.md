---
description: Frequently asked questions are the common situations we stumble upon regularly, across all parts of Semaphore 2.0.
---

# Frequently asked questions

<p>Issues we stumble upon regularly, across all parts of Semaphore 2.0</p>

<!-- <table>
  <thead>
    <tr>
      <th>Troubleshooting</th>
      <th>Jobs & Workflows</th>
    </tr>
  </thead>
  <tbody>
  <tr>
    <td><a href="#fail-could-not-parse-object">How to solve "Fail: Could not parse object" during bundle install?</a></td>
    <td><a href="#why-my-jobs-dont-start">Why my jobs don't start?</a></td>
  </tr>
  <tr>
    <td><a href="#how-to-change-the-timezone">How to change the timezone?</a></td>
    <td><a href="#shell-configuration">Why does my job break after changing the shell configuration?</a></td>
  </tr>
  <tr>
    <td><a href="#how-to-build-with-git-submodules">How to build a project with git submodules?</a></td>
    <td><a href="#workflows-parallel">Why are my workflows not running in parallel?</a></td>
  </tr>
  <tr>
    <td><a href="#self-signed-certificate">How to use a self-signed certificate with private Docker registry?</a></td>
  </tr>
  <tr>
    <td><a href="#attach-to-ssh-session">Is it possible to attach to an ongoing SSH session?</a></td>
  </tr>
  <tr>
    <th>Billing</th>
    <th>Account management</th>
  </tr>
  <tr>
    <td><a href="#replace-old-credit">How can I correctly replace the old credit card with the new one?</a></td>
    <td><a href="#add-repositories-github">How can I add repositories that belong to my GitHub organization?</a></td>
  </tr>
  <tr>
    <td><a href="#remove-old-card">How to remove the old credit card information from the subscription?</a></td>
  </tr>
  </tbody>
</table> -->

### Troubleshooting

<details>
  <summary id="fail-could-not-parse-object">How to solve "Fail: Could not parse object" during bundle install?</summary>
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
  <summary id="self-signed-certificate">How to use a self-signed certificate with private Docker registry?</summary>
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
  <summary id="attach-to-ssh-session">Is it possible to attach to an ongoing SSH session?</summary>
  <p>

It's possible to use <a href="https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-attach">sem attach</a> to an ongoing SSH session but you'd need to attach to the job ID of the SSH session.
To get the job ID you can use <code>sem get jobs</code> to get the list of all running jobs.
 </p>
</details>

<details>
  <summary id="change-locale">How to change the Postgres locale?</summary>
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
  <summary id="remove-status-checks-in-pull-requests">How can I remove Semaphore Status checks on pull requests?</summary>
  <p>
    
 You can disable Semaphore as a required status check through the <a href="https://docs.github.com/en/github/administering-a-repository/enabling-required-status-checks">repository settings page</a> in your GitHub account.
  
  </p>  
</details>

<details>
  <summary id="troubleshoot-a-stalling-job">How to troubleshoot a stalling job?</summary>
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
  <summary id="test-suite-failing-tests-pass">Why is my test suite failing if all the tests pass?</summary>
  <p>
    
 This usually happens because code coverage tools, for instance <a href="https://github.com/simplecov-ruby/simplecov">simplecov</a>, can be set to fail the test
 suite if a <a href="https://github.com/simplecov-ruby/simplecov#minimum-coverage">minimum coverage is not achieved</a>.
 <br>
 Besides the above, some dependencies can configure an <a href="https://relishapp.com/rspec/rspec-core/v/2-99/docs/command-line/exit-status#exit-with-rspec's-exit-code-when-an-at-exit-hook-is-added-upstream">at_exit hook</a> and will change the final exit code of the suite.
  
  </p>  
</details>

<details>
  <summary id="network-issue-github">How to solve the "fatal: expected flush after ref listing" error?</summary>
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
You may find more information about the retry tool here: https://docs.semaphoreci.com/reference/toolbox-reference/#retry.
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
  <summary id="shell-configuration">Why does my job break after changing the shell configuration?</summary>
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
  <summary id="workflows-parallel">Why are my workflows not running in parallel?</summary>
  <p>

When pushing several commits into the same branch, Semaphore won't run parallel workflows. This means that pushing several times into a branch won't create parallel workflows, instead, Semaphore assigns the new workflows to the queue and run one workflow at a time. However, it's possible to push commits to different branches and they will be run in parallel.
</p>
<p>
  
The only way to push several commits to a single branch and not wait for the workflows to finish one by one is to enable the <a href="https://docs.semaphoreci.com/essentials/auto-cancel-previous-pipelines-on-a-new-push/">auto_cancel</a> feature.
</p>
</details>

### Billing

<details>
  <summary id="replace-old-credit">Why are you still charging my old credit card when I added a new default credit card?</summary>
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
  <summary id="remove-old-card">Why can't I remove the old credit card after adding a new one?</summary>
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
  <summary id="add-repositories-github">How can I add repositories that belong to my GitHub organization?</summary>
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
