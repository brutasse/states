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
    - sites.dotim
    - sites.bruno_renie_fr
    - sites.noelle_renie_fr
    - sites.media_bruno_im
