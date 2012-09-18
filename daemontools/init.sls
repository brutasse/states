daemontools:
  pkg:
    - installed

{% macro env(name, values) -%}

/etc/{{ name }}.d:
  file.directory:
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 750
    - recurse:
      - user
      - group
    - makedirs: True
    - require:
      - pkg: daemontools

{% for key, value in values.iteritems() %}
/etc/{{ name }}.d/{{ key }}:
  file.managed:
    - require:
      - file: /etc/{{ name }}.d
    - source: salt://daemontools/value
    - template: jinja
    - defaults:
        value: {{ value }}
{% endfor %}

{%- endmacro %}
