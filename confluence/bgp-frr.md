# BGP with FRR

**Goal:** reach a Kubernetes LoadBalancer IP from outside the cluster, without an AWS load balancer.

**How:** a small FRR router (ASN 65000) talks BGP with Cilium on every node (ASN 65001). Cilium gives the `web` Service an IP from `10.200.0.0/24` and tells the router about it.

**Check:**

    ansible router -b -a "vtysh -c 'show bgp summary'"
    ansible router -b -a "vtysh -c 'show ip route bgp'"
    ansible router -a "curl -s -m 5 http://10.200.0.0"

One neighbor per node, a route to `10.200.0.0` through every node, and the nginx page.

**Test:** I took the BGP label off one node. The route moved to the other nodes and curl still worked. More nodes means one can go down.

**Note:** on AWS, all servers must be in the same subnet and have source/dest check turned off, or the traffic gets dropped.
