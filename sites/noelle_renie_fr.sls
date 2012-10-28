include:
  - nginx
  - git
  - git.deploy_keys
  - certs

{% set root = "/home/" + pillar['user'] + "/bundles/noelle.renie.fr" %}

noelle.renie.fr:
  file.directory:
    - name: {{ root }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - makedirs: True
  cmd.run:
    - name: git clone git@noelle.renie.fr.bitbucket.org:bruno/noelle.renie.fr.git .
    - cwd: {{ root }}
    - user: {{ pillar['user'] }}
    - unless: file {{ root }}/.git/config
    - require:
      - file: noelle.renie.fr
      - file: deploy-key-noelle.renie.fr

noelle.renie.fr-nginx-available:
  file.managed:
    - name: /etc/nginx/sites-available/noelle.renie.fr.conf
    - source: salt://sites/noelle.renie.fr.conf
    - template: jinja
    - watch_in:
      - service: nginx

noelle.renie.fr-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/noelle.renie.fr.conf
    - target: /etc/nginx/sites-available/noelle.renie.fr.conf
    - watch_in:
      - service: nginx
