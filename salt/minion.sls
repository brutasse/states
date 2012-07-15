include:
  - supervisor
  - salt

restart-salt-minion:
  cmd.wait:
    - name: supervisorctl restart salt-minion
    - watch:
      - file: salt
    - require:
      - cmd: salt

run-salt-minion:
  cmd.wait:
    - name: supervisorctl update
    - watch:
      - file: run-salt-minion
  file.managed:
    - name: /etc/supervisor/conf.d/salt-minion.conf
    - source: salt://salt/salt.conf
    - template: jinja
    - defaults:
        run_mode: minion
