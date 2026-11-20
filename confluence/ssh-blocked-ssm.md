# SSH blocked, moved to SSM

**Problem:** Ansible timed out on port 22. Work network blocks SSH.

**Fix:** added an IAM role for SSM, installed `session-manager-plugin`, and pointed `i-*` hosts in `~/.ssh/config` through SSM. Inventory now uses instance IDs.

**Check:** `ansible all -m ping` returns `pong` on both nodes.
