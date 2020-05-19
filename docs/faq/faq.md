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
    <td><a href="#why_my_jobs_dont_start">Why my jobs don't start?</a></td>
    <td><a href="https://github.com/semaphoreci/docs/blob/faq/docs/faq/faq.md#how-to-add-new-users">How to add new users?</a></td>
  </tr>
  </tbody>
</table>  
 
 An anchor is a sort of reference point that you can put in your HTML pages when they are very long.
Indeed, it may be then be useful to create a link to a point further down the same page to allow visitors to jump directly to the part they are interested in.

To create a new anchor, just add theidattribute a tag which will then act as a reference point. It can be any tag, such as a title, for example.
Use theidattribute to give a name to the anchor. We will then be able to use it to make a link to this anchor. For example:



The idea is to make a link that opens another page AND that takes you directly to an anchor located further down on this page.
In practice it's fairly simple to do: just type the page name, followed by a hash character (#), followed by the anchor name.


... will take you to the pageanchors.html, directly to the anchor calledrollers.

Here's a page that contains three links, each leading to one of the anchors of the page in the previous example:



 

 <details>
 <summary id="why_my_jobs_dont_start">Why my jobs don't start?</summary>
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
