---
Description: Project Insights are a set of metrics that provide a granular view of your project.
---
# Project Insights
Project Insights provide metrics about your teams' development performance, speed, and reliability. For example, you can
see the percentage of passed tests for the last few days in the whole project or your main branch.

You can also set up Insights for your project's deployment branch via Settings on the Project Insights page.

## Default behavior

By default, Project Insights are enabled for all projects. Metrics are held for 30 days and are updated every 24 hours.


## Configuring Insights

Semaphore automatically collects metrics for your project without needing to set up anything. However, you need to
set up Insights for your deployment branch if you want to see metrics for that specific branch.

### Setting up CD Insights

To set up Insights for your deployment branch, go to the Project Insights page and click the "Settings" button below 
"Reliability".

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/settings.png" alt="Project Insights - Settings page">


Now you need to let Semaphore know the deployment branch for your project and the deployment pipeline.


Enter the name of the branch in the "Branch" input field and the path to the deployment pipeline in the 
"Pipeline File Path" input field, as shown in the image below.

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/filled_settings.png" alt="Filled Settings">

Then save the settings. Semaphore will start collecting metrics for your deployment branch.

## Metrics

### Performance
### Speed
### Reliability