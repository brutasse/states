nginx:
  pkg:
    - installed
  service.running:
    - enable: True
    - watch:
      - file: time-log

time-log:
  file.managed:
    - name: /etc/nginx/conf.d/time_log.conf
    - source: salt://nginx/time_log.conf
    - require:
      - pkg: nginx
