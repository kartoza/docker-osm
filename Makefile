PROJECT_ID := dockerosm
# COMPOSE_FILE := docker-compose-web.yml
COMPOSE_FILE := docker-compose.yml

.PHONY: logs

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

rm: kill
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing production instance!!! "
	@echo "------------------------------------------------------------------"
	@docker-compose -f $(COMPOSE_FILE) -p $(PROJECT_ID) rm

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

ipdb:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Database's IP"
	@echo "------------------------------------------------------------------"
	@docker inspect $(PROJECT_ID)_db | grep '"IPAddress"' | head -1 | cut -d '"' -f 4

import_clip:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Importing clip shapefile"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_db /usr/bin/shp2pgsql -c -I -D -s 4326 /home/settings/clip/clip.shp | docker exec -i $(PROJECT_ID)_db su - postgres -c "psql gis"

remove_clip:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing clip shapefile"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_db /bin/su - postgres -c "psql gis -c 'DROP TABLE IF EXISTS clip;'"

timestamp:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Timestamp"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_imposm cat /home/settings/timestamp.txt

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
