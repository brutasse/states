base:
  "*":
    - salt.minion

  "linode.renie.fr":
    - salt.master
    - znc
    - iptables
    - pptp
    - sshd
    - postgresql.postgis
    - sites.geoportail
    - sites.dotim
    - sites.bruno_renie_fr
    - sites.noelle_renie_fr
    - sites.media_bruno_im
    - sites.djangocommits
