# Kubernetes lab: lessons learned

**Goal:** a production-style Kubernetes cluster on AWS, built with kubeadm (CKA style), cost near $0.
**Result:** 2-node cluster on v1.35. Rebuilt from code in about 10 minutes, about $0.06/hour, torn down after every session.

## Incident: control plane down after etcd restore

- **Impact:** API server unavailable for about 5 minutes during a restore drill.
- **Detection:** kubectl refused connections. `crictl ps -a` showed etcd and kube-apiserver in a restart loop.
- **Root cause:** the restore used etcd tools v3.4 against etcd v3.6.6. etcd crashed reading the old-format data. `crictl logs` showed the panic.
- **Fix:** restored again with matching etcdutl v3.6.6 into a fresh data dir. Control plane healthy in about 1 minute.
- **Prevention:** the runbook now checks the etcd image version first ([runbook](etcd-backup-restore.md)).

## Debug tools missing during the outage

- **What happened:** crictl wasn't installed when kubectl was down, which slowed down debugging.
- **Fix:** installed cri-tools.
- **Prevention:** added cri-tools to the Ansible playbook. Every node has it from now on.

## Rule I took from this

If I fix something by hand twice, it goes into Ansible.

## Automating the cluster build

- `aws login` 400 error: picked "Sign into new session" and didn't press Ctrl+C.
- Port 22 blocked at work: moved to SSM ([runbook](ssh-blocked-ssm.md)).
- `RequestExpired`: exported credentials expire, run the `eval` line again.
