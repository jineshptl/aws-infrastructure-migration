# Worker node died, site went down

**Symptom:** I turned off the worker server. The site went down and stayed down.

    ansible router -a "curl -s -m 5 http://10.200.0.0"
    rc=7

**Check:**

    ansible control -a "kubectl get nodes"
    ansible control -a "kubectl get pods -o wide"

The worker was `NotReady`. All 3 `web` pods were on it. The router only had a route through the control node. After about 6 minutes Kubernetes made new pods, but they stayed `Pending`.

**Cause:** there was only one worker. The control node doesn't run normal pods, so the pods had nowhere to go. One server could take down the whole site.

**Fix:** three changes, all in code:

1. Added a second worker (`count = 2` in Terraform).
2. Spread the pods across workers (`topologySpreadConstraints` in `web.yml`).
3. Move pods off a dead node after 30 seconds, not 5 minutes (`tolerations` in `web.yml`).

The `web.yml` change went through a PR, and ArgoCD deployed it.

**Verify:** I turned off a worker again (it had 2 of the 3 pods) and checked the site every few seconds.

    14:26:03 000
    14:26:24 200
    14:26:34 000
    14:26:46 000
    14:26:53 200
    ...
    14:29:08 200

About 50 seconds of some errors, then `200` every time. The 2 lost pods came back on the other worker in about 2 minutes.

| | Before | After |
|---|---|---|
| Site | down until I started the worker again | about 50 seconds of some errors |
| New pods | stuck `Pending` | running on the other worker |

**Note:** in the first 50 seconds some requests still went to the dead pods, until Kubernetes marked the node `NotReady`. Also, my first retry still failed because ArgoCD hadn't deployed the fix yet. Check the fix is live before you test it.
