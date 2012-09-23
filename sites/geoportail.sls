include:
  - daemontools
  - nginx
  - postgresql.postgis
  - postgresql.wale
  - python
  - redis

{% from "bunlde/init.sls" import bundle %}

{{ bundle(pillar['geoportail'], pillar) }}
