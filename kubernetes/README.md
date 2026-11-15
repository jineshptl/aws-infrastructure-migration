# kubernetes-lab

A 2-node Kubernetes cluster on AWS, built with kubeadm the same way the CKA exam does it.
Terraform makes the servers, Ansible prepares them, I run `kubeadm init` and `join` by hand.

## What's in it

- 1 control plane (t4g.medium) + 1 worker (t4g.small), Ubuntu 24.04 ARM
- Kubernetes v1.35, containerd, flannel
- SSH only from my IP, nodes talk to each other inside the security group
- About $0.06/hour. I destroy it after every session.

## Files

- [terraform/main.tf](terraform/main.tf) - servers, security group, SSH key
- [ansible/playbooks/prep.yml](ansible/playbooks/prep.yml) - containerd, kernel settings, kubeadm/kubelet/kubectl
- [ansible/inventory/aws_ec2.yml](ansible/inventory/aws_ec2.yml) - finds the nodes by their Role tag

## Build it

    ssh-keygen -t ed25519 -f ~/.ssh/k8s-lab -N ""
    cd terraform
    echo "my_ip = \"$(curl -s ifconfig.me)\"" > terraform.tfvars
    terraform init && terraform apply

    cd ../ansible
    ansible-playbook playbooks/prep.yml

On the control node:

    sudo kubeadm init --pod-network-cidr=10.244.0.0/16
    mkdir -p $HOME/.kube
    sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
    kubeadm token create --print-join-command

Run the printed join command with `sudo` on the worker, then check:

    kubectl get nodes

## Tear it down

    cd terraform && terraform destroy
