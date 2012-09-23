include:
  - postgresql

postgis-packages:
  pkg.installed:
    - names:
      - postgis
      - postgresql-9.1-postgis

postgis-template:
  file.managed:
    - name: /etc/postgresql/9.1/main/postgis_template.sh
    - source: salt://postgresql/create_template_postgis-debian.sh
    - user: postgres
    - group: postgres
    - mode: 755
  cmd.run:
    - name: bash /etc/postgresql/9.1/main/postgis_template.sh
    - user: postgres
    - cwd: /var/lib/postgresql
    - unless: psql -U postgres -l|grep template_postgis
    - require:
      - file: postgis-template
      - pkg: postgis-packages
