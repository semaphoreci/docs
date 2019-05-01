# A recipe for GitHub SSO

To authorize Semaphore to use GitHub for an organization with SSO enabled, there are two configurations you need to update in Github.

1. Enable SSO for Semaphore SSH key `semaphore-key`.
2. Grant orgnization access to Semaphore 2.0 deployment app.

Below you'll find detailed steps on how to accomplish both steps.

## Enable SSO for Semaphore SSH key
1. Goto https://github.com/settings/profile
2. From the left side menu click "[SSH and GPG keys]: https://github.com/settings/keys".
3. Find the key with id "semaphore-key".
4. Click "Enable SSO.nt"
5. From the drop-down menue choose your organization and click "Authorize".
6. Follow the steps to authorize with your SAML SSO provider.

## Grant Semaphore 2.0 app access to your Github org
1. Goto https://github.com/settings/profile
2. From the left side menu click "Applications".
3. Click "[Authorized OAuth Apps]: https://github.com/settings/applications".
4. From the applications list, click on "Semaphore 2.0".
5. Under "Organization access" choose your private organization and click "Grant".
6. Once access is granted, you should be able to see your repo https://{YOUR_ORGNAME}.semaphoreci.com/new_project.
