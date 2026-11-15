# AWS migration: lessons learned

**Goal:** move a 2-server lab to AWS, fully in code, at low cost.
**Result:** network, servers, Nginx, monitoring and alerting built with Terraform and Ansible. CI on every push. Main protected by PR-only rules.

## Alert didn't fire during a failure test

- **What happened:** I removed the firewall rule for Node Exporter. The target stayed "up" and no alert fired.
- **Root cause:** security groups are stateful. Connections that were already open kept working.
- **Fix:** restarted Prometheus to force new connections. The alert fired after 1 minute.
- **Prevention:** I test alerts with real failures, not by reading config. An alert that was never seen firing is not trusted.

## Changes could go straight to main

- **What happened:** a test push to main went through with no review.
- **Root cause:** no branch protection was set up.
- **Fix:** added a ruleset. Main now only changes through a PR with passing CI.
- **Prevention:** every change is checked by `terraform validate` and `ansible-lint` before it lands.

## Design choices that scale

- Servers are found by AWS tag, not IP, so Ansible works the same for 2 servers or 200
- Everything is code, so a full rebuild is one command
