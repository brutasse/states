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
    - postgresql.wale
    - postgresql.postgis
    - sites.geoportail
    - sites.bruno_renie_fr
