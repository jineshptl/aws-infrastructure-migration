# app01 down in Prometheus (security group)

**Symptom:** InstanceDown alert firing for app01. Server and site still fine.

**Check:**

    ansible app -b -a "systemctl is-active prometheus-node-exporter"
    ansible monitoring -a "curl -s -m 5 http://<app01_private_ip>:9100/metrics"

Node Exporter was `active`, but curl from monitor01 timed out (`rc=28`). So it's the network, not the service.

    cd terraform
    terraform plan

Plan showed `1 to change`: the port 9100 rule from monitor01 was missing in AWS.

**Cause:** rule was removed by hand outside Terraform (drift).

**Fix:**

    terraform apply

**Verify:** curl from monitor01 returns `200`, alert goes back to inactive.

**Note:** removing a rule doesn't cut connections already open. Prometheus kept scraping until it was restarted. Don't trust a firewall change until you test a new connection.
