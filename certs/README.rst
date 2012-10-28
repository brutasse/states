SSL certificates
================

This state lets you deploy SSL certificates. Include ``certs`` and set some
pillar data::

    ssl_certs:
      example.com:
        key: |
          -----BEGIN RSA PRIVATE KEY-----
          stuff here…
          -----END RSA PRIVATE KEY-----
        crt:
          -----BEGIN CERTIFICATE-----
          yo
          -----END CERTIFICATE-----
          -----BEGIN CERTIFICATE-----
          dawg
          -----END CERTIFICATE-----
          -----BEGIN CERTIFICATE-----
          sup'
          -----END CERTIFICATE-----

This will write ``/etc/ssl/private/example.com.{key,crt}``. You can then use
them in the config files you need.
