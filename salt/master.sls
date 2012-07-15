include:
  - supervisor
  - salt

restart-salt-master:
  cmd.wait:
    - name: supervisorctl restart salt-master
    - watch:
      - file: salt
    - require:
      - cmd: salt

run-salt-master:
  cmd.wait:
    - name: supervisorctl update
    - watch:
      - file: run-salt-master
  file.managed:
    - name: /etc/supervisor/conf.d/salt-master.conf
    - source: salt://salt/salt.conf
    - template: jinja
    - context:
      mode: master
