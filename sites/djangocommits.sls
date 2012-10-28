include:
  - git
  - git.deploy_keys

{% set root = "/home/" + pillar['user'] + "/bundles/djangocommits" %}

djangocommits:
  file.directory:
    - name: {{ root }}
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - makedirs: True
  cmd.run:
    - name: git clone git@djangocommits.bitbucket.org:bruno/djangocommits.git .
    - cwd: {{ root }}
    - user: {{ pillar['user'] }}
    - unless: file {{ root }}/.git/config
    - require:
      - file: djangocommits
      - file: deploy-key-djangocommits
      - file: sshconfig

djangocommits-env:
  virtualenv.managed:
    - name: {{ root }}/env
    - no_site_packages: True
    - system_site_packages: False
    - require:
      - file: djangocommits
      - cmd: djangocommits
  cmd.run:
    - name: {{ root }}/env/bin/pip install -r {{ root }}/requirements.txt
    - require:
      - virtualenv: djangocommits-env
  cron.present:
    - name: {{ root }}/env/bin/python {{ root }}/commits.py
    - minutes: "30"
    - require:
      - cmd: djangocommits-env
