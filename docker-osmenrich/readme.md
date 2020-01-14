# Docker-osmenrich
Docker osm-enrich is the extension for docker osm to get the changeset of the osm data. 
It will get the data from osm API and also get the update data from files that generated from docker-osmupdate

- data is new (changeset is null) : get from docker osm
- data is exist but need to check the recent changeset : get data from file generated from osmupdate, update into database

osmenrich will create new fields which are: 
- changeset_id
- changeset_timestamp
- changeset_version
- changeset_user