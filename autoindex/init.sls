include:
  - supervisor
  - nginx
  - virtualenv

autoindex:
  file.directory:
    - name: /home/{{ pillar['user'] }}/autoindex
    - user: {{ pillar['user'] }}
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/autoindex/env
    - require:
      - file: autoindex
  cmd.wait:
    - name: env/bin/pip install -U pip; env/bin/pip install -r requirements.txt
    - cwd: /home/{{ pillar['user'] }}/autoindex
    - require:
      - virtualenv: autoindex
    - watch:
      - file: autoindex-requirements

autoindex-requirements:
  file.managed:
    - name: /home/{{ pillar['user'] }}/autoindex/requirements.txt
    - source: salt://autoindex/requirements.txt
    - template: jinja
    - user: {{ pillar['user'] }}
    - defaults:
        autoindex_version: 0.1
    - require:
      - file: autoindex

autoindex-public:
  file.directory:
    - name: /home/{{ pillar['user'] }}/autoindex/public
    - recurse:
      - user
    - user: {{ pillar['user'] }}

autoindex-mirror:
  file.managed:
    - name: /home/{{ pillar['user'] }}/autoindex/public/mirror
    - source: salt://autoindex/mirror
    - user: {{ pillar['user'] }}
    - template: jinja
    - require:
      - file: autoindex-public
  cmd.wait:
    - name: env/bin/autoindex mirror -d public
    - cwd: /home/{{ pillar['user'] }}/autoindex
    - user: {{ pillar['user'] }}
    - require:
      - cmd: autoindex-watch
    - watch:
      - file: autoindex-mirror

autoindex-watch:
  file.managed:
    - name: /etc/supervisor/conf.d/autoindex-watch.conf
    - source: salt://autoindex/watch.conf
    - template: jinja
  cmd.wait:
    - name: supervisorctl update
    - watch:
      - file: autoindex-watch
    - require:
      - cmd: autoindex

restart-watcher:
  cmd.wait:
    - name: supervisorctl restart autoindex-watch
    - watch:
      - cmd: autoindex

autoindex-server:
  file.managed:
    - name: /etc/nginx/sites-available/autoindex.conf
    - source: salt://autoindex/nginx.conf
    - template: jinja
    - require:
      - pkg: nginx

autoindex-symlink:
  file.symlink:
    - name: /etc/nginx/sites-enabled/autoindex.conf
    - target: /etc/nginx/sites-available/autoindex.conf
    - require:
      - file: autoindex-server

extend:
  nginx:
    service:
      - watch:
        - file: autoindex-server
