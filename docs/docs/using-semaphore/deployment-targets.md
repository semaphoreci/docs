---
description: Control who and what can trigger promotions
---

# Deployment Targets

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';


WIP

1. Create deployment target
2. Create promotion
3. Link promotion to deployment target

Goals: 
- control who and what branch/tag/pr can trigger a promotion
- control if automatic promotions are allowed
- set special/hidden environment variables, files, or secrets for the promotion
- a dedicated view a history of deployments, you can detailed history pipeline or easily rerun 
  deployment (only promoted pipeline is run, not full workflow).

There's a lock icon: changes between lock/unlock depending on situation: Show what happens if branch/person in target is forbidden

How to use bookmark:
1. Only if using parametrized promotion
2. The bookmark in the target should match interesting parameter names, e.g. ENVIRONMENT
3. View deployment tab
4. Click view hitory button
5. Type the value in promotion parameters: "Production" or "Stage"
6. Press enter. You will only see deployments that match the string


Deployment target

https://docs.semaphoreci.com/essentials/deployment-targets/

Deployment Targets allow you to apply strict conditions for who can start individual pipelines and under which conditions. Using them, you have the ability to control who has the ability to start specific promoted pipelines or select git references (branches and tags).

Combining the functionality of promotions and Deployment Targets gives you a full toolset to configure secure Continuous Deployment pipelines. This is backwards compatible with your previous setup.

The core advantage of using Deployment Targets is multi-faceted access control, i.e. taking many factors into account while granting the right to promote. Moreover, they are backed with a dedicated secret, unique per Deployment Target and inaccessible to outside Deployments. Last but not least, Deployment Targets give you a clear overview of your previous deployments, so you can see which version was shipped and by whom.

## How to add targets

## Access control

## Promotions with the UI

## Promotions with the API

### Deployment history




