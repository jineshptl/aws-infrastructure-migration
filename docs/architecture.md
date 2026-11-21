# Architecture

## 2-server lab

```mermaid
flowchart LR
    me[Laptop] --> app01[app01: Nginx]
    me --> mon[monitor01: Prometheus + Grafana]
    mon -- metrics --> app01
```

Two servers on AWS. Terraform builds them, Ansible sets them up. Only my IP can reach them.

## Kubernetes lab

```mermaid
flowchart LR
    gh[GitHub] -- ArgoCD --> control[control node]
    control --> w1[worker-1]
    control --> w2[worker-2]
    router[FRR router] -- BGP --> control
    router -- BGP --> w1
    router -- BGP --> w2
```

One control node, two workers and a router. Cilium runs the network. BGP sends the app IP (`10.200.0.0`) to the router, so if one worker dies the other one keeps the site up.

ArgoCD deploys whatever is in Git. I reach the servers through SSM, not SSH.
