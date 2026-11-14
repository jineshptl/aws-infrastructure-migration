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
