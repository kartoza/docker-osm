#Docker-OSM

## Usage

### PBF File
In this example we will set up an OSM database for South Africa that 
will pull for updates every 2 minutes.

First get a PBF file from your area and put this file in the 'settings' folder.
You can download some PBF files on these URLS for instance :
* http://download.geofabrik.de/
* http://download.openstreetmap.fr/extracts/

```
cd settings
wget -c -O country.pbf http://download.openstreetmap.fr/extracts/africa/south_africa.osm.pbf
```

### Clipping

You can put a shapefile in the clip folder. This shapefile will be used for clipping every features after the import.

### QGIS Styles

### SQL Trigger

### Build and run

Now build the docker images needed to run the application:

```
docker-compose build
docker-compose up
```

In production you should daemonize the services when bringing them up:

```
docker-compose up -d
```

## Docker OSM Update

This docker image when run will fetch on a regular interval any new diff file
for all the changes that have happened in the world over the update interval.

You can also specify a custom url for fetching the diff if you wish to retrieve
regional diffs rather than the global one.

You can specify a polygonal area for the diff so that it will only apply features
from the diff that fall within that area. For example providing a polygon of the
borders of Malawi will result in only Malawi features being extracted from the diff.

Note that the diff retrieved and options specified here are not related to the
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

``docker build -t osmupdate .``
``docker run -v $('pwd')import-queue/:/home/import-queue -v $('pwd')base-pbf/:/home/base-pbf -v $('pwd')import-done/:/home/import-done -d osmupdate``

With -e, you can add some settings :
 - MAX_DAYS = 100, the maximum time range to assamble a cumulated changefile.
 - DIFF = sporadic, osmupdate uses a combination of minutely, hourly and daily changefiles. This value can be minute, hour, day or sporadic.
 - MAX_MERGE = 7, argument to determine the maximum number of parallely processed changefiles.
 - COMPRESSION_LEVEL = 1, define level for gzip compression. values between 1 (low compression but fast) and 9 (high compression but slow)
 - BASE_URL = http://planet.openstreetmap.org/replication/, change the URL to use a custom URL to fetch regional file updates.
 - IMPORT_QUEUE = import_queue
 - IMPORT_DONE = import_done
 - OSM_PBF = osm_pbf
 - TIME = 120, seconds between two executions of the script

If you are using docker-compose, you can use these settings within the 
```docker-compose.yml``` file.

## Docker ImpOSM3

This image will take care of doing the initial load for the selected region
(e.g. planet, or a country such as Malawi) into your database. It will then
apply, at a regular interval (default is 2 minutes), any diff that arrives
in the /home/import_queue folder to the postgis OSM database. The diffs
are fetched by a separate container (see osm_update container).

The container will look for an OSM file (*.pbf) and its state file
(*.state.txt) in BASE_PBF.

With -e, you can add some settings :
 - TIME = 120, seconds between 2 executions of the script
 - USER = docker, default user
 - PASSWORD = docker, default password
 - HOST = db
 - PORT = 5432
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

You can adjust these preferences in the ```docker-compose.yml``` file provided
in this repository.

# Technical architecture
![Lucidchart](https://www.lucidchart.com/publicSegments/view/55bca772-7b94-4589-b0f5-3e9c0a005a39/image.png)

# Credits

This application was designed and implemented by:

* Etienne Trimaille (etienne@kartoza.com)
* Tim Sutton (tim@kartoza.com)

With some important design ideas provided by Ariel Nunez (ingenieroariel@gmail.com).

Parts of this project are built on the existing work of others.

July 2015
