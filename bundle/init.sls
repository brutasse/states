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
    - name: /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}/requirements.txt:
    - source: salt://bundle/requirements.txt
    - makedirs: True
    - defaults:
        requirements: {{ config['requirements'] }}
  cmd.wait:
    - name: env/bin/pip install -r requirements.txt
    - cwd: /home/{{ pillar['user'] }}/bundles/{{ config['http_host'] }}
    - require:
      - virtualenv: {{ config['http_host'] }}-venv
    - watch:
      - file: {{ config['http_host'] }}-requirements
{%- endif %}

{% if config['env'] %}
{{ env(config['http_host'], config['env'], pillar) }}
{% endif %}

{% endmacro %}
