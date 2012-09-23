{% from "daemontools/init.sls" import env %}

{% macro bundle(config, pillar) %}

{#
include:
  - daemontools
  - nginx
  - postgresql.postgis
  - postgresql.wale
  - python
#}

{{ config['http_host'] }}-dirs:
  file.directory:
    - names:
      - /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}/conf
      - /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}/log
      - /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}/public
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

{% if config['requirements'] -%}
{{ config['http_host'] }}-venv:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}/env
    - no_site_packages: True
    - system_site_packages: False
    - require:
      - file: {{ config['http_host'] }}-dirs

{{ config['http_host'] }}-requirements:
  file.managed:
    - name: /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}/requirements.txt
    - source: salt://bundle/requirements.txt
    - template: jinja
    - makedirs: True
    - mode: 644
    - defaults:
        config: {{ config }}
  cmd.wait:
    - name: env/bin/pip install -r requirements.txt
    - cwd: /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}
    - require:
      - virtualenv: {{ config['http_host'] }}-venv
    - watch:
      - file: {{ config['http_host'] }}-requirements

{% if config['db_name'] %}
{{ config['http_host'] }}-db:
  cmd.run:
    - name: createdb -E UTF8 -T template_postgis -U postgres {{ config['db_name'] }}
    - unless: psql -U postgres -ltA | grep '^{{ config['db_name'] }}|'
    - require:
      - cmd: postgis-template

{{ config['http_host'] }}-syncdb:
  cmd.wait:
    - name: >
        envdir /etc/{{ config['http_host'] }}.d
        env/bin/django-admin.py syncdb --noinput
    - cwd: /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}
    - watch:
      - file: {{ config['http_host'] }}-requirements
    - require:
      - cmd: {{ config['http_host'] }}-db
{% endif %}

{{ config['http_host'] }}-collectstatic:
  cmd.wait:
    - name: >
        envdir /etc/{{ config['http_host'] }}.d
        env/bin/django-admin.py collectstatic --noinput
    - cwd: /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}
    - watch:
      - file: {{ config['http_host'] }}-requirements
    - require:
      - cmd: {{ config['http_host'] }}-requirements
{% if config['db_name'] %}
      - cmd: {{ config['http_host'] }}-db
{%- endif %}
{%- endif %}

{% if config['env'] %}
{{ env(config['http_host'], config['env'], pillar) }}
{% endif %}

{{ config['http_host'] }}-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ config['http_host'] }}.conf
    - template: jinja
    - source: salt://bundle/nginx.conf
    - mode: 644
    - defaults:
        config: {{ config }}
    - watch_in:
      - service: nginx

{{ config['http_host'] }}-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ config['http_host'] }}.conf
    - target: /etc/nginx/sites-available/{{ config['http_host'] }}.conf
    - require:
      - file: {{ config['http_host'] }}-nginx-available
    - require_in:
      - service: nginx
{% endmacro %}
