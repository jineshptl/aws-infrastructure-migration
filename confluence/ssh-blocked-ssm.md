# Can't reach the nodes on port 22 (moved to SSM)

**Symptom:** Ansible could not connect to either node. Error: `Connection timed out during banner exchange`.

**Check:**

    terraform apply
    curl -s ifconfig.me

Terraform said `No changes`. My IP was the same as in the security group. So AWS was fine. The problem was my network.

**Cause:** my work network blocks SSH (port 22).

**Fix:** use SSM instead. SSM sends SSH over port 443, which is not blocked. I added an IAM role for SSM ([iam.tf](../kubernetes/terraform/iam.tf)), installed `session-manager-plugin`, added `i-*` hosts to `~/.ssh/config`, and changed the inventory to use instance IDs.

**Verify:**

    ansible all -m ping

Both nodes say `pong`.

**Note:** I rebuilt the servers so they had the role from the start. If you add the role later, SSM can take a while to work.
