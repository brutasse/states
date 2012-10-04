Postgresql
==========

Installs and configures a postgresql server and its databases. Include
``postgresql`` on a minion.

Optionally you can add `WAL-E`_ for continuous archiving to your S3 account.
To do so, include ``postgresql.wale`` and set some pillar data::

    user: ubuntu # the user account holding the wal-e installation
    postgresql:
      env:
        AWS_SECRET_ACCESS_KEY: <secret here>
        AWS_ACCESS_KEY_ID: <access key here>
        WALE_S3_PREFIX: s3://some-bucket/directory/or/whatever

.. _WAL-E: https://github.com/heroku/WAL-E/

PostGIS is also supported. Instead of including ``postgresql``, simply include
``postgresql.postgis``. This will create a spatial database template named
``template_postgis``.

To create databases, add to your pillar data::

    postgresql:
      databases:
        - database1
        - database2

And for spatial databases::

    postgresql:
      spatial_databases:
        - spatial1
        - spatial2
