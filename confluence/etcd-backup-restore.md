# etcd backup and restore

**Symptom:** need to roll the cluster back, or etcd data is lost.

**Check the etcd version first**

    sudo grep image /etc/kubernetes/manifests/etcd.yaml

Use etcdctl/etcdutl of the same version. Ubuntu's etcd-client is 3.4 and breaks a 3.6 cluster.

**Backup**

    sudo ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-backup.db \
      --endpoints=https://127.0.0.1:2379 \
      --cacert=/etc/kubernetes/pki/etcd/ca.crt \
      --cert=/etc/kubernetes/pki/etcd/server.crt \
      --key=/etc/kubernetes/pki/etcd/server.key
    sudo etcdutl snapshot status /tmp/etcd-backup.db -w table

**Restore**

    sudo etcdutl snapshot restore /tmp/etcd-backup.db --data-dir=/var/lib/etcd-restore
    sudo vi /etc/kubernetes/manifests/etcd.yaml   # hostPath path -> /var/lib/etcd-restore

**Verify**

    sudo crictl ps -a | grep -E "etcd|kube-apiserver"
    kubectl get deployments

**What went wrong the first time:** restored with etcdctl 3.4 on etcd 3.6.6. etcd crash-looped and the API server was refused. Found it with `crictl logs`. Restored again with etcdutl 3.6.6 and it came back.
