znc:
  pkg:
    - installed
  cmd.run:
    - user: {{ pillar['user'] }}
    - cwd: /home/{{ pillar['user'] }}
    - unless: pgrep znc
    - require:
      - pkg: znc
      - file: znc
      - file: znc-cert
  file.managed:
    - name: /home/{{ pillar['user'] }}/.znc/configs/znc.conf
    - source: salt://znc/znc.conf
    - template: jinja
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

znc-cert:
  file.managed:
    - name: /home/{{ pillar['user'] }}/.znc/znc.pem
    - template: jinja
    - source: salt://znc/znc.pem
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
