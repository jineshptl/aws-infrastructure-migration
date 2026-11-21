# AWS migration: lessons learned

**Goal:** move a 2-server lab to AWS, fully in code, at low cost.
**Result:** network, servers, Nginx, monitoring and alerting built with Terraform and Ansible. CI on every push. Main only changes through a PR.

## Alert didn't fire during a failure test

- **What happened:** I removed the firewall rule for Node Exporter. The target stayed "up" and no alert fired.
- **Cause:** security groups are stateful. Connections that were already open kept working.
- **Fix:** restarted Prometheus to force new connections. The alert fired after 1 minute.
- **Next time:** test alerts with a real failure, not by reading the config. If I never saw an alert fire, I don't trust it.

## Changes could go straight to main

- **What happened:** a test push to main went through with no review.
- **Cause:** branch protection wasn't set up.
- **Fix:** added a ruleset. Main now only changes through a PR with passing CI.
- **Next time:** every change is checked by `terraform validate` and `ansible-lint` before it lands.

## Rules I took from this

- Servers are found by AWS tag, not IP, so Ansible works the same for 2 servers or 200.
- Everything is code, so a full rebuild is one command.
