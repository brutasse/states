Sysctl
======

This state lets you set kernel configuration values in ``/etc/sysctl.conf``.

Include ``sysctl`` and set the values you need in a ``sysctl`` pillar
variable::

    sysctl:
      net.ipv4.ip_forward: 1
      kernel.shmmax: 268435456
