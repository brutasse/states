Iptables
========

Configure and run iptables on a minion. Include ``iptables`` on the minion and
set some pillar data::

    iptables:
      tcp_ports:
        - 80
        - 443
        - 4505
        - 4506

This will allow SSH traffic and the specified ports. To explicitly disable
SSH, do::

    iptables:
      ssh: False

If you run a VPN you need to allow forwarded traffic by doing so::

    iptables:
      nat:
        - eth0
        - ppp+
      forward:
        interface: ppp+
        protocol: 47
