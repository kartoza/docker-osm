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
