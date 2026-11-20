# App down, route still up

**Symptom:** the site went down, but this time the error was different.

    curl -s -m 5 http://10.200.0.0
    FAILED | rc=7

**Check:** first I checked the network.

    ansible router -b -a "vtysh -c 'show ip route bgp'"
    B>* 10.200.0.0/32 via 172.31.18.230
      *               via 172.31.22.68

The route was fine. So the problem was the app. No `web` pods were running.

**Cause:** I scaled `web` to 0 on purpose. BGP only sends traffic. It doesn't know if the app works.

**Fix:**

    ansible control -a "kubectl scale deploy web --replicas=2"

**Verify:** curl showed the nginx page.

**Note:** the curl error tells you where to look.
`rc=28` (timed out) = network or BGP problem.
`rc=7` (refused) = network is fine, the app is down.
