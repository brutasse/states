bind9:
  pkg:
    - installed
  service.running:
    - enabled: True
    - watch:
      - file: bind9
  file.managed:
    - name: /etc/bind/named.conf.options
    - source: salt://bind/named.conf.options
    - template: jinja
    - mode: 644

/etc/dhcp/dhclient.conf:
  file.append:
    - text: |
        interface "eth0" {
        prepend domain-name-servers 127.0.0.1;
        }
    - cmd.wait:
      - name: /etc/init.d/networking restart
      - watch:
        - file: /etc/dhcp/dhclient.conf
