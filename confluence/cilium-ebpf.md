# kube-proxy still running after switching to Cilium

**Symptom:** Cilium was working, but kube-proxy was still there.

**Check:**

    ansible control -a "kubectl -n kube-system get ds"
    ansible control -b -a "iptables-save" | grep -c KUBE-SVC

`kube-proxy` was in the list. There were `19` KUBE-SVC rules. So kube-proxy was still doing the work.

    grep -n "skip-phases\|kubeProxyReplacement" kubernetes/ansible/playbooks/cluster.yml

Nothing came back. The new playbook was never saved.

**Cause:** I pasted the new `cluster.yml` from the wrong folder. The file was not saved, so the old one ran.

**Fix:** saved the file from the repo root. Then rebuilt the cluster.

**Verify:** no `kube-proxy`, `0` KUBE-SVC rules, and `cilium status` says OK.

**Note:** now kubeadm does not install kube-proxy. Cilium does that job with eBPF, which is faster. BGP is turned on for the next step.
