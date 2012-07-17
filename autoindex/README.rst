Autoindex
---------

This lets you run `autoindex`_ as a private package index / PyPI mirror.

.. _autoindex: https://github.com/brutasse/autoindex


To use it, just include ``autoindex`` on a minion and put in the pillar data::


    autoindex:
      url: pypi.example.com
      packages:
        - Django
        - Fabric
        - etc. etc.

If you want ``autoindex`` to report to Sentry, set ``autoindex.sentry_dsn``::

    autoindex:
      sentry_dsn: https://…
