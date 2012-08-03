ssh:
  pkg.installed:
    - name: openssh-server
  service.running:
    - enable: True
    - watch:
      - file: ssh
      - pkg: ssh
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd/sshd_config
    - template: jinja
