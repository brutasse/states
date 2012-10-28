include:
  - nginx

{% set root = "/home/" + pillar['user'] + "/bundles/media.bruno.im" %}

media.bruno.im:
  file.directory:
    - name: {{ root }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - makedirs: True

media.bruno.im-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/media.bruno.im.conf
    - source: salt://sites/media.bruno.im.conf
    - template: jinja
    - watch_in:
      - service: nginx

media.bruno.im-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/media.bruno.im.conf
    - target: /etc/nginx/sites-available/media.bruno.im.conf
    - watch_in:
      - service: nginx
