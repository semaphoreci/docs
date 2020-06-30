# Frequently asked questions

<!-- markdownlint-disable -->
<table>
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
</table>  
 
### Troubleshooting
 
<details>
  <summary id="fail-could-not-parse-object">How to solve "Fail: Could not parse object" during bundle install?</summary>
  <p>
    
If the `bundle install` output looks like this:
```bash
Fetching gem metadata from http://rubygems.org/.......
Fetching gem metadata from http://rubygems.org/..
Updating git://github.com/some/gem.git
fatal: Could not parse object 'a84dd3407eaf064064cca9650c354cb163384467'.
Git error: command `git reset --hard a84dd3407eaf064064cca9650c354cb163384467` in directory /home/runner/somehash/vendor/bundle/ruby/1.9.1/bundler/gems/gem-a84dd3407eaf has failed.
If this error persists you could try removing the cache directory '/home/runner/somehash/vendor/bundle/ruby/1.9.1/cache/bundler/git/gem-cbe2ee16ed53098079007f06cd77ed0890d0d752'
```
    
This problem occurs when there have been changes like 
force-pushes to a git repo which is referenced in a Gemfile. 
You can solve it by following these steps:
- Comment that gem line in the Gemfile
- Run `bundle install`
- Uncomment the gem line in the Gemfile
- Run `bundle install` again

The Gemfile.lock will now reference a valid git revision.
  </p>
</details>

<details>
  <summary id="how-to-change-the-timezone">How to change the timezone?</summary>
  <p>
    
The default timezone in the virtual machine is set to UTC. 
The timezone can be changed in 2 ways:

- Assign a different value to `TZ` environment variable: 
```bash
export TZ=Europe/Belgrade
```
- Create a symlink in `/etc/localtime` to one of the available timezones:
```bash
sudo ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
```
  </p>
</details>

<details>
  <summary id="how-to-build-with-git-submodules">How to build a project with git submodules?</summary>
  <p>

- Add the following commands as a [prologue][]:
```bash
git submodule init
git submodule update
```
- Add the following command as an [epilogue][]:
```bash
git submodule deinit --force .
```
Make sure that Semaphore has permissions to clone your submodules repository. 
In our [private dependencies][private-dependencies] page you can find more
information about setting permissions for private repositories.
  </p>
</details>

<details>
  <summary id="self-signed-certificate">How to use a self-signed certificate with private Docker registry?</summary>
  <p>

If you have a private Docker registry that uses a self-signed SSL certificate 
and pulling the Docker images does not work. The solution is to:

- Add a self-signed certificate as a [secret][] on Semaphore
- Save it under the name of domain.crt
- Add the following command to your pipeline
```bash
sudo mv $SEMAPHORE_GIT_DIR/domain.crt /etc/docker/certs.d/myregistrydomain.com:5000/ca.crt
```
This will allow the connection to a private remote registry using the self-signed certificate.
  </p>
</details>

<details>
  <summary id="attach-to-ssh-session">Is it possible to attach to an ongoing SSH session?</summary>
  <p>
    
It's possible to use [sem attach][sem-attach] to an ongoing SSH session but you'd need to attach to the job ID of the SSH session. 
To get the job ID you can use `sem get jobs` to get the list of all running jobs.

 </p>
</details>


### Jobs & Workflows

 <details>
 <summary id="why-my-jobs-dont-start">Why my jobs don't start?</summary>
  <p>
    
You might be hitting the quota limitation. Check your organization's quota
in Billing > See detailed insights… > Quota. More information about quota 
and how to ask for an increase here: 
https://docs.semaphoreci.com/article/133-quotas-and-limits.

You may also run `sem get jobs` to display all running jobs 
so you may confirm how much quota is being used. 
More information about `sem get`: 
https://docs.semaphoreci.com/article/53-sem-reference#sem-get-examples.
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

The only way to push several commits to a single branch and not wait for the workflows to finish one by one is to enable the [auto_cancel][auto-cancel] feature.

</p>
</details>

### Billing

<details>
  <summary id="replace-old-credit">How can I correctly replace the old credit card with the new one?</summary>
  <p>
    
If you’ve added a new credit card to the subscription, but the old one is still being charged, 
it means that the new credit card wasn't marked for usage. Here’s how to do that:

1. Go to `Billing`,
2. Click on `Credit card and Billing info...`
3. Go to `Subscription` tab,
4. Click on `Manage`,
5. Go to `Update Payment Method`,
6. Click on the `Use this` button next to the credit card you'd like to use.

After that, you can also remove the old credit card if you don't need it anymore.
</p>
</details>

<details>
  <summary id="remove-old-card">How to remove the old credit card information from the subscription?</summary>
  <p>

If you run into this situation, it means that the old credit card is still in use. 
In order to mark the new credit card for usage, you can:

1. Go to `Billing`,
2. Click on `Credit card and Billing info...`
3. Go to `Subscription` tab,
4. Click on `Manage`,
5. Go to `Update Payment Method`,
6. Click on the `Use this` button next to the credit card you'd like to use.

After that, you’ll be able to remove the old credit card.

</p>
</details>

### Account management

<details>
  <summary id="add-repositories-github">How can I add repositories that belong to my GitHub organization?</summary>
  <p>
    
In order to be able to do that, the access for Semaphore 2.0 needs to be granted within your GitHub organization. 
You can grant the access [here](https://github.com/settings/connections/applications/328c742132e5407abd7d). If it has already been granted, there should be a green checkmark next to the name of your organization. 
If not, you should either grant access or request it from the organization's owner.    

</p>
</details>

[prologue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-prologue-property
[epilogue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-epilogue-property
[private-dependencies]: https://docs.semaphoreci.com/essentials/using-private-dependencies/
[secret]: https://docs.semaphoreci.com/essentials/using-secrets/
[auto-cancel]: https://docs.semaphoreci.com/article/153-auto-cancel
[sem-attach]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-attach
