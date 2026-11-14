# Node Exporter down on app01

**Symptom:** InstanceDown alert for app01, no metrics in Grafana.

**Check:**

    ansible app -b -a "systemctl is-active prometheus-node-exporter"
    ansible app -b -a "journalctl -u prometheus-node-exporter -n 5 --no-pager"

Service was `inactive`. Logs showed `Stopped ... Deactivated successfully`, so it was stopped, not crashed.

**Cause:** service was stopped by hand.

**Fix:**

    ansible-playbook playbooks/node_exporter.yml

Only app01 showed `changed=1`, monitor01 was already fine.

**Verify:** service is `active`, alert goes back to inactive.
