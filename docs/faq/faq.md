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
    <td><a href="https://github.com/semaphoreci/docs/blob/faq/docs/faq/faq.md#how-to-add-new-users">How to add new users?</a></td>
  </tr>
  </tbody>
</table>  
 
 An anchor is a sort of reference point that you can put in your HTML pages when they are very long.
Indeed, it may be then be useful to create a link to a point further down the same page to allow visitors to jump directly to the part they are interested in.

To create a new anchor, just add theidattribute a tag which will then act as a reference point. It can be any tag, such as a title, for example.
Use theidattribute to give a name to the anchor. We will then be able to use it to make a link to this anchor. For example:

<h2 id="my_anchor">Title</h2>
Then just create a link as usual, but this time thehrefattribute will contain a hash character (#) followed by the anchor name. Example:

<a href="#my_anchor">Go to the anchor</a>
Normally, if you click the link, it will take you further down the same page (provided the page has enough text for the scroll bars to move automatically).
Here's an example of a page with lots of text and which uses anchors (I've used any old text just to fill up the page):

<h1>>My big page</h1>

<p>
Go straight to the part dealing with:<br />
<a href="#kitchen">The kitchen</a><br />
<a href="#rollers">Rollers</a><br />
<a href="#archery">Archery</a><br />
</p>
<h2 id="kitchen">The kitchen</h2>

<p>... (lots of text) ...</p>

<h2 id="rollers">Rollers</h2>

<p>... (lots of text) ...</p>

<h2 id="archery">Archery</h2>

<p>... (lots of text) ...</p>
If nothing happens when you click on the links, this means that there is not enough text. In this case, you can either add any old text to the page so that it has (even) more text or reduce the size of your browser window to display the scroll bars on the side.

Theidattribute is used to give a "unique" name to a tag, to use it as a reference. And believe me, you haven't heard the last of this attribute. Here, it is used to link to an anchor, but in CSS, it will be very useful to us to "mark" a specific tag, as you'll see.
However, avoid creating ids with spaces or special characters. Wherever possible, simply use letters and numbers so that the value is recognized by all browsers.

Link to an anchor located in another page
OK, be warned. This is really going to be a megamix!

The idea is to make a link that opens another page AND that takes you directly to an anchor located further down on this page.
In practice it's fairly simple to do: just type the page name, followed by a hash character (#), followed by the anchor name.

For example:<a href="anchors.html#rollers">

... will take you to the pageanchors.html, directly to the anchor calledrollers.

Here's a page that contains three links, each leading to one of the anchors of the page in the previous example:

<h1>Megamix</h1>
<p>
Reference somewhere on another page:<br />
<a href="anchors.html#kitchen">The kitchen</a><br />
<a href="anchors.html#rollers">Rollers</a><br />
<a href="anchors.html#arc">Archery</a><br />
</p>
Practical examples of using links
Here, I'm going try to show you a few practical examples of using links. For example, did you know that it's very easy to make links that start a download? That create a new e-mail? That open a new window?

No? Well, we're going to have a look at all that here.

A link that displays a hover tooltip
You can use thetitleattribute which displays a tooltip when you point to the link. This attribute is optional.

You should obtain a result similar to the next figure.

A tooltip
A tooltip
The tooltip can be useful in providing visitors with information even before they have clicked the link.
Here's how to reproduce this result:

<p>Hello. Do you want to visit <a href="http://www.google.com" title="Some say it's a search engine">Google</a> ?</p>
A link that opens a new window
A link can be "forced" to open a link in a new window. To do this, you addtarget="_blank"to the to<a>tag:

<p>Hello. Do you want to visit <a href="http://www.google.com" target="_blank">Google</a> ?<br />
The website will be displayed in another window.</p>
Depending on the browser configuration, the page will open in a new window or a new tab. You can't choose between opening a new window or a new tab.

Note, however, that it is not recommended to overuse this technique as it disrupts browsing. Visitors can decide for themselves whether they want to open the link in a new window. They can press Shift + Click on the link to open it in a new window or Ctrl + Click to open it in a new tab.

A link to send an email
If you want your visitors to be able to send you an email, you can use links of themailtotype. Nothing changes at the level of the tag. You simply change the value of thehrefattribute like this:

<p><a href="mailto:yourname@yourisp.com">Send me an email!</a></p>
So you just need to start the link bymailto:and enter the email address at which you can be contacted. If you click the link, a new blank message opens, ready to be sent to your email address.

A link to download a file
Many of you must be wondering how this works for downloading a file... In fact, the procedures is exactly the same as for linking to a web page, but this time indicating the name of the file to be downloaded.

For example, suppose you want to downloadmyfile.zip. Simply place this file in the same folder as your web page (or in a subfolder) and make a link to this file:

<p><a href="myfile.zip">Download the file</a></p>
That's all! As the browser sees that there is no web page to be displayed, it will start the download process when user clicks on the link.

Summing up
Links are used to move from one page to another and are as default in blue underlined text.

To insert a link, use the<a>tag with thehrefattribute to indicate the address of the target page. Example:<a href="http://www.google.com">.

You can make a link to another page in your website simply by writing the file name:<a href="page2.html">.

Links can also be used to jump to other places on the same page. You have to create an anchor with the id attribute to "mark" a place on the page and then make a link to the anchor like this: <a href="#anchor">.

#
ORGANIZING YOUR TEXT		IMAGES	
HTML5 basics
How do you create websites?
Your first web page in HTML
Organizing your text
Creating links
Images
Quiz: Quiz 1
Created by
logo OpenClassrooms
OpenClassrooms, Leading E-Learning Platform in Europe


 
 

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

#### How to add new users?

<details>
  <summary>Answer</summary>
  <p>
Go to the People page of your organization and click on Refresh list button.
  </p>
</details>
