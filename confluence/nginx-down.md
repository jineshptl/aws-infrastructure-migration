# Nginx down on app01

**Symptom:** the site on port 8080 wouldn't load. curl gave me `Couldn't connect to server`.

**Check:**

    ansible app -b -a "systemctl is-active docker"
    ansible app -b -a "docker ps -a"

Docker was running fine, but the web container said `Exited (0)`.

**Cause:** I stopped the container myself. `unless-stopped` won't bring back a container you stopped on purpose.

**Fix:**

    ansible-playbook playbooks/nginx.yml

**Verify:** curl showed "Welcome to nginx!" again.

**Note:** no alert went off. Prometheus only watches the servers, not the site itself. A blackbox check on port 8080 would have caught it.
