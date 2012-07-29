bind9:
  pkg:
    - installed
  service.running:
    - enabled: True
    - watch:
      - file: bind9-forwarders
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://bind/resolv.conf
    - template: jinja

bind9-forwarders:
  file.managed:
    - name: /etc/bind/named.conf.options
    - source: salt://bind/named.conf.options
    - template: jinja
