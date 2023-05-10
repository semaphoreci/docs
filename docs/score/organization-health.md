---
Description: Organization Health shows an aggregation of your organization's metrics in one place.
---

# Organization Health

!!! plans "Available on: <span class="plans-box">Scaleup</span>"

Organization Health provides an overview of all your project metrics in one place. For example,
you can see the lowest-performing projects for the last 30 days, which can help you spot potential problems and
find optimization opportunities across your organization.

### Where can you find Organization Health?

If your organization is on the Scaleup plan, you will find a new tab on your Semaphore Dashboard
to the right of "My Starred Projects".

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/org-health/header.png" alt="Organization Health - Dashboard tab">


### Available metrics and functionality

Organization Health lists your projects and their Performance, Reliability, and Frequency characteristics.
You can also see when a given project was last run, which helps identify stale projects.

!!! warning "Note: We calculate these metrics every few hours, Last Run may not be accurate up to the minute."

By default, the system sorts your organization's list of projects by lowest to highest performance, but you can change that by
clicking the arrows or the metric name you want to sort by. Sorting by ascending or descending order is available in all cases.

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/org-health/body.png" alt="Organization Health - project list">

You can click on any row for more details about a project's metrics. Also, you can see any project's <a href="/score/project-insights/">Insights page</a>
where daily metrics are available.


!!! warning "Note: We use every branch and pipeline to build project metrics in Organization Health, and this may not always match what is shown on the Insights page."

We would like to hear feedback from you! <a href="mailto:rlopes@renderedtext.com?subject=Organization health issue">Contact us</a> if you find a bug or have questions.
