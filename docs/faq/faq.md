# FAQ [Attention! This site is under construction]

<!-- markdownlint-disable -->
<table>
  <thead>
    <tr>
      <th>Technical Support</th>
      <th>Account Support</th>
    </tr>
  </thead>
  <tbody>
  <tr>
    <td><a href="#why-my-jobs-dont-start">Why my jobs don't start?</a></td>
    <td><a href="#how-to-add-new-users">How to add new users?</a></td>
  </tr>
  <tr>
    <td><a href="#fail-could-not-parse-object">How to solve "Fail: Could not parse object" during bundle install?</a></td>
    <td></td>
  </tbody>
</table>  
 
 
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
  <summary id="how-to-add-new-users">How to add new users?</summary>
  <p>
    
Go to the `People` page of your organization and click on `Refresh list` button.
  </p>
</details>
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

