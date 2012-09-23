include:
  - daemontools
  - nginx
  - postgresql.postgis
  - postgresql.wale
  - python
  - redis

{% from "bundle/init.sls" import bundle %}

{{ bundle(pillar['geoportail'], pillar) }}
