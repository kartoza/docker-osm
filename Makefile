PROJECT_ID := dockerosm
COMPOSE_FILE := docker-compose.yml
# Uncomment the next line if you want to display data with Leaflet.
# COMPOSE_FILE := docker-compose-web.yml

.PHONY: logs

###
#    DOCKER MANAGEMENT
###

status:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Status in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) ps


build:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Building in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) build

run:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Running in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) up -d --no-recreate

rundev:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Running in DEVELOPMENT mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) up

stop:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Stopping in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) stop

kill:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Killing in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) kill

rm: kill rm-volumes
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing production instance and all volumes!!! "
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) rm

rm-volumes:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing all volumes!!!! "
	@echo "------------------------------------------------------------------"
	@docker volume rm $(PROJECT_ID)_osm-postgis-data $(PROJECT_ID)_import_queue $(PROJECT_ID)_import_done $(PROJECT_ID)_cache

logs:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Logs"
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) logs

live_logs:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Live Logs"
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) logs -f


###
#    CLIPPING
###


import_clip:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Importing clip shapefile and clip function into the database"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_imposm /usr/bin/ogr2ogr -progress -skipfailures -lco GEOMETRY_NAME=geom -nlt PROMOTE_TO_MULTI -f PostgreSQL PG:"host=db user=docker password=docker dbname=gis" /home/settings/clip/clip.shp
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) exec imposm psql -h db -f /home/settings/clip/clip.sql gis docker

remove_clip:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing clip shapefile from the database"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_db /bin/su - postgres -c "psql gis -c 'DROP TABLE IF EXISTS clip;'"

###
#    STATS
###


timestamp:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Timestamp"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_imposm cat /home/settings/timestamp.txt

###
#    STYLES
###


import_styles: remove_styles
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Importing QGIS styles"
	@echo "------------------------------------------------------------------"
	@docker exec -i $(PROJECT_ID)_db su - postgres -c "psql -f /home/settings/qgis_style.sql gis"

remove_styles:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing QGIS styles"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_db /bin/su - postgres -c "psql gis -c 'DROP TABLE IF EXISTS layer_styles;'"

backup_styles:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Backup QGIS styles to BACKUP.sql"
	@echo "------------------------------------------------------------------"
	@echo "SET XML OPTION DOCUMENT;" > BACKUP-STYLES.sql
	@ docker exec -t $(PROJECT_ID)_db su - postgres -c "/usr/bin/pg_dump --format plain --inserts --table public.layer_styles gis" >> BACKUP-STYLES.sql
