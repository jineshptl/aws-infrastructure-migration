# Nginx down on app01

**Symptom:** site on port 8080 not loading. curl says `Couldn't connect to server`.

**Check:**

    ansible app -b -a "systemctl is-active docker"
    ansible app -b -a "docker ps -a"

Docker was `active`, but the web container showed `Exited (0)`.

**Cause:** container was stopped by hand. `unless-stopped` doesn't restart a container someone stopped.

**Fix:**

    ansible-playbook playbooks/nginx.yml

**Verify:** curl shows "Welcome to nginx!" again.

**Note:** no alert fired, Prometheus only watches the servers. A blackbox check on port 8080 would catch this.
