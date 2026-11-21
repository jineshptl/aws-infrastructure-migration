# Node Exporter down on app01

**Symptom:** I got an InstanceDown alert for app01, and Grafana had no data.

**Check:**

    ansible app -b -a "systemctl is-active prometheus-node-exporter"
    ansible app -b -a "journalctl -u prometheus-node-exporter -n 5 --no-pager"

The service was `inactive`. The logs said `Stopped ... Deactivated successfully`, so someone stopped it. It didn't crash.

**Cause:** that someone was me. I stopped it to test the alert.

**Fix:**

    ansible-playbook playbooks/node_exporter.yml

Only app01 came back `changed=1`. monitor01 was already fine.

**Verify:** the service was `active` again and the alert cleared.
