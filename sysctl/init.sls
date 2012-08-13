sysctl:
  file.managed:
    - name: /etc/sysctl.conf
    - source: salt://sysctl/sysctl.conf
    - template: jinja
  cmd.wait:
    - name: sysctl -p
    - watch:
      - file: sysctl
