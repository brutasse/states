Daemontools
===========

This state installs `Daemontools`_. Simply include ``daemontools`` on a
minion.

.. _Daemontools: http://cr.yp.to/daemontools.html

To create a structure usable with ``envdir``, set your desired environment in
your pillar data::

    some_project:
      env:
        SENTRY_DSN: https://…
        DATABASE_URL: postgres://…

And then, in a state file::

    {% from "daemontools/init.sls" import env %}

    {% env("some_project", pillar['some_project']['env']) %}

This will create ``/etc/some_project.d/SENTRY_DSN``, etc. so you can use
``envdir /etc/some_project.d <command>``.
