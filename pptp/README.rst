PPTPD
=====

This lets you run a VPN server with pptpd. Include ``pptp`` to your minion and
set some pillar data::

    pptp:
      localip: 192.168.1.2
      remoteip: 192.168.1.10-20
      users:
        username1: "password"
        username2: "password"

    bind:
      nameservers:
        - 8.8.8.8
        - 4.4.4.4

    sysctl:
      net.ipv4.ip_forward: 1

Here is how to configure it on a client:

.. image:: https://github.com/brutasse/states/raw/master/pptp/vpn.png
