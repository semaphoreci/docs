---
Description: Project Insights are a set of metrics that provide a granular view of your project.
---
# Project Insights
Project Insights provide metrics about your projects' development performance, speed, and reliability. For example, you can
see the percentage of passed tests for the last few days in the whole project or your main branch.

You can also set up insights for your project's deployment branch via Settings on the Project Insights page.

## Configuring Insights

Semaphore tracks your CI insights automatically. You only need to set up insights for CD. 

### Setting up Continuous Deployment insights

Follow the steps below to set up CD insights:

1. Click on the **Insights** tab on the project page.
2. Click on the Gear Icon (Settings) on the left side navigation bar of the Insights page.
3. Provide the required information:
    - Provide the Branch
    - Provide the Pipeline Path
    4. Click on the **Save changes** button.


<img style="box-shadow: 0 0 5px #ccc" src="/score/img/settings.png" alt="Project Insights - Settings page">
After you save changes, Semaphore will start collecting metrics for your deployment branch.


## Metrics
Semaphore breaks down the metrics by Performance, Frequency, and Reliability. You can switch between metrics in the panel
on the left.

On the dashboard, you can see a summary of how long the pipelines need to run on average (Performance), how often
your team runs a pipeline (Frequency), and how stable your code is (Reliability).

### Performance
Performance metrics provide an overview of the median time (p50) and the standard deviation (std.dev) that it takes the 
pipelines to run. In addition, you can see the data for a selected branch (main or master) and all branches combined.

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/perf.png" alt="Performance metrics">

If you have set up the CD Insights, you can also see data for the deployment branch.

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/cd_perf.png" alt="Performance metrics - CD">

### Frequency
Frequency metrics show the number of executed pipelines per week for your project's main branch and all 
branches and the total number of runs for all pipelines per day.

A tooltip with the total number of runs appears when you hover over the chart for a specific day.

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/ci_freq.png" alt="Performance frequency">

You can see the data from the deployment branch if you have CD insights set up.

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/cd_freq.png" alt="Performance frequency - CD">

### Reliability

Reliability metrics provide an overview of your project's pipeline run pass rate. You can also see the 
mean time it takes to recover from a failed pipeline run and when the last successful run was.

When you hover over a day on the chart, a tooltip gets displayed with the Pass Rate, Number of Builds, and Passed builds.

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/ci_rel.png" alt="Performance reliability">

You can see the data from the deployment branch if you have CD insights set up.

<img style="box-shadow: 0 0 5px #ccc" src="/score/img/cd_rel.png" alt="Performance reliability - CD">


## Default data retention

By default, Semaphore enables Project Insights for all projects. 
Metrics are held for 30 days and are updated every 24 hours.
