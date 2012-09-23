include:
  - virtualenv

python-dev-packages:
  pkg.installed:
    - names:
      - build-essential
      - dnsutils
      - gdal-bin
      - libevent-dev
      - libfreetype6
      - libfreetype6-dev
      - libgeos-dev
      - libjpeg62-dev
      - libjpeg8
      - libplist-utils
      - libpq-dev
      - libproj-dev
      - libxml2-dev
      - libxslt-dev
      - python-dev

{% for lib in ['libz', 'libjpeg', 'libfreetype'] %}
{{ lib }}-symlink:
  cmd.run:
    - name: ln -s i386-linux-gnu/{{ lib }}.so .
    - cwd: /usr/lib
    - unless: file /usr/lib/{{ lib }}.so
    - onlyif: file /usr/lib/i386-linux-gnu/{{ lib }}.so
    - require:
      - pkg: python-dev-packages
{% endfor %}
