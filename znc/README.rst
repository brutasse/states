ZNC
===

This state configures a ZNC bouncer. Include ``znc`` on the minion you want it
to run on and add some pillar data::

    znc:
      port: 6667
      cert: |
        -----BEGIN RSA PRIVATE KEY-----
        here the content of your .pem file
        for SSL handling. Contains a private key…
        -----END RSA PRIVATE KEY-----
        -----BEGIN CERTIFICATE-----
        …and a certificate
        -----END CERTIFICATE-----
      users:
        nickname1:
          password_hash: sha256#hexdigest#salt#
          real_name: Your Name
          vhost: example.com
          quit_msg: Cool story bro
          server_host: chat.freenode.net
          server_port: 6667
          buffer: 5000
          admin: true
          chans:
            - "#django-floppyforms"
            - "#djangopeople.net"
        nickname2:
          # etc etc

To generate a password hash, use this python snippet::

    import getpass
    import hashlib
    import string

    from random import SystemRandom

    raw_password = getpass.getpass()

    salt_chars = string.ascii_letters + string.digits
    random = SystemRandom()
    salt = "".join([random.choice(salt_chars) for i in range(20)])
    print("sha256#{hash}#{salt}#".format(
        hash=hashlib.sha256((raw_password+salt).encode('utf-8')).hexdigest(),
        salt=salt
    ))
