include:
  - daemontools
  - nginx
  - postgresql.postgis
  - python
  - redis

{% from "bundle/init.sls" import bundle %}

{{ bundle("geoportail", pillar) }}
