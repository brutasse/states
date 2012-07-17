include:
  - supervisor
  - salt

configure-salt-master:
  file.managed:
    - name: /etc/salt/master
    - source: salt://salt/master.template
    - template: jinja

restart-salt-master:
  cmd.wait:
    - name: supervisorctl restart salt-master
    - watch:
      - file: salt
      - file: configure-salt-master
    - require:
      - cmd: salt

run-salt-master:
  cmd.wait:
    - name: supervisorctl update
    - watch:
      - file: run-salt-master
    - require:
      - file: configure-salt-master
  file.managed:
    - name: /etc/supervisor/conf.d/salt-master.conf
    - source: salt://salt/salt.conf
    - template: jinja
    - defaults:
        run_mode: master
