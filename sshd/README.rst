SSH
===

This configures an SSH server with the following options:

* No password authentication, only SSH keys

* No root login

* Aggressive connection settings (LoginGraceTime, MaxAuthTries, MaxStartups)

Just include ``sshd`` on your minion. Optionally restrict SSH login to a set
of user by adding to your pillar data::

    sshd:
      users:
        - test
        - otheruser
