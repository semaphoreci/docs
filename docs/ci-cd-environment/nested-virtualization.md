# Nested virtualization

Linux based virtual machines support nested virtualization.

To check if nested virtualization is supported, we suggest
issuing `grep -cw vmx /proc/cpuinfo`. The resulting number 
will be greater than 0 since the virtualization flag is present 
on all VM cpu cores.

Nested virtualization can be managed through `libvirt`, 
which is already preinstalled.

Predefined default network for nested virtualization is `192.168.123.0/24`.
The base VM provides `virbr0` interface with the IP address: `192.168.123.1`.

Example of nested virtualization, using `uvltool` and prebuilt 
Ubuntu cloud images:

``` yaml
version: v1.0
name: Demo nested virtualization
agent:
  machine:
    type: e1-standard-2
    os_image: ubuntu1804

blocks:
  - name: with uvltool
    task:
      jobs:
      - name: Using ubuntu cloud images
        commands:
          - checkout
          - sudo apt-get install -y uvtool sshpass net-tools netcat-openbsd
          - uvt-simplestreams-libvirt --verbose sync --source http://cloud-images.ubuntu.com/daily release=focal arch=amd64
          - uvt-simplestreams-libvirt query
          - rm -rf ~/.ssh/id_rsa
          - echo | ssh-keygen -t rsa  -f ~/.ssh/id_rsa
          - uvt-kvm create vm1 --memory 1024 --cpu 1 --disk 4 --password ubuntu --bridge virbr0
          - uvt-kvm list
          - IP=""
          - while [ -z $IP ];do IP=$(arp -an | grep $(virsh dumpxml vm1| grep "mac address" | cut -d"'" -f2)|cut -d"(" -f2|cut -d")" -f1);done
          - echo $IP
          - while ! nc -w5 -z $IP 22; do  echo "Sleep while $IP is up";sleep 1; done
          - sshpass -p "ubuntu" -v  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@$IP -t 'uname -a'
```
