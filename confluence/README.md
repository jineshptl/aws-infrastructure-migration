# Troubleshooting

Things I broke on purpose and how I fixed them.

## Servers

- [Nginx down](nginx-down.md)
- [Security group rule removed](security-group-broken.md)
- [Node Exporter down](node-exporter-down.md)

## Kubernetes

- [etcd backup and restore](etcd-backup-restore.md)
- [SSH blocked, moved to SSM](ssh-blocked-ssm.md)
- [Credentials expired](credentials-expired.md)
- [kube-proxy still running after Cilium](cilium-ebpf.md)
- [Worker node died, site went down](worker-node-down.md)

## BGP

- [BGP with FRR](bgp-frr.md)
- [Router down](bgp-router-down.md)
- [Firewall blocks BGP](bgp-firewall.md)
- [Wrong ASN on the router](bgp-wrong-asn.md)
- [App down, route still up](bgp-app-down.md)
- [LoadBalancer IP stuck on pending](lb-ip-pending.md)

## ArgoCD

- [ArgoCD (GitOps)](argocd.md)
- [Someone changed the cluster by hand](argocd-manual-change.md)

## Lessons learned

- [AWS lessons learned](aws-lessons-learned.md)
- [Kubernetes lessons learned](kubernetes-lessons-learned.md)
