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
	@docker inspect $(PROJECT_ID)_db_1 | grep '"IPAddress"' | head -1 | cut -d '"' -f 4

timestamp:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Timestamp"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)_imposm_1 cat /home/settings/timestamp.txt
