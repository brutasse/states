include:
  - nginx
  - git
  - git.deploy_keys
  - certs

{% set root = "/home/" + pillar['user'] + "/bundles/bruno.renie.fr" %}

bruno.renie.fr:
  file.directory:
    - name: {{ root }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - makedirs: True
  cmd.run:
    - name: git clone git@bruno.renie.fr.bitbucket.org:bruno/bruno.renie.fr.git .
    - cwd: {{ root }}
    - user: {{ pillar['user'] }}
    - unless: file {{ root }}/.git/config
    - require:
      - file: bruno.renie.fr
      - file: deploy-key-bruno.renie.fr
      - file: sshconfig

bruno.renie.fr-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/bruno.renie.fr.conf
    - source: salt://sites/bruno.renie.fr.conf
    - template: jinja
    - watch_in:
      - service: nginx

bruno.renie.fr-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/bruno.renie.fr.conf
    - target: /etc/nginx/sites-available/bruno.renie.fr.conf
    - watch_in:
      - service: nginx

extend:
  nginx:
    service:
      - watch:
        - file: ssl-cert-bruno.renie.fr-key
        - file: ssl-cert-bruno.renie.fr-crt
