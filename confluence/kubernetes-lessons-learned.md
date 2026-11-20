# Kubernetes lab: lessons learned

**Goal:** a real Kubernetes cluster on AWS, built with kubeadm (like the CKA exam), for almost $0.
**Result:** 2-node cluster on v1.35. I can rebuild it from code in about 10 minutes. It costs about $0.06/hour and I delete it after every session.

## Problem: cluster went down after etcd restore

- **Impact:** the API server was down for about 5 minutes during a practice restore.
- **How I found it:** kubectl stopped working. `crictl ps -a` showed etcd and the API server restarting again and again.
- **Cause:** I used etcd tools v3.4 on etcd v3.6.6. The versions did not match, so etcd crashed. `crictl logs` showed the error.
- **Fix:** restored again with etcdutl v3.6.6. The cluster was back in about 1 minute.
- **Next time:** the runbook checks the etcd version first ([runbook](etcd-backup-restore.md)).

## Missing tool during the outage

- **What happened:** crictl was not installed when kubectl was down. That slowed me down.
- **Fix:** installed cri-tools.
- **Next time:** cri-tools is now in the Ansible playbook, so every node has it.

## Work network blocked the build

- **What happened:** Ansible could not reach the nodes from my work network.
- **Cause:** the network blocks port 22.
- **Fix:** moved to SSM, which uses port 443 ([runbook](ssh-blocked-ssm.md)).
- **Next time:** the nodes don't need SSH from outside anymore.

## AWS login ran out during long runs

- **What happened:** Ansible found no hosts, and a destroy stopped halfway.
- **Cause:** the AWS login only lasts a short time.
- **Fix:** logged in again and re-ran ([runbook](credentials-expired.md)).
- **Next time:** refresh the login before each long step.

## kube-proxy still running after the Cilium switch

- **What happened:** the cluster had both Cilium and kube-proxy running.
- **Cause:** I pasted the new playbook in the wrong folder, so it was never saved.
- **Fix:** saved it in the right place and rebuilt ([runbook](cilium-ebpf.md)).
- **Next time:** check the file with `grep` before rebuilding.

## Rules I took from this

- If I fix something by hand twice, it goes into Ansible.
- Check that the file really changed before rebuilding.

## Breaking BGP on purpose

- **What happened:** I broke BGP 5 ways: router stopped, port blocked, wrong ASN, app scaled to 0, IP pool deleted.
- **What I learned:** the curl error points to the problem. `rc=28` means network or BGP. `rc=7` means the app.
- **What I learned:** BGP is slow. It took about 90 seconds to notice the block, and more than 20 seconds to come back.
- **Next time:** fix drift by running `bgp.yml` again, not by hand.
