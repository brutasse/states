postgresql:
  pkg:
    - installed
  file.managed:
    - name: /etc/postgresql/9.1/main/postgresql.conf
    - source: salt://postgresql/postgresql.conf
    - template: jinja
    - user: postgres
    - group: postgres
    - defaults:
      shared_buffers: 128MB
      work_mem: 16MB
      maintenance_work_mem: 16MB
      effective_cache_size: 256MB
    - require:
      - pkg: postgresql
  service.running:
    - enable: True
    - watch:
      - file: postgresql
