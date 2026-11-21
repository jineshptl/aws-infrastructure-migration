# kubernetes-lab

Kubernetes cluster on AWS (kubeadm, v1.35): 1 control node, 2 workers and 1 FRR router. Terraform makes the servers, Ansible builds the cluster. Access is through SSM, so port 22 isn't needed.

- **Network:** Cilium with eBPF, no kube-proxy
- **Outside access:** BGP to an FRR router gives the app the IP `10.200.0.0`
- **Deploys:** ArgoCD watches `apps/` in Git and applies changes by itself

## Setup (once)

    ssh-keygen -t ed25519 -f ~/.ssh/k8s-lab -N ""
    brew install --cask session-manager-plugin

Add to `~/.ssh/config`:

    Host i-*
      User ubuntu
      IdentityFile ~/.ssh/k8s-lab
      StrictHostKeyChecking accept-new
      ProxyCommand aws ssm start-session --region us-east-1 --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p

## Build

    aws login
    eval "$(aws configure export-credentials --format env)"
    cd terraform && terraform apply
    sleep 120
    cd ../ansible
    eval "$(aws configure export-credentials --format env)"
    ansible-playbook playbooks/prep.yml playbooks/cluster.yml playbooks/bgp.yml playbooks/argocd.yml

Takes about 15 minutes.

## Check

    ansible control -a "kubectl get nodes"
    ansible control -a "kubectl -n argocd get applications"
    ansible router -a "curl -s -m 5 http://10.200.0.0"

## Change the app

Edit `apps/web/web.yml`, open a PR and merge it. ArgoCD deploys it in about 3 minutes.

## Tear down

    cd terraform && terraform destroy
    ../../scripts/aws-check.sh

Problems and fixes: [confluence/](../confluence/README.md)
