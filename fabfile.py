import sys

from fabric.api import run, sudo, task, cd, env
from fabric.colors import red, blue
from fabric.contrib.files import exists, upload_template, contains, append
from fabric.utils import abort

config = {}
with open('salt.conf', 'r') as conf:
    for line in conf.readlines():
        key, config[key] = line.strip().split(' = ')
        if key.startswith('env.'):
            env[key[4:]] = config[key]
env.forward_agent = True
SALT_MASTER = config['SALT_MASTER']


def die(msg):
    abort(red(msg, bold=True))


def btw(msg):
    print >>sys.stderr, blue(msg)


@task
def enable_salt(mode):
    if not mode in ('master', 'minion'):
        die("`mode` can only be 'master' or 'minion'")
    sudo('apt-get update')

    sudo('apt-get -y install libzmq-dev python-virtualenv supervisor swig '
         'python-m2crypto build-essential python-dev')
    run('mkdir -p salt')
    with cd('salt'):
        if not exists('env/bin/pip'):
            version = run('virtualenv --version')
            opts = '--system-site-packages' if version >= "1.7" else ''
            run('virtualenv %s env' % opts)
            run('./env/bin/pip install -U pip')
        btw('Installing salt. This may take a while.')
        cmd = './env/bin/pip install {opts} salt-raven'
        opts = ''
        if 'index_url' in env:
            opts = '-i {index_url}'.format(index_url=env.index_url)
        cmd = cmd.format(opts=opts)
        run(cmd)

    sudo('mkdir -p /etc/salt')
    user = run('whoami')

    upload_template('%s.template' % mode, '/etc/salt/%s' % mode,
                    context={'salt_master': SALT_MASTER, 'user': user},
                    use_sudo=True)
    upload_template('supervisor.conf',
                    '/etc/supervisor/conf.d/salt-%s.conf' % mode,
                    context={'mode': mode, 'user': user}, use_sudo=True)
    out = sudo('supervisorctl update')
    if not out:
        sudo('supervisorctl restart salt-%s' % mode)

    if mode == 'minion':
        btw("Now go to the salt master and accept the client key")
        btw("    (run salt-key -L then salt-key -a <the name>)")

    else:
        bashrc = '/home/%s/.bashrc' % user
        if not exists(bashrc):
            run('touch %s' % bashrc)

        # Alias to make salt easier to use
        items = [i[4:] for i in run('ls -x salt/env/bin').split() if i.startswith('salt')]
        for item in items:
            alias = 'alias salt%(item)s="sudo /home/%(user)s/salt/env/bin/salt%(item)s"' % {'item': item, 'user': user}
            if not contains(bashrc, alias):
                append(bashrc, alias)
