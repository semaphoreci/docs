# A recipe for GitHub SSO

To authorize Semaphore to use GitHub for an organization with SSO enabled, there's one configuration you need to update in Github.

- Grant orgnization access to Semaphore 2.0 deployment app.

Below you'll find detailed steps on how to accomplish this.

## Grant Semaphore 2.0 app access to your Github org
1. Goto https://github.com/settings/profile
2. From the left side menu click "Applications".
3. Click [Authorized OAuth Apps](https://github.com/settings/applications).
4. From the applications list, click on "Semaphore 2.0".
5. Under "Organization access" choose your private organization and click "Grant".
6. Once access is granted, you should be able to see your repo and add it: https://{YOUR_ORGNAME}.semaphoreci.com/new_project.
