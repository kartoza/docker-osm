# Docker-OSM

A docker compose project to setup an OSM PostGIS database with automatic
updates from OSM periodically.
The only files you need is a PBF file, geojson (if you intent to restrict data download to
a smaller extent than the one specified by the PBF) and run the docker compose project.

## General architecture

![Alt text](/docs/architecture.png?raw=true "Optional Title")

## Quick setup

As a quick example, we are going to setup Docker-OSM with default values everywhere:
* Download a PBF file from http://download.geofabrik.de/
* Put the file in the `settings` folder and rename it `country.pbf`. 

Alternatively you can execute the `settings_downloader.sh` script to download the pbf and the clip file
``
./settings_downloader.sh GEOJSON_URL CONTINENT COUNTRY ie
./settings_downloader.sh https://github.com/kartoza/docker-osm/blob/develop/settings/clip.geojson africa south-africa
`` 

If you use rancher for container management you can use the provided docker-compose.yml which allows you to automatically
download the settings onto the host machine by using environment variables.
* Run the docker-compose-rancher file and make sure the environment variables are setup properly for
osm_downloader to download the correct pbf file

* If you want to connect from your local QGIS Desktop:
  * In the file `docker-compose.yml`, uncomment the block:

```yml
# Uncomment to use the postgis database from outside the docker network
ports:
 - "35432:5432"
```
* Do `make run` in the build directory. This will download and execute the docker-osm project. 
It might be very long depending of your bandwidth and the PBF you are importing.
* In QGIS, add a new PostGIS connection: `localhost`, database `gis`, port `35432`, `docker` for both username and password.
* That's it! You have an OSM database, up and running. The update is done every 2 minutes from the main OSM website.

For further reading and customizations, read below.

## Docker cloud

