## Docker Imposm

The container will look for an OSM file (*.pbf) and its state file (*.state.txt) in BASE_PBF.

With -e, you can add some settings :
 - TIME = 120, seconds between 2 executions of the script
 - USER = docker, default user
 - PASSWORD = docker, default password
 - HOST = db
 - PORT = 5432
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