Salt
====

Run salt masters or minions.

Set some pillar data::

    user: test

    salt:
      master: 192.168.1.2
      index_url: http://pypi.python.org/simple

Then on a machine, include ``salt.master`` and/or ``salt.minion``.
