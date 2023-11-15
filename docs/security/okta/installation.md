---
Description: This page explains the process of integrating Semaphore with Okta 
---

# Integrating Okta with Semaphore

!!! plans "Available on: <span class="plans-box">Scaleup</span>"

## Prerequisites, People, and Access Rights

To make use of this tutorial, you will need the following:

- An existing Okta organization
- A person with admin access rights within the Semaphore organization
- A person with admin access rights on Okta

## Creating an App Integration on Okta

Log in to your Okta organization, go to the admin, and open the Applications dashboard.

![Applications dashboard](resources/image1.png)

Click on the "Create App Integration" button to start the wizard for setting up a new SAML
2.0 integration with Semaphore.

![Create new app screen](resources/image2.png)

In the sign-in method section choose SAML 2.0 and click Next.

![Create SAML integration](resources/image3.png)

Choose a name for this integration, e.g. 'Semaphore', then click Next.

![Configure SAML](resources/image4.png) 

On the configure SAML screen, fill in the three fields:

- **Single Sign On URL** — has the format {your-organization-name}semaphoreci.com/okta/auth. 
For  example, if your organization is called test-org-123456789, the Sign on URL will be https://test-org-123456789.semaphoreci.com/okta/auth.

- **Audience URL** — this is the full URL of your organization. For example, test-org-123456789.semaphoreci.com.

- **Application username** — choose email.

On the next screen, choose "I'm an Okta customer adding an internal app."

![SAML integration Feedback](resources/image5.png)

At the bottom of the page, click Finish to complete the setup.

After this step you should have a new App Integration on Okta that is ready to be connected with your Semaphore instance.

## Connecting Okta with Semaphore

Log in to your Semaphore instance with an Owner or Admin account and go to the organization settings page.

![Semaphore settings page](resources/image6.png) 

![Semaphore Okta Integration page](resources/image23.png) 

Navigate to the Okta Integration tab and start the Okta integration process by clicking on the "Set Up" button.

The next step will ask you to input your Single Sign On URL, SAML Issuer, and SAML Certificate.
Go to your Okta application created in step 2 of this guide. Open the Sign On tab,
and click on the "View SAML setup instructions" button at the bottom of the page.

![Okta Saml instructions](resources/image7.png)

When you reach this page, copy the "Identity Provider Single Sign-On URL",
"Identity Provider Issuer", and the "X.509 Certiﬁcate" in order to add them to Semaphore.

Go back to your Okta Integration setup page on Semaphore and fill in all of the fields.

![Semaphore Okta setup](resources/image8.png) 

Click Save to finish the setup and obtain a SCIM token, which you will need for the next step of this guide.

Make sure to save this token to a safe location, as you will need to re-enter all of the SAML info from last step again
to attain the newly-generated SCIM token from Semaphore.

![SCIM Authorization Token](resources/image9.png) 

## Provisioning Semaphore users from Okta

In this step, we are going to set up automatic user provisioning, de-provisioning, 
and profile updates. You will need the SCIM token from the previous step for this.

Navigate to your Okta Integration application and, under the General Tab, click on the 
"Edit" button to edit your application settings.

![Okta Application General tab](resources/image10.png)

Once in the edit mode, choose SCIM under the Provisioning section, and click Save.

![Okta Scim selected](resources/image11.png)

A new tab will appear in the Okta application navigation named Provisioning. Open 
that tab and click on "Edit" to configure the SCIM Connection.

![Okta Provisioning tab](resources/image12.png)

In edit mode, fill in the details for the SCIM connection.

![Okta SCIM connection](resources/image13.png)

- **SCIM connector** — has the format {your-organization-name}.semaphoreci.com/okta/scim.
For example, if your organization is called test-org-123456789, the Sign on URL will be 
https://test-org-123456789.semaphoreci.com/okta/scim.

- **Unique identifier field for users** — enter email.

- **Supported provisioning actions** — choose "Push New Users", "Push Profile Updates", and "Push Groups".

- **Authentication Mode** — choose "HTTP Header".

- **Authorization** — enter the SCIM Token obtained earlier.

Click on "Test Connector Configuration" to test out your connection with Semaphore.

![Test connection configuration](resources/image14.png)

If everything works, you should see a green checkmark under "Create Users", "Update User Attributes", and "Push Groups".

Click close, and then click "Save" to set up the connection.
This step will configure the SCIM Integration, but it won't enable it.

Under the Provisioning tab, click on the "To App" section and click Edit.

![Okta Provisioning - The App section](resources/image15.png)

![Okta Provisioning - events enabled](resources/image16.png)


Enable "Create Users", "Update User Attributes", and "Deactivate Users". After that, click on Save.

The Okta Integration App is now ready to assign people or groups to Semaphore. 
Click on Assignments and, in the "Assign" dropdown, choose a user or group that you want to assign to Semaphore.

![Okta Assignments](resources/image17.png)

![Okta Assign User](resources/image18.png)

![Okta User Assigned](resources/image19.png)

**DISCLAIMER** Semaphore provisions users async, in batches. If you want to provision a lot of members 
(hundreds or even thousands) all at once, that process will take some time. Depending on the number of users,
it can be up to half an hour. On the Okta integration page, it should show a green tick next to all of
the users (or groups) that you have provisioned. This means that Semaphore has succesfully received the command for
user provisioning, but not that it was processed. If you want to follow the progress (how many users
have been provisioned), you can do that on the Okta Integration tab within Semaphore Settings page.

![Okta Connected Semaphore page](resources/image20.png) 

## Logging in to Semaphore and Connecting your GitHub Account

Log in to Okta with a user that was assigned to Semaphore. They should now be able to see 
"Semaphore" as one of the options in the "My Apps" section.

Click on the application to log into Semaphore.

![Okta My Apps section](resources/image21.png)

As the first step for any new logins, Semaphore will ask the person to connect their GitHub account.
They do not have to do this, and can skip this step by clicking on the Semaphore icon in the top right corner.
Otherwise, click on the "Connect…" link to connect your GitHub account with Semaphore.

![Connect Github](resources/image22.png)

The user should now see the Organizations Semaphore home page. Integration between Okta and Semaphore is complete!

