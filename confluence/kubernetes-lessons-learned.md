# Kubernetes lab: lessons learned

**Goal:** a real Kubernetes cluster on AWS, built with kubeadm (like the CKA exam), for almost $0.
**Result:** a v1.35 cluster with 1 control node, 2 workers and a BGP router. Cilium, BGP and ArgoCD. I can rebuild it from code in about 15 minutes. It costs about $0.08/hour and I delete it after every session.

## Cluster went down after an etcd restore

- **What happened:** the API server was down for about 5 minutes during a practice restore. `crictl ps -a` showed etcd and the API server restarting again and again.
- **Cause:** I used etcd tools v3.4 on etcd v3.6.6. The versions didn't match, so etcd crashed. `crictl logs` showed the error.
- **Fix:** restored again with etcdutl v3.6.6. The cluster was back in about 1 minute.
- **Next time:** the runbook checks the etcd version first ([runbook](etcd-backup-restore.md)).

## Missing tool during the outage

- **What happened:** crictl wasn't installed when kubectl was down. That slowed me down.
- **Cause:** I only installed tools I needed day to day.
- **Fix:** installed cri-tools.
- **Next time:** cri-tools is in the Ansible playbook, so every node has it.

## Work network blocked the build

- **What happened:** Ansible couldn't reach the nodes from my work network.
- **Cause:** the network blocks port 22.
- **Fix:** moved to SSM, which uses port 443 ([runbook](ssh-blocked-ssm.md)).
- **Next time:** the nodes don't need SSH from outside anymore.

## AWS login ran out during long runs

- **What happened:** Ansible found no hosts, and a destroy stopped halfway.
- **Cause:** the AWS login only lasts a short time.
- **Fix:** logged in again and ran it again ([runbook](credentials-expired.md)).
- **Next time:** refresh the login before each long step.

## kube-proxy still running after the Cilium switch

- **What happened:** the cluster had both Cilium and kube-proxy running.
- **Cause:** I pasted the new playbook in the wrong folder, so it was never saved.
- **Fix:** saved it in the right place and rebuilt ([runbook](cilium-ebpf.md)).
- **Next time:** check the file with `grep` before rebuilding.

## Breaking BGP on purpose

- **What happened:** I broke BGP 5 ways: router stopped, port blocked, wrong ASN, app scaled to 0, IP pool deleted.
- **Cause:** on purpose, to see how BGP fails ([runbooks](README.md#bgp)).
- **Fix:** undid the change, or ran `bgp.yml` again.
- **Next time:** the curl error points to the problem. `rc=28` means network or BGP. `rc=7` means the app. BGP is slow, so wait a minute or two after a fix.

## One worker took the whole site down

- **What happened:** I turned off the only worker. The site was down until I brought it back.
- **Cause:** all pods were on one worker, and there was no other place to run them.
- **Fix:** added a second worker and spread the pods. Now a dead worker means about 50 seconds of errors, not a full outage ([runbook](worker-node-down.md)).
- **Next time:** test what happens when each part dies, not just when everything works.

## Tested the fix before it was deployed

- **What happened:** after the fix, I killed a worker again and the site still went down.
- **Cause:** ArgoCD hadn't picked up the new commit yet. It was still running the old `web.yml`.
- **Fix:** made ArgoCD check Git right away, confirmed the commit matched, then tested again ([runbook](argocd.md)).
- **Next time:** check the deployed commit before testing a fix.

## AWS CLI blocked on the work network

- **What happened:** `aws ec2 stop-instances` failed with `SSL validation failed ... certificate key too weak`.
- **Cause:** my work network inspects HTTPS traffic, and the AWS CLI rejected its certificate.
- **Fix:** turned the server off from inside with `poweroff -f` over SSM, and started it again from the AWS console.
- **Next time:** have a second way to reach AWS (the console, or SSM).

## Rules I took from this

- If I fix something by hand twice, it goes into Ansible.
- Change Git, not the cluster.
- Check that the file really changed before rebuilding.
- Check that the fix is really deployed before testing it.
