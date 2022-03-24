---
Description: This guide shows how to authorize Semaphore 2.0 to access repositories hosted on GitHub SSO.
---

# Working with GitHub SSO

Semaphore supports repositories hosted on GitHub with SAML single sign-on (SSO).
This GitHub feature is available in the GitHub Enterprise Cloud offering.

To authorize Semaphore to access repositories hosted on GitHub SSO,
you need to grant Semaphore 2.0 access to your organization on GitHub.

These are the steps to accomplish this:

1. Go to [https://github.com/settings/profile](https://github.com/settings/profile).
2. On the left-hand side menu, click "Applications".
3. Click [Authorized OAuth Apps](https://github.com/settings/applications).
4. From the applications list, select "Semaphore 2.0".
5. Under "Organization access", choose your private organization and click
   either "Grant" or "Request Access".
6. *optional* If you clicked "Request Access" in step 5, the admin of the
   orgnization will receive an email showing your request.
7. Once access is granted, you should be able to see your repo and use it to
   create a project on Semaphore:
   `https://{YOUR_ORGNAME}.semaphoreci.com/new_project`.
