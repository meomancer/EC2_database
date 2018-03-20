SHELL := /bin/bash
PROJECT_ID := agritechnovation

build: db-django-slave db-gis-slave
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Building in production mode"
	@echo "------------------------------------------------------------------"


db-gis-slave:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Running web database in production mode"
	@echo "------------------------------------------------------------------"
	docker-compose -p $(PROJECT_ID) up --no-recreate -d gis-slave

db-gis-slave-2:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Running web database in production mode"
	@echo "------------------------------------------------------------------"
	docker-compose -p agritechnovation up --no-recreate -d django-slave-2

dbshell-qgis:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Shelling in in production database"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)-gis-db-slave psql -U docker -h localhost gis

dbshell-qgis-2:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Shelling in in production database"
	@echo "------------------------------------------------------------------"
	@docker exec -t -i $(PROJECT_ID)-django-db-slave-2 psql -U docker -h localhost gis