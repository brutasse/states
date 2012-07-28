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
  file.managed:
    - name: /home/{{ pillar['user'] }}/.znc/configs/znc.conf
    - source: salt://znc/znc.conf
    - template: jinja
    - makedirs: True
