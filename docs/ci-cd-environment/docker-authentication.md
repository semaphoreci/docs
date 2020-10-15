# Docker Hub rate limits - Docs

As announced in the Docker blog post, on November 1st 2020, Docker Hub will introduce rate limits based on the IP address used. 

The rate limits of 100 pulls in 6 hours will apply to anonymous image pulls, while the authenticated users on a free plan will be able to make up to 200 pulls in 6 hours.

Exceeding the explained rate limits might cause a disruption in your Semaphore 2.0 workflows and below you can find the recommended steps in order to avoid it. 

In the meantime, our platform team is actively working on finding a solution that will minimize the impact of this change on the Semaphore users. 
Further updates on the topic will follow in the upcoming days and weeks.

## Will this affect you?
Semaphore runs jobs from a shared pool of IPs and anonymous pulls are counted based on the IP address. 
This means that if you are pulling containers from a public repository as an anonymous user, there is a high chance that you will be affected by the new DockerHub rate limit. 
This applies to both Semaphore 2.0 and Semaphore Classic projects.

## What should you do to avoid the rate limit?
If you have a DockerHub account, we suggest that you start authenticating your pulls in your Semaphore configuration. 
To learn more about the easiest ways of doing this, please read our Docker - Authenticating pulls guide. 
Docker offers a rate limit of 200 pulls per 6 hours for their free plan accounts and unlimited for Pro and Team. 

## What about Semaphore pre-built convenience Docker images?
Our convenience Docker images are hosted on the public DockerHub repository, so the same rate limit will apply as for the other repositories. 
Our team is working on finding alternative solutions and we will keep you posted. 
If you want to be on the safe side, you can always start authenticating pulls of these images too. 

Feel free to reach out to our support team with any questions that you might have. 
We will continue with our efforts to ensure that this transition goes smoothly for all Semaphore users. 

## How to authenticate compose style
## How to authenticate other Docker pulls
## How to check if you are logged in
