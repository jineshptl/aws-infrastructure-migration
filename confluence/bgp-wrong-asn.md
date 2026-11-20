# Wrong ASN on the router

**Symptom:** I changed the router config and the site went down.

    curl -s -m 5 http://10.200.0.0
    FAILED | rc=28

**Check:**

    ansible router -b -a "vtysh -c 'show bgp summary'"
    % No BGP neighbors found in VRF default

No neighbors. The ASN in `frr.conf` said `65099`, but Cilium uses `65001`. If they don't match, BGP won't connect.

**Cause:** I changed the number by hand on purpose.

**Fix:** I didn't fix it by hand. I just ran the playbook again.

    ansible-playbook playbooks/bgp.yml
    TASK [FRR config]   changed
    RUNNING HANDLER [Restart FRR]   changed

Ansible saw the file was wrong and put the right one back.

**Verify:** curl showed the nginx page.

**Note:** if Ansible says `changed` and nobody changed anything, someone edited the server by hand.
