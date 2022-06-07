.PHONY: logs

###
#    DOCKER MANAGEMENT
###

status:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Status in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose ps

build:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Building in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose build

redeploy:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Recreate containers"
	@echo "------------------------------------------------------------------"
	@docker-compose up -d

run:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Running in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose up -d --no-recreate

rundev:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Running in DEVELOPMENT mode"
	@echo "------------------------------------------------------------------"
	@docker-compose up

stop:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Stopping in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose stop

kill:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Killing in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose kill

rm: kill rm-volumes
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing production instance and all volumes!!! "
	@echo "------------------------------------------------------------------"
	@docker-compose rm

rm-volumes:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing all volumes!!!! "
	@echo "------------------------------------------------------------------"
	@docker-compose down --volumes

logs:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Logs"
	@echo "------------------------------------------------------------------"
	@docker-compose logs

live_logs:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Live Logs"
	@echo "------------------------------------------------------------------"
	@docker-compose logs -f



###
#    STATS
###


timestamp:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Timestamp"
	@echo "------------------------------------------------------------------"
	@docker-compose exec -T imposm cat /home/settings/timestamp.txt


###
#    STYLES
###


import_styles: import_styles
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Importing QGIS styles"
	@echo "------------------------------------------------------------------"
	@docker-compose exec -T db su - postgres -c "psql -f /home/settings/qgis_style.sql gis"

remove_styles:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing QGIS styles"
	@echo "------------------------------------------------------------------"
	@docker-compose exec -T db /bin/su - postgres -c "psql gis -c 'DROP TABLE IF EXISTS layer_styles;'"

backup_styles:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Backup QGIS styles to BACKUP.sql"
	@echo "------------------------------------------------------------------"
	@echo "SET XML OPTION DOCUMENT;" > BACKUP-STYLES.sql
	@docker-compose exec -T db su - postgres -c "/usr/bin/pg_dump --format plain --inserts --table public.layer_styles gis" >> BACKUP-STYLES.sql


### 
#   QGIS Project
### 

materialized_views:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Generate materialized views for the OSM layers"
	@echo "------------------------------------------------------------------"
	@docker cp settings/materialized_views.sql dockerosm_db_1:/tmp/ 
	@COMPOSE_PROFILES=$(shell paste -sd, enabled-profiles) docker-compose exec -u postgres db psql -f /tmp/materialized_views.sql -d gis
	@COMPOSE_PROFILES=$(shell paste -sd, enabled-profiles) docker-compose exec db rm /tmp/materialized_views.sql
	@COMPOSE_PROFILES=$(shell paste -sd, enabled-profiles) docker-compose exec -u postgres db psql -c "select schemaname as schema_name, matviewname as view_name, matviewowner as owner, ispopulated as is_populated from pg_matviews order by schema_name, view_name;" gis 

elevation:
	@echo "-------------------------------------------------------------------"
	@echo "Adding the SRTM 30m DEM and contours for the OSM clip area to the db"
	@echo "-------------------------------------------------------------------"
	@python3 settings/getDEM.py
	@echo -n "Are you sure you want to delete the elevation schema? [y/N] " && read ans && [ $${ans:-N} = y ]
	# - at start of next line means error will be ignored (in case the elevation schema isn't already there)
	-@COMPOSE_PROFILES=$(shell paste -sd, enabled-profiles) docker-compose exec -u postgres db psql -c "DROP SCHEMA IF EXISTS elevation CASCADE; CREATE SCHEMA elevation AUTHORIZATION docker;" gis
	# Load the dem into the database. 
	@raster2pgsql -s 4326 -C -P -F -I settings/SRTM_DEM/SRTM_30m_DEM.tif elevation.dem > settings/SRTM_DEM/srtm30m_dem.sql
	@docker cp settings/SRTM_DEM/srtm30m_dem.sql dockerosm_db_1:/tmp/
	@COMPOSE_PROFILES=$(shell paste -sd, enabled-profiles) docker-compose exec -u postgres db psql -f /tmp/srtm30m_dem.sql -d gis
	@COMPOSE_PROFILES=$(shell paste -sd, enabled-profiles) docker-compose exec db rm /tmp/srtm30m_dem.sql 
	# Load the contours into the database.	 
	@shp2pgsql -s 4326 settings/SRTM_DEM/countours.shp elevation.contours > settings/SRTM_DEM/contours.sql
	@docker cp settings/SRTM_DEM/contours.sql dockerosm_db_1:/tmp/
	@COMPOSE_PROFILES=$(shell paste -sd, enabled-profiles) docker-compose exec -u postgres db psql -f /tmp/contours.sql -d gis
	@COMPOSE_PROFILES=$(shell paste -sd, enabled-profiles) docker-compose exec db rm /tmp/contours.sql
	# File clean up 
	@rm -r settings/SRTM_DEM/

