# Firewall blocks BGP

**Symptom:** I added a firewall rule and everything still worked. About 2 minutes later, the site went down.

    curl -s -m 5 http://10.200.0.0
    FAILED | rc=28

**Check:**

    ansible router -b -a "vtysh -c 'show bgp summary'"
    % No BGP neighbors found in VRF default

The router lost both nodes.

**Cause:** I blocked port 179 on purpose. BGP uses that port.

    iptables -I INPUT -p tcp --dport 179 -j DROP

**Fix:** removed the rule.

    ansible router -b -a "iptables -D INPUT -p tcp --dport 179 -j DROP"

**Verify:** 30 seconds later, curl showed the nginx page.

**Note:** BGP waits about 90 seconds before it gives up on a neighbor. So a bad change can look fine at first and break later.
