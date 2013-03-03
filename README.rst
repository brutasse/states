My Salt states
==============

These are the `Salt`_ states I use on my personal servers. Fully tested on
Ubuntu 12.04 LTS. They're useful for things such as:

* Managing Salt itself

* Running an IRC bouncer

* Running a VPN

* Running a private python package index

* Running a PostgreSQL server with continuous archiving through WAL-E, PostGIS
  support

* Running a relatively secured SSH server

* Running a local DNS cache

.. _Salt: http://saltstack.org/

Installation
------------

* On a bare ubuntu machine, create a ``$HOME/salt`` folder and clone this repo
  in it.

* Create a ``$HOME/salt/salt.conf`` file with the following content::

      SALT_MASTER = <salt master IP>
      env.user = <your user>
      env.index_url = <your index url for pip>

  (``env.index_url`` is optional if you're fine with using the canonical
  python package index).

* Create a virtualenv and install ``Fabric`` and ``Jinja2`` in it::

      cd $HOME/salt
      virtualenv env --system-site-packages
      env/bin/pip install Fabric Jinja2

* Bootstrap the master::

      cd states
      ../env/bin/fab -H <master ip> enable_salt:master

And to create minions, set their hostnames and do::

    ../env/bin/fab -H <minion ip> enable_salt:minion

Usage
-----

See `salt/README.rst`_ and all the state's ``README`` files.

.. _salt/README.rst: https://github.com/brutasse/states/tree/master/salt

License
-------

3-clause BSD license, see the LICENSE file for details.
