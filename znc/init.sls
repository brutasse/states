znc-dir:
  file.directory:
    - name: /home/{{ pillar['user'] }}/.znc
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}

znc-configs-dir:
  file.directory:
    - name: /home/{{ pillar['user'] }}/.znc/configs
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - require:
      - file: znc-dir

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
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - require:
      - file: znc-configs-dir

znc-cert:
  file.managed:
    - name: /home/{{ pillar['user'] }}/.znc/znc.pem
    - template: jinja
    - source: salt://znc/znc.pem
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - require:
      - file: znc-dir
