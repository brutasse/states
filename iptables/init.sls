iptables:
  pkg:
    - installed
  file.managed:
    - name: /etc/iptables.rules
    - source: salt://iptables/rules
    - template: jinja
  cmd.wait:
    - name: iptables-restore < /etc/iptables.rules
    - watch:
      - file: iptables
    - require:
      - pkg: iptables

iptables-pre-up:
  file.managed:
    - name: /etc/network/if-pre-up.d/iptables
    - mode: 755
    - source: salt://iptables/pre-up
