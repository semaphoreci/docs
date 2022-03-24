---
Description: Frequently asked questions regarding project management on Semaphore.
---

# FAQ: Managing projects

## How to rename a project

If you want to rename your project, you can:

1. Choose the project for which you want to change the name.
2. Go to **Settings** in the top right corner of the page.
3. Change the name in the **Name and Description** section.
4. Click on **Save Changes**.

This can also be performed from the CLI by using the [`sem edit` command](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-edit-examples).

## How to transfer project ownership

In order to transfer the project ownership to a different user, the following 
conditions need to be met:

1. The new project owner needs to have Admin permission level for the related repository on GitHub.
2. If you plan to build private projects, the new owner needs to grant Semaphore access to all repositories. This can be done under [Personal Settings -> GitHub repository access](https://me.semaphoreci.com/account).
3. If you plan to build only public projects, the new owner needs to grant Semaphore access to public repositories. This can be done under [Personal Settings -> GitHub repository access](https://me.semaphoreci.com/account). 

After that, go to _Project Settings -> General_, in the _Project Owner_ section, find the user that you want to become the new owner, and click _Change_.

If you come accross any issues, please reach out to [support@semaphoreci.com](mailto:support@semaphoreci.com)
and include the name of the project and the GitHub username of the new owner in your message.

**Note:** After project ownership has been transferred, you need to push a new commit. 
Rerunning old builds will no longer work after ownership of a project has been transferred.

## Deleting a project

In order to delete a project, you can:

1. Choose the project you want to delete.
2. Go to **Settings** in the top right corner of the page.
3. At the bottom of the page, click on the link in the **Delete project** section.
4. Leave your feedback.
5. Enter the project name for final confirmation.
5. Click on the **Delete project** button.

**Please note that this action cannot be reversed.**

If you prefer using CLI, you can delete a project by using the [`sem delete` command](https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-delete-example).
