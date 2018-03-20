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

db-gis-slave-2-restore:
	@echo
	@echo "------------------------------------------------------------------"
	@echo "Restore dump from backups/latest.dmp in production mode"
	@echo "------------------------------------------------------------------"
	@# - prefix causes command to continue even if it fails
	-@docker exec -t -i $(PROJECT_ID)-gis-db-slave-2 su - postgres -c "dropdb gis"
	@docker exec -t -i $(PROJECT_ID)-gis-db-slave-2 su - postgres -c "createdb -O docker -T template_postgis gis"
	@docker exec -t -i $(PROJECT_ID)-gis-db-slave-2 su - postgres -c "psql -f /backups/[global]latest-gis.sql postgres"
	@docker exec -t -i $(PROJECT_ID)-gis-db-slave-2 pg_restore /backups/latest-gis.dmp | docker exec -i $(PROJECT_ID)-gis-db-slave-2 su - postgres -c "psql gis"