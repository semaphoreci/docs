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
    <td><a href="https://github.com/semaphoreci/docs/blob/faq/docs/faq/faq.md#why-my-jobs-dont-start">Why my jobs don't start?</a></td>
    <td><a href="https://github.com/semaphoreci/docs/blob/faq/docs/faq/faq.md#how-to-add-new-users">How to add new users?</a></td>
  </tr>
  </tbody>
</table>  
 

#### Why my jobs don't start?

<details>
  <summary>Answer</summary>
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

#### How to add new users?

<details>
  <summary>Answer</summary>
  <p>
Go to the People page of your organization and click on Refresh list button.
  </p>
</details>
