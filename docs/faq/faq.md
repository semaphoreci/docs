# FAQ [Attention! This site is under construction]

<!-- markdownlint-disable -->
<table>
  <thead>
    <tr>
      <th>Troubleshooting</th>
      <th>Account management</th>
    </tr>
  </thead>
  <tbody>
  <tr>
    <td><a href="#fail-could-not-parse-object">How to solve "Fail: Could not parse object" during bundle install?</a></td>
    <td><a href="#how-to-add-new-users">How to add new users?</a></td>
  </tr>
  <tr>
    <td><a href="#how-to-change-the-timezone">How to change the timezone?</a></td>
    <td></td>
  </tr>
  <tr>
    <td><a href="#how-to-build-with-git-submodules">How to build a project with git submodules?</a></td>
    <td></td>
  </tr>
  <tr>
    <td><a href="#self-signed-certificate">How to use a self-signed certificate with private Docker registry?</a></td>
    <td></td>
  </tr>
  <tr>
    <th>Jobs & Workflows</th>
    <th>Billing</th>
  </tr>
  <tr>
    <td><a href="#why-my-jobs-dont-start">Why my jobs don't start?</a></td>
    <td></td>
  </tr>
  <tr>
    <td><a href="#shell-configuration">Why does my job break inexplicably after changing the shell configuration?</a></td>
    <td></td>
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
```
export TZ=Europe/Belgrade
```
- Create a symlink in `/etc/localtime` to one of the available timezones:
```
sudo ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
```
  </p>
</details>

<details>
  <summary id="how-to-build-with-git-submodules">How to build a project with git submodules?</summary>
  <p>

- Add the following commands as a [prologue][]:
```
git submodule init
git submodule update
```
- Add the following command as an [epilogue][]:
```
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
```
sudo mv $SEMAPHORE_GIT_DIR/domain.crt /etc/docker/certs.d/myregistrydomain.com:5000/ca.crt
```
This will allow the connection to a private remote registry using the self-signed certificate.
  </p>
</details>

### Account management

<details>
  <summary id="how-to-add-new-users">How to add new users?</summary>
  <p>
    
Go to the `People` page of your organization and click on `Refresh list` button.
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
  <summary id="shell-configuration">Why does my job break inexplicably after changing the shell configuration?</summary>
  <p>
    
Adding any of the following to your shell is not supported and will cause the jobs to immediately fail.
```
set -e
set -o pipefail
set -euxo pipefail
```
  </p>
  <p>
  
This also applies when sourcing a script that contains the previous settings:
```
source ~/my_script
. ~/my_script
```
  </p>
</details>

### Billing



[prologue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-prologue-property
[epilogue]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#the-epilogue-property
[private-dependencies]: https://docs.semaphoreci.com/essentials/using-private-dependencies/
[secret]: https://docs.semaphoreci.com/essentials/using-secrets/
