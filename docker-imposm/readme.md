# Docker ImpOSM3

> Version 1.0.0

This image will take care of doing the initial load for the selected region
(e.g. planet, or a country such as Malawi) into your database. It will then
apply, at a regular interval (default is 2 minutes), any diff that arrives
in the /home/import_queue folder to the postgis OSM database. The diffs
are fetched by a separate container (see osm_update container).

The container will look for an OSM file (*.pbf) and its state file
(*.state.txt) in BASE_PBF.

With -e, you can add some settings :

```bash
 - TIME = 120, seconds between 2 executions of the script
 - POSTGRES_USER = docker, default user
 - POSTGRES_PASS = docker, default password
 - POSTGRES_HOST = db
 - POSTGRES_PORT = 5432
 - SETTINGS = settings, folder for settings (with *.json and *.sql)
 - CACHE = cache, folder for caching
 - BASE_PBF = base_pbf, folder the OSM file
 - IMPORT_DONE = import_done, folder for diff which has been imported
 - IMPORT_QUEUE = import_queue, folder for diff which hasn't been imported yet
 - SRID = 4326, it can be 3857
 - OPTIMIZE = false, check (Imposm)[http://imposm.org/docs/imposm3/latest/tutorial.html#optimize]
 - DBSCHEMA_PRODUCTION = public, check (Imposm)[http://imposm.org/docs/imposm3/latest/tutorial.html#deploy-production-tables]
 - DBSCHEMA_IMPORT = import, check (Imposm)[http://imposm.org/docs/imposm3/latest/tutorial.html#deploy-production-tables]
 - DBSCHEMA_BACKUP = backup, check (Imposm)[http://imposm.org/docs/imposm3/latest/tutorial.html#deploy-production-tables]
```
