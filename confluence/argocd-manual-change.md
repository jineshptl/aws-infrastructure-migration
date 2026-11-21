# Someone changed the cluster by hand

**Symptom:** I scaled `web` to 5 by hand. Then I deleted it.

    kubectl scale deploy web --replicas=5
    kubectl delete deploy web

**Check:** a few seconds later it was back to 2 pods. After the delete, it came back right away. curl to the site said `200` the whole time.

**Cause:** I did both on purpose. Git says 2 pods, so the cluster no longer matched Git.

**Fix:** nothing. ArgoCD fixed it by itself (self-heal).

**Verify:**

    ansible control -a "kubectl get deploy web"
    web   2/2

**Note:** hand changes don't last. To change the app for real, change Git and open a PR.
