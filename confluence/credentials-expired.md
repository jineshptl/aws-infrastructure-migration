# Ansible finds no hosts / destroy stops halfway

**Symptom:** Ansible skipped everything with `no hosts matched`. Another time, `terraform destroy` deleted the servers but not the rest.

**Check:** both errors said `RequestExpired` or `ExpiredToken`.

**Cause:** the AWS login from the `eval` line only lasts a short time. Long runs went past it.

**Fix:**

    eval "$(aws configure export-credentials --format env)"

Then run the playbook or destroy again. If it still fails, run `aws login` first.

**Verify:** playbook shows `failed=0`. `./scripts/aws-check.sh` says ALL CLEAR.

**Note:** run the `eval` line again before any long step.
