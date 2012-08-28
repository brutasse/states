Bind
====

Run a DNS cache using bind9. Include ``bind`` on your minion and set some
pillar data::

    bind:
      nameservers:
        - 8.8.8.8
        - 4.4.4.4
