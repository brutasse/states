{% from "daemontools/init.sls" import env %}

{% macro bundle(config, pillar) %}

{#
include:
  - daemontools
  - nginx
  - postgresql.postgis
  - python
#}

{{ pillar[config]['http_host'] }}-dirs:
  file.directory:
    - names:
      - /home/{{ pillar['user'] }}/bundles/{{ pillar[config]['http_host'] }}/conf
      - /home/{{ pillar['user'] }}/bundles/{{ pillar[config]['http_host'] }}/log
      - /home/{{ pillar['user'] }}/bundles/{{ pillar[config]['http_host'] }}/public
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

{% if pillar[config]['requirements'] -%}
{{ pillar[config]['http_host'] }}-venv:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/bundles/{{ pillar[config]['http_host'] }}/env
    - no_site_packages: True
    - system_site_packages: False
    - require:
      - file: {{ pillar[config]['http_host'] }}-dirs

{{ pillar[config]['http_host'] }}-requirements:
  file.managed:
    - name: /home/{{ pillar['user'] }}/bundles/{{ pillar[config]['http_host'] }}/requirements.txt
    - source: salt://bundle/requirements.txt
    - template: jinja
    - makedirs: True
    - mode: 644
    - defaults:
        config: {{ config }}
  cmd.wait:
    - name: env/bin/pip install -r requirements.txt
    - cwd: /home/{{ pillar['user'] }}/bundles/{{ pillar[config]['http_host'] }}
    - require:
      - virtualenv: {{ pillar[config]['http_host'] }}-venv
    - watch:
      - file: {{ pillar[config]['http_host'] }}-requirements

{% if pillar[config]['db_name'] %}
{{ pillar[config]['http_host'] }}-syncdb:
  cmd.wait:
    - name: >
        envdir /etc/{{ pillar[config]['http_host'] }}.d
        env/bin/django-admin.py syncdb --noinput
    - cwd: /home/{{ pillar['user'] }}/bundles/{{ pillar[config]['http_host'] }}
    - watch:
      - file: {{ pillar[config]['http_host'] }}-requirements
{% endif %}

{{ pillar[config]['http_host'] }}-collectstatic:
  cmd.wait:
    - name: >
        envdir /etc/{{ pillar[config]['http_host'] }}.d
        env/bin/django-admin.py collectstatic --noinput
    - cwd: /home/{{ pillar['user'] }}/bundles/{{ pillar[config]['http_host'] }}
    - watch:
      - file: {{ pillar[config]['http_host'] }}-requirements
    - require:
      - cmd: {{ pillar[config]['http_host'] }}-requirements
{%- endif %}

{% if pillar[config]['env'] %}
{{ env(pillar[config]['http_host'], pillar[config]['env'], pillar) }}
{% endif %}

{{ pillar[config]['http_host'] }}-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ pillar[config]['http_host'] }}.conf
    - template: jinja
    - source: salt://bundle/nginx.conf
    - mode: 644
    - defaults:
        config: {{ pillar[config] }}
    - watch_in:
      - service: nginx

{{ pillar[config]['http_host'] }}-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ pillar[config]['http_host'] }}.conf
    - target: /etc/nginx/sites-available/{{ pillar[config]['http_host'] }}.conf
    - require:
      - file: {{ pillar[config]['http_host'] }}-nginx-available
    - require_in:
      - service: nginx

{% if pillar[config]['processes'] %}

{% for name, command in pillar[config]['processes'].iteritems() %}
{{ pillar[config]['http_host'] }}-process-{{ name }}:
{% if command %}
  file.managed:
    - name: /etc/supervisor/conf.d/{{ name }}.conf
    - template: jinja
    - source: salt://bundle/process.conf
    - defaults:
        config: {{ pillar[config] }}
        process: {{ name }}
        command: {{ command }}
    - watch_in:
      - cmd: {{ pillar[config]['http_host'] }}-supervisor

{% if not "env/bin/gunicorn " in command %}
{{ pillar[config]['http_host'] }}-process-{{ name }}-restart:
  cmd.wait:
    - name: supervisorctl restart {{ name }}
    - watch:
      - file: {{ pillar[config]['http_host'] }}-requirements
    - require:
      - cmd: {{ pillar[config]['http_host'] }}-requirements
{% endif %}
{% else %}
  file.absent
{% endif %}
{% endfor %}

{{ pillar[config]['http_host'] }}-supervisor:
  cmd.wait:
    - name: supervisorctl update

{{ pillar[config]['http_host'] }}-gunicorn:
  cmd.wait:
    - name: kill -HUP `pgrep gunicorn`
    - watch:
      - file: {{ pillar[config]['http_host'] }}-requirements
    - require:
      - cmd: {{ pillar[config]['http_host'] }}-requirements

{% endif %}

{% for job in pillar[config].get('cron', []) %}
{{ pillar[config]['http_host'] }}-{{ job['name'] }}:
  cron.present:
    - name: {{ job['name'] }}
    - user: {{ pillar['user'] }}
    - minute: "{{ job.get('minute', '*') }}"
    - hour: "{{ job.get('hour', '*') }}"
    - daymonth: "{{ job.get('daymonth', '*') }}"
    - month: "{{ job.get('month', '*') }}"
    - dayweek: "{{ job.get('dayweek', '*') }}"
{% endfor %}
{% endmacro %}
