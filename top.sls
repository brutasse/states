base:
  "*":
    - salt.minion

  "linode.renie.fr":
    - salt.master
    - autoindex
    - znc
    - iptables
    - pptp
    - sshd
    - certs
    - postgresql.wale
    - postgresql.postgis
    - sites.geoportail
    - git
    - git.deploy_keys
