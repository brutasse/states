Salt
====

Run salt masters or minions.

Set some pillar data::

    user: test
    index_url: http://pypi.python.org/simple

    salt:
      master: 192.168.1.2

Then on a machine, include ``salt.master`` and/or ``salt.minion``.

You can customize which python package provides salt, for instance if you
have a vendorized version. Mine is called ``salt-raven`` and adds Sentry
debugging. Oh and you can add environment variables::

    salt:
      package: salt-raven
      master: 192.168.1.2
      env:
        SENTRY_DSN: https://…
