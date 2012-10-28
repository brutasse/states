{% for cert in pillar.get('ssl_certs', {}) %}
{% for type in ['key', 'crt'] %}
ssl-cert-{{ cert }}-{{ type }}:
  file.managed:
    - name: /etc/ssl/private/{{ cert }}.{{ type }}
    - source: salt://certs/key
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - defaults:
        key: {{ cert }}
        type: {{ type }}
{% endfor %}
{% endfor %}
