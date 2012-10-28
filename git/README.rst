Git
===

This state installs git on minions. Just include ``git``.

Deploy keys
-----------

If you're using git deploy keys, you can manage them using
``git.deploy_keys``. Include it and set some pillar data::

    user: someuser

    deploy_keys:
      repository_name:
        host: github.com
        key: |
          -----BEGIN RSA PRIVATE KEY-----
          etc etc
          -----END RSA PRIVATE KEY-----
      other_repo:
        host: bitbucket.org
        key: |
          etc etc

Keys are written to ``/home/someuser/.ssh/repository_name_rsa`` and
``/home/someuser/.ssh/other_repo_rsa``. Then when you need to clone a
repository, prepend the repo name to the host to let git select the
appropriate deploy key::

    git@repository_name.github.com:brutasse/repository_name.git

``repository_name.github.com`` is aliased to ``github.com`` in
``~/.ssh/config``.
