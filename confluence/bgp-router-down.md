# Router down

**Symptom:** the site stopped loading. curl timed out.

    curl -s -m 5 http://10.200.0.0
    FAILED | rc=28

**Check:** I looked at the routes on the router.

    ansible router -a "ip route"

The route to `10.200.0.0` was gone. The router didn't know where to send traffic.

**Cause:** FRR was stopped. I stopped it on purpose with `systemctl stop frr`.

**Fix:**

    ansible router -b -a "systemctl start frr"

I tried curl 20 seconds later and it still failed. I thought the fix didn't work. It was just slow. BGP needs time to connect again.

**Verify:** about a minute later, curl showed the nginx page.

**Note:** after a BGP fix, wait a minute or two before trying something else.
