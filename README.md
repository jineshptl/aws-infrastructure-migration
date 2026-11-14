# AWS Infrastructure Migration

Cloud version of my [Linux Infrastructure Automation Lab](https://github.com/jineshptl/linux-infrastructure-automation-lab). Same two servers, now on AWS with Terraform and Ansible.

Architecture: [docs/architecture.md](docs/architecture.md)

## Requirements

Check these on your local machine first:

```bash
aws --version
terraform --version
ansible --version
ls ~/.ssh/id_ed25519.pub
```

- AWS CLI: `brew install awscli`
- Terraform and Ansible: see [setup in the on-prem lab](https://github.com/jineshptl/linux-infrastructure-automation-lab#4-automation-tools-macos)
- SSH key: if missing, create one as in [SSH key login](https://github.com/jineshptl/linux-infrastructure-automation-lab#8-ssh-key-login) (only the `ssh-keygen` command)

## Setup

```bash
git clone https://github.com/jineshptl/aws-infrastructure-migration.git
cd aws-infrastructure-migration
```

## AWS login

Use an IAM user with MFA, not root.

```bash
aws login
aws sts get-caller-identity
```

## Cost alert

Set this up before creating anything. Servers cost about $1/day while running.

Billing and Cost Management → Budgets → Create budget → **Monthly cost budget** template, `$10`, your email.

Verify the email AWS sends, otherwise no alerts are sent.

## VPC

VPC, public subnet, internet gateway and route table. Config: [terraform/vpc.tf](terraform/vpc.tf)

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Security groups

SSH and web ports open to your IP only. Config: [terraform/security.tf](terraform/security.tf)

```bash
echo "admin_cidr = \"$(curl -s https://checkip.amazonaws.com)/32\"" > terraform.tfvars
terraform apply
```

If your IP changes, run both commands again.

## IAM role

Lets the servers use SSM and CloudWatch without storing access keys. Config: [terraform/iam.tf](terraform/iam.tf)

```bash
terraform apply
```

## EC2

app01 (t3.micro) and monitor01 (t3.small), Ubuntu 24.04. Config: [terraform/ec2.tf](terraform/ec2.tf)

```bash
terraform apply
ssh ubuntu@$(terraform output -raw app01_ip)
```
