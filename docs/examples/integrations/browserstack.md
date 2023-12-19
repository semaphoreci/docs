---
Description: This guide shows you how to use BrowserStack Automate in your Semaphore workflows.
---

# BrowserStack

> BrowserStack is a cloud-based testing platform that enables developers to test their websites and mobile applications across a vast range of browsers and operating systems without the need to set up and maintain a lab of physical testing devices.

This guide shows you how to integrate [BrowserStack Automate][browserstack] into your Semaphore workflows.

## Integrating BrowserStack Automate into Semaphore

If you are new to Semaphore and have not yet set-up a project, please view the guide on [how to set-up a Semaphore Project][semaphore-project-setup].

<div class="docs-video-wrapper">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/HJWZgdf8MBs?si=i7MpHZJBoSxk1-2z" title="How to Set-Up BrowserStack in Semaphore" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</div>

## Code Snippets used in Video

Restore cached dependencies and run tests:

```bash
cache restore
npm install
cache store
npm run sample-test
```

Name tests using Semaphore Job ID and the project name:

```javascript
/** Top content of .test.js file ... */

const BUILD_NAME = process.env.SEMAPHORE_PROJECT_NAME
const SEMAPHORE_JOB_ID = process.env.SEMAPHORE_JOB_ID
/** Your username and access key variables ... **/

/** Your code for describe block ... */

/** Driver options naming block */

driver = new Builder()
    .usingServer(`http://localhost:4444/wd/hub`)
    .withCapabilities({...Capabilities.chrome(),
    'bstack:options' : {
        "buildName" : "semaphore-" + BUILD_NAME + "-" + SEMAPHORE_JOB_ID,
        "userName" : username,
        "accessKey" : accessKey,
        "seleniumVersion" : "4.0.0",
    },
}).build();

/** Your after all and code blocks ... */
```

## BrowserStack Guides

- 📚 [Set-Up Local Testing][browserstack-docs-localwebsites] - Use this guide if your websites are hosted on a private or internal network.
- 📚 [Integrate Existing Test Cases][browserstack-docs-existing-testcases]

[browserstack]: https://www.browserstack.com
[semaphoredocs]: https://www.browserstack.com/docs/automate/selenium/semaphore
[browserstack-docs-existing-testcases]: https://www.browserstack.com/docs/automate/selenium/semaphore#integrate-existing-test-cases
[browserstack-docs-localwebsites]: https://www.browserstack.com/docs/automate/selenium/semaphore#integrate-test-cases-for-locally-hosted-websites
[semaphore-project-setup]: https://docs.semaphoreci.com/guided-tour/getting-started/#creating-a-semaphore-project