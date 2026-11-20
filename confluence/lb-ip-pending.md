# LoadBalancer IP stuck on pending

**Symptom:** the Service lost its IP.

    ansible control -a "kubectl get svc web"
    web   LoadBalancer   10.98.18.70   <pending>   80:30243/TCP

The router had no BGP route either.

**Check:** no IP pool. Cilium had no IP to give out, so BGP had nothing to share.

**Cause:** I deleted the pool `lab-pool` on purpose.

**Fix:**

    ansible-playbook playbooks/bgp.yml
    TASK [Apply BGP config]   changed

**Verify:**

    web   LoadBalancer   10.98.18.70   10.200.0.0   80:30243/TCP

**Note:** if a Service says `<pending>`, check the IP pool first.