Dockerfiles are executed on [Docker Cloud kartoza/docker-osm](https://cloud.docker.com/swarm/kartoza/repository/docker/kartoza/docker-osm/general)

```bash
docker pull kartoza/docker-osm:imposm-latest
docker pull kartoza/docker-osm:osmupdate-latest
```

To run you can use the provided docker-compose project and use the images
hosted on the internet. This is useful if you want to integrate Docker-OSM in
your existing docker-compose project.

## Usage

### PBF File
In this example we will set up an OSM database for South Africa that 
will pull for updates every 2 minutes.

Specify a PBF file for your area in the environment variables for `osm_downloader` container.
You can download some PBF files on these URLS for instance :
* http://download.geofabrik.de/
* http://download.openstreetmap.fr/extracts/


You must put only one PBF file in the settings folder. Only the last one will be read.

### OSM Features

In `settings`, you can edit the `mapping.yml` to customize the PostGIS schema.
You can find the documentation about the mapping configuration on the imposm
website: https://imposm.org/docs/imposm3/latest/mapping.html
The default file in Docker-OSM is coming from
https://raw.githubusercontent.com/omniscale/imposm3/master/example-mapping.yml

**Note** that you can't import OSM metadata such as author, timestamp or version.
This is a limitation from ImpOSM, check the feature request on the [Imposm repository](https://github.com/omniscale/imposm3/issues/58).
Imposm is designed for spatial analysis, not for OSM contribution analysis.
If you need such a feature, you need to use another database schema supporting OSM Metadata. 
You can check the [OSM Wiki](https://wiki.openstreetmap.org/wiki/Databases_and_data_access_APIs#Database_Schemas) for "Lossless" schemas.

### Updates

You can configure the time interval in the docker-compose file. By default,
it's two minutes. If you set the TIME variable to 0, no diff files will be
imported.

The default update stream is worldwide. So even if you imported a local PBF, if
you don't set a clipping area, you will end with data from all over the world.

### Clipping

During the initial import or post update imposm uses the flag `-limito` which allows 
you to define a smaller area that you can work with.  
This is always desirable to limit the features being imported into the database rather 
than clipping them.

**NB:** Ensure you add a geojson covering the area you intent to clip into the settings folder.
The geojson can be the same extent of the administrative area of your country or it can be a 
smaller extent. The CRS of the geojson should always be EPSG:4326.


**NB:** It is encouraged to simplify the geometry for the `clip.geojson` as
a simplified geometry is easier to process during the import. 
Rather use the minimum bounding box for the area you intent to clip your dataset with.

### QGIS Styles

The database is provided with some default styles. These styles will be loaded
automatically when loaded in QGIS. It's following the default OSM mapping from
ImpOSM.

```bash
make import_styles
make remove_styles
make backup_styles
```

### SQL Trigger, functions, views...

You can add PostGIS functions, triggers, materialized views in a 
SQL file called `post-pbf-import.sql`. 
It will be imported automatically in the database.

### Build and run

Now build the docker images needed to run the application:

```bash
docker-compose build
docker-compose up 
```

In production you should daemonize the services when bringing them up:

```bash
docker-compose up -d
```

You can check the timestamp of your database by reading the file :
``settings/timestamp.txt`` or you can use : 

```bash
make timestamp
```

### Display

In the makefile, you can switch to another docker compose project.
The other one includes QGIS Server. When it's running, you should be able to
open, on the host(not in docker), the `index.html` file and see OSM and QGIS
Server showing PostGIS tables. The webpage is using Leaflet.

If you want to tweak the QGIS Project, you need to add a host in your in `/etc/hosts`:
```
127.0.0.1       db
```
Because in the docker-compose file, the link is made with the PostGIS database using the alias `db`.

## In the background

![architecture](https://raw.githubusercontent.com/kartoza/docker-osm/develop/docs/docker-compose.png)

### Docker OSM Update

This docker image, when run will regularly fetch any new diff file for all the
changes that have happened in the world over the update interval.

You can also specify a custom url for fetching the diff if you wish to retrieve
regional diffs rather than the global one.

You can specify a polygonal area for the diff so that it will only apply features
from the diff that fall within that area. For example providing a polygon of the
borders of Malawi will result in only Malawi features being extracted from the diff.

**Note:** the diff retrieved and options specified here are not related to the
initial base map used - so for example if your initial base map is for Malawi and
you specify a diff area in Botswana, updated features in Botswana will be applied
to your base map which only includes features from Malawi. For this reason, take
care to ensure that your diff area coincides with the region covered by your
original base map.

Once the diff has been downloaded, it is placed into /home/import_queue where
it will be picked up by the long running imposm3 container, which will apply
the diff to the database.

You should have 3 folders : osm_pbf, import_queue, import_done

Put a state file in base-pbf like this one :
http://download.openstreetmap.fr/extracts/africa/south_africa.state.txt

```bash
docker build -t osmupdate .
docker run -v $('pwd')import-queue/:/home/import-queue -v $('pwd')base-pbf/:/home/base-pbf -v $('pwd')import-done/:/home/import-done -d osmupdate
```

With -e, you can add some settings :

```bash
 - MAX_DAYS = 100, the maximum time range to assemble a cumulated changefile.
 - DIFF = sporadic, osmupdate uses a combination of minutely, hourly and daily changefiles. This value can be minute, hour, day or sporadic.
 - MAX_MERGE = 7, argument to determine the maximum number of parallely processed changefiles.
 - COMPRESSION_LEVEL = 1, define level for gzip compression. values between 1 (low compression but fast) and 9 (high compression but slow)
 - BASE_URL = http://planet.openstreetmap.org/replication/, change the URL to use a custom URL to fetch regional file updates.
 - IMPORT_QUEUE = import_queue
 - IMPORT_DONE = import_done
 - OSM_PBF = osm_pbf
 - TIME = 120, seconds between two executions of the script
```

If you are using docker-compose, you can use these settings within the 
```docker-compose.yml``` file.

### Docker ImpOSM3

This image will take care of doing the initial load for the selected region
(e.g. planet, or a country such as Malawi) into your database. It will then
apply, at a regular interval (default is 2 minutes), any diff that arrives
in the /home/import_queue folder to the postgis OSM database. The diffs
are fetched by a separate container (see osm_update container).

The container will look for an OSM file (*.pbf) and its state file
(*.state.txt) in BASE_PBF.

With -e, you can add some settings :

```bash
 - TIME = 120, seconds between 2 executions of the script
 - POSTGRES_USER = docker, default user
 - POSTGRES_PASS = docker, default password
 - POSTGRES_HOST = db
 - POSTGRES_PORT = 5432
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
```

You can adjust these preferences in the ```docker-compose.yml``` file provided
in this repository.

# PostGIS

With -e, you can add some settings to PostGIS:
```bash
 - ALLOW_IP_RANGE= 0.0.0.0/0
```
More environment variables for Kartoza/postgis image can be found from https://github.com/kartoza/docker-postgis#environment-variables

# QGIS Server and Martin Vector tiles

You can run a QGIS Server front end or martin vector tiles to the OSM mirror by using the provided
docker-compose-web.yml file. For example:

```bash
docker-compose -f docker-compose.yml -f docker-compose-web.yml qgisserver  up
```

or
```bash
docker-compose -f docker-compose.yml -f docker-compose-web.yml martin  up
```
For more information about martin configuration and usage can be found from https://github.com/urbica/martin


# Credits

This application was designed and implemented by:

* Etienne Trimaille (etienne.trimaille@gmail.com)
* Tim Sutton (tim@kartoza.com)

With some important design ideas provided by Ariel Nunez (ingenieroariel@gmail.com).

Parts of this project are built on the existing work of others.

July 2015
