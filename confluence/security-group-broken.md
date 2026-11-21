# app01 down in Prometheus (security group)

**Symptom:** the InstanceDown alert fired for app01, but the server and the site were both fine.

**Check:**

    ansible app -b -a "systemctl is-active prometheus-node-exporter"
    ansible monitoring -a "curl -s -m 5 http://<app01_private_ip>:9100/metrics"

Node Exporter was running, but curl from monitor01 timed out (`rc=28`). So the service was fine and the network wasn't.

    cd terraform
    terraform plan

The plan said `1 to change`. The port 9100 rule from monitor01 was gone in AWS.

**Cause:** I deleted the rule by hand in the console, so Terraform didn't know about it (drift).

**Fix:**

    terraform apply

**Verify:** curl from monitor01 got `200` and the alert cleared.

**Note:** deleting a rule doesn't kill connections that are already open. Prometheus kept scraping until I restarted it. So after a firewall change, always test with a new connection.
