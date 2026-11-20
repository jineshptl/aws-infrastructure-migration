# Flannel to Cilium

Swapped flannel for Cilium and removed kube-proxy. Cilium handles Services with eBPF.

**Check:** no `kube-proxy` in `kubectl -n kube-system get ds`, and `iptables-save | grep -c KUBE-SVC` is `0`.
