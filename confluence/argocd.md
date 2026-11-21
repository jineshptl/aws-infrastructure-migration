# ArgoCD (GitOps)

**Goal:** nobody runs `kubectl apply` by hand. Git is the only way to change the app.

**How:** ArgoCD runs in the cluster and watches `kubernetes/apps/web` on `main`. When Git changes, it updates the cluster. When the cluster changes by hand, it puts it back.

**Check:**

    ansible control -a "kubectl -n argocd get applications"
    web    Synced        Healthy

**Test:** I changed `replicas: 2` to `3` in Git and merged the PR. A few minutes later the cluster had 3 pods. I never ran `kubectl`. ArgoCD showed it was running commit `d91ec4f`, the same as Git.

**Check what's deployed:**

    ansible control -a "kubectl -n argocd get application web -o jsonpath={.status.sync.revision}"
    git log --oneline -1

Both should show the same commit.

**Note:** ArgoCD checks GitHub about every 3 minutes. To check right away:

    ansible control -a "kubectl -n argocd annotate application web argocd.argoproj.io/refresh=normal --overwrite"
