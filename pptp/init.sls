pptpd:
  pkg:
    - installed
  service.running:
    - enabled: True
    - watch:
      - file: pptptd
      - file: pptpd-secrets
  file.managed:
    - name: /etc/pptpd.conf
    - source: salt://pptpd/pptpd.conf
    - template: jinja
    - require:
      - pkg: pptpd

pptpd-secrets:
  file.managed:
    - name: /etc/ppp/chap-secrets
    - mode: 600
    - source: salt://pptpd/chap-secrets
    - template: jinja
