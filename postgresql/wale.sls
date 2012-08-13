include:
  - daemontools
  - postgresql
  - virtualenv
  - python

wal-e:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/wal-e
    - no_site_packages: True
    - requirements: salt://postgresql/requirements.txt
    - require:
      - pkg: wal-e-deps
  file.directory:
    - name: /etc/wal-e.d/env
    - user: root
    - group: postgres
    - mode: 750
    - makedirs: True
    - recurse:
      - user
      - group

wal-e-deps:
  pkg.installed:
    - names:
      - lzop
      - mbuffer

extend:
  postgresql:
    file:
      - defaults:
          wal_e: True
          wal_e_command: envdir /etc/wal-e.d/env /home/{{ pillar['user'] }}/wal-e/bin/wal-e

{% for key, value in pillar['postgresql']['env'].iteritems() %}
wal-e-{{ key }}:
  file.managed:
    - name: /etc/wal-e.d/env/{{ key }}
    - source: salt://postgresql/env
    - template: jinja
    - mode: 640
    - context:
      value: {{ value }}
    - require:
      - file: wal-e
{% endfor %}
