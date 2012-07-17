include:
  - supervisor
  - salt

configure-salt-minion:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://salt/minion.template
    - template: jinja

restart-salt-minion:
  cmd.wait:
    - name: supervisorctl restart salt-minion
    - watch:
      - file: salt
      - file: configure-salt-minion
    - require:
      - cmd: salt

run-salt-minion:
  cmd.wait:
    - name: supervisorctl update
    - watch:
      - file: run-salt-minion
    - require:
      - file: configure-salt-minion
  file.managed:
    - name: /etc/supervisor/conf.d/salt-minion.conf
    - source: salt://salt/salt.conf
    - template: jinja
    - defaults:
        run_mode: minion
