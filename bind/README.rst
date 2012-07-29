Bind
====

Run a DNS cache using bind9. Include ``bind`` on your minion and set some
pillar data::

    bind:
      domain: members.linode.com
      search: members.linode.com
      nameservers:
        - 8.8.8.8
        - 4.4.4.4
