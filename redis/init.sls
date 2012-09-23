redis-server:
  pkg:
    - installed
  service.running:
    - enable: True
