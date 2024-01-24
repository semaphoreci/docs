---
Description: Semaphore is now integrated with Okta, which will allow you to provision and deprovision users automatically. You can also use the Okta app as a Single Sign On for your Semaphore organization
---

# Okta Integration

!!! plans "Available on: <span class="plans-box">Scaleup</span>"

Integration with Okta allows you to automate user management within your Semaphore organization, as well as to use Okta apps for
Single Sign On.

## SAML/SCIM

Semaphore implements SCIM protocol for integration with ID providers (such as Okta), and SAML for user
management (provisioning and deprovisioning of users). If you would like to use this Semaphore feature,
but your company uses another SCIM/SAML ID provider, feel free to contact our [support team][form].


## How do SAML and SCIM work?

SAML and SCIM are well-established protocols defined in the 2000s, that have became de facto standards
for user management and identity management, especially in large enterprise corporations. For an in-depth
explanation on how they work, check out these resources for [SAML][saml_docs] and [SCIM][scim_docs]

## How to set up integration between Okta and Semaphore

[Here][okta_installation] you will find detailed instruction on how to set up Okta integration.

[form]:  https://semaphoreci.com/contact
[saml_docs]: https://developer.okta.com/docs/concepts/saml/
[scim_docs]: https://developer.okta.com/docs/reference/scim/scim-20/#determine-if-the-user-already-exists
[scim_docs]: https://developer.okta.com/docs/reference/scim/scim-20/#determine-if-the-user-already-exists
[okta_installation]: ./installation.md
