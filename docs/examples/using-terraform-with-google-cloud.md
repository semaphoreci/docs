---
description: This guide shows you how to use Semaphore to set up a pipeline using Terraform with Google Cloud.
---

# Using Terraform with Google Cloud

This guide shows you how to use Semaphore to set up a pipeline
using Terraform with Google Cloud.

For this guide you will need:

- [A working Semaphore project][create-project] with a basic CI pipeline.
You can use one of the documented [use cases][use-cases] or
[language guides][language-guides] as a starting point.
- Basic familiarity with Git and SSH.

## Store credentials in secrets

- Store the Google Cloud credentials

Assuming that your Google Cloud credentials are stored on your computer in
`/home/<username>/.ssh/gcp.json` use the following command to create a
secret on Semaphore:

``` bash
sem create secret gcp \
  -f /home/<username>/.ssh/gcp.json:.ssh/gcp.json
```

- Create and store a deploy key

```bash
$ ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/admin/.ssh/id_rsa): /Users/admin/.ssh/id_rsa_semaphore_terraform
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/admin/.ssh/id_rsa_semaphore_terraform.
Your public key has been saved in /Users/admin/.ssh/id_rsa_semaphore_terraform.pub.
The key fingerprint is:
SHA256:otdc9yDdLtmtkCJvt2uOdDH6yrLfa/BZBu6qtmvbRsY admin@example.com
The key's randomart image is:
+---[RSA 4096]----+
|                 |
|                 |
|                 |
|           ...   |
|      . S.o.*..  |
|     . + .E+.Xo. |
|    . . +o++*++ .|
|     .  +*o*Bo . |
|       o*@OBB+.  |
+----[SHA256]-----+
```

We need to make the private key `id_rsa_semaphore_terraform` available on
Semaphore, and add the corresponding public key `id_rsa_semaphore_terraform.pub`
to the Google Cloud project under `Metadata/SSh keys`

``` bash
$ sem create secret terraform-key \
  --file /Users/admin/.ssh/id_rsa_semaphore_terraform:/home/semaphore/.ssh/id_rsa_semaphore_terraform
Secret 'terraform-key' created.
```

## Define the Terraform configuration file

```tf
provider "google" {
 credentials = file("~/.ssh/gcp.json")
 project     = "example-project"
 region      = "us-west1"
}
// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "terraformvm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"
metadata = {
   ssh-keys = "terraform:${file("~/.ssh/id_rsa_semaphore_terraform")}"
 }
 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq nginx"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}
output "ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
```

## Define the pipeline

Finally, let's define what happens in our `semaphore.yml` pipeline:

```yaml
version: v1.0
name: Initial Pipeline
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804
blocks:
  - name: 'Init'
    task:
      secrets:
        - name: terraform-key
        - name: gcp
      jobs:
        - name: 'Init Terraform Gcloud'
          commands:
            - checkout
            - chmod 0600 ~/.ssh/id_rsa_semaphore_terraform
            - cd gcloud
            - terraform init
            - terraform plan
            - terraform apply -auto-approve
            - terraform show terraform.tfstate
```

### Verify it works

Push a new commit on any branch and open Semaphore to watch a new workflow run.
If all goes well you'll see a `Passed` green box next to your pipeline indicating
the workflow finished successfully.

### Next steps

Congratulations! You have created a successful pipeline that
communicates Terraform with Google Cloud.
Here’s some recommended reading:

- [Explore the promotions reference][promotions-ref] to learn more about what
options you have available when designing delivery pipelines on Semaphore.
- [Set up a deployment dashboard][deployment-dashboards] to keep track of
your team's activities.



[create-project]: https://docs.semaphoreci.com/guided-tour/creating-your-first-project/
[use-cases]: https://docs.semaphoreci.com/examples/tutorials-and-example-projects/
[language-guides]: https://docs.semaphoreci.com/programming-languages/android/
[promotions-ref]: https://docs.semaphoreci.com/reference/pipeline-yaml-reference/#promotions
[promotions-intro]: https://docs.semaphoreci.com/guided-tour/deploying-with-promotions/
[secrets-guide]: https://docs.semaphoreci.com/guided-tour/environment-variables-and-secrets/
[sem-create-ref]: https://docs.semaphoreci.com/reference/sem-command-line-tool/#sem-create
[deployment-dashboards]: https://docs.semaphoreci.com/essentials/deployment-dashboards/
