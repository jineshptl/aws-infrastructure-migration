# kubernetes-lab

2-node Kubernetes cluster on AWS (kubeadm, v1.35). Terraform makes the servers, Ansible builds the cluster. Access is through SSM, so port 22 isn't needed.

## Setup (once)

    ssh-keygen -t ed25519 -f ~/.ssh/k8s-lab -N ""
    brew install --cask session-manager-plugin

Add to `~/.ssh/config`:

    Host i-*
      User ubuntu
      IdentityFile ~/.ssh/k8s-lab
      ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p

## Build

    aws login
    eval "$(aws configure export-credentials --format env)"
    cd terraform && terraform apply
    cd ../ansible
    ansible-playbook playbooks/prep.yml
    ansible-playbook playbooks/cluster.yml

## Tear down

    cd terraform && terraform destroy
