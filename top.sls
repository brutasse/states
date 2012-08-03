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
