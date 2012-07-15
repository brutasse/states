My Salt states
==============

This uses a modified version of `Salt`_ which adds `Sentry`_ support for
remote debugging. If you don't need this, simply change ``salt-raven`` to
``salt`` in the fabfile and the salt state.

.. _Salt: http://saltstack.org/
.. _Sentry: http://sentry.readthedocs.org/

Usage:

* On a bare ubuntu machine, create a ``$HOME/salt`` folder and clone this repo
  in it.

* Create a ``$HOME/salt/salt.conf`` file with the following content::

      SALT_MASTER = <salt master IP>
      env.user = <your user>
      env.index_url = <your index url for pip>

  (``env.index_url`` is optional if you're not installing ``salt-raven``).

* Create a virtualenv and install ``Fabric`` in it::

      cd $HOME/salt
      virtualenv env
      env/bin/pip install Fabric

* Bootstrap the master::

      env/bin/fab -H <master ip> enable_salt:master

And to create minions, set their hostnames and do::

    env/bin/fab -H <minion ip> enable_salt:minion
