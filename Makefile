PROJECT_ID := dockerosm


build:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Building in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -p $(PROJECT_ID) build

run:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Running in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -p $(PROJECT_ID) up -d --no-recreate

rundev:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Running in DEVELOPMENT mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -p $(PROJECT_ID) up

stop:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Stopping in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -p $(PROJECT_ID) stop

kill:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Killing in production mode"
	@echo "------------------------------------------------------------------"
	@docker-compose -p $(PROJECT_ID) kill

rm: kill
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Removing production instance!!! "
	@echo "------------------------------------------------------------------"
	@docker-compose -p $(PROJECT_ID) rm

ipdb:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Database's IP"
	@echo "------------------------------------------------------------------"
	@docker inspect $(PROJECT_ID)_db | grep '"IPAddress"' | head -1 | cut -d '"' -f 4

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
