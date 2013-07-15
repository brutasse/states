"""
Manage a file structure suitable for envdir
===========================================

.. code-block:: yaml

    /etc/my-app.d/envdir:
      envdir.managed:
        - user: brutasse
        - mode: 640
        - data:
            AWS_ACCESS_KEY: foobar
            DATABASE_URL: postgres://etc etc

To remove the envdir::

    /etc/my-app.d/envdir:
      file:
        - absent

To use with Pillar data::

    # pillar/myapp.sls
    myapp:
      env:
        SECRET_KEY: "foobar"

    # states/myapp.sls
    myapp:
      envdir.managed:
        - user: brutasse
        - mode: 640
        - data:
            {% for key, value in pillar['myapp']['env'].items() %}
            {{ key }}: "{{ value }}"
            {% endfor %}
"""
import os


def _error(ret, message):
    ret['result'] = False
    ret['comment'] = message
    return ret


def managed(name, user=None, group=None, mode=None, data=None, **kwargs):
    mode = __salt__['config.manage_mode'](mode)
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': ''}

    if data is None:
        ret['comment'] = 'No data provided'
        return ret

    if not os.path.isabs(name):
        return _error(
            ret,
            "Specified directory {0} is not an absolute path".format(name))

    if not os.path.exists(name):
        __salt__['file.mkdir'](name, user=user, group=group, mode=755)
        ret['changes'][name] = 'New directory'
        __salt__['file.check_perms'](name, ret, user, group, 755)

    existing = os.listdir(name)

    extra = set(existing) - set(data.keys())
    for filename in extra:
        full_name = os.path.join(name, filename)
        os.remove(full_name)
        ret['changes'][full_name] = 'Deleted'

    for key, value in data.items():
        file_name = os.path.join(name, key)
        existing = os.path.exists(file_name)
        if existing:
            with open(file_name, 'r') as f:
                content = f.read()
            if content == value:
                __salt__['file.check_perms'](file_name, ret, user, group, mode)
                continue

        with open(file_name, 'w') as f:
            f.write(value)
            ret['changes'][file_name] = 'Updated' if existing else 'Created'
            __salt__['file.check_perms'](file_name, ret, user, group, mode)
    return ret
